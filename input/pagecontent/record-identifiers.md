<!--
SPDX-FileCopyrightText: 2026 Steven van der Vegt

SPDX-License-Identifier: CC-BY-SA-4.0
-->

Disclosure risks, identifier schemes, and who decides what.
Status: draft.

## 1. Problem statement

Record identifiers travel further than the records they name.
They appear in notifications, in references from other records, in URLs (as part of the path or a query parameter), and in access logs.
A party that is not allowed to read a record may still see its identifier.
If that identifier encodes order, volume, timing, or content, it leaks information on its own.
At the same time, receiving systems depend on identifiers for lookup, deduplication, and cross-system references, so an identifier cannot be volatile, freshly generated on every request.

Existing guidance does not cover this ground.
The FHIR specification tells readers that logical ids are opaque and that they "should not attempt to determine their internal structure" [^1], but it gives producers no rules for constructing identifiers, and its security pages do not mention identifier-borne disclosure.
The practical cost of missing agreements is documented: Nictiz's deduplication guideline for MedMij documents describes patients receiving the same letter twice in their PGO because each source system issued its own identifier, and concludes that sector-wide agreements on identifier use are needed [^2].
This document describes how identifiers are used, what they can reveal, which choices there are to make, which are acceptable, and who gets to make each choice: the vendor, the information standard, or the trust framework.
Chapter 9 applies the whole framework to one real exchange, the eOverdracht nursing handover; readers who prefer a concrete case before the model can start there.

## 2. Terminology and scope

FHIR uses two identifier constructs that look interchangeable but belong to different categories.
One is an address, the other is a name.
Most identifier problems in exchange trace back to this difference, so this chapter treats it in full.

### 2.1 The address: Resource.id and the full URL

Every resource carries a logical id (`Resource.id`): a plain string of at most 64 characters, assigned by the server that stores the resource and never changed afterwards [^1].
On its own the string identifies nothing; it is unique only within one resource type on one server.
The identity of a resource instance is the full URL: server base URL plus resource type plus logical id, for example `https://fhir.hospital-a.nl/Task/123`.
The full URL is what a reference by URL contains and what a client can dereference.
FHIR keeps this identity outside the resource: "the identity is not stored inside the resource, but must be tracked by systems handling resources" [^3].

Copying makes the distinction visible.
When a resource is copied to another server, the copy is a new resource instance with a new full URL, even if the id string is preserved.
FHIR attaches no meaning to two resources on different servers sharing an id string.
Servers may let clients bring their own id (update-as-create), which the specification suggests for data migrations [^4], but a preserved id string buys a recognizable URL, not identity: nothing in the model links the copy to the original.
An address is infrastructure, not content, and infrastructure does not travel with the record.

### 2.2 The name: the business identifier

A business identifier (`Resource.identifier`) is part of the resource's content.
It uses the `Identifier` datatype, a system URI plus a value, and is assigned by the authoritative source of the information.
It names the entity the resource is about, independent of where any resource is stored.
Because it is content, it travels when the resource is copied.
This is why the specification calls business identifiers "the preferred basis to recognize the same content on different systems" [^5].
A business identifier also serves the business process itself: an order number appears on letters and in phone calls, not only in FHIR exchanges.

|                  | Logical id (address)                     | Business identifier (name)                  |
| ---------------- | ---------------------------------------- | ------------------------------------------- |
| Denotes          | one resource instance, via the full URL  | the named entity; any number of resources   |
| Assigned by      | the storing server                       | the authoritative source                    |
| Structure        | opaque string, max 64 characters         | system URI plus value                       |
| Unique within    | one resource type on one server          | the identifier system                       |
| Survives copying | no                                       | yes, it is content                          |
| Appears in       | URLs and references by URL               | resource content, references by identifier  |

### 2.3 What is named, and who issues

Business identifiers vary along two independent axes.
The first axis is the referent.
Some name real-world entities that exist outside any information system: a person (BSN), an organisation (URA), a device (serial number).
Others name records that exist only inside information systems: a transfer request number, a report number.
The second axis is the issuer.
Some identifiers are issued by a registry outside the organisation; others by the organisation itself.
The axes are independent.
A BSN names a person and is issued externally.
An order number names a record and is issued internally.
An internal patient number names a person but is issued internally, which shows that referent and issuer do not determine each other.

### 2.4 Uniqueness: the thing or the resource

A full URL denotes exactly one resource instance.
A business identifier denotes the thing, and any number of resources, in any number of systems and even of different resource types, may represent that thing and carry the same identifier: the same order number appears on the ServiceRequest and on the Task that executes it.
A reference by business identifier can therefore resolve to several resources.
Therefore every reference design must answer one question first: do you refer to the thing, or to one specific resource representing it?

### 2.5 Reference styles

A reference by URL (`Reference.reference`, a literal reference in FHIR terms) contains a full URL and points at one resource on one server.
A reference by business identifier (`Reference.identifier`) carries a name instead of an address.
FHIR calls this a logical reference, a term unrelated to the logical id despite the shared word; this document avoids it.
The identifier alone locates nothing.
Resolving it requires knowing the issuer, from the `Identifier.system` or from context such as the Task's requester, plus a directory that maps the issuer to an endpoint, for example URA to an mCSD endpoint.
The specification warns that servers are not expected to resolve identifier-based references, that chaining and includes do not work on them, and that when both styles are present the reference by URL is preferred [^6].
Searching on `Reference.identifier` needs the `:identifier` modifier, and server support for it is inconsistent in practice.

### 2.6 Scope

This document covers record identifiers: logical ids, and business identifiers whose referent is a record.
Their formats are chosen by the implementer of the authoritative source rather than dictated by an external registry, which makes both a design decision subject to the same risk analysis.
Real-world entity identifiers are in scope in one respect and out of scope in another.
How references and registries use them, by URL or by identifier, is in scope: the thing-or-resource question of section 2.4 applies to an Organization exactly as it applies to a Task.
Their format is out of scope: this document cannot redesign the BSN or the URA.
They also appear as a constraint: record identifiers must never be derivable from them.

## 3. Use cases

Identifiers do different jobs in different exchange patterns.
Each job puts its own demands on the identifier, so later chapters refer back to these use cases.

### 3.1 Notify

A sender posts a reference to tell another party that a record exists or changed.
The receiver fetches the record within a processing window of hours to days.
The identifier must resolve at the source during that window.
The receiver may not, or not yet, be authorized for the content, so at the moment of notification the identifier is the entire payload.

### 3.2 Fetch from the source

The holder of an identifier retrieves the current version of the record from the system that owns it, possibly long after the identifier was obtained.
The identifier, together with source addressing, must still lead to the record.

### 3.3 Deduplicate

A receiver obtains the same record more than once: through a second system or exchange channel, after a re-collection, or after the source migrated to another vendor.
The receiver must recognize the copies as one record.
This requires an identity that is stable across channels, across time, and across the servers that happen to host the record.
Both failure modes are documented in practice: an EHR that issues a new identifier every time the same document is shared again, and one letter acquiring two independent identifiers on its way to the patient via the GP and via the hospital [^2].

### 3.4 Reference across systems

A record copied to a local system keeps references to records that remain at the source.
A Task copied by the filler refers to the ServiceRequest and Patient at the placer.
These references must stay valid for as long as the local copy is in use, regardless of what the source does with its server.
The reference style decides what must stay valid: a reference by URL depends on the source's base URL and logical id, a reference by business identifier depends on the identifier plus the addressing lookup.

### 3.5 Synchronize a registry

A central registry aggregates resources from many sources and makes them available for local sync, as mCSD does for addressing data.
The same record then exists at the source, in the registry, and in local copies.
Updates must reach the right copy at every hop, so record identity must survive at least two changes of server.
The thing-or-resource question of section 2.4 returns here concretely: does a HealthcareService in the registry refer to its Organization by URA or by URL, and what happens when several Organization resources carry the same URA?
IHE leaves this open and expects jurisdictions to mandate a source of truth for directory identities [^7], which is a decision of exactly the kind chapter 7 allocates.

## 4. Risks

Everything in this chapter applies to any identifier whose format an implementer chooses: logical ids and issued business identifiers alike.

### 4.1 Who sees an identifier

Three categories of parties potentially see identifiers without being authorized for the record content:

1. The addressed but unauthorized recipient.
   A notification tells a party that a record exists before, or instead of, granting access to its content.
2. The observer.
   Brokers, proxies, logs, and backups hold identifiers in transit and at rest, long after the exchange.
3. The coalition.
   Parties that each hold identifiers legitimately and compare them, within one organisation or across organisations, to link records neither could link alone.

### 4.2 What an identifier can reveal

Ordered identifiers, such as sequence numbers, reveal creation order and volume, and let a reader infer that a record exists between two identifiers it has seen.
Time-encoding identifiers (UUIDv1, UUIDv7) additionally reveal the absolute moment of creation; a sequence number reveals it too, once a reader can anchor a few identifiers to known times.
Concatenated identifiers (e.g. department, patient number, date) reveal content directly.
Identifiers derived from sensitive input by an unkeyed function, one that anyone can recompute because it involves no secret, reveal content to anyone who can brute-force the input space; an unsalted hash of a patient number is the typical example.

Low-entropy identifiers carry a further risk that is about security rather than disclosure.
A guessable identifier lets an attacker with an overbroad or forged access token probe a range of candidates.
The FHIR specification itself acknowledges one such probing channel: a server that supports client-assigned ids cannot honestly answer "not found", so clients can test whether content exists that they cannot access [^8].
And operational mistakes, such as restoring the wrong customer database or mixing up internal tenant identifiers, are far more likely to silently hit a valid record when identifiers are small numbers than when they carry 122 bits of randomness.
Identifier entropy is a layer of defense for the moment access control fails.

### 4.3 Who bears the harm

Not every leak harms the same party, and this determines who may accept the risk.
Volume and growth figures leaking from a global counter harm the disclosing organisation: a commercial exposure.
Creation-time inference, per-patient order, record existence, guessability, and anything derived from patient identifiers harm the patient.
Cross-party correlation harms the patient first, whose records get linked without consent, and the trust in the ecosystem second.

An organisation may accept a risk whose harm falls on itself.
It may not accept a risk on someone else's behalf.
Patients have no say in the identifier scheme, so patient-borne risks cannot be accepted by any implementer.
They need a baseline that no implementer can opt out of.

## 5. Requirements

The use cases translate into functional properties, and the patient-borne risks into a privacy baseline.
Together they make five properties:

1. Stable: the same record keeps the same identifier across time, channels, and hosting servers.
2. Unique: within its namespace, one identifier never denotes two different records.
3. Resolvable: given the identifier plus addressing information, the holder can obtain the current resource, or match the identifier against records already held.
4. Unpredictable: the identifier is not guessable, and not computable or confirmable from known inputs by anyone without a secret held by the source.
   This one property covers both the entropy requirement and the derivation risk: an unsalted hash of a patient number looks random, but its effective entropy is only that of the input space.
5. Attributable: a receiver can establish which party issued the identifier, and reject an identifier presented by a party that neither issued it nor may relay it.
   Without this, deduplication can be poisoned: a buggy or malicious source that stamps another organisation's identifier on its own record makes receivers merge two different records silently.
6. Unlinkable across contexts, where correlation is a threat.

The use cases demand them unevenly.
Notify and fetch need property 3.
Deduplication and registry sync need property 1 in its strongest form, identity that survives channels, time, and server migration, which a logical id by definition cannot offer, and property 5, because a match is only meaningful when the issuer is known.
A reference stored inside a copied record needs properties 1 and 3 for as long as that copy is in use.
Properties 4 and 6 come from the risks of chapter 4, not from any use case; they are the baseline.
Property 5 carries a tension of its own: naming the issuer is itself a disclosure in the sense of chapter 4, so chapter 8 leaves it to each information standard to decide which exchanges carry the issuer.

Properties 1 through 5 do not conflict.
A random identifier stored with the resource, or a keyed transformation of an internal key, satisfies 1 through 4 at once, at the cost of bookkeeping or key management; chapter 6 works this out.
Property 5 is met by carrying the issuer alongside the identifier and verifying it against the authenticated channel, independent of the scheme.
The one genuine conflict is between 1 and 6.
A stable identifier shown to every party is exactly what a coalition needs to correlate records.
Only per-recipient identifiers remove this conflict, and chapter 6 parks them as out of scope.
The ecosystem therefore accepts residual correlatability of record identifiers and controls it through access agreements rather than identifier design.

### 5.1 When a record needs an issued business identifier

The specification points the same way this document does: business identifiers are "the preferred basis to recognize the same content on different systems" [^5].
A business identifier is required if any of the following holds for the exchange:

- (a) receivers must recognize the record across channels, time, or server migrations (deduplicate, synchronize a registry);
- (b) references to the record live inside copies that outlast the processing window, so the identifier must keep working for as long as those copies are in use (reference across systems);
- (c) the record's identity is used in the business process outside FHIR exchanges, as with order numbers between placer and filler.

If none of these hold, the logical id suffices, as in notify followed by a short-lived fetch.
Whether (a), (b), or (c) hold is a property of the information exchange, not of the vendor or the trust framework.

## 6. Identifier schemes

The options, given the privacy baseline.
Each produces identifiers fit for use as a logical id, as an issued business identifier, or as both.

- Random identifiers (UUIDv4).
  Fully opaque and high-entropy.
  For a system of record, storing the identifier alongside the resource is all the bookkeeping there is.
  A separate mapping only becomes real work for facades that compose resources on the fly from several sources: they must first establish a stable internal identity, then map it to the external identifier.
- Keyed transformations of the internal record key.
  One-way: an HMAC under a secret key.
  Generation is stateless, since the identifier can be recomputed from the internal key at any time, but resolution is not: an inbound identifier cannot be reversed, so lookup requires storing the computed identifier alongside the record, indexed.
  Two-way: deterministic encryption of the internal key.
  The source decrypts an inbound identifier directly, so neither generation nor resolution needs stored state; this is the only fully stateless option for facades.
  Both variants are stable and opaque to anyone without the key; both stand or fall with key management, and rotation changes every identifier.
- Per-recipient identifiers.
  Defeat cross-party correlation at the cost of matching complexity at every boundary.
  Likely out of scope for this ecosystem; included for completeness.

Design notes.
A secret key is unnecessary only when the input is itself genuinely random and known only to the source, for example an internal key that is already a UUIDv4; enumerable inputs such as patient numbers, dates, and counters always require one.
Beyond blocking brute force, a key prevents a party that holds a candidate input from confirming that an identifier belongs to it.

### 6.1 Anti-patterns

Schemes that come up often and fail the baseline:

- Sequential counters: reveal order, volume, and existence; guessable; collision-prone under operational mistakes.
- Time-encoding UUIDs (v1, v7): reveal the moment of creation.
- Concatenated fields: reveal content directly.
- Unkeyed hashes of enumerable input, including UUIDv5, which is an unkeyed SHA-1 of a namespace and a name: reveal content to anyone who can brute-force the input space.
- Volatile identifiers, freshly generated per request: opaque, but break lookup and deduplication downstream.

## 7. Who decides what

The schemes above leave real choices open, and not every party may make every choice.
This chapter allocates the decisions.

- Trust framework (or national) level: the privacy baseline of chapter 5.
  It protects parties who are not represented in any single implementation choice, so no vendor or exchange can waive it.
- Information standard or exchange program: whether the conditions of section 5.1 apply, and therefore whether records carry an issued business identifier; and what a notification payload contains.
- Vendor or implementer: the identifier scheme (random, or a keyed transformation), management of the HMAC or encryption keys, and risks whose harm falls only on the implementing organisation itself.

There is precedent for each level.
US Core mandates the NPI as business identifier on Organization, a standard-level decision [^9].
NHS England prescribes reference styles per exchange paradigm: by URL in REST, by identifier in messaging, contained in documents [^10].
And IHE mCSD explicitly expects jurisdictions, not implementers, to mandate the source of truth for directory identities [^7].

## 8. Recommendations

The rules below use RFC 2119 keywords and are numbered for reference.
Each rule is placed at the decision level of chapter 7 that owns it.
Adoption of the trust-framework rules is voluntary in the sense that joining the trust framework is; once adopted, they bind every participant.

### 8.1 Trust framework level

These rules bind every system that exposes record identifiers to other parties.
They exist because their violation harms patients or other participants, who cannot waive them (section 4.3).

- REC-01 (stability): a source SHALL return the same identifier for the same record on every request.
  Volatile identifiers break lookup and deduplication for every receiver downstream.
- REC-02 (opacity): a record identifier SHALL NOT reveal creation order, volume, creation time, or content.
  This rules out sequential counters, time-encoding UUIDs (v1, v7), and concatenated fields.
- REC-03 (unpredictability): a record identifier SHALL NOT be guessable, and SHALL NOT be computable or confirmable from real-world entity identifiers by anyone who does not hold a secret of the source.
  This rules out unkeyed hashes of patient numbers and other enumerable input.
- REC-04 (consumer opacity): a consumer SHALL treat received identifiers as opaque strings.
  It SHALL NOT parse them, derive meaning from them, or assume a format when querying.
- REC-05 (namespace): an issued business identifier SHALL be globally unique through one of two mechanisms:
  (a) an `Identifier.system` URI registered to and controlled by the issuer, with values unique within it; or
  (b) the shared system for self-assigned identifiers designated by the trust framework, with a value that meets REC-03's entropy requirement.
  Mechanism (a) guarantees uniqueness by delegation, mechanism (b) by entropy.
  Mechanism (b) does not reveal the issuer and is the default for identifiers that travel beyond the care relationship.
- REC-06 (issuer and integrity): where receivers must resolve, verify, or deduplicate an identifier issued under mechanism (b), the identifier SHALL carry its issuer in `Identifier.assigner`, as a reference by business identifier holding the issuer's URA.
  A receiver SHALL accept an assigner claim only from the assigner itself, authenticated on the connection, or from a party the exchange trusts to relay that assigner's records.
  Receivers that deduplicate SHALL match on system, value, and assigner together, never on system and value alone.
  Note: an issuer-owned system URI and an assigner both disclose the issuer; which exchanges may carry them is decided per information standard.

### 8.2 Information standard level

These rules are decided per exchange, because they depend on which use cases of chapter 3 apply.

- REC-07 (business identifier mandate): an information standard SHALL determine, per record type, whether any condition of section 5.1 holds, and SHALL require an issued business identifier where one does.
  A standard SHOULD NOT require business identifiers on record types where no condition holds.
- REC-08 (reference style): within notified pull, references SHOULD be by URL, because the receiver dereferences them against the source at read time.
  References by business identifier are for contexts without a resolvable source endpoint, such as store-and-forward exchanges.
  Documents SHOULD contain the resources they reference.
- REC-09 (notification payload): a notification SHOULD carry the reference by URL, for the fetch.
  Receivers that persist the record deduplicate on the business identifier found in the fetched content, not on the notification payload.
  This default stands until the thing-or-resource discussion (chapter 10) concludes otherwise.

### 8.3 Vendor level

These choices are free, within the rules above.

- REC-10 (scheme): a vendor MAY use any scheme of chapter 6 that meets REC-01 through REC-03: random identifiers stored with the resource, or a keyed transformation of the internal key.
  The vendor is responsible for key custody where a keyed scheme is used.
- REC-11 (identifier reuse): a business identifier MAY double as the logical id only if (a) the server is the authoritative source of the identified entity and (b) the identifier itself satisfies REC-02 and REC-03.
  A URA in a national directory satisfies this; a BSN never does.

## 9. Worked example: eOverdracht

The eOverdracht information standard transfers nursing care from one organisation, say a hospital, to another, say a home care organisation.
The Task that drives the workflow is hosted on the server of the transferring organisation: "The Task instance SHALL be hosted on the server of the sending organisation" [^11].
The draft eOverdracht Notifications guide [^12] adds a topic-based notification layer on top: the transferring organisation creates a Subscription scoped to the receiver (`Task?owner=<URA of the receiving organisation>`), and on every relevant Task change sends a rest-hook notification with payload mode id-only.
The notification is a history Bundle whose `notification-event.focus` carries the Task reference; the receiver dereferences it at the sender (`GET https://sender.example/fhir/Task/...`), follows `Task.input` to the nursing handover Composition, and pulls the content through a separately authorised request.
This is the notify, fetch, and reference pattern of chapter 3 in one exchange, which makes it a complete test case for the rules of chapter 8.

One detail carries most of this document's weight.
The notification reveals exactly one record-level data point to anyone who sees it: the Task reference.
Whether that is harmless is decided entirely by the sender's identifier scheme, and neither the eOverdracht standard nor the notification guide says anything about how ids are constructed.
That silence is what the trust-framework rules exist to fill.
The notification protocol itself additionally carries an ordered counter (`event-number`) and a timestamp, so an observer of the channel learns per-relation event volume and timing regardless of the identifier scheme; that exposure is inherent to the subscriptions backport and is per subscription pair, not per record system.

### 9.1 The decision template, filled in

Applying the test of section 5.1 per record type in this exchange:

| Record type              | (a) recognize across channels, time, migration        | (b) references outlive the processing window | (c) identity used in the business process       | Verdict                     |
| ------------------------ | ----------------------------------------------------- | -------------------------------------------- | ----------------------------------------------- | --------------------------- |
| Task                     | no: one instance, hosted at the sender                | no: references resolve during the transfer   | yes: transfer coordinators discuss the transfer by number | issued identifier, via (c)  |
| Advance notice           | yes: an updated notice must replace the earlier one   | no                                           | no                                              | issued identifier, via (a)  |
| Nursing handover         | yes: the receiver persists it, and the same document can later reach the patient's PGO through MedMij | yes: the stored copy keeps references to source resources | no                          | issued identifier, via (a) and (b) |
| Resources in the document Bundle | no: identity is managed at document level     | no                                           | no                                              | logical id suffices         |
| Patient                  | out of scope: real-world entity, identified by BSN    |                                              |                                                 | never an input for record identifiers |

The Patient row is the boundary of section 2.6 in action: the BSN appears in the exchange as content, but no record identifier in this exchange may be derived from it.

### 9.2 The fields, filled in

Below is an eOverdracht Task as the rules of chapter 8 require it, trimmed to the identifier-relevant fields (the eOverdracht profile targets FHIR STU3, hence the `requester.agent` shape; the notification layer is R4 and indifferent to this):

```json
{
  "resourceType": "Task",
  "id": "5f2f9a4e-8c1d-4b6e-9d3a-7c0e2f4b8a1d",
  "meta": { "profile": ["http://nictiz.nl/fhir/StructureDefinition/eOverdracht-Task"] },
  "identifier": [{
    "system": "https://fhir.nl/id/self-assigned",
    "value": "urn:uuid:0b8f3f6e-2d4a-4c8b-a1e9-6f7d0c3b5a2e",
    "assigner": {
      "identifier": { "system": "http://fhir.nl/fhir/NamingSystem/ura", "value": "12345678" }
    }
  }],
  "status": "in-progress",
  "intent": "order",
  "code": { "coding": [{ "system": "http://snomed.info/sct", "code": "308292007", "display": "Transfer of care" }] },
  "for": { "reference": "Patient/9c1e0c7a-2b5f-4d38-8a6e-3f1b9d0e6c42" },
  "requester": { "agent": { "identifier": { "system": "http://fhir.nl/fhir/NamingSystem/ura", "value": "12345678" } } },
  "owner": { "identifier": { "system": "http://fhir.nl/fhir/NamingSystem/ura", "value": "87654321" } },
  "input": [{
    "type": { "coding": [{ "system": "http://nictiz.nl/fhir/CodeSystem/TaskInputType", "code": "nursingHandoff" }] },
    "valueReference": { "reference": "Composition/7e4a1f92-6b3d-4c8e-9f0a-2d5b8c1e4a76" }
  }]
}
```

The corresponding notification event, as the receiver sees it:

```json
{
  "name": "notification-event",
  "part": [
    { "name": "event-number", "valueString": "42" },
    { "name": "timestamp", "valueInstant": "2026-07-16T09:15:00Z" },
    { "name": "focus", "valueReference": { "reference": "Task/5f2f9a4e-8c1d-4b6e-9d3a-7c0e2f4b8a1d" } }
  ]
}
```

### 9.3 Walking the rules that leave a choice

The baseline rules REC-01 through REC-04 leave nothing to decide: an implementation either meets them or violates them, regardless of the exchange.
The rules below each contain a choice, and this is how eOverdracht makes it:

- REC-05 (namespace): the transfer number in `Task.identifier` uses the shared self-assigned system with a high-entropy value, mechanism (b).
  The system URI shown is a placeholder; designating the real one is a trust-framework decision.
  An issuer-owned system URI, mechanism (a), would work too, at the cost of naming the hospital in every copy of the identifier.
- REC-06 (issuer and integrity): the assigner carries the sender's URA.
  The receiver already knows the authenticated URA of the party behind the Subscription, because the Subscription was scoped with `Task?owner=<URA>`; verifying the assigner is comparing two values it already holds.
  When the handover Composition later reaches a PGO through MedMij, the PGO matches on system, value, and assigner together, and accepts the assigner claim only from a channel trusted to relay that hospital's records.
- REC-07 (business identifier mandate): the filled-in template of section 9.1 is precisely the homework this rule assigns to the information standard: identifiers required on the Task and both Compositions, none required on the resources inside the document Bundle.
- REC-08 (reference style): each style lands where it belongs.
  The notification focus and `Task.input` are references by URL, dereferenced at the sender during the processing window.
  `Task.requester` and `Task.owner` reference real-world entities by business identifier (URA), the in-scope entity use of section 2.6, resolvable through addressing.
  The focus reference is relative (`Task/...`); that works because the Subscription pairing implies the sender's base URL, and it stops working the moment a broker or second source enters the route, at which point the full URL is needed.
- REC-09 (notification payload): id-only mode is this rule in its purest form: the payload is a reference for the fetch, nothing else.
  Deduplication of the handover happens on `Composition.identifier` after the pull, never on anything in the notification.
  The guide's empty payload mode is stricter still and equally conformant.
- REC-10 (scheme): the sender's vendor is free to store UUIDv4 values with the record or to derive both ids from the internal transfer key with a keyed transformation; nothing in the exchange can tell the difference, which is the point.
- REC-11 (identifier reuse): the sender is the authoritative source of the transfer number, and under mechanism (b) that number satisfies REC-02 and REC-03, so the vendor MAY reuse it as the Task's logical id (one value in both `Task.id` and `Task.identifier.value`).
  Reusing the BSN-derived internal patient number this way remains forbidden no matter who hosts the resource.

## 10. Open issues

- Whether a notification refers to the thing or to one resource representing it.
  This determines whether the payload carries a business identifier or a logical id, and it depends on the wider discussion of what subscriptions notify about.
- Key custody and rotation for keyed transformations: who holds the key, and what happens to already-issued identifiers on rotation.
- Where the decision framework itself should be laid down: this document, the generic functions IG, or per information standard.
- Alignment with Nictiz's Objectidentificatie project, which addresses the same gap for document identifiers [^2].

[^1]: FHIR R4, Resource Identity: https://hl7.org/fhir/R4/resource.html#id
[^2]: Nictiz, Richtlijn Deduplicatie bij MedMij gegevensdienst Documenten, v0.1, November 2024, https://informatiestandaarden.nictiz.nl
[^3]: FHIR, Managing Resource Identity: https://hl7.org/fhir/managing.html
[^4]: FHIR, RESTful API, section "Update as Create": https://hl7.org/fhir/http.html
[^5]: FHIR, section "Consistent Resource Identification": https://hl7.org/fhir/resource.html
[^6]: FHIR, References: https://hl7.org/fhir/references.html
[^7]: IHE ITI mCSD, Volume 1, section "Federated and Cross-Jurisdictional Deployments": https://profiles.ihe.net/ITI/mCSD/
[^8]: FHIR, Security, section "Access Denied Response Handling": https://hl7.org/fhir/security.html
[^9]: US Core Organization profile: https://hl7.org/fhir/us/core/
[^10]: NHS England FHIR policy on identifiers: https://nhsconnect.github.io/fhir-policy/identifiers.html
[^11]: Nictiz, eOverdracht 4.0, FHIR implementation (eOverdracht-Task profile): https://informatiestandaarden.nictiz.nl/wiki/vpk:V4.0_FHIR_eOverdracht
[^12]: eOverdracht Notifications Implementation Guide, v0.2 draft, based on TTA Notifications v0.4 (internal working document, not yet published).
