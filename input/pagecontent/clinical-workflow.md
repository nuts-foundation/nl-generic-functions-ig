<!--
SPDX-FileCopyrightText: 2026 Steven van der Vegt

SPDX-License-Identifier: CC-BY-SA-4.0
-->

### Introduction

This page specifies a Dutch profile on the [HL7 Clinical Order Workflows (COW) IG](https://build.fhir.org/ig/HL7/cow/) (v1.0.0-ballot) for the **Notified Pull** exchange pattern: a Placer informs a Fulfiller that an order is available, and the Fulfiller pulls the associated data on its own terms. The profile harmonizes two existing Dutch specifications that solve the same problem differently:

- [Twiin Technical Agreement Notified Pull v1.0.1](https://twiin.nl/tanp)
- [Nuts eOverdracht leveranciersspecificatie](https://nuts-foundation.gitbook.io/bolts/eoverdracht/leveranciersspecificatie)

The goal is one specification, based on an international standard, that future versions of both can adopt.

This profile follows COW. Where it deviates, the deviation and its reason are stated in place.

This profile adopts **COW pattern 2, "Task at Placer with Subscriptions"**: the Coordination Task lives at the Placer, and the Fulfiller is notified via an R4 Subscription Backport event and then pulls. See [Pattern choice](#pattern-choice) for the rationale. The notification layer is [TTA Notifications v0.6](https://ontwikkelsupplement.twiin.nl/actueel/10-3-1-1-tta-notifications-v0-6); the [Notification](notification.html) page relates it to this IG. This page reuses it as-is.

Access control is specified by [GF Authorization](./authorization.html) and is out of scope of this page, with one exception: how the Placer records the Fulfiller's right to pull when it creates the order. See [Authorization basis](#authorization-basis).

### Terminology

This profile uses COW terminology throughout. The table below maps it to the Dutch-language and legacy-specification terms for readers coming from TA NP, eOverdracht, or the domain in general.

| COW (this profile)            | Twiin TA NP v1.0.1          | Nuts eOverdracht                 | Dutch                         |
|-------------------------------|-----------------------------|----------------------------------|-------------------------------|
| Placer                        | Sending Organization        | Sending System / sender          | Bronhouder / verzender        |
| Fulfiller                     | Receiving Organization      | Receiving System                 | Ontvangende organisatie       |
| Coordination Task             | Workflow Task               | Task                             | Workflow-Task                 |
| Request (Task.focus)          | (implicit)                  | Composition / referral           | Opdracht / verwijzing         |
| CancellationRequest Task      | Notification Cancellation   | (Task.status=cancelled)          | Annuleringsverzoek            |
| Subscription (R4 Backport)    | (none)                      | (none)                           | Abonnement                    |
| Notification Bundle           | Notification message        | Empty POST (notification)        | Notificatie                   |
| Authorization basis (recorded at Placer) | authorization-base | Nuts Authorization Credential    | Grondslag                     |
{:.grid .table-hover}

"Request" refers to a FHIR [Workflow Request resource](https://hl7.org/fhir/R4/workflow.html#respatterns) of one of the six order types COW allows: `ServiceRequest`, `DeviceRequest`, `MedicationRequest`, `NutritionOrder`, `SupplyRequest` or `VisionPrescription`.

### Overview

The diagram shows the happy path of one order. The Placer creates a Request and a Coordination Task and notifies the Fulfiller. The Fulfiller reads the Task, pulls the dataset and advances the Task status at the Placer. Cancellation and orders offered to several candidates follow in later sections.

{% include clinical-workflow-overview.svg %}

Example payloads below correspond to the step numbers in the diagram. The same flow drives both use cases; only the Request content and the referenced PlanDefinition differ.

| Step | Resource                                         | Referral (single candidate)                                                                                                                    | Transfer of care (multiple candidates)                                                                                                                                                                    |
|------|--------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 2    | Request + Coordination Task(s)                   | [np-referral-servicerequest](ServiceRequest-np-referral-servicerequest.html), [np-referral-coordination-task](Task-np-referral-coordination-task.html) | [np-eov-servicerequest](ServiceRequest-np-eov-servicerequest.html), [np-eov-coordination-task-a](Task-np-eov-coordination-task-a.html) + [np-eov-coordination-task-b](Task-np-eov-coordination-task-b.html) |
| 11   | Dataset queries, derived from PlanDefinition     | [np-bgz-plandefinition](PlanDefinition-np-bgz-plandefinition.html) (BgZ dataset)                                                               | [np-eov-plandefinition](PlanDefinition-np-eov-plandefinition.html) (eOverdracht dataset)                                                                                                                   |
{:.grid .table-hover}

The pattern has four layers, each specified separately below:

1. **Request**: a FHIR Request resource at the Placer describes *what is being ordered*: a `ServiceRequest` for a referral, a `MedicationRequest` for a medication handoff, etc. The Request is the clinical payload; the Task does not duplicate its content.
2. **Workflow**: a COW Coordination Task at the Placer references the Request (`Task.focus`) and tracks the lifecycle of the order. Status is advanced by the Fulfiller; cancellation after acceptance is negotiated with the Placer.
3. **Notification**: a TTA Notifications event tells the Fulfiller that the Coordination Task has changed. The notification carries no clinical content. See the [Notification](notification.html) page.
4. **Data**: the Fulfiller pulls resources from the Placer's FHIR endpoint, using queries derived from the Request.

Every change to the Coordination Task at the Placer produces a notification, whoever made the change. The Fulfiller therefore also receives notifications for its own status writes and ignores them; TTA Notifications requires idempotent processing anyway. This follows COW pattern 2 and eOverdracht. TA NP v1.0.1 never notified on status changes.

#### Pattern choice

The COW IG defines two patterns. **Pattern 1 ("Task at Fulfiller")** has the Placer push the Task into the Fulfiller's FHIR endpoint. **Pattern 2 ("Task at Placer with Subscriptions")** keeps the Task at the Placer and uses a Subscription to notify the Fulfiller, which then pulls. That matches the "pull" semantics of Notified Pull.

Pattern 2 is chosen because:

- **It matches current practice.** TA NP v1.0.1 hosts its Workflow Task at the Sending System and eOverdracht hosts its Task at the bronhouder. Both already keep the status-bearing Task at the source; only their push notifications (TA NP's Notification Task, eOverdracht's empty POST) are replaced by the Subscription mechanism.

- **Stronger Fulfiller authentication at the Placer.** In pattern 1 the Placer only trusts that the notification endpoint published for the Fulfiller in the addressing function is the correct one; it has no further assurance about who ultimately acts on the Task. In pattern 2 the Fulfiller must authenticate to the Placer every time it reads or updates the Task, giving the Placer a direct, repeatable identity check at the moment it matters.
- The Placer remains the source of truth for the Task; delta updates flow naturally via new notifications on the same Task.
- The Fulfiller does not need to host a writable FHIR Task endpoint to accept incoming orders; a thin notification endpoint is enough.
- Transport (Subscription) and workflow (Task) are cleanly separated, so the same transport serves multiple use cases.
- The notification can remain small and free of clinical content, matching Dutch data-minimization expectations.

### Notification

The notification layer is [TTA Notifications v0.6](https://ontwikkelsupplement.twiin.nl/actueel/10-3-1-1-tta-notifications-v0-6); the [Notification](notification.html) page relates it to this IG. This profile uses a broad, long-lived Subscription per partner against an NL-specific SubscriptionTopic on `Task` (one per use case, e.g. referral, transfer of care), and a `backport-subscription-notification` Bundle whose `notification-event.focus` references the Coordination Task at the Placer. The payload mode is `id-only`. The Coordination Task's logical id therefore has to meet the TTA's identifier requirements: stable, opaque and unpredictable. A sequential or time-based id disqualifies the Task from `id-only` notifications. A SubscriptionTopic that narrows on `Task.code` MUST also match `abort`, so that the [CancellationRequest Task](#cancellation) reaches the Fulfiller through the same Subscription.

The notification carries **no FHIR queries, no dataset content, no workflow status and no authorization token**. The Fulfiller learns the status by reading the referenced Coordination Task. TA NP v1.0.1 fields that have no place in a notification, such as the restriction period and the requester acting on behalf of another party, live on the Coordination Task instead.

### Coordination Task

Profile: [NlCowCoordinationTask](StructureDefinition-nl-cow-coordination-task.html), derived from COW's [Coordination Task](https://build.fhir.org/ig/HL7/fhir-cow-ig/StructureDefinition-coordination-task.html) profile (1.0.0-ballot). The rows below are what COW requires plus what this profile adds or narrows.

The Coordination Task is hosted at the Placer and is the single point of truth for the lifecycle of one order. The profile constrains at minimum:

| Element                    | Card. | Description                                                                       |
|----------------------------|-------|-----------------------------------------------------------------------------------|
| `Task.identifier`          | 1..*  | Business identifier of the order, issued by the Placer (REQ-07 on the Record Identifiers page). |
| `Task.status`              | 1..1  | See [state machine](#state-machine).                                              |
| `Task.businessStatus`      | 0..1  | Domain progress within a lifecycle state. Example binding to COW's business-status value set; this profile defines `selected` for multi-Fulfiller solicitation. |
| `Task.intent`              | 1..1  | Fixed `order`.                                                                    |
| `Task.code`                | 1..1  | Two codings: `task-code#fulfill` (COW's workflow verb) and the use-case code the SubscriptionTopic narrows on (e.g. referral, transfer of care). |
| `Task.focus`               | 1..1  | Reference to the Request resource describing what is ordered.                     |
| `Task.for.identifier`      | 1..1  | Patient BSN, see [Patient identification](#patient-identification).               |
| `Task.requester`           | 1..1  | Placer (organization + acting practitioner).                                      |
| `Task.owner`               | 1..1  | Fulfiller.                                                                        |
| `Task.restriction.period`  | 0..1  | Window during which the data will remain available for pull.                      |
{:.grid .table-hover}

`Task.businessStatus` carries progress that does not change the lifecycle state: an appointment is scheduled, a specimen is collected, an interim note is available. COW binds it at example strength, so its five codes are a starting set, not a closed list. Each use case defines the business-status codes its process needs and states which party sets them. COW's [workflow state overview](https://build.fhir.org/ig/HL7/fhir-cow-ig/workflow-state-overview.html) uses `selected` for the Fulfiller chosen among several candidates, but its value set does not define the code; this profile defines it for [multi-Fulfiller solicitation](#soliciting-multiple-fulfillers).

`Task.focus` is a generic FHIR `Reference`; this profile binds it to the six order types COW allows (see [Terminology](#terminology)) so the same Coordination Task structure drives different clinical orders.

`Task.code` carries two codings. COW puts the workflow verb there (`fulfill` from FHIR's task-code system) and keeps the kind of order on the Request. This profile adds the use-case code (SNOMED, e.g. referral or transfer of care) because an R4B SubscriptionTopic evaluates its `queryCriteria` against the Task alone and cannot follow `Task.focus` to the Request. A topic that only fires for transfers of care has to find that code on the Task.

`accepted` marks the Fulfiller's commitment to the order; `in-progress` marks active fulfillment, which is typically the phase during which the data pull happens. They are distinct transitions so the Placer can observe "agreed to do it" and "working on it" as separate events.

#### Impact on current implementations

Adopting this profile costs an existing TA NP v1.0.1 or eOverdracht implementation the following, as discussed in the working-group meeting of 1 September 2026:

- **FHIR R4.** Both legacy specifications are STU3. The workflow resources (Task, Request) move to R4.
- **A persisted Request resource.** Neither legacy specification has one: TA NP points at data through `Task.input`, eOverdracht through a Composition in `Task.input`. This profile requires `Task.focus` to reference a Request of one of six order types.
- **A business identifier on the Task.** Required by COW; neither legacy specification mandates one.
- **`Task.businessStatus`.** Unused by both. A party populates it when it knows a value and stores what the other party set.
- **The post-`in-progress` cancellation path.** Both legacy specifications have one flat cancellation mechanism; the CancellationRequest Task is new functionality. See [Cancellation](#cancellation).
- **Notifications on Fulfiller writes.** TA NP never notified on status changes. Under this profile every change to the Coordination Task notifies, so a TA NP Sending System gains a trigger.

#### State machine

The profile allows the full FHIR [Task state machine](https://hl7.org/fhir/R4/task.html#statemachine), as COW does. The diagram shows the transitions this profile gives a meaning. `received` is optional: the Fulfiller acknowledges the order before deciding, which TA NP v1.0.1 and COW's state overview both use. Other FHIR states (`draft`, `ready`, `on-hold`, `entered-in-error`) are allowed but carry no workflow meaning here.

{% include clinical-workflow-task-lifecycle.svg %}

The `in-progress` transition marks the boundary at which the Placer loses the ability to cancel unilaterally. Before that (`requested`, `received` or `accepted`) the Placer MAY set `Task.status = cancelled` directly. Once the Fulfiller has moved the Task to `in-progress`, cancellation by the Placer MUST be negotiated via a separate [CancellationRequest Task](#cancellation), per [COW cancellation rules](https://build.fhir.org/ig/HL7/fhir-cow-ig/en/cancelling-and-modifying-requests.html).

#### Soliciting multiple Fulfillers

Some use cases, eOverdracht in particular, let the Placer offer a patient to several candidate Fulfillers in parallel and proceed with whichever one accepts first. The pattern is **one ServiceRequest and multiple Coordination Tasks**, as in COW:

- One `ServiceRequest` describes the clinical order; it is created once.
- N Coordination Tasks reference the same ServiceRequest via `Task.focus`, each with a different `Task.owner` (one per candidate Fulfiller). The shared `Task.focus` correlates them; see [Correlating Tasks](#correlating-tasks). `Task.groupIdentifier` is not used.
- Each Task triggers its own notification to that candidate.
- During solicitation `ServiceRequest.performer` is left empty; candidates are known from the Tasks' owners, not from the ServiceRequest. Setting `performer` is appropriate only once a candidate has been selected, and even then it is optional: `Task.owner` on the selected Task remains the authoritative signal. This is COW's distinction between "Request Placed (No Performer)" and "Request Placed (Performer Selected)".

When a Fulfiller accepts, the Placer **selects** that Task by setting `Task.businessStatus = selected`, and cancels the others with `Task.status = cancelled` and `Task.statusReason = "not selected"`. Each cancellation fires its own notification so the losing candidates are informed. These are direct cancellations: none of the Tasks have reached `in-progress`, so no `CancellationRequest Task` is required.

**Privacy caveat.** Pre-selection, every candidate has a valid Coordination Task referencing the same ServiceRequest. Access-control policy MUST limit what each candidate can actually pull until selection: typically minimal or de-identified content during solicitation, full dataset only after `businessStatus = selected`. The access record the Placer keeps per candidate (see [Authorization basis](#authorization-basis)) encodes this phase: minimal scope during solicitation, the full dataset after selection. This is a use-case policy concern, out of scope for this transport profile, but it must be implemented somewhere.

#### Correlating Tasks

Every Task about one order references that order in `Task.focus`, so `focus` is the correlation key. The table gives the FHIR searches at the Placer for the common questions. `X` is the id of the ServiceRequest, `Y` the id of a Coordination Task.

| Question                                          | Search at the Placer                                                                                         |
|---------------------------------------------------|--------------------------------------------------------------------------------------------------------------|
| All candidate Tasks for order X                   | `Task?focus=ServiceRequest/X&code=http://hl7.org/fhir/CodeSystem/task-code\|fulfill`                        |
| Open candidates (to cancel after selection)       | same, plus `&status=requested,received,accepted`                                                             |
| The selected Fulfiller for order X                | same, plus `&business-status=http://fhir.nl/CodeSystem/nl-cow-business-status\|selected`                    |
| Cancellation requests for Task Y                  | `Task?focus=Task/Y&code=http://hl7.org/fhir/CodeSystem/task-code\|abort`                                    |
| A Fulfiller's own Tasks for order X               | `Task?focus=ServiceRequest/X&owner:identifier=http://fhir.nl/fhir/NamingSystem/ura\|<own URA>`              |
{:.grid .table-hover}

A second solicitation round for the same order creates new Tasks with the same `focus`; the round is Placer bookkeeping and is not on the wire. A candidate never sees the other candidates' Tasks, so it has nothing to correlate beyond its own.

### Data retrieval

Once the Fulfiller has read the Coordination Task, it performs the FHIR queries needed to retrieve the ordered dataset. The notification carries no queries; TTA Notifications does not allow them there. The dataset definition is shared, the per-order additions are on the Task.

**Shared: the dataset.** `Request.code` identifies the dataset (e.g. BgZ, eOverdracht dataset), bound to a Dutch value set. Optionally, `Request.instantiatesCanonical` references a `PlanDefinition` that enumerates the FHIR queries for that dataset. A PlanDefinition is a definitional resource: published once by the dataset owner under a canonical URL and version, referenced from every Request, resolved once per version by the Fulfiller and cached. No system hosts a copy per order. The owner of the information standard (e.g. Nictiz) is the natural publisher; the canonical in the example (`http://nictiz.nl/fhir/PlanDefinition/bgz|1.2.0`) is illustrative. The PlanDefinition is optional: a Fulfiller MAY implement the query list directly from the dataset code.

**Per order: `Task.input`.** The Placer adds what this order needs beyond the dataset, per Coordination Task:

- `supplemental-resource`: a reference to a specific resource instance the Placer has identified, e.g. the trigger Observation behind a referral (TA NP's `read-available-resource`);
- `supplemental-query`: an ad-hoc FHIR query that extends the dataset for this order only, e.g. `valueString = "Observation?category=laboratory&date=ge2026-01-01"` (TA NP's `query-available-resources`).

Both are placed on the Task and not on the Request for two reasons. The Subscription is on Task, so adding an input is a Task update and notifies the Fulfiller; a change to the Request notifies nobody. And each candidate Fulfiller has its own Task, so the Placer can attach different resources per candidate while the Request stays shared. COW's guidance would put "why the order was authorized" on `Request.supportingInfo` and only "how to fulfil" on `Task.input`; this profile deviates for those two reasons. This is also where eOverdracht keeps everything.

**The Task is the only resource a Fulfiller has to watch.** The Placer signals every change the Fulfiller must act on by updating the Coordination Task: a new input, a changed order. Adding data to the workflow is a workflow change; changing data that was already added is not. A Fulfiller that wants to follow changes inside an attached resource or inside the Request subscribes to that resource itself, with a receiver-initiated Subscription (see [Subscription Topics Exploration](subscription-topics-exploration.html)). This is the working-group decision of May 2026. To see what an update added, the Fulfiller compares `Task.input` with its cached copy; Task history is not required.

#### Outputs and completion

The Fulfiller MAY reference outcomes of the order (a consult note, a report) from `Task.output`, hosted at the Fulfiller. When the Coordination Task reaches `completed`, the Placer sets `Request.status = completed`, or keeps the Request active and creates a new Coordination Task to continue fulfilment. Both follow COW.

#### Where additional information goes

The table lists every element a Placer or Fulfiller could use to add information to an order, whether it is shared by all candidate Fulfillers or specific to one Task, and what this profile does with it.

| Element                                 | Scope                    | Set by    | This profile   | Why                                                                                                   |
|-----------------------------------------|--------------------------|-----------|----------------|-------------------------------------------------------------------------------------------------------|
| `Request.code`                          | Shared (all candidates)  | Placer    | Used           | Names the dataset or order type.                                                                      |
| `Request.instantiatesCanonical`         | Shared                   | Placer    | Used, optional | Dataset query list by canonical; resolved once per version.                                           |
| `Request.reasonCode`, `.reasonReference`| Shared                   | Placer    | Allowed        | Part of the order content. A change here does not notify; the Placer updates the Task if it matters.  |
| `Request.supportingInfo`                | Shared                   | Placer    | Not used       | Cannot differ per candidate, and adding to it does not notify. Use `Task.input`.                      |
| `Request.note`                          | Shared                   | Placer    | Allowed        | Free text for humans; not for instructions a system must act on.                                      |
| `Task.input` supplemental-resource      | Per Task (one Fulfiller) | Placer    | Used           | Specific resource instances for this order; adding one notifies.                                      |
| `Task.input` supplemental-query         | Per Task                 | Placer    | Used           | Ad-hoc queries beyond the dataset; adding one notifies.                                               |
| `Task.input` other types                | Per Task                 | Either    | Not standardised | Use cases MAY define more (COW names a Specimen or a QuestionnaireResponse).                        |
| `Task.output`                           | Per Task                 | Fulfiller | Used, optional | Outcomes hosted at the Fulfiller; see [Outputs and completion](#outputs-and-completion).              |
| `Task.restriction.period`               | Per Task                 | Placer    | Used, optional | Window in which the data stays available for pull.                                                    |
| `Task.description`, `Task.note`         | Per Task                 | Either    | Allowed        | Free text for humans.                                                                                 |
| `Task.reasonCode`, `.reasonReference`   | Per Task                 | Placer    | Not used       | The reason belongs to the order, so it is on the Request.                                             |
| `notification-event.focus`              | Per Task                 | Placer    | Used           | The Task reference; the only content of an `id-only` notification.                                    |
| `notification-authorization-hint`       | Per Task                 | Placer    | Not used       | The basis is recorded at the Placer, see [Authorization basis](#authorization-basis); the extension is an open question. |
| `notification-event.additional-context` | Per Task                 | Placer    | Not used       | The notification carries the Task reference and nothing else; everything per order is on the Task.   |
{:.grid .table-hover}

### Cancellation

Profile (for the sub-Task used after the Fulfiller has started): [NlCowCancellationRequestTask](StructureDefinition-nl-cow-cancellationrequest-task.html), derived from COW's [Cancellation Request Task](https://build.fhir.org/ig/HL7/fhir-cow-ig/StructureDefinition-cancellation-request-task.html).

{% include clinical-workflow-cancellation.svg %}

Cancellation follows COW. The Placer never uses `Subscription.status = off` to cancel an order; the Subscription belongs to the notification layer. A notification cannot be cancelled either. Only the workflow state changes, and a new notification announces that change.

- **Placer cancels before the Fulfiller started** (Task is `requested`, `received` or `accepted`): the Placer sets `Coordination Task.status = cancelled`. The notification follows.
- **Placer cancels after the Fulfiller started** (Task is `in-progress`): the Placer creates a `CancellationRequest Task` with `Task.code = abort`, `Task.status = requested` and `Task.focus` referencing the Coordination Task. A notification points the Fulfiller to this new Task. The Fulfiller reads it and sets it to `accepted` or `rejected`. On acceptance the Placer sets the Coordination Task to `cancelled`.
- **Fulfiller declines or abandons**: the Fulfiller sets the Coordination Task to `rejected` (from `requested` or `received`) or `failed` (from `in-progress`). No separate Task is needed; the Fulfiller owns these transitions.

In both Placer paths the Placer decides whether the order itself is withdrawn. If so, it also sets `Request.status = revoked`, as COW requires. If the order stays open (a losing candidate in a solicitation, an order re-routed to another Fulfiller), the Request stays `active` and only the Task is cancelled. A Fulfiller reads the difference from the Request.

Every Task write notifies its owner, including the Fulfiller's own writes above (see [Overview](#overview)); the diagram omits those echoes.

This profile narrows the CancellationRequest Task's focus to the Coordination Task: only the Placer requests a cancellation. COW also lets a Fulfiller ask the Placer to revoke the order, with a CancellationRequest Task whose focus is the Request. That path is not profiled here: the Dutch use cases have no need beyond `rejected` and `failed`, and COW is still balloting whether it becomes a separate profile. The narrowing is a deviation from COW for that reason.

### Patient identification

> **Under discussion.** The placement and conveyance of the BSN is still being debated by the working group. The rules below are this profile's proposal, as input for that decision.

A candidate Fulfiller decides on an offer without the patient's BSN. It needs the BSN when it starts matching the patient in its own record, at acceptance or selection, and for legal-basis evaluation before the data pull. Whether a Fulfiller may know the BSN at all depends on the use case: eOverdracht only allows the BSN to be communicated when the receiver already has a treatment relationship with the patient, and keeps it off the Task for that reason. TA NP v1.0.1 sends it at creation, on the Task or in an OAuth `patient` claim.

This profile keeps the patient on the Coordination Task and lets the Placer decide, per Fulfiller and per phase, whether the BSN is on it:

1. `Task.for` SHALL reference the `Patient` resource at the Placer. The Placer's access record decides whether a Fulfiller may read it.
2. `Task.for.identifier` (system `http://fhir.nl/fhir/NamingSystem/bsn`) is optional. The Placer SHALL populate it when the Fulfiller may know the patient's BSN, and SHALL NOT before. The use case's information standard defines when that is: at creation for a Fulfiller with an existing treatment relationship, after selection in a solicitation.
3. Adding the BSN later is a Task update and notifies the Fulfiller, like any other addition to the workflow.
4. `Request.subject` SHALL reference the Patient without an identifier. The Request is shared by all candidates and outlives the selection, so it carries no BSN.
5. The BSN is not carried in the notification or in the access-control layer (TA NP's OAuth `patient` claim).

The Task is the right place because it is per Fulfiller where the Request is shared, and because a Task update notifies where a Request update does not. Both legacy positions fit: TA NP's use cases set the identifier at creation, eOverdracht's after selection.

### Authorization basis

Many Notified Pull use cases are referrals or transfers of care. There the legal basis for disclosure is **not** always a recorded patient consent or an existing treatment relationship between patient and Fulfiller. It can be the referral itself (presumed consent under the WGBO), inter-collegial consultation, or another ground the Placer determines.

The Placer decides this basis when it creates the order and records it locally: which Fulfiller may pull which resources, for which purpose, until when. [GF Authorization](./authorization.html) carries this record into the policy input as a local consent record on the requested resource (`resource.consents` with a `scope`) and evaluates the Fulfiller's pull against it, together with the other inputs. The Fulfiller presents nothing beyond its normal access token. The Placer withdraws the basis by removing the record, for example when the Task is cancelled or `Task.restriction.period` ends. In a solicitation the record per candidate is narrow until selection.

Nothing about the basis travels in the notification. This follows TTA Notifications v0.6, which verifies authorization at the Placer before activation, before each send and at the pull, and carries nothing else in an `id-only` notification.

TA NP v1.0.1 carried the basis as an opaque `authorization-base` token in the notification Task, which the Fulfiller played back on token requests. The Backport IG's CI build (1.2.0-ballot, unpublished) has a trial extension, [`notification-authorization-hint`](https://build.fhir.org/ig/HL7/fhir-subscription-backport-ig/StructureDefinition-notification-authorization-hint.html), that could carry such a token on `notification-event`. It would matter where the authorization server is not the Placer's own. Whether the harmonized TA needs it is an open question; see [Open questions](#open-questions).

### Mapping: Twiin TA NP v1.0.1 to this profile

| TA NP                                             | This profile                                                    |
|---------------------------------------------------|-----------------------------------------------------------------|
| Notification Task (STU3 Task, POSTed to receiver) | Notification Bundle, see [Notification](notification.html)      |
| Task.code = `pull-notification`                   | SubscriptionTopic canonical URL, see [Notification](notification.html) |
| Task.status = `requested` / `cancelled`           | Coordination Task status / CancellationRequest Task             |
| Workflow Task                                     | Coordination Task (same role, COW-profiled)                     |
| Task.input:authorization-base                     | Basis recorded at the Placer, see [Authorization basis](#authorization-basis) |
| Task.input:query-available-resources              | Derived from Request / PlanDefinition (see Data retrieval)      |
| Task.input:read-available-resource                | Idem                                                            |
| Task.input:get-workflow-task                      | Obsolete; the Coordination Task is always referenced            |
| Task.for.identifier (BSN) or OAuth patient claim  | `Coordination Task.for.identifier` (BSN)                        |
| Notification Cancellation (conditional update)    | CancellationRequest Task (if accepted) or status update         |
{:.grid .table-hover}

### Mapping: Nuts eOverdracht to this profile

| eOverdracht                                       | This profile                                                    |
|---------------------------------------------------|-----------------------------------------------------------------|
| Empty POST to Task endpoint                       | Notification referencing a Coordination Task, see [Notification](notification.html) |
| Task (STU3, Nictiz eOverdracht profile)           | Coordination Task + Request (COW-profiled, R4)                  |
| Task.input:nursingHandoff (document reference)    | Request.code + dataset queries via PlanDefinition               |
| Task.status transitions gate access               | Coordination Task status transitions + access record at the Placer |
| Nuts Authorization Credential                     | Basis recorded at the Placer, see [Authorization basis](#authorization-basis) |
{:.grid .table-hover}

### Open questions

1. **Query list location.** The canonical query list is on the Request via a PlanDefinition, per-order additions are on `Task.input`. Open is whether TA NP wants the canonical list on the Task as well. To be decided by the working group.
1. **SubscriptionTopic ownership.** Whether NL topics are published per dataset or per use case, and under which canonical base URL.
1. **Authorization basis on the wire.** Whether the harmonized TA carries a basis to the Fulfiller (the `notification-authorization-hint` extension) in addition to the basis recorded at the Placer. TA Notifications v0.6 has no equivalent for TA NP's `authorization-base`; the working group's fit-gap analysis (August 2026) names the extension as a candidate.
1. **Patient identification / BSN placement.** This draft places the BSN on `Coordination Task.for.identifier`, populated per Fulfiller and per phase (see [Patient identification](#patient-identification)). Alternatives are carrying it via the access-control layer (the OAuth `patient` claim, as in TA NP v1.0.1), via a Patient resource reference only, or inside the notification itself. Needs working-group decision.
