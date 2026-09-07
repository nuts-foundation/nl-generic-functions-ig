<!--
SPDX-FileCopyrightText: 2026 Steven van der Vegt

SPDX-License-Identifier: CC-BY-SA-4.0
-->

### Purpose

The exchange specifications in this IG are designed as three stackable building blocks. Each block defines a small set of mechanisms with explicit extension points. A use case is a concrete combination of these blocks: it picks a topic, a focus shape, a dataset binding, and an authorization model, and inherits everything else from the blocks below.

This page explains the layering, documents the design decisions behind it, and shows one concrete instantiation (a BGZ referral) so the role of each block is visible end to end.

### The three building blocks

The diagram below shows the artifacts of each block (the FHIR resources, extensions and references that make up the wire surface) and how they compose. Composition arrows (filled diamond) show "contained in"; reference arrows (open arrowhead) show "points at". The cross-layer arrows from `notification-event.focus` show that NP focus targets and CW focus targets are alternatives at the same slot.

{% include building-blocks.svg %}

#### Notification (Transport)

The wire-level mechanism: a long-lived `Subscription` between two partners for a given `SubscriptionTopic`, a notification `Bundle` carrying an event with an `event-number` for gap detection, and the handshake / heartbeat lifecycle. `Subscription.channel.endpoint` is a plain URL value (not a FHIR Reference to an `Endpoint` resource); the Sender resolves the Receiver's URL out-of-band from the Care Services Directory and copies it into the Subscription. See [Notification](notification.html).

#### Notified Pull (NP)

What the Receiver does with a notification: pull the resource that `notification-event.focus` points at, follow its references, detect updates via `_lastUpdated` / `_history`, and observe withdrawals via HTTP 410 / 404 / 403 on the next pull. NP is strictly read-only at the Sender. The `notification-authorization-hint` opaque token is carried here. See [Notified Pull](notified-pull.html).

#### Clinical Workflow (CW)

A profile on [HL7 Clinical Order Workflows](https://build.fhir.org/ig/HL7/cow/) Pattern 2 ("Subscriptions with Task at Placer"). CW reuses NP twice: once on a Coordination Task (workflow channel) and once on the dataset (data channel). It adds the things NP intentionally lacks: a Coordination Task lifecycle expressed via `Task.businessStatus`, Fulfiller write-back to the Placer's `Task` resource, multi-candidate solicitation, cancellation negotiation via a `CancellationRequest Task`, and dataset binding via `Request.instantiatesCanonical` to a `PlanDefinition`. See [Clinical Workflow](clinical-workflow.html).

### Why the Sender pre-resolves the dataset

The data offered in a CW or pure NP exchange typically draws from three sources:

1. A canonical dataset specification (e.g. Nictiz publishes a BgZ `PlanDefinition` that enumerates the FHIR queries comprising a BgZ snapshot).
2. Specific resource instances the Sender wants to attach to this case (e.g. the trigger Observation that motivated a referral).
3. Per-case supplemental queries the Sender wants to evaluate beyond the canonical dataset.

Two design options for how these reach the Receiver:

**Option A (proposed): the Sender pre-resolves everything into a flat container.** The Placer evaluates the canonical queries and any supplemental queries against its own data, gathers the matching resources, and writes the references into a single container (`List`, `Composition`, or `DocumentReference` depending on the use case). The container is the operational truth on the wire.

**Option B (less optimal): the container carries query specifications.** Entries would be a mix of `Reference(clinical resource)` for instances and `Reference(PlanDefinition)` or contained `Library` resources for queries the Receiver must execute.

The working group leans toward Option A. The reasons:

- **Notification precision.** Only the party that resolves a query can observe when its result changes. If the Sender resolves, notifications carry actual deltas (entry added, content updated, entry removed). If the Receiver resolves, the notification can at best say "something might have changed, please re-poll your queries", with no delta. NP's design assumes precise notifications; Option B forces it into a coarse polling mode.
- **Wire consistency.** Every `notification-event.focus` resolves to a "read and follow references" interaction on the Receiver side, regardless of use case. No branching on entry resource type. One pull loop in the Receiver covers every scenario.
- **Privacy.** The Placer curates exactly what is in the container. A query may match more resources than the Placer expected; closing that gap requires Placer-side filtering anyway, which is most of the work of Option A.
- **Audit clarity.** `List._history` gives an auditable trail of what was offered when. Option B has no equivalent because the queries are stable while their results drift outside the container.

**The cost the Sender pays.**

Option A is an implementation tax on the Placer:

- The Placer evaluates every canonical PlanDefinition and every per-case supplemental query against its own data.
- The Placer continuously detects when underlying data changes (new lab result, updated medication, withdrawn observation) and reflects that change in the relevant containers.
- For each impacted container, the Placer updates the container's membership or content so that the data Subscription fires.

EHRs that cannot watch their own data for changes cannot participate as Placers for this profile. This is a deliberate trade: the Receiver implementation stays simple and uniform; the capability requirement sits on the Sender. We accept it because Receiver heterogeneity is the harder problem to manage at national scale.

### Subscription topic strategies for the data channel

The workflow channel is straightforward: one long-lived Subscription per partner pair, filtered on `Task.owner.identifier = <Fulfiller URA>`. The data channel admits two strategies with materially different operational profiles.

**Strategy 1: broad per-Receiver Subscription (recommended default).**

One data Subscription per partner pair, long-lived alongside the partnership. The filter selects containers destined for this Receiver via an `nl-intended-recipient` extension on `List` / `Composition` / `DocumentReference`. The Placer sets this extension on every container it offers; the existing Subscription matches automatically.

| Property | Value |
|---|---|
| Subscription count at the Placer | One per partner pair |
| Lifecycle | Long-lived; aligned with the partnership |
| Filter shape | `List?intended-recipient.identifier=http://fhir.nl/fhir/NamingSystem/ura\|<Fulfiller URA>` |
| Receiver-side dispatch | Receiver looks up which Coordination Task / offer a container belongs to (one extra step per notification) |
| Multi-Receiver offers | Native: `nl-intended-recipient` is `0..*` on the container |
| Requires new IG artifacts | Extension `nl-intended-recipient` and a matching SearchParameter |
{:.grid .table-hover}

**Strategy 2: narrow per-container Subscription.**

A new Subscription is created when an offer is accepted, with a filter pinning the specific container by `_id`. Retired when the Coordination Task reaches a terminal state.

| Property | Value |
|---|---|
| Subscription count at the Placer | One per active offer per Receiver |
| Lifecycle | Bound to the offer; created on accept, retired on terminal Task state |
| Filter shape | `List?_id=<offer-list-id>` |
| Receiver-side dispatch | Implicit: one Subscription equals one offer |
| Multi-Receiver offers | Requires parallel Subscriptions, one per candidate |
| Requires new IG artifacts | None beyond standard `_id` search |
{:.grid .table-hover}

**Scale and the recommendation.**

Notification volume per Receiver is the same in both strategies (each Receiver receives only its own notifications). What differs is the Placer's Subscription registry.

At realistic Dutch volumes (a hospital can run thousands of active referrals + transfers of care concurrently, across dozens of partners) Strategy 2 turns the Subscription registry into the bottleneck: thousands of create / retire events per day, each tied to a Coordination Task lifecycle. Strategy 1 reduces this to a fixed registry sized by the partner graph (dozens of Subscriptions, durably configured).

This IG proposes **Strategy 1 as the default**. Use cases with low offer volume, strict isolation requirements between offers, or implementations that cannot author the `nl-intended-recipient` extension MAY use Strategy 2 by documenting the choice in the use-case profile.

The workflow channel is unaffected: it stays broad per-Receiver, filtered on `Task.owner`. CW is a profile on COW; that filter mirrors COW Pattern 2 exactly.

### Container choice for the data channel

The container is a per-use-case decision, not a building-block decision. NP supports four focus shapes; CW inherits them via the data channel:

| Container | Use when |
|---|---|
| `List` | The offer is a flat collection of resource references with no document semantics. Recommended default for data sets. |
| `Composition` | The offer is a clinical document with section-based narrative, author, custodian, attestation. |
| `DocumentReference` | The offered payload is an opaque attachment (PDF/A, image, ZIP). |
| Single clinical resource | The offer is one resource (e.g. a single Observation availability event). No wrapper container. |
{:.grid .table-hover}

Concrete picks for known use cases:

- **BGZ referral**: `List`. BgZ is a data set with categorical entries; no narrative.
- **eOverdracht (nursing handoff)**: `Composition`. The handoff has sections, narrative, custodian, signatures.
- **Discharge letter delivery**: `DocumentReference`. The payload is a PDF.

The container choice does not affect the building-block layering. NP's pull-and-follow semantics work identically across the four shapes; CW just specifies that its data channel's focus is whatever container the use case selected.

### Subscriptions summary

Combining the decisions above: a CW exchange under the recommended profile uses two long-lived Subscriptions per partner pair.

| Subscription | Topic example | Filter example | Lifetime |
|---|---|---|---|
| Workflow channel | `.../SubscriptionTopic/nl-cow-coordination-task-changes` | `Task?owner.identifier=URA\|<Fulfiller URA>` | Long-lived; one per partner pair |
| Data channel | `.../SubscriptionTopic/nl-data-offer-changes` | `List?intended-recipient.identifier=URA\|<Fulfiller URA>` | Long-lived; one per partner pair |
{:.grid .table-hover}

The data channel Subscription is shared between CW (where containers are tied to Coordination Tasks) and pure NP (where containers are offered without a workflow above them). One topic, one filter shape, two consumers.

### Example: BGZ referral

The diagram below shows a single BGZ referral from a Placer hospital (URA 11111111) to a Fulfiller hospital (URA 22222222). Each step is annotated with the building block in use.

{% include building-blocks-bgz-referral.svg %}

Three things to notice:

1. The same Notification + NP machinery appears twice in this single exchange: once with `focus` referencing the Coordination Task, once with `focus` referencing a `List` (the BgZ snapshot).
2. The only flow not expressible as Notification + NP is the Fulfiller writing the Coordination Task back at the Placer (steps marked "write-back"). Write-back is CW-specific; the Placer observes the writes at its own endpoint and does not notify itself.
3. The Coordination Task's `Task.businessStatus` drives the COW state machine; `Task.status` follows the FHIR R4 normative state machine alongside.

### Mapping to FHIR resources

| Building block | Primary FHIR artifacts |
|---|---|
| Notification | `Subscription`, `SubscriptionTopic`, notification `Bundle` (Backport profiles) |
| Notified Pull | Any FHIR resource as `focus`; container patterns use `List`, `Composition`, or `DocumentReference`; `nl-intended-recipient` extension for broad per-Receiver Subscriptions |
| Clinical Workflow | `Task` (Coordination + CancellationRequest), `ServiceRequest` / `MedicationRequest` / `DeviceRequest`, `PlanDefinition` |
{:.grid .table-hover}
