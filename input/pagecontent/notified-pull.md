<!--
SPDX-FileCopyrightText: 2026 Steven van der Vegt

SPDX-License-Identifier: CC-BY-SA-4.0
-->

### Introduction

This page specifies a Dutch profile on the [HL7 Clinical Order Workflows (COW) IG](https://build.fhir.org/ig/HL7/cow/) for the **Notified Pull** exchange pattern: a Placer informs a Fulfiller that an order is available, and the Fulfiller pulls the associated data on its own terms. The profile harmonizes two existing Dutch specifications that solve the same problem differently:

- [Twiin Technical Agreement Notified Pull v1.0.1](https://twiin.nl/tanp)
- [Nuts eOverdracht leveranciersspecificatie](https://nuts-foundation.gitbook.io/bolts/eoverdracht/leveranciersspecificatie)

The goal is a single, internationally-grounded specification for future iterations of both.

This profile adopts **COW pattern 2 — "Task at Placer with Subscriptions"**: the Coordination Task lives at the Placer, and the Fulfiller is notified via an R4 Subscription Backport event and then pulls. See [Why pattern 2?](#why-pattern-2) for the rationale.

Access control (mTLS, OAuth 2.0, client/authorization assertions) is **out of scope** of this page; it is specified separately and agreed between partners. The only access-control concept retained here is the `notification-authorization-hint`, because it crosses the transport/policy boundary — see [Notification authorization hint](#notification-authorization-hint).

### Terminology

This profile uses COW terminology throughout. The table below maps it to the Dutch-language and legacy-specification terms for readers coming from TA NP, eOverdracht, or the domain in general.

| COW (this profile)            | Twiin TA NP v1.0.1          | Nuts eOverdracht                 | Dutch                         |
|-------------------------------|-----------------------------|----------------------------------|-------------------------------|
| Placer                        | Sending Organization        | Sending System / sender          | Bronhouder / verzender        |
| Fulfiller                     | Receiving Organization      | Receiving System                 | Ontvangende organisatie       |
| Coordination Task             | Workflow Task               | Task                             | Workflow-Task                 |
| Request (Task.focus)          | — (implicit)                | Composition / referral           | Opdracht / verwijzing         |
| CancellationRequest Task      | Notification Cancellation   | — (Task.status=cancelled)        | Annuleringsverzoek            |
| Subscription (R4 Backport)    | —                           | —                                | Abonnement                    |
| Notification Bundle           | Notification message        | Empty POST (notification)        | Notificatie                   |
| notification-authorization-hint | authorization-base          | Nuts Authorization Credential    | grondslag-token               |
{:.grid .table-hover}

"Request" refers to any FHIR [Workflow Request resource](https://hl7.org/fhir/R4/workflow.html#respatterns) — typically `ServiceRequest`, `MedicationRequest`, `DeviceRequest`, or any other request-type resource permitted by the use case.

### Overview

{% include notified-pull-overview.svg %}

Example payloads below correspond to the step numbers in the diagram. The same flow drives both use cases; only the Request content and the referenced PlanDefinition differ.

| Step | Resource                                         | Referral (single candidate)                                                                                                                    | Transfer of care (multiple candidates)                                                                                                                                                                    |
|------|--------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1    | Subscription                                     | [np-referral-subscription](Subscription-np-referral-subscription.html)                                                                         | [np-eov-subscription](Subscription-np-eov-subscription.html) (one per candidate Fulfiller)                                                                                                                 |
| 2    | Request + Coordination Task(s)                   | [np-referral-servicerequest](ServiceRequest-np-referral-servicerequest.html), [np-referral-coordination-task](Task-np-referral-coordination-task.html) | [np-eov-servicerequest](ServiceRequest-np-eov-servicerequest.html), [np-eov-coordination-task-a](Task-np-eov-coordination-task-a.html) + [np-eov-coordination-task-b](Task-np-eov-coordination-task-b.html) |
| 3    | Notification Bundle (with SubscriptionStatus)    | [np-referral-notification-bundle](Bundle-np-referral-notification-bundle.html) / [np-referral-subscription-status](Parameters-np-referral-subscription-status.html) | [np-eov-notification-bundle](Bundle-np-eov-notification-bundle.html) / [np-eov-subscription-status](Parameters-np-eov-subscription-status.html) (analogous Bundle sent to each candidate)                   |
| 9    | Dataset queries — derived from PlanDefinition    | [np-bgz-plandefinition](PlanDefinition-np-bgz-plandefinition.html) (BgZ dataset)                                                               | [np-eov-plandefinition](PlanDefinition-np-eov-plandefinition.html) (eOverdracht dataset)                                                                                                                   |
{:.grid .table-hover}

The pattern has four layers, each specified separately below:

1. **Request** — a FHIR Request resource at the Placer describes *what is being ordered*: a `ServiceRequest` for a referral, a `MedicationRequest` for a medication handoff, etc. The Request is the clinical payload; the Task does not duplicate its content.
2. **Workflow** — a COW Coordination Task at the Placer references the Request (`Task.focus`) and tracks the lifecycle of the order. Status is advanced by the Fulfiller; cancellation after acceptance is negotiated with the Placer.
3. **Transport** — a FHIR R5 Subscription Backport event notifies the Fulfiller that the Coordination Task has changed. The notification carries no clinical content.
4. **Data** — the Fulfiller pulls resources from the Placer's FHIR endpoint, using queries derived from the Request.

### Why pattern 2?

The COW IG defines two patterns. **Pattern 1 ("Task at Fulfiller")** has the Placer push the Task into the Fulfiller's FHIR endpoint; this matches TA NP v1.0.1's current design. **Pattern 2 ("Task at Placer with Subscriptions")** keeps the Task at the Placer and uses a Subscription to notify the Fulfiller, which then pulls — matching the "pull" semantics of Notified Pull.

Pattern 2 is chosen because:

- **Stronger Fulfiller authentication at the Placer.** In pattern 1 the Placer only trusts that the notification endpoint published for the Fulfiller in the addressing function is the correct one; it has no further assurance about who ultimately acts on the Task. In pattern 2 the Fulfiller must authenticate to the Placer every time it reads or updates the Task, giving the Placer a direct, repeatable identity check at the moment it matters.
- The Placer remains the source of truth for the Task; delta updates flow naturally via new notifications on the same Task.
- The Fulfiller does not need to host a writable FHIR Task endpoint to accept incoming orders; a thin notification endpoint is enough.
- Transport (Subscription) and workflow (Task) are cleanly separated, so the same transport serves multiple use cases.
- The notification can remain small and free of clinical content, matching Dutch data-minimization expectations.

### Subscription

Profile: [NlCowSubscription](StructureDefinition-nl-cow-subscription.html).

The profile uses a **broad, long-lived Subscription per partner**, not per-case. One Subscription covers all Coordination Tasks the Placer may send to a given Fulfiller.

A Subscription MUST exist at the Placer for the targeted Fulfiller before any notifications flow. How the Subscription is created is **use-case defined**: it may be created in-band (the Fulfiller POSTs a Subscription to the Placer) or out-of-band (the Placer records it from the addressing function, which publishes the Fulfiller's notification endpoint per organization). The Placer MUST check for an existing Subscription for the Fulfiller before sending notifications; beyond that, the creation mechanism does not affect runtime behavior.

The Subscription profile (`NlCowSubscription`) SHALL:

- set `Subscription.status = active` while in use and `off` to retire the channel;
- set `Subscription.channel.type = rest-hook` with the Fulfiller's notification endpoint;
- identify the sending organization via the R5 cross-version `Subscription.managingEntity` extension, using a URA identifier;
- reference a single NL-specific `SubscriptionTopic` per use case (e.g. referral, transfer of care).

### Notification

Conforms to the HL7 Subscription Backport IG `backport-subscription-notification` Bundle profile; no additional NL constraints in this draft.

Each Coordination Task event at the Placer triggers one notification to the Fulfiller.

The notification is a FHIR `Bundle` of type `history` conforming to the Subscription Backport IG `SubscriptionNotification` profile, further constrained by `NlCowNotificationBundle`. It contains a `Parameters` resource (SubscriptionStatus) with:

- `subscription` — reference to the registered Subscription;
- `type = event-notification`;
- `status = active` or `off`;
- `topic` — canonical URL of the NL SubscriptionTopic;
- `notification-event.focus` — reference to the Coordination Task at the Placer;
- `notification-event` MAY carry a `notification-authorization-hint` (see [Notification authorization hint](#notification-authorization-hint)).

The notification carries **no FHIR queries, no dataset content, and no workflow status**. The Fulfiller learns the status by reading the referenced Coordination Task.

### Coordination Task

Profile: [NlCowCoordinationTask](StructureDefinition-nl-cow-coordination-task.html).

The Coordination Task is hosted at the Placer and is the single point of truth for the lifecycle of one order. The profile constrains at minimum:

| Element                    | Card. | Description                                                                       |
|----------------------------|-------|-----------------------------------------------------------------------------------|
| `Task.status`              | 1..1  | See [state machine](#state-machine).                                              |
| `Task.intent`              | 1..1  | Fixed `order`.                                                                    |
| `Task.code`                | 1..1  | Identifies the use case (e.g. referral, transfer of care).                        |
| `Task.focus`               | 1..1  | Reference to the Request resource describing what is ordered.                     |
| `Task.for.identifier`      | 1..1  | Patient BSN — see [Patient identification](#patient-identification).              |
| `Task.requester`           | 1..1  | Placer (organization + acting practitioner).                                      |
| `Task.owner`               | 1..1  | Fulfiller.                                                                        |
| `Task.restriction.period`  | 0..1  | Window during which the data will remain available for pull.                      |
{:.grid .table-hover}

`Task.focus` is a generic FHIR `Reference`; this profile binds it to any FHIR Workflow Request resource (`ServiceRequest`, `MedicationRequest`, `DeviceRequest`, …) so the same Coordination Task structure drives different clinical orders.

`accepted` marks the Fulfiller's commitment to the order; `in-progress` marks active fulfillment, which is typically the phase during which the data pull happens. They are distinct transitions so the Placer can observe "agreed to do it" and "working on it" as separate events.

#### State machine

{% include notified-pull-task-lifecycle.svg %}

The `in-progress` transition marks the boundary at which the Placer loses the ability to cancel unilaterally. Before that (`requested` or `accepted`) the Placer MAY set `Task.status = cancelled` directly. Once the Fulfiller has moved the Task to `in-progress`, cancellation by the Placer MUST be negotiated via a separate [CancellationRequest Task](#cancellation), per [COW cancellation rules](https://build.fhir.org/ig/HL7/fhir-cow-ig/en/cancelling-and-modifying-requests.html).

#### Soliciting multiple Fulfillers

Some use cases — eOverdracht in particular — let the Placer offer a patient to several candidate Fulfillers in parallel and proceed with whichever one accepts first. The pattern is **one ServiceRequest and multiple Coordination Tasks**:

- One `ServiceRequest` describes the clinical order; it is created once.
- N Coordination Tasks reference the same ServiceRequest via `Task.focus`, each with a different `Task.owner` (one per candidate Fulfiller).
- All Tasks share a `Task.groupIdentifier` so they can be correlated as one solicitation.
- Each Task triggers its own notification via the Placer's Subscription to that candidate.
- During solicitation `ServiceRequest.performer` is left empty; candidates are known from the Tasks' owners, not from the ServiceRequest. Setting `performer` is appropriate only once a candidate has been selected, and even then it is optional — `Task.owner` on the selected Task remains the authoritative signal. This is COW's distinction between "Request Placed (No Performer)" and "Request Placed (Performer Selected)".

When a Fulfiller accepts, the Placer **selects** that Task by setting `Task.businessStatus = selected`, and cancels the others with `Task.status = cancelled` and `Task.statusReason = "not selected"`. Each cancellation fires its own notification so the losing candidates are informed. These are direct cancellations — none of the Tasks have reached `in-progress`, so no `CancellationRequest Task` is required.

**Privacy caveat.** Pre-selection, every candidate has a valid Coordination Task referencing the same ServiceRequest. Access-control policy MUST limit what each candidate can actually pull until selection — typically minimal or de-identified content during solicitation, full dataset only after `businessStatus = selected`. The `notification-authorization-hint` is the natural place to encode this phase: a pre-selection token with minimal scope, a post-selection token with the full dataset. This is a use-case policy concern, out of scope for this transport profile, but it must be implemented somewhere.

### Data retrieval

Once the Fulfiller has read the Coordination Task, it performs the FHIR queries needed to retrieve the ordered dataset. **This profile does not place the query list in the notification.**

The recommended approach is to derive the query list from the Request resource:

- `Request.code` identifies the dataset (e.g. BgZ, eOverdracht dataset), bound to a Dutch value set;
- optionally, `Request.instantiatesCanonical` references a `PlanDefinition` that enumerates the FHIR queries for that dataset. A `PlanDefinition` lets a dataset specification publish its query list once and be referenced by every Request, rather than every Placer re-listing the same queries. It is optional: a Fulfiller MAY implement the query list directly from the dataset code.

This keeps the notification thin, keeps queries versionable alongside the dataset specification, and matches standard FHIR workflow practice. For per-case additions beyond the canonical dataset, see [Adding information per layer](#adding-information-per-layer).

#### Adding information per layer

> **Under discussion.** This subsection is still being debated by the working group.

This subsection describes further possibilities for adding information to each layer. Keeping them separate means a change in one does not force changes in the others.

**Transport — notification.** The notification carries no clinical content. It MAY carry a `notification-authorization-hint` (the Placer's opaque legal-basis token) on `SubscriptionStatus.notification-event`. That placement gets the token to the Fulfiller before any pull.

**Workflow — Coordination Task.** `Task.input` is a repeating slot for per-case parameters. This profile uses it for one thing: a Placer-supplied **supplemental FHIR query**, e.g. `valueString = "Observation?category=laboratory&date=ge2026-01-01"`. A Coordination Task MAY carry zero or more such entries. No other per-case parameters are standardised in this draft.

**Data — Request and PlanDefinition.** The dataset itself is shared; case-specific additions are not.

- **Shared**: a `PlanDefinition` publishes the canonical list of FHIR queries for a dataset (BgZ, eOverdracht, …). One PlanDefinition per dataset, one central owner — Nictiz is the natural fit for Dutch information standards. Versioned by canonical URL (e.g. `http://nictiz.nl/fhir/PlanDefinition/bgz|1.2.0`) and referenced from `Request.instantiatesCanonical`. Placers do not re-list queries; Fulfillers resolve the PlanDefinition once per version and cache it.
- **Per case**: `Request.supportingInfo` for *specific resource instances* the Placer has already identified (e.g. the trigger Observation behind the referral); `Task.input` supplemental-query for *ad-hoc queries* that extend the canonical dataset for this case only.

| Layer      | Shared                         | Per-case                                                  |
|------------|--------------------------------|-----------------------------------------------------------|
| Transport  | `SubscriptionTopic`            | `notification-authorization-hint` on `notification-event` |
| Workflow   | `Task.code`                    | `Task.input` supplemental-query                           |
| Data       | Nictiz `PlanDefinition`        | `Request.supportingInfo`, `Task.input` supplemental-query |
{:.grid .table-hover}

### Cancellation

Profile (for the sub-Task used after the Fulfiller has started): [NlCowCancellationRequestTask](StructureDefinition-nl-cow-cancellationrequest-task.html).

{% include notified-pull-cancellation.svg %}

Cancellation is COW-native: the Placer never uses `Subscription.status = off` to signal per-case cancellation; the Subscription is transport, not workflow.

- **Placer cancels before Fulfiller started** (Task is `requested` or `accepted`) — Placer updates `Coordination Task.status = cancelled` and sends a notification so the Fulfiller observes the change.
- **Placer cancels after Fulfiller started** (Task is `in-progress`) — Placer creates a `CancellationRequest Task` with `Task.code = abort` and `Task.focus` referencing the Coordination Task. A notification points the Fulfiller to this new Task. The Fulfiller reads it and either accepts (Placer then sets the Coordination Task to `cancelled`) or rejects it.
- **Fulfiller declines or abandons** — Fulfiller updates the Coordination Task to `rejected` (from `requested`) or `failed` (from `in-progress`). No separate Task is needed; the Fulfiller is the authorized owner of these status transitions.

### Patient identification

> **Under discussion.** The placement and conveyance of the BSN is still being debated by the working group.

The Fulfiller needs the patient's BSN before pulling any clinical data, for routing, identity-matching, and legal-basis evaluation. This profile places the BSN on the Coordination Task itself:

- `Task.for.identifier.system = http://fhir.nl/fhir/NamingSystem/bsn`
- `Task.for.identifier.value = <BSN>`

`Task.for.reference` MAY additionally point to a `Patient` resource at the Placer, but the identifier MUST be present. This keeps the BSN within the FHIR graph and decoupled from the access-control layer — unlike TA NP v1.0.1, which could alternatively carry the BSN in an OAuth `patient` claim.

### Notification authorization hint

Many Notified Pull use cases are referrals or transfers of care. In those scenarios, the legal basis for disclosure is **not** always a recorded patient consent or an existing treatment relationship between patient and Fulfiller: it can be the referral itself (presumed consent under WGBO), inter-collegial consultation, or another Placer-determined ground.

The `notification-authorization-hint` is an opaque token issued by the Placer that encodes this decision. It rides on `SubscriptionStatus.notification-event` using the Backport IG's [`notification-authorization-hint`](http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/notification-authorization-hint) extension, so it reaches the Fulfiller before any pull. The Fulfiller plays it back in subsequent access-token requests so the Placer's authorization server can verify the legal basis it itself decided upon; the Fulfiller does not interpret the token.

Inclusion of the hint is optional. Its wire format and processing rules are out of scope of this page and are settled in the access-control specification agreed between partners.

### Mapping: Twiin TA NP v1.0.1 → this profile

| TA NP                                             | This profile                                                    |
|---------------------------------------------------|-----------------------------------------------------------------|
| Notification Task (STU3 Task, POSTed to receiver) | Notification Bundle (R4 Backport SubscriptionNotification)      |
| Task.code = `pull-notification`                   | `SubscriptionTopic` canonical URL                               |
| Task.groupIdentifier                              | Subscription identifier (reused across notifications)           |
| Task.identifier                                   | `notification-event.event-number`                               |
| Task.status = `requested` / `cancelled`           | Coordination Task status / CancellationRequest Task             |
| Workflow Task                                     | Coordination Task (same role, COW-profiled)                     |
| Task.input:authorization-base                     | `notification-event` `notification-authorization-hint`          |
| Task.input:query-available-resources              | Derived from Request / PlanDefinition (see Data retrieval)      |
| Task.input:read-available-resource                | Idem                                                            |
| Task.input:get-workflow-task                      | Obsolete — Coordination Task is always referenced               |
| Task.for.identifier (BSN) or OAuth patient claim  | `Coordination Task.for.identifier` (BSN)                        |
| Notification Cancellation (conditional update)    | CancellationRequest Task (if accepted) or status update         |
{:.grid .table-hover}

### Mapping: Nuts eOverdracht → this profile

| eOverdracht                                       | This profile                                                    |
|---------------------------------------------------|-----------------------------------------------------------------|
| Empty POST to Task endpoint                       | Notification Bundle referencing a Coordination Task             |
| Task (STU3, Nictiz eOverdracht profile)           | Coordination Task + Request (COW-profiled, R4)                  |
| Task.input:nursingHandoff (document reference)    | Request.code + dataset queries via PlanDefinition               |
| Task.status transitions gate access               | Coordination Task status transitions + notification-authorization-hint |
| Nuts Authorization Credential                     | `notification-authorization-hint`                               |
{:.grid .table-hover}

### Open questions

1. **R4 Backport on STU3** — TA NP v1.0.1 is STU3-based. Determine whether the Subscription Backport IG can be applied to STU3 servers, or whether STU3 implementations need a transition path.
2. **Query list location** — this draft derives queries from the Request resource and an optional PlanDefinition. The alternative is carrying them on `Coordination Task.input`, matching TA NP v1.0.1 more closely. To be decided by the working group.
3. **SubscriptionTopic ownership** — whether NL topics are published per-dataset (Nictiz) or per-use-case (Twiin/Nuts), and under which canonical base URL.
4. **`additional-context` for deltas** — whether the notification should hint at which resource types changed since the last event, or the Fulfiller always refetches from the Request-derived query list.
5. **Patient identification / BSN placement** — this draft places the BSN on `Coordination Task.for.identifier`. Alternatives are carrying it via the access-control layer (the OAuth `patient` claim, à la TA NP v1.0.1), via a Patient resource reference only, or inside the notification itself. Needs working-group discussion.
