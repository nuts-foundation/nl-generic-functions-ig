<!--
SPDX-FileCopyrightText: 2026 Steven van der Vegt

SPDX-License-Identifier: CC-BY-SA-4.0
-->

> **Status: discussion document.** This page is a working-group exploration, not a specification.
> Nothing on it is confirmed. It exists to answer the question at which granularity should
> SubscriptionTopics be defined for subscriber-initiated Notified Pull (without a workflow).

### Introduction

The working group has to decide at which granularity a Subscriber can scope a subscription in pure
Notified Pull. We will make use of 4 "levels" of granularity:

| Level | Granularity                                          | Example                                              |
| ----- | ---------------------------------------------------- | ---------------------------------------------------- |
| L1    | FHIR resource type, optionally narrowed by a query   | All `Observation?category=laboratory` for patient X  |
| L2    | Data category (zorgcontext)                          | All medication data for patient X                    |
| L3    | Named canonical dataset                              | The BgZ of patient X                                 |
| L4    | Per-case set, curated by the initiator               | The dataset behind one specific referral (sender-initiated; not applicable to subscriber-initiated NP) |
{:.grid .table-hover}

Letting a Subscriber define topics freely was already recognized as a risk: unpredictable
server load and an unclear query support across
Dutch servers. As the [anatomy section](#what-a-subscriptiontopic-actually-is) below shows, the
chosen notification mechanism rules free definition out anyway so the open question is purely at
which granularity the, nationally published set of topics is defined.

This page works that question through a use-case: **a GP practice wants to stay current on
the BgZ data that a hospital holds for a shared patient.** Every scenario answers the same
questions for a different topic granularity: which topics must exist, what the GP must subscribe to to
cover the BgZ, what it gets notified on (and not), what the receiving system has to do per
notification, and what it costs both sides.

Scenarios are presented in order of granularity, coarsest first. At the end there will be a comparison.
A note on authorization and Access policy: theoratically this can be used to limit sets of data,
but that is not how we assume it is used. It can veto an event, never define scope (see [Topic matching and access evaluation](#topic-matching-and-access-evaluation)).

A note on the backport: topics are implemented by hand, so a contract could technically demand
anything. With forward compatibility in mind we limit topics to the R5/R6 `SubscriptionTopic`
solution space (see [Forward compatibility](#forward-compatibility)).

### What a SubscriptionTopic actually is

This IG uses the [Subscriptions R5 Backport](https://hl7.org/fhir/uv/subscriptions-backport/) on
FHIR R4 (see [Notification](notification.html)). Under that combination, a topic is less of a
runtime object than the name suggests:

- **On the wire, a topic is only a canonical URL.** The Subscription carries it in
  `Subscription.criteria`; per the Backport profile, "the primary criteria is always the topic,
  indicated by its canonical URL".
- **R4 has no SubscriptionTopic resource.** The Backport IG declares full topic definitions
  out-of-scope for R4. The definition is a design-time artifact: a human-readable contract
  published in an Implementation Guide, optionally accompanied by an R4B/R5-format
  `SubscriptionTopic` JSON as a machine-readable reference. It is documentation, not something a
  server stores and interprets at runtime.
- **Sources implement topics as code.** A vendor reads the published specification and implements/configures the
  trigger logic manually ("when a resource matching X is written and an active Subscription matches,
  emit an event"). The server advertises which topic URLs it supports via the Backport's
  CapabilityStatement SubscriptionTopic Canonical extension.
- **The Subscriber's entire freedom is `canFilterBy`.** A topic declares which filter parameters a
  Subscriber may set; the Subscription carries them in the `backport-filter-criteria` extension.
  Per the Backport, filter keys "can be either search parameters appropriate to the filtering
  resource or keys defined within the subscription topic".

Two consequences frame everything that follows:

1. **A finite national topic set is not (only) a policy choice but also an architecture consequence.** A Subscriber
   cannot send a topic definition to a server; it can only cite URLs the server already
   implements. The risk to manage is therefore not "subscribers overload servers with free
   queries" but "the national set is cut at the wrong granularity".
2. **Topic granularity is the unit of vendor implementation cost.** Every topic in the national
   set is a contract that every source system must implement, test, advertise and keep correct
   across versions.

One more distinction matters before the scenarios make sense. Granularity design has **two independent
properties**:

- **Event granularity**: which changes produce an event at all.
- **Topic-artifact granularity**: how those events are sliced into named topics, versus
  parameterized by filters within one topic.

The same event stream can be offered as many narrow topics or as one broad topic with a
`canFilterBy` parameter. The events on the wire are identical; what changes is bookkeeping: one
Subscription per topic, and each Subscription is its own channel with its own `event-number`
sequence, handshake and heartbeats. Several scenarios below differ only in this second dial.

#### Topic matching and access evaluation

Between a change at the source and a notification at the Subscriber sit two independent gates, in
series:

1. **Topic matching**: does the change match the topic's triggers and the
   Subscription's filters? Nationally defined, identical at every source.
2. **Access evaluation**: may _this_ Subscriber be told about _this_ event? Even an
   `id-only` notification disclosing only "an Observation exists for patient X" is a
   disclosure, so the source must know or evaluate it per event against the related policy it has for this
   Subscriber and context.

The second gate is not optional: servers "SHOULD ensure that authorization is (still) in place when
sending any event notifications"; shielded data "cannot generate a notification event" at all
([R5 Subscriptions](https://hl7.org/fhir/R5/subscriptions.html#safety),
[Backport safety](https://hl7.org/fhir/uv/subscriptions-backport/safety_security.html)).
Suppression of events is silent: the Subscriber cannot distinguish "nothing happened" from "withheld".

A source could technically narrow a broad topic to "what it considers relevant" by authz-policy. That
breaks the contract and voids any completeness claim;
[best practice](https://www.cms.gov/priorities/burden-reduction/overview/interoperability/frequently-asked-questions/admission-discharge-transfer-patient-event-notification-conditions-participation-cop-42-cfr-482-24d)
scopes by contract and suppresses only on patient opt-out. This page defines the gate's role
as follows:

- **Scope is defined by the topic.** A Subscriber receives the full stream; access is enforced again
  at pull time.
- **National policies or patient opt-out can filter.** Only on grounds that would also block the pull:
  patient shielding or a lapsed legal basis. Completeness means "complete minus national
  shielding rules".
- **A retracted basis ends the Subscription.** The source sets `Subscription.status = off`; the
  Subscriber learns it via `$status` or a final notification. HL7 defines no mechanism here; the
  convention is ours to write.

### Anchor case: a GP follows a hospital patient

| Actor                            | Properties                                                                                  |
| -------------------------------- | ------------------------------------------------------------------------------------------- |
| Source / Subscription Server     | Hospital EHR, URA `22222222`, FHIR endpoint `https://hospital-ehr.example.org/fhir`         |
| Subscriber / Subscription Client | GP system, URA `33333333`, notification endpoint `https://gp-his.example.org/notifications` |
| Patient                          | BSN `999911120`, under treatment at the hospital, enrolled at the GP                        |
{:.grid .table-hover}

This is pure Notified Pull: no order, or workflow Task. The Subscription is created **in-band**: the GP system POSTs
it to the hospital's FHIR endpoint, citing a topic canonical URL and filters. Subscriptions are per
patient; the partner-wide variant (one Subscription for all shared patients) is treated once in
[Interest direction](#interest-direction-receiver-asserted-and-sender-addressed).

### The patient filter

Every scenario below allows the same `patient` filter: limit events to one patient, identified
by BSN. It is defined once, nationally, and referenced from each topic's `canFilterBy`.

The `patient` filter parameter is not a standard search parameter: many resource types lack one,
and some (`Medication`, `Practitioner`) have no patient link at all. The topic backs it with a
national `SearchParameter`, referenced by `filterDefinition`, one expression branch per resource
type:

```json
{
  "resourceType": "SearchParameter",
  "url": "http://fhir.nl/SearchParameter/patient-identifier",
  "name": "PatientIdentifier",
  "status": "draft",
  "code": "patient",
  "base": ["Patient", "Observation", "Condition", "Encounter", "Coverage"],
  "type": "token",
  "description": "The patient a resource is about, matched on identifier (BSN).",
  "expression": "Patient.identifier | Observation.subject.identifier | Condition.subject.identifier | Encounter.subject.identifier | Coverage.beneficiary.identifier"
}
```

An R5/R6 server evaluates the expression against the changed resource and token-compares the
result to the filter value (`bsn|999911120`); the backport implements the same contract by hand.
The expression matches the BSN carried on the reference itself, which nl-core profiles populate;
a server may instead resolve the reference and match `Patient.identifier`. Chained parameters
(`patient.identifier=...`) exist in no FHIR version for subscription filters. Resources outside
every patient compartment never produce events, at any granularity.

### Scenario L0: one catch-all topic

L0 is on this page because it is the base case with the coarsest possible topic with
one topic for everything. It carries the full wire-level components (topic contract, Subscription,
notification) and allows us to show the basic shape of a subscription and build the following scenario's from it by only showing the difference.

#### The topic contract

What a national publication of this topic would amount to:

|                                 |                                                                         |
| ------------------------------- | ----------------------------------------------------------------------- |
| Canonical URL                   | `http://fhir.nl/SubscriptionTopic/patient-record-changed`               |
| Event                           | Any create, update or delete of any resource in the patient compartment |
| Allowed filters (`canFilterBy`) | [`patient`](#the-patient-filter)                                        |
| Notification payload            | `id-only` (see [Notification](notification.html))                       |
{:.grid .table-hover}

As a full machine-readable reference, in FHIR R5 `SubscriptionTopic` form (remember: R4 itself has no `SubscriptionTopic` resource).

```json
{
  "resourceType": "SubscriptionTopic",
  "id": "patient-record-changed",
  "url": "http://fhir.nl/SubscriptionTopic/patient-record-changed",
  "version": "0.1.0",
  "title": "Patient record changed (L0 catch-all)",
  "status": "draft",
  "experimental": true,
  "description": "Fires on any change to any resource in a patient compartment at the source. Boundary case for the granularity discussion; not a proposal.",
  "resourceTrigger": [
    {
      "resource": "http://hl7.org/fhir/StructureDefinition/Observation",
      "supportedInteraction": ["create", "update", "delete"]
    },
    {
      "resource": "http://hl7.org/fhir/StructureDefinition/Condition",
      "supportedInteraction": ["create", "update", "delete"]
    },
    {
      "resource": "http://hl7.org/fhir/StructureDefinition/Encounter",
      "supportedInteraction": ["create", "update", "delete"]
    }
  ],
  "canFilterBy": [
    {
      "description": "Limit events to a single patient, identified by BSN.",
      "filterParameter": "patient",
      "filterDefinition": "http://fhir.nl/SearchParameter/patient-identifier"
    }
  ]
}
```

Shown are three of the triggers. There is no wildcard in any FHIR version, so the normative
topic enumerates one trigger per resource type in the patient compartment (60+). "Everything" is
the most expensive contract to write down.

#### The flow

{% include subscription-topics-l0.svg %}

#### What the GP creates

The GP system POSTs one Subscription to `https://hospital-ehr.example.org/fhir/Subscription`
(diagram step 1). The topic URL goes in `criteria` and the patient filter in a backported
extension:

```json
{
  "resourceType": "Subscription",
  "meta": {
    "profile": [
      "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-subscription"
    ]
  },
  "status": "requested",
  "reason": "GP keeps its record current for a shared patient",
  "criteria": "http://fhir.nl/SubscriptionTopic/patient-record-changed",
  "_criteria": {
    "extension": [
      {
        "url": "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-filter-criteria",
        "valueString": "patient=http://fhir.nl/fhir/NamingSystem/bsn|999911120"
      }
    ]
  },
  "channel": {
    "extension": [
      {
        "url": "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-heartbeat-period",
        "valueUnsignedInt": 86400
      }
    ],
    "type": "rest-hook",
    "endpoint": "https://gp-his.example.org/notifications",
    "payload": "application/fhir+json",
    "_payload": {
      "extension": [
        {
          "url": "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-payload-content",
          "valueCode": "id-only"
        }
      ]
    }
  }
}
```

The hospital validates the request against the topic contract (is the topic URL supported? is
`patient` an allowed filter? may this Subscriber follow this patient?), stores the
Subscription with `status = requested`, performs the handshake to the GP's notification endpoint,
and flips the status to `active` (steps 2-5). From here on the channel is guarded by heartbeats:
silence longer than the agreed period tells the GP to check `$status`.

#### What arrives

A week later a lab result lands in the hospital EHR (step 6): a new `Observation` with category
`laboratory`. The write matches the topic (any resource, this patient), so the hospital POSTs a
notification Bundle to the GP's endpoint (step 7):

```json
{
  "resourceType": "Bundle",
  "meta": {
    "profile": [
      "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-subscription-notification-r4"
    ]
  },
  "type": "history",
  "timestamp": "2026-06-04T14:12:09+02:00",
  "entry": [
    {
      "fullUrl": "urn:uuid:1d3c5b7a-9e2f-4c80-b1a6-3f5d7e9c2b4a",
      "resource": {
        "resourceType": "Parameters",
        "meta": {
          "profile": [
            "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-subscription-status-r4"
          ]
        },
        "parameter": [
          {
            "name": "subscription",
            "valueReference": {
              "reference": "https://hospital-ehr.example.org/fhir/Subscription/63f0a7d2-44cd-4f54-9c1e-2b8e1d0a9b3f"
            }
          },
          { "name": "status", "valueCode": "active" },
          { "name": "type", "valueCode": "event-notification" },
          {
            "name": "notification-event",
            "part": [
              { "name": "event-number", "valueString": "7" },
              {
                "name": "timestamp",
                "valueInstant": "2026-06-04T14:12:09+02:00"
              },
              {
                "name": "focus",
                "valueReference": {
                  "reference": "https://hospital-ehr.example.org/fhir/Observation/d9c3b2a1-5e64-4f00-8c11-7aa2f60b3c55"
                }
              }
            ]
          }
        ]
      },
      "request": {
        "method": "GET",
        "url": "https://hospital-ehr.example.org/fhir/Subscription/63f0a7d2-44cd-4f54-9c1e-2b8e1d0a9b3f/$status"
      },
      "response": { "status": "200" }
    }
  ]
}
```

With `id-only` payload the Bundle carries no clinical content, but it is not anonymous either: the
focus URL alone tells the GP that an `Observation` now exists for this patient. The notification
itself is a disclosure and must pass the same authorization policy as a read.

#### What the GP system does

Per incoming notification (steps 8-9):

1. Match the Bundle to the stored Subscription and verify the sender.
2. Check `event-number` continuity. This Bundle says `7`; if the GP last processed `5`, event `6`
   was missed and is recovered via the `$events` operation on the Subscription.
3. Read the focus URL. At L0 the URL is the only clue to what changed; the resource type in it
   (`Observation`) is known **before** any pull.
4. Decide whether to pull. The GP cannot tell from the notification whether the change is
   BgZ-relevant, clinically interesting, or administrative noise; for anything potentially
   relevant it must `GET` the focus resource and classify it after the fact.
5. Update the local record, or discard.

This is the L0 summary in one line: **the channel is trivial to set up but the topic does not provide any relevance filtering. That is a job of the subscriber after the pull.**

#### Observations

- **Coverage**: trivially complete. Every BgZ change for this patient produces an event, because
  every change does.
- **Noise**: maximal. An inpatient stay produces hundreds of writes (every vital-signs
  measurement, every administrative update); each one becomes a notification to a GP who wanted
  BgZ currency.
- **Source cost**: the trigger logic is trivial ("fire on everything"), so the cost is volume:
  every write to a followed patient runs the full delivery machinery (matching, shielding check,
  delivery, audit). Narrower topics shrink the stream before it reaches that machinery.
- **Privacy**: the existence of a resource type leaks information by itself. A
  notification with focus `.../Condition/...` from a psychiatric department discloses something.
- **Governance**: one topic, nothing dataset-specific to maintain. The catch-all is the cheapest
  possible artifact to govern, which is exactly why everything it does not solve lands on the
  parties at runtime.
- **Forward compatibility**: poor. No FHIR version has a wildcard or compartment trigger; a
  conformant topic enumerates every resource type.
### Scenario L1: one topic per resource type

The national set publishes one topic per FHIR resource type: `observation-changed`,
`condition-changed`, `encounter-changed`, and so on. Filters narrow within the type: all
laboratory Observations for patient X.

#### The topic contract

One representative topic; the other types follow the same shape.

|                                 |                                                        |
| ------------------------------- | ------------------------------------------------------ |
| Canonical URL                   | `http://fhir.nl/SubscriptionTopic/observation-changed` |
| Event                           | Any create, update or delete of an `Observation`       |
| Allowed filters (`canFilterBy`) | [`patient`](#the-patient-filter), `category`, `code`   |
| Notification payload            | `id-only`                                              |
{:.grid .table-hover}

Unlike L0, `category` and `code` are plain `Observation` search parameters; only `patient`
stays topic-defined, backed by the same national `SearchParameter`.

#### What the GP creates

One Subscription cites one topic. Covering the BgZ takes 19 Subscriptions per patient: 19
handshakes, 19 event-number streams, 19 heartbeat timers. Flow and channel settings are identical
to L0.

| Topic                            | Filter besides patient        | BgZ content covered                   | Notes                                                                      |
| -------------------------------- | ----------------------------- | ------------------------------------- | -------------------------------------------------------------------------- |
| `patient-changed`                | -                             | Patient info, contacts, GP            | Fires on any demographic change                                            |
| `consent-changed`                | `category` (2 codes)          | Treatment/advance directives          |                                                                            |
| `observation-changed`            | `category` (lab, vitals, ...) | Lab, vitals, functional/social        | BgZ selects some observations by `code`; a `category` filter over-notifies |
| `medication*-changed` (3 topics) | -                             | Medication use, agreements, dispenses | One BgZ section, three topics                                              |
| `procedure-changed`              | `category` (surgical)         | Procedures                            |                                                                            |
| `encounter-changed`              | `class` (IMP, ACUTE, NONAC)   | Encounters                            | Without the `class` filter: every outpatient contact                       |
| `servicerequest-changed`         | -                             | Planned procedures                    | STU3 BgZ uses `ProcedureRequest`; R4 equivalent is `ServiceRequest`        |
{:.grid .table-hover}

Ten rows without distinguishing filters omitted for brevity (allergies, alerts, problems,
coverage, devices, vaccinations, nutrition, planned care).

The Subscription differs from L0 only in `criteria`. Multiple filter extensions AND together;
commas OR within one parameter (backport search syntax; undefined in R5/R6):

```json
"criteria": "http://fhir.nl/SubscriptionTopic/observation-changed",
"_criteria": {
  "extension": [
    {
      "url": "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-filter-criteria",
      "valueString": "patient=http://fhir.nl/fhir/NamingSystem/bsn|999911120"
    },
    {
      "url": "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-filter-criteria",
      "valueString": "category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory,http://terminology.hl7.org/CodeSystem/observation-category|vital-signs"
    }
  ]
}
```

#### What the GP system does

As L0, with two differences:

- The Subscription that delivered the event implies the resource type and the BgZ mapping; no
  need to parse the focus URL for routing.
- Continuity tracking runs per Subscription: 19 `event-number` sequences, 19 heartbeat timers,
  19 `$events` catch-up paths.

Relevance is still settled after the pull: a `category` filter cannot see that BgZ wants only the
most recent observation (`$lastn`) or only specific codes.

#### Observations

- **Coverage**: complete; the 19 topics span every BgZ section. `Medication` resources sit
  outside the patient compartment and never notify; their content comes with the pull.
- **Noise**: well below L0. What remains comes from filter coarseness: `category` is wider than
  BgZ's code lists, and every update of a matching resource notifies, also where the BgZ snapshot
  would ignore it.
- **Subscriber cost**: the 19x bookkeeping. 1,000 shared patients means 19,000 Subscriptions and
  as many daily heartbeats.
- **Intent**: invisible. Nineteen subscriptions that mean "follow this patient's BgZ" look to the
  source like nineteen unrelated interests. FHIR has no way to group Subscriptions.
- **Authorization binding**: none. A permission rule needs something to name; no
  autorisatierichtlijn row can attach to `observation-changed`, and the dataset it would bind to
  is not named anywhere.
- **Source cost**: trigger evaluation is cheap; type plus standard search parameters maps onto
  existing FHIR search machinery. The cost sits in administration: 19 admission checks against
  the same legal basis, and on a lapsed basis finding and switching off all 19. The source must
  tie Subscriptions to the recorded basis itself; the standard offers nothing.
- **Privacy**: the GP only learns about types it subscribed to. Existence leak per event remains.
- **Governance**: the type list must be complete and versioned; a BgZ section without a published
  topic is a silent hole. Topics are dataset-neutral: the same set serves eOverdracht, MedMij or
  any other dataset.
- **Forward compatibility**: good. Type-scoped triggers and standard search parameters are
  native R5/R6 configuration; only the comma-OR value lists are undefined there.
### Scenario L2: one topic per data category

The national set adopts the
[GF data categories (zorgcontext)](https://minvws.github.io/generiekefuncties-docs/ValueSet-nl-gf-zorgcontext-vs.html):
28 codes used to publish and localize patient data in the national localization index, intended
to cover all patient data. Two subscription variants exist: 28 topics, one per category,
subscribed like L1; or one topic with a `data-category` filter. Events are identical; the
single-topic variant is worked out here.

#### The topic contract

|                                 |                                                         |
| ------------------------------- | ------------------------------------------------------- |
| Canonical URL                   | `http://fhir.nl/SubscriptionTopic/patient-data-changed` |
| Event                           | Any change to a resource that maps to a data category   |
| Allowed filters (`canFilterBy`) | [`patient`](#the-patient-filter), `data-category`       |
| Notification payload            | `id-only`                                               |
{:.grid .table-hover}

The contract's bulk is the mapping: per category, which resource types and conditions belong to
it. Nine of the 28 codes are `Observation` split by category, most others are single resource
types, a few span types (`Request`, `Imaging`, `Episode`). Whether one resource may map to
several categories is not specified (value set v0.10.0).

#### What the GP creates

One Subscription per patient. The category list for the BgZ:

| `data-category` filter value                                                                | BgZ content                                                          | Notes                                                         |
| ------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------- |
| `Patient`                                                                                   | Patient info, contacts, GP                                           |                                                               |
| `AdvanceDirective`, `Consent`                                                               | Treatment/advance directives                                         |                                                               |
| `ObservationLaboratory`, `ObservationVitalSigns`, `ObservationSocialHistory`                | Lab, vitals, lifestyle                                               |                                                               |
| `MedicationRequest`, `MedicationUse`                                                        | Medication                                                           | Where dispenses map is unclear                                |
| `Condition`, `AllergyIntolerance`, `Alert`, `Procedure`, `Encounter`, `Device`, `Nutrition` | Problems, allergies, alerts, procedures, encounters, aids, nutrition | Type-shaped, mapping trivial                                  |
| `Request`                                                                                   | Planned care                                                         | One category, five resource types                             |
| none                                                                                        | Functional status                                                    | No fitting category (`ObservationExam`? `ObservationSurvey`?) |
| none                                                                                        | Payment details                                                      | No category for `Coverage`                                    |
| none                                                                                        | Vaccinations                                                         | No category for `Immunization`                                |
{:.grid .table-hover}

Sixteen categories cover what they can; three BgZ sections have no home. The Subscription
differs from L0 in `criteria` and the second filter:

```json
"criteria": "http://fhir.nl/SubscriptionTopic/patient-data-changed",
"_criteria": {
  "extension": [
    {
      "url": "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-filter-criteria",
      "valueString": "patient=http://fhir.nl/fhir/NamingSystem/bsn|999911120"
    },
    {
      "url": "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-filter-criteria",
      "valueString": "data-category=Patient,Condition,AllergyIntolerance,ObservationLaboratory,ObservationVitalSigns,MedicationRequest,MedicationUse,Encounter,Procedure,Request"
    }
  ]
}
```

#### What the GP system does

As L1, on a single stream. The notification does not say which category fired; the resource type
comes from the focus URL, classification comes after the pull. Per-type narrowing is gone: the
`data-category` filter cannot carry an encounter `class` or observation `code`, so every
encounter notifies, not only admissions.

#### Observations

- **Coverage**: the value set misses BgZ ground: no category for payment details or
  vaccinations, ambiguous homes for functional status and dispenses.
- **Noise**: above L1. Category granularity drops the per-type filters that L1 still had.
- **Subscriber cost**: one Subscription per patient. The category list per dataset is a lookup
  once defined nationally.
- **Intent**: approximate. "These sixteen categories" gestures at the BgZ without naming it.
- **Authorization binding**: per category. The categories are the localization vocabulary, so a
  subscription mirrors a localization-index registration and a permission rule can name a
  category. A rule about the BgZ as such has no anchor; it shatters into sixteen category rules.
- **Source cost**: classify every write into categories. Trivial for the type-shaped codes,
  contested for `Imaging`, `Genomics`, `Episode`, `Request`. The classification must be
  identical at every source, or the same subscription means different things.
- **Privacy**: as L1 per event; the subscription reveals a category profile.
- **Governance**: VWS owns the categories, Nictiz owns the datasets; the dataset-to-category
  mapping needs an owner and moves whenever either side changes.
- **Forward compatibility**: weak for this single-topic variant. A server evaluates a filter by
  reading values from the changed resource, and no resource carries its zorgcontext code: the
  category is the outcome of the mapping rules. Those rules are queries, queries live in
  triggers, and triggers are identical for every subscriber, so they cannot carry a
  per-subscriber category choice. Every source therefore implements the mapping itself, as code
  or vendor configuration. The 16-value comma list is also undefined in R5/R6 filters: one
  Subscription decays into 16.

**The 28-topic variant**: one topic per category, generated from the same mapping table the way
L3a generates from the PlanDefinition; each topic expresses its category as ordinary triggers
and reuses its type's search parameters (`class`, `code`) as filters, so per-type narrowing
returns. No comma lists, no custom mapping at the source, portable to R5/R6. The price is
L1-style bookkeeping: 16 Subscriptions and 16 event streams per patient. The scores table
carries both forms.
### Scenario L3: one topic per dataset

The national set publishes one topic per canonical dataset. For the BgZ that is a single topic
that fires when the patient's BgZ changes; eOverdracht and medicatiegegevens would get their own.

"The BgZ changed" can mean two things as an event, and the choice defines the topic:

- **L3a, change events**: every change to a resource belonging to the dataset is an event. The
  topic contract is the BgZ selection recast as triggers.
- **L3b, snapshot events**: the source publishes or updates a BgZ container; the publication is
  the event. The topic contract is about the container, not its members.

#### L3a: change events

|                                 |                                                |
| ------------------------------- | ---------------------------------------------- |
| Canonical URL                   | `http://fhir.nl/SubscriptionTopic/bgz-changed` |
| Event                           | Any change to a resource in the patient's BgZ  |
| Allowed filters (`canFilterBy`) | [`patient`](#the-patient-filter)               |
| Notification payload            | `id-only`                                      |
{:.grid .table-hover}

The trigger list mirrors the BgZ section queries, one trigger per section:

```json
"resourceTrigger": [
  {
    "resource": "http://hl7.org/fhir/StructureDefinition/Observation",
    "supportedInteraction": ["create", "update"],
    "queryCriteria": {
      "current": "category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory",
      "resultForCreate": "test-passes"
    }
  },
  {
    "resource": "http://hl7.org/fhir/StructureDefinition/Encounter",
    "supportedInteraction": ["create", "update"],
    "queryCriteria": {
      "current": "class=http://terminology.hl7.org/CodeSystem/v3-ActCode|IMP,http://terminology.hl7.org/CodeSystem/v3-ActCode|ACUTE,http://terminology.hl7.org/CodeSystem/v3-ActCode|NONAC"
    }
  }
]
```

Seventeen more triggers follow the same pattern. They are not hand-maintained: the trigger list
is the dataset's [PlanDefinition](clinical-workflow.html#data-retrieval) query list recast as
write-time predicates, and can be generated from it. Pull-time constructs (`_include`, `$lastn`)
are stripped, `supportedInteraction` (including delete) is added. One published query list then
powers the receiver's pull, the source's triggers and, where wanted, the L3b view: the dataset
definition evaluated forwards and backwards.

The Subscription the GP creates is identical to
the L0 example, with `criteria = http://fhir.nl/SubscriptionTopic/bgz-changed`: one per patient,
one handshake, one event stream, one heartbeat timer.

The receiver works as in L1, on a single stream. Every event is BgZ-relevant by contract; the
pull still decides what to do with it. Trigger fidelity has limits: "most recent only"
(`$lastn`) and `_include`d resources stay pull-time concerns.

#### L3b: snapshot events

|                                 |                                                             |
| ------------------------------- | ----------------------------------------------------------- |
| Canonical URL                   | `http://fhir.nl/SubscriptionTopic/bgz-published`            |
| Event                           | The source publishes or updates the patient's BgZ container |
| Allowed filters (`canFilterBy`) | [`patient`](#the-patient-filter)                            |
| Notification payload            | `id-only`; focus references the container                   |
{:.grid .table-hover}

The container is the `List` from the
[Notified Pull container pattern](notified-pull.html#multi-resource-notifications). Two
publication policies:

- **Continuous**: the container is updated on every member change. Event frequency as L3a, but
  the focus is stable and the receiver diffs `List.entry` instead of classifying resources.
- **Moment-based**: the source publishes at clinical moments (discharge, end of an outpatient
  episode). Few, meaningful events; the copy is stale between moments.

The receiver reads the container and diffs it against its own cached copy; additions and
removals both surface without `_history`, which facade servers rarely offer. The focus URL leaks
no resource type: an event says only "the BgZ changed".

The container is a view on the dataset: materialized by executing the PlanDefinition queries,
maintained only while subscriptions are active. No subscribers, no view; the standing cost for
unsubscribed patients and datasets is zero. Continuous publication then costs L3a's trigger
evaluation plus a List write.

#### Observations

- **Coverage**: complete by contract in L3a. In L3b it equals the publication policy: complete
  at every moment, stale in between.
- **Noise**: none by construction; the trigger or container is the BgZ selection.
- **Subscriber cost**: minimal. One Subscription per patient; 1,000 shared patients means 1,000
  Subscriptions. L3b receivers skip resource classification entirely.
- **Intent**: explicit. The Subscription says "follow this patient's BgZ"; admission, audit and
  a lapsed basis each concern exactly one Subscription.
- **Authorization binding**: direct. The topic names a Nictiz informatiestandaard dataset, so
  one checkable rule attaches: an autorisatierichtlijn row ("GP may subscribe to BgZ") with a
  systeemrol ("BgZAbonnerend"); abonneren would join the four Nictiz activity verbs. MedMij and
  LSP Signaal already scope subscriptions to named datasets.
- **Source cost**: dataset-specific code. L3a evaluates the BgZ selection queries at write time
  instead of query time. L3b adds a view per subscribed patient (continuous) or publication
  hooks in the clinical workflow (moment-based).
- **Privacy**: L3a leaks resource types as L1 does. L3b leaks least of all scenarios: no type on
  the wire. The subscription itself reveals the broadest intent: the GP follows the whole BgZ.
- **Governance**: the topic version rides the dataset version by generation, not by parallel
  maintenance: a BgZ release regenerates the topic. Each new dataset adds a topic. Nictiz is the
  natural owner; the topic is the information standard's abonneren transactie.
- **Forward compatibility**: best. `queryCriteria` search strings are runtime configuration in
  R5 and R6 unchanged; R6 only renames `resourceTrigger` to `trigger`.
### Scenario L4: per-case curated set

A standing subscriber cannot subscribe to a case that does not exist yet, so L4 is not a
subscription granularity for the anchor case. Per-case curation is sender-initiated: the source
selects resources for one exchange and notifies the recipient.

The transport still fits one generic topic: `curated-set-published`, firing when the source
publishes a container addressed to a recipient. The Subscription is partner-wide and permanent
(`canFilterBy recipient`); the per-case scope lives in the container, not in the topic. This is
the [Notified Pull container pattern](notified-pull.html#multi-resource-notifications); with a
workflow above it, the [Clinical Workflow](clinical-workflow.html) profile. For L4 the
granularity question dissolves: the topic names the exchange pattern, the sender names the data.

### Interest direction: receiver-asserted and sender-addressed

A subscription setup answers two questions: what data, and for whom. The scenarios above put
both in the Subscription: the topic names the data, the `patient` filter names the subject; the
subscriber asserts its own interest. Sender-initiated exchanges answer "for whom" in the data:
the focal resource carries the addressee, and one permanent partner-wide Subscription per
partner delivers everything addressed to it. This IG already uses that form: the
[notification page](notification.html) filters partner-wide on `Task.owner`.

|                     | Receiver-asserted (L1-L3)                      | Sender-addressed (L4, workflow Task)                 |
| ------------------- | ----------------------------------------------- | ----------------------------------------------------- |
| Interest declared   | In the Subscription (topic + `patient` filter)  | In the data (`Task.owner`, recipient on a container)  |
| Subscription shape  | One per patient and dataset                     | One per partner, permanent                            |
| Focal resource      | Shared per patient and dataset; no recipient    | Per case, per recipient                               |
| Partner-wide filter | Not expressible (cross-resource join)           | A plain filter on the focal resource                  |
{:.grid .table-hover}

The directions do not mix: one exchange has one interest holder. Sender addressing fits where
the sender holds the relationship (it curates a set for a known recipient); receiver assertion
fits where interest is the receiver's own call. The container is what enables L4: the sender can
put in it whatever the case needs, beyond any canonical dataset.

Clinical Workflow needs both directions at once. The Coordination Task is the sender-addressed
stream. Whether the Fulfiller also wants updates on the case's dataset while the workflow runs
is its own call: a receiver-asserted subscription, created at acceptance, ended at completion.
That data stream is no new mechanism; it is this page's subscriber-initiated subscription with a
workflow-bounded lifetime. The granularity chosen here is therefore also the shape of the COW
data channel.

### Comparison

#### Scores

Scores trace to the scenario observations. L3b cells split continuous / moment-based where the
publication policy matters.

| Axis                  | L0  | L1  | L2 (1 topic) | L2 (28 topics) | L3a | L3b    |
| --------------------- | --- | --- | ------------ | -------------- | --- | ------ |
| BgZ completeness      | ++  | ++  | -            | -              | ++  | ++ / 0 |
| Noise                 | --  | 0   | -            | 0              | ++  | ++     |
| Subscriber cost       | -   | --  | +            | --             | +   | ++     |
| Source cost           | -   | 0   | -            | 0              | 0   | -      |
| Intent                | --  | --  | 0            | 0              | ++  | ++     |
| Authorization binding | --  | --  | +            | +              | ++  | ++     |
| Governance            | ++  | +   | 0            | 0              | 0   | 0      |
| Privacy               | --  | 0   | 0            | 0              | 0   | ++     |
| Forward compatibility | --  | +   | -            | ++             | ++  | ++     |
{:.grid .table-hover}

#### Reading the table

- **L0** was never a candidate; it calibrates the axes.
- **L1** is eliminated as a complete-dataset strategy: completeness costs 19 subscriptions per
  patient and intent and authorization binding stay empty. Resource-type topics may still serve
  single-concern subscribers (a lab-results-only follower); this page did not evaluate that use.
- **L2 vs L3**: as scored, L3a dominates both L2 forms. The single-topic form concentrates its
  loss in forward compatibility and noise; the 28-topic form repairs both at the price of
  L1-style bookkeeping. The value-set gaps (missing categories, ambiguous homes) are fixable by
  definition; the unnamed dataset intent is not. The scores are the author's judgment; challenge
  individual cells, not the arithmetic.
- **Caveat**: the anchor case is dataset-shaped, which flatters dataset topics. A subscriber
  with a single-concern interest would weight these axes differently.

#### Forward compatibility

In the backport, topics are implemented by hand and a contract can say anything. From R5 on the
topic is a resource the server evaluates as configuration; what cannot be expressed there will
not survive the transition.

One rule explains most of the table below: **R5/R6 reward semantics in triggers and punish
semantics in filters.** A trigger carries full query semantics (`queryCriteria`), runs on the
server's standard search machinery, and is identical for every subscriber, so it ships as
configuration. A filter is evaluated per Subscription by comparing the subscriber's value with
what a FHIRPath expression reads from the one changed resource; anything not readable from that
resource (a category mapping, compartment membership, a chain) needs custom implementation.
Topics that put their meaning in triggers (L1, L2's 28-topic form, L3) travel; the single-topic
L2 puts its meaning in a filter and does not. Per construct used above:

| Construct                             | R5 / R6                                                                             |
| ------------------------------------- | ------------------------------------------------------------------------------------ |
| Wildcard trigger (L0)                 | Not expressible; no compartment triggers, enumerate every type                        |
| Cross-resource `patient` filter (all) | Expressible via a national `SearchParameter` in `filterDefinition`; chaining is not   |
| Comma-OR filter values (L1, L2)       | Undefined; multiple filters AND                                                       |
| `data-category` filter (L2, 1 topic)  | No resource carries its category; mapping is custom per source. 28-topic form: triggers |
| `queryCriteria` triggers (L3)         | Fully runtime-evaluable; R6 renames `resourceTrigger` to `trigger`                    |
{:.grid .table-hover}

#### Open questions

1. Will the data-category value set add the missing codes and a normative dataset-to-category
   mapping? Both lift L2.
2. Is the dataset topic generated from the dataset's PlanDefinition, and who owns that pipeline?
   The natural form is one Nictiz release carrying both.
3. Change events or snapshot events per dataset (L3a vs L3b): fixed by the information standard,
   or chosen per source?
4. Does "abonneren" become a Nictiz activity verb, so that systeemrollen and autorisatierichtlijn
   rows can name subscriptions?
5. What is the lifecycle convention for a lapsed legal basis (`status = off`, final
   notification)? Needed in every scenario; defined nowhere.
6. Do resource-type topics need to exist alongside dataset topics for non-dataset subscribers?
7. Who publishes and maintains the national `patient` SearchParameter that the topics reference?
8. Does the COW data stream reuse the dataset topics unchanged (patient filter, workflow
   duration), or does it need case-scoped subscriptions where the case dataset deviates from the
   canonical one?
