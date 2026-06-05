<!--
SPDX-FileCopyrightText: 2026 Steven van der Vegt

SPDX-License-Identifier: CC-BY-SA-4.0
-->

### Introduction

**Notified Pull** is a data-availability exchange pattern: a Sender publishes a notification saying that one or more resources are available, and the Receiver pulls those resources on its own terms.

In its base form, described on this page, Notified Pull is **fire-and-forget**. The Sender does not expect the Receiver to accept, reject, report progress, or signal completion. The data exists at the Sender; the notification points the Receiver at it; what happens after that is the Receiver's concern. Workflows that need acceptance, lifecycle and cancellation negotiation (referrals, transfers of care) layer the [HL7 Clinical Order Workflow (COW) IG](https://build.fhir.org/ig/HL7/cow/) on top of this pattern; that combination is specified separately.

This page builds on the generic [Notification](./notification.html) transport (Subscription, SubscriptionTopic, notification Bundle, `notification-event`). It adds three things:

- the semantics of `notification-event.focus` for data-availability events,
- how the patient (subject) is identified,
- how the `notification-authorization-hint` carried on the transport is used to scope the pull.

{% include notified-pull-overview.svg %}

### When to use Notified Pull

The pattern fits when:

- the Sender wants to make data available to a known Receiver without coordinating a workflow;
- the Receiver controls whether, when and how to pull (data minimisation, freshness, user-driven retrieval);
- audit ("who fetched what when") is sufficient as a verification mechanism and is handled server-side on the Sender;
- the data set is well-defined enough that no negotiation is needed about *what* is being made available.

It does **not** fit when:

- the Sender needs the Receiver to accept or reject the exchange;
- the Sender needs to track receiver-side processing state (in-progress, completed, failed);
- the Sender needs to negotiate cancellation after the Receiver has begun acting on the data;
- multiple candidate Receivers must be solicited and one chosen.

Use cases of that shape layer the COW workflow on top of Notified Pull.

### Trade-offs

The fire-and-forget stance has explicit, deliberate costs:

- **No protocol-level retry.** If the Receiver never pulls, the Sender does not learn it from this protocol. The Sender inspects its own access logs.
- **No application-level confirmation.** A pull tells the Sender the data was *fetched*, not that it was *consumed* or *acted upon*. If consumption confirmation is required, the use case needs a workflow layer.
- **Cancellation only by withdrawal.** There is no acknowledged cancellation handshake. The Sender cancels by withdrawing the data or revoking access; the Receiver discovers it on the next pull attempt (`410 Gone`, `404 Not Found`, or `403 Forbidden`).

Implementers and use-case owners should weigh these costs explicitly. If any of them is unacceptable, the use case belongs in a workflow profile, not in plain Notified Pull.

### Single-resource notifications

The simplest pattern: one notification, one resource.

`notification-event.focus` references the clinical resource directly:

- a new lab result: `focus → Observation/abc123`
- a discharge summary made available: `focus → DocumentReference/def456`
- a medication dispense record: `focus → MedicationDispense/ghi789`

The Receiver performs a standard FHIR `read` against the Sender's endpoint. Patient identity comes from the resource's `.subject` field (see [Subject identification](#subject-identification)).

### Multi-resource notifications

When the Sender wants to make a coherent set of resources available in a single event, `notification-event.focus` references a **container resource** that aggregates the references. Three FHIR resources are reasonable containers; the choice is driven by what semantics best match the use case:

| Container          | Best for                                                  | Notes                                                                                                                                  |
|--------------------|-----------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|
| `List`             | Generic collection of resources (recommended default)     | `List.subject` carries the patient; `List.entry.item` carries each reference; `List.code` can label the collection (e.g. "BgZ snapshot") |
| `Composition`      | Document-style aggregates with a narrative structure      | Use when the set represents a coherent clinical document (e.g. a transfer-of-care summary). `Composition.section.entry` carries the references |
| `DocumentReference` | Document or binary content (e.g. PDF/A handoff document) | Use when the actual payload is a document rather than discrete resources                                                               |
{:.grid .table-hover}

For most data-availability events the **`List`** container is sufficient and the recommended default.

#### Example: List container

```
List
  status: current
  mode: snapshot
  code: <use-case-bound code, e.g. "BgZ snapshot">
  subject: Reference(Patient with identifier = BSN)
  date: 2026-05-11T10:30:00+02:00
  entry:
    - item: Reference(Observation/...)
    - item: Reference(Condition/...)
    - item: Reference(MedicationStatement/...)
```

A container instance lives at the Sender's FHIR endpoint and is read by the Receiver like any other resource. The Receiver MAY pull the container alone (for routing or display) and pull entries on demand, or pull everything eagerly with `_include`.

Multiple `notification-event.focus` references (without a container) are also valid for small ad-hoc groups; the trade-off is that the Receiver loses the explicit aggregation and any metadata the container would carry.

### Updates to a previously notified set

When a previously notified resource set evolves (an item changes, an item is added, or an item is removed), the Sender SHOULD send a new notification on the same Subscription with an incremented `event-number` and the same `notification-event.focus`. The Receiver detects the new event and decides what to pull again. Pulling everything is always safe but rarely necessary; two FHIR mechanisms let the Receiver minimise what it pulls.

**`meta.lastUpdated` on individual resources.** Every FHIR resource instance carries `meta.lastUpdated`, which the server sets whenever the resource is modified. After a `read` the Receiver compares this against its cached value and refreshes only when newer. The corresponding `_lastUpdated` search parameter does the same job for a set: `GET [base]/Observation?patient=X&_lastUpdated=ge<timestamp>` returns only resources updated since the timestamp. This works for any resource the Receiver has seen before, including each entry in a container.

**`_history` for explicit version chains.** Retrieving the history of a resource (`GET [base]/List/abc/_history`) returns every version with its own `meta.lastUpdated`. For a container focus this is the only reliable way to detect *membership* changes: an entry that was removed does not produce an updated version of the now-missing resource, so a `_lastUpdated` query against the items alone cannot surface a removal. History requires the Sender to retain past versions, which is the FHIR default behaviour.

The two patterns combine. For a single-resource focus, a `read` followed by a `meta.lastUpdated` comparison is usually sufficient. For a container focus, the Receiver typically reads the container (or its `_history`) to detect membership changes and then uses `_lastUpdated`-filtered searches or per-item `read`s to refresh the items it still wants.

### Subject identification

The patient identity (BSN, in the Dutch context) is **not** carried on the notification wire. Two complementary mechanisms apply:

- **On the focus resource** at the Sender. The clinical resource or container carries the subject in the usual FHIR way: `Resource.subject.identifier` for a clinical resource focus, `List.subject.identifier` / `Composition.subject.identifier` / `DocumentReference.subject.identifier` for a container focus. The Receiver learns the BSN at the moment it reads the focus resource (or via `_include` when fetching it). This is the standard FHIR pattern.
- **Encoded inside the `notification-authorization-hint` token.** When the Sender needs to scope the pull to the patient without exposing the BSN to the Receiver in the clear, it encodes the BSN into the opaque token using a Sender-only key. The Receiver plays the token back; the Sender's authorization server decodes it and constrains the pull. See [Authorization base](#authorization-base).

Routing the notification internally before pulling (to a specific department, mailbox or user) is a separate concern from subject identification, and is covered by a routing label rather than by exposing the subject. See [Open questions](#open-questions).

### Authorization base

The transport layer's `notification-authorization-hint` extension carries an opaque token from the Sender to the Receiver. The Receiver plays it back in subsequent access-token requests; the Sender's authorization server decodes it and authorizes the pull. The token is opaque to the Receiver and is not interpreted by it.

For Notified Pull, a practical pattern is to **encode the patient identifier (BSN), the scope of resources made available, and a validity window into the token, using a Sender-only key**:

- the BSN does not need to travel as clear-text in the notification or in `additional-context`;
- the Sender retains authoritative control over scope: a Receiver presenting a valid token still cannot pull data outside the scope encoded in it;
- the audit trail naturally ties access-token usage to the originating notification.

Costs of this approach:

- the Receiver cannot route internally on BSN before pulling (a routing label is needed if pre-pull routing is required, see [Open questions](#open-questions));
- the Sender implements an internal encode/decode mechanism and key management;
- token semantics are Sender-defined, so a Receiver cannot rely on common parsing.

The token's wire format and processing rules are out of scope of this page and belong to the access-control specification agreed between partners. Inclusion of the hint is optional; whether a use case requires it depends on the access-control model in play.

### Data unavailability

When the Sender decides the data should no longer be retrievable (because it was wrong, superseded, withdrawn or expired), it either removes the resource from its FHIR endpoint or revokes the access that the `notification-authorization-hint` token grants. Subsequent `read` requests receive a standard HTTP response that doubles as the withdrawal signal:

- `410 Gone`: the resource was here and has been deliberately removed. Use this when the Sender is willing to confirm that the withdrawal happened.
- `404 Not Found`: the URL does not resolve to a resource. Use this when the Sender does not want to disclose whether the resource ever existed.
- `403 Forbidden`: the Receiver's authorization (typically the authorization-base) has been rejected. This response implies nothing about whether the resource exists; the existence check sits behind the access step.

There is no `cancel` operation in Notified Pull and no follow-up notification announcing withdrawal. The HTTP response on the next pull *is* the signal. A Receiver that never re-pulls will not learn of the withdrawal; that is the deliberate price of fire-and-forget.

Per-case workflow cancellation with an acknowledged handshake between Sender and Receiver requires the COW workflow profile.

### Sender intent and receiver-side state tracking

> **Under discussion.** This section captures working-group suggestions for the middle ground between pure fire-and-forget and a full COW workflow. Nothing here is normative yet.

Some use cases want lightweight tracking of whether the Receiver has fetched, viewed or processed the data, without committing to a full COW workflow lifecycle. Three approaches are on the table:

**Server-side audit only.** The Sender already logs every `read` request on the focus resource and its referenced entries; "was it pulled" is derivable from those access logs without any Receiver-side participation. No protocol additions, no Receiver obligation. Tells the Sender only about fetches, not about consumption or downstream action.

**Receiver-updated status on the focus resource.** The Sender exposes a status field on the focus resource (for example, a `processing-status` extension on the `List` container) that the Receiver updates from `pending` to `viewed` or `processed`. State lives on the resource the Receiver already pulled. The Sender accepts and validates the updates, and decides which Receivers may set which values. Couples state semantics to the focus resource type.

**A separate Task carrying the acknowledgement.** The Sender creates a Task with `focus` on the data and `status = requested`; the Receiver updates the Task's `status` to `received` or `completed` as it makes progress. Conceptually this is COW Lite: a single Task, no Request resource, no multi-candidate solicitation, no cancellation negotiation. It re-uses the FHIR Task state machine and is unambiguous from the Sender's perspective. The risk is conceptual drift: an acknowledgement Task is shape-wise similar to a COW Coordination Task and the two should not be confused in mixed deployments.

In all three approaches, the Sender's intent (whether tracking is expected at all, and which mechanism applies) should be discoverable from the SubscriptionTopic, so a Receiver knows up-front whether a notification implies an obligation to update state somewhere.

### Relationship to other layers

- **Transport** ([Notification](./notification.html)): provides the Subscription, SubscriptionTopic, notification Bundle and `notification-event` mechanics that Notified Pull uses unchanged. This page extends that transport only by giving `notification-event.focus` a data-availability meaning and by describing how the `notification-authorization-hint` is used.
- **Workflow** (COW profile, separate page): a COW workflow that uses Notified Pull for the data-fetch part references this page. In that case `notification-event.focus` points at a Coordination Task rather than a clinical resource or container; the workflow page adds the Task lifecycle, multi-candidate solicitation, and cancellation negotiation on top.
- **Endpoint discovery** ([Care Services Directory](./care-services.html)): the notification endpoint to which the Sender POSTs a notification Bundle is resolved per Receiver organisation via the addressing function (mCSD-based directory). NP uses the resolved endpoint unchanged.
- **Internal routing** ([Routing](./routing.html)): how the Receiver routes a landed notification to the right department, mailbox or user is specified by TA Routing using `HealthcareService`, `Location` and optionally `ActivityDefinition` published in an mCSD Directory. See [Pre-pull routing](#pre-pull-routing) for how NP carries a routing hint that points the Receiver at one of those primitives.
- **Access control** (out of scope): mTLS, OAuth, JWT assertions, and the wire format and validation rules for the `notification-authorization-hint` token are specified by the partners' access-control agreement.

### Open questions

See also the [Subscription Topics Exploration](subscription-topics-exploration.html), a working-group discussion document on the granularity of subscriber-initiated subscriptions.

1. **Container resource default.** This draft proposes `List` as the default multi-resource container, with `Composition` and `DocumentReference` as use-case-driven alternatives. Working group to confirm.
2. **Routing label.** Whether the spec should define an explicit internal routing label (department, mailbox, specialism) for pre-pull routing. Real Dutch deployments often need this; the open question is where it lives (`notification-event.additional-context`, on a separate resource, etc.) and how it relates to the BSN-in-authorization-base pattern.
3. **Authorization-base structure.** Whether the spec should recommend any minimum structure for the token (e.g. carry expiry, scope ids, signature algorithm) or leave it entirely opaque.
4. **Container ↔ focus cardinality.** Whether to support multiple focuses pointing at multiple containers in a single notification, or restrict to one focus (single resource or single container) per event.
