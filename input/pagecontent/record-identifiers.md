<!--
SPDX-FileCopyrightText: 2026 Steven van der Vegt

SPDX-License-Identifier: CC-BY-SA-4.0
-->

Disclosure risks, identifier schemes, and who decides what. Status: draft.

### Problem statement

Record identifiers travel further than the records they name. They appear in notifications, in references from other records, in URLs (as part of the path or a query parameter), and in access logs, so parties that may never read a record still see its identifiers. When identifier design fails, the failures come in four classes. Disclosure: an identifier that encodes order, volume, timing, or content leaks information to everyone who sees it. Duplicates: one business object that a receiver fails to recognize as one. Dangling references: an identifier that no longer leads anywhere. False merges: two different objects treated as one. Disclosure is why this document was started; the other three cannot be separated from it, because the same design decisions cause or prevent all four. This document uses "identifier problem" for these four classes and addresses them together.

Existing guidance does not cover identifier construction. The FHIR specification tells readers that logical ids are opaque and that they "should not attempt to determine their internal structure" [1], but it gives producers no rules for constructing identifiers, and its security pages do not mention disclosure through identifiers. The practical cost is documented: Nictiz's deduplication guideline for MedMij documents describes the duplicates class in the field, patients receiving the same letter twice in their PGO because each source system issued its own identifier, and concludes that sector-wide agreements on identifier use are needed [2].

This document describes how identifiers are used in information exchange, what they can reveal, which choices there are to make, which are acceptable, and who gets to make each choice: the vendor, the information standard, or the trust framework. The worked example near the end applies the whole framework to one real exchange, the eOverdracht nursing handover; readers who prefer a concrete case before the model can start there.

### Terminology and scope

{% include record-identifiers-layers.svg %}

One referral letter, one business identifier, two representations with two different addresses: the figure shows the split this whole document rests on. Business objects, such as a referral letter, an order, or a patient, exist independent of any encoding: the same order is discussed by phone, printed on paper, and exchanged electronically. Representations are what information systems hold and exchange: in this ecosystem, FHIR resources that stand for business objects. A business object carries a *name*; a representation needs an *address*. The split is not a FHIR invention; FHIR merely provides a construct for each. The first three failure classes of the problem statement arise where the two are confused: duplicates where an *address* had to stand in for a missing *name*, dangling references where an *address* was trusted to behave like a *name*, false merges where *names* were matched without checking who issued them. Disclosure, the fourth, is about how either is constructed, and gets its own chapter.

#### The address: identifying a representation

In FHIR, every resource carries a logical id (`Resource.id`), a plain string assigned by the server that stores the resource [1]. On its own the string identifies nothing; the identity of a representation is the full URL, server base URL plus resource type plus logical id, which is what a reference by URL contains and what a client can dereference. FHIR keeps this identity outside the resource [3], and copying shows why that matters: a copy on another server is a new representation with a new full URL, even when the id string is preserved through update-as-create [4]. Nothing in the model links the copy to the original. The *address* belongs to the representation, and every representation has its own; nothing at this layer says which business object it stands for.

FHIR does record where a copy came from: `Resource.meta.source` names the source system, and a Provenance resource can describe the derivation in full [5]. Lineage, however, is not identity: one source emits many distinct objects, so shared lineage never proves shared identity, and neither mechanism replaces a *name*.

#### The name: identifying the business object

A business identifier names the business object, independent of any representation and of where representations are stored. In FHIR it is carried as content, in `Resource.identifier`, using the `Identifier` datatype: a system URI plus a value, assigned by the authoritative source of the information. Because the *name* belongs to the object and travels as content, every faithful copy of a representation carries it. This is why the specification calls business identifiers "the preferred basis to recognize the same content on different systems" [5]. A business identifier also serves the business process itself: an order number appears on letters and in phone calls, not only in FHIR exchanges.

|                  | Logical id (address)                     | Business identifier (name)                  |
| ---------------- | ---------------------------------------- | ------------------------------------------- |
| Belongs to       | one representation                       | the business object                         |
| Denotes          | one resource instance, via the full URL  | the named object; any number of resources   |
| Assigned by      | the storing server                       | the authoritative source                    |
| Structure        | opaque string, max 64 characters         | system URI plus value                       |
| Unique within    | one resource type on one server          | the identifier system                       |
| Survives copying | no                                       | yes, it is content                          |
| Appears in       | URLs and references by URL               | resource content, references by identifier  |
{:.grid .table-hover}

#### What is named, and who issues

Business identifiers vary along two independent axes. The first axis is the referent. Some name real-world entities that also exist outside any recorded information: a person (BSN), an organisation (URA), a device (serial number). Others name records: business objects that exist only as recorded information, such as a transfer request or a report. The second axis is the issuer. Some identifiers are issued by a registry outside the organisation; others by the organisation itself. The axes are independent. A BSN names a person and is issued externally. An order number names a record and is issued internally. An internal patient number names a person but is issued internally, which shows that referent and issuer do not determine each other.

#### Uniqueness: the object or the representation

A full URL denotes exactly one representation. A business identifier denotes the business object; any number of representations, across systems and even across resource types, may stand for that object and carry the same identifier, like the same order number on the ServiceRequest and on the Task that executes it. A reference by *name* can therefore resolve to several resources; a reference by *address* to exactly one. Every reference design must answer the layer question first: do you refer to the business object, or to one specific representation of it?

{% include record-identifiers-model.svg %}

The model in one picture: an object can carry several *names*, a *name* denotes exactly one object; every representation stands for exactly one object and has exactly one *address*.

#### Reference styles in FHIR

The mechanics in this section are FHIR-specific; the concepts above are not. A reference by URL (`Reference.reference`, a literal reference in FHIR terms) contains a full URL and points at one resource on one server. A reference by business identifier (`Reference.identifier`) carries a *name* instead of an *address*. FHIR calls this a logical reference, a term unrelated to the logical id despite the shared word; this document avoids it. The identifier alone locates nothing. Resolving it requires knowing the issuer, from the `Identifier.system` or from context such as the Task's requester, plus a directory that maps the issuer to an endpoint, for example URA to an mCSD endpoint. The specification warns that servers are not expected to resolve identifier-based references, that chaining and includes do not work on them, and that when both styles are present the reference by URL is preferred [6]. Searching on `Reference.identifier` needs the `:identifier` modifier, and server support for it is inconsistent in practice.

#### Scope

This document covers record identifiers: logical ids, and business identifiers whose referent is a record. Scope follows the referent axis alone, whoever issues the identifier:

| Referent              | Issued by an external registry              | Issued by the organisation itself           |
| --------------------- | ------------------------------------------- | ------------------------------------------- |
| Real-world entity     | BSN, URA (out of scope)                     | internal patient number (out of scope)      |
| Record                | rare today (in scope if it emerges)         | order and transfer numbers (in scope)       |
{:.grid .table-hover}

Addresses (logical ids and full URLs) are always in scope: every representation has one, whatever its object. The in-scope formats are chosen by the implementer of the authoritative source rather than dictated by an external registry, which makes them a design decision subject to the risk analysis of this document. Entity-referent identifiers are out of scope as design targets, but they stay relevant in two ways. How references and registries use them is in scope, because the object-or-representation question applies to an Organization exactly as it applies to a Task. And all of them, external like the BSN or internal like the patient number, are forbidden as input: record identifiers must never be derivable from them.

### Use cases

Identifiers do different jobs in different exchange patterns. Each job puts its own demands on the identifier, so later chapters refer back to these use cases.

#### Notify

A sender posts a reference to tell another party that a record exists or changed. The receiver fetches the record within a processing window of hours to days. The identifier must resolve at the source during that window. The receiver may not, or not yet, be authorized for the content, so at the moment of notification the identifier is the entire payload.

#### Fetch from the source

The holder of an identifier retrieves the current version of the record from the system that owns it, possibly long after the identifier was obtained. The identifier, together with source addressing, must still lead to the record.

#### Deduplicate

A receiver obtains more than one representation of the same business object: through a second exchange channel, after a re-collection, or after the source migrated to another vendor and re-issued every address. The receiver must recognize them as one object, which requires a *name* that is stable across channels, time, and hosting servers. Both ways this fails are documented in the field by Nictiz's deduplication guideline [2]: a source that issues a fresh identifier every time it shares the same document (the name is not stable), and one letter reaching the patient via the GP and via the hospital with two independently issued identifiers (the copies never shared a name).

#### Reference across systems

A record copied to a local system keeps references to records that remain at the source. A Task copied by the filler refers to the ServiceRequest and Patient at the placer. These references must stay valid for as long as the local copy is in use, regardless of what the source does with its server. The reference style decides what must stay valid: a reference by URL depends on the source's base URL and logical id, a reference by business identifier depends on the identifier plus the addressing lookup.

#### Synchronize a registry

A central registry aggregates resources from many sources and makes them available for local sync, as mCSD does for addressing data. The same record then exists at the source, in the registry, and in local copies. Updates must reach the right copy at every hop, so record identity must survive at least two changes of server. The object-or-representation question returns here concretely: does a HealthcareService in the registry refer to its Organization by URA or by URL, and what happens when several Organization resources carry the same URA? IHE leaves this open and expects jurisdictions to mandate a source of truth for directory identities [7], which is a decision of exactly the kind the requirements chapter allocates.

### Risks and identifier schemes

A risk, in this chapter, is what a party can learn from identifiers alone, without access to the record content, and what a party can do with a guessable identifier. The chapter answers three questions. Who sees identifiers: more parties than the exchange partners. Which schemes fail, and what each reveals. And which schemes pass. Everything here applies to every identifier whose format an implementer chooses, *name* or *address* alike, and none of it is FHIR-specific: the same risks apply to any identifier a system exposes, whatever the representation technology.

#### Who sees an identifier

Three categories of parties potentially see identifiers without being authorized for the record content:

1. The addressed but unauthorized recipient. A notification tells a party that a record exists before, or instead of, granting access to its content.
2. The observer. Brokers, proxies, logs, and backups hold identifiers in transit and at rest, long after the exchange.
3. The coalition. Parties that each hold identifiers legitimately and compare them, within one organisation or across organisations, to link records neither could link alone.

#### Schemes that fail

- **Ordered identifiers** (sequential counters): reveal creation order and volume, and let a reader infer that a record exists between two identifiers it has seen. They are also guessable, and collision-prone under operational mistakes.
- **Time-encoding identifiers** (UUIDv1, UUIDv7): reveal the absolute moment of creation. Ordered identifiers reveal it too, once a reader can anchor a few of them to known times.
- **Concatenated identifiers** (department plus patient number plus date): reveal content directly.
- **Derived identifiers**, produced from sensitive input by an unkeyed function, one that anyone can recompute because it involves no secret; UUIDv5, an unkeyed SHA-1 of a namespace and a name, is in this class: reveal content to anyone who can brute-force the input space. The unsalted hash of a patient number is the typical example.
- **Low-entropy identifiers**: a risk about security rather than disclosure. A guessable identifier lets an attacker with an overbroad or forged access token probe a range of candidates; the FHIR specification itself acknowledges that a server supporting client-assigned ids cannot honestly answer "not found", so clients can test whether content exists that they cannot access [8]. Operational mistakes, such as restoring the wrong customer database or mixing up internal tenant identifiers, are also far more likely to silently hit a valid record when identifiers are small numbers than when they carry 122 bits of randomness. Identifier entropy is a layer of defense for the moment access control fails.
- **Volatile identifiers**, freshly generated per request: fail functionally rather than by disclosure. They are opaque, but not stable, and break lookup and deduplication for every receiver downstream.

**Who bears the harm.** Not every leak is of the same kind. Volume and growth figures from a global counter expose commercial information about the disclosing organisation; whether to accept that exposure is that organisation's own trade-off, made in its own risk assessment. Creation-time inference, per-patient order, record existence, guessability, derivation from patient identifiers, and cross-party correlation leak healthcare data, and minimizing that leakage is the point of this document. It is baseline material for a practical reason: the leakage happens at observers and coalitions outside the disclosing organisation, so no single organisation's risk assessment can see or contain it, and consistent minimization requires shared rules rather than per-implementation trade-offs.

#### Schemes that pass

Each of the following produces values fit for use as an *address*, as an issued business identifier, or as both.

- **Random identifiers** (UUIDv4). Fully opaque and high-entropy. For a system of record, storing the identifier alongside the resource is all the bookkeeping there is. A separate mapping only becomes real work for facades that compose resources on the fly from several sources: they must first establish a stable internal identity, then map it to the external identifier.
- **Keyed transformations** of the source system's internal key. One-way: an HMAC under a secret key. Generation is stateless, since the identifier can be recomputed from the internal key at any time; resolution is not, because a one-way value can be matched but never reversed, so inbound lookup requires the computed identifier to be stored alongside the record, indexed. Two-way: deterministic encryption of the internal key. The source decrypts an inbound identifier straight back to its internal key, so neither generation nor resolution needs stored state; this is the only fully stateless option for facades. Both variants are stable and opaque to anyone without the key; both stand or fall with key management, and rotation changes every identifier.
- **Per-recipient identifiers**. Defeat cross-party correlation at the cost of matching complexity at every boundary. Likely out of scope for this ecosystem; included for completeness.

Design notes. A secret key is unnecessary only when the input is itself genuinely random and known only to the source, for example an internal key that is already a UUIDv4; enumerable inputs such as patient numbers, dates, and counters always require one. Beyond blocking brute force, a key prevents a party that holds a candidate input from confirming that an identifier belongs to it.

### Identifier properties

This chapter turns the use cases and risks into six properties of an identifier. They are properties, not yet rules: each is a quality an identifier has to a degree, and the requirements chapter later sets the bar.

- **Stability**: the degree to which a referent keeps its identifier across time, channels, and hosting servers. An *address* is at best stable per server; only a *name* can be stable across servers.
- **Uniqueness**: within its namespace, an identifier never denotes two different referents.
- **Resolvability**: what a holder can do with the identifier. An *address* is dereferenceable: it leads directly to the representation. A *name* is matchable: it can be compared against data already held. A *name* is indirectly resolvable only when the exchange defines a lookup chain from issuer to endpoint; on its own it is never dereferenceable, and the FHIR specification expects no server to resolve it [6].
- **Unpredictability**: how unlikely it is that the identifier can be guessed, or computed or confirmed from known inputs, by anyone without a secret held by the source. An unsalted hash of a patient number looks random, but its effective unpredictability is only that of the input space.
- **Attributability**: the degree to which a receiver can establish which party issued the identifier, and reject an identifier presented by a party that neither issued it nor may relay it. Without it, deduplication can be poisoned: a source that stamps another organisation's identifier on its own record, through a bug or on purpose, makes receivers merge two different objects silently.
- **Unlinkability**: the inability of parties to correlate contexts through the identifier. Relevant where correlation is a threat.

The properties do not conflict, with one exception. A random identifier stored with the resource, or a keyed transformation of an internal key, delivers stability, uniqueness, resolvability, and unpredictability at once, at the cost of bookkeeping or key management. Attributability is met by carrying the issuer alongside the identifier and verifying it against the authenticated channel, independent of the scheme. The genuine conflict is between stability and unlinkability: a stable identifier shown to every party is exactly what a coalition needs to correlate records. Only per-recipient identifiers remove this conflict, and the previous chapter parks them as out of scope. The ecosystem therefore accepts residual correlatability of record identifiers and controls it through access agreements rather than identifier design.

#### When an issued business identifier is needed

The use cases demand the properties unevenly, and the FHIR specification points the same way this document does: business identifiers are "the preferred basis to recognize the same content on different systems" [5]. The table states, per use case, which properties it demands and whether it forces an issued business identifier:

| Use case                  | Properties demanded                                                        | Issued business identifier needed?           |
| ------------------------- | -------------------------------------------------------------------------- | -------------------------------------------- |
| Notify                    | resolvability: dereference during the processing window                     | no                                           |
| Fetch from the source     | resolvability at fetch time, stability until then                           | no, for a fetch within the processing window |
| Deduplicate               | stability across channels, time, and servers; matchability; attributability | yes                                          |
| Reference across systems  | stability and resolvability for the lifetime of the stored copy             | yes                                          |
| Synchronize a registry    | as deduplicate, surviving at least two server hops                          | yes                                          |
| Identity in the business process (an order number in letters and calls) | a *name* usable outside any exchange          | yes                                          |
{:.grid .table-hover}

Unpredictability and unlinkability appear in no row: they come from the risks, not from any use case, and apply to every identifier that leaves the source. That is what makes them baseline material in the next chapter. Attributability carries a tension of its own: naming the issuer is itself a disclosure, so the requirements leave it to each information standard to decide which exchanges carry the issuer.

In short, an issued business identifier is required as soon as receivers must recognize the object across channels, time, or migrations; as soon as references live inside copies that outlast the processing window; or as soon as the object's identity is used in the business process outside the exchange. If none of these hold, the *address* suffices, as in notify followed by a short-lived fetch. Whether they hold is a property of the information exchange, not of the vendor or the trust framework.

### Requirements

The rules below use RFC 2119 keywords and are numbered **REQ-nn** for reference. Each rule sits at the decision level that owns it, so the levels are allocated first. Adoption of the trust-framework rules is voluntary in the sense that joining the trust framework is; once adopted, they bind every participant.

#### Who decides what

The schemes and properties above leave real choices open, and not every party may make every choice. The allocation follows the layers of the terminology chapter: information standards govern the information layer, so business-identifier questions land there; vendors build the implementation layer, so representation addressing lands there; the baseline cuts across both, because the harms do.

- Trust framework (or national) level: the baseline properties, opacity and unpredictability. They minimize leakage of healthcare data through identifiers, which happens outside the disclosing organisation and therefore needs shared rules.
- Information standard or exchange program: whether the conditions of the use-case table hold, and therefore whether records carry an issued business identifier; and what a notification payload contains. For the payload this section allocates only the authority; the substantive question is still open (see open issues).
- Vendor or implementer: the identifier scheme (random, or a keyed transformation), management of the HMAC or encryption keys, and residual risks that expose only the organisation's own commercial information.

There is precedent for each level. US Core mandates the NPI as business identifier on Organization, a standard-level decision [9]. NHS England prescribes reference styles per exchange paradigm: by URL in REST, by identifier in messaging, contained in documents [10]. And IHE mCSD explicitly expects jurisdictions, not implementers, to mandate the source of truth for directory identities [7].

#### Trust framework level

These rules bind every system that exposes record identifiers to other parties. They exist to minimize leakage of healthcare data through identifiers, which no single implementation can achieve on its own (see the harm note in the risks chapter).

- **REQ-01** (stability): a source SHALL return the same identifier for the same record on every request. Volatile identifiers break lookup and deduplication for every receiver downstream.
- **REQ-02** (opacity): a record identifier SHALL NOT reveal creation order, volume, creation time, or content. This rules out ordered, time-encoding, and concatenated identifiers.
- **REQ-03** (unpredictability): a record identifier SHALL NOT be guessable, and SHALL NOT be computable or confirmable from real-world entity identifiers by anyone who does not hold a secret of the source. This rules out derived identifiers: unkeyed hashes of patient numbers and other enumerable input.
- **REQ-04** (consumer opacity): a consumer SHALL treat received identifiers as opaque strings. It SHALL NOT parse them, derive meaning from them, or assume a format when querying.
- **REQ-05** (namespace): an issued business identifier SHALL be globally unique through one of two mechanisms: (a) an `Identifier.system` URI registered to and controlled by the issuer, with values unique within it; or (b) the shared system for self-assigned identifiers designated by the trust framework, with a value that meets REQ-03's entropy requirement. Mechanism (a) guarantees uniqueness by delegation, mechanism (b) by entropy. Mechanism (b) does not reveal the issuer and is the default for identifiers that travel beyond the care relationship.
- **REQ-06** (issuer and integrity): where receivers must resolve, verify, or deduplicate an identifier issued under mechanism (b), the identifier SHALL carry its issuer in `Identifier.assigner`, as a reference by business identifier holding the issuer's URA. A receiver SHALL accept an assigner claim only from the assigner itself, authenticated on the connection, or from a party the exchange trusts to relay that assigner's records. In exchanges where the standard requires deduplication (REQ-07), receivers SHALL match on system, value, and assigner together, never on system and value alone. Note: an issuer-owned system URI and an assigner both disclose the issuer; which exchanges may carry them is decided per information standard.

#### Information standard level

These rules are decided per exchange, because they depend on which use cases apply.

- **REQ-07** (business identifier mandate): an information standard SHALL determine, per record type, whether any condition of the use-case table holds, and SHALL require an issued business identifier where one does. A standard SHOULD NOT require business identifiers on record types where no condition holds.
- **REQ-08** (reference style): within notified pull, references SHOULD be by URL, because the receiver dereferences them against the source at read time. References by business identifier are for contexts without a resolvable source endpoint, such as store-and-forward exchanges. Documents SHOULD contain the resources they reference.
- **REQ-09** (notification payload): a notification SHOULD carry the reference by URL, for the fetch. Receivers that persist the record deduplicate on the business identifier found in the fetched content, not on the notification payload. This default stands until the object-or-representation discussion (see open issues) concludes otherwise.

#### Vendor level

These choices are free, within the rules above.

- **REQ-10** (scheme): a vendor MAY use any passing scheme of the risks and schemes chapter that meets REQ-01 through REQ-03: random identifiers stored with the resource, or a keyed transformation of the internal key. The vendor is responsible for key custody where a keyed scheme is used.
- **REQ-11** (identifier reuse): a business identifier MAY double as the logical id only if (a) the server is the authoritative source of the identified entity and (b) the identifier itself satisfies REQ-02 and REQ-03. A URA in a national directory satisfies this; a BSN never does.

### Worked example: eOverdracht

The eOverdracht information standard transfers nursing care from one organisation, say a hospital, to another, say a home care organisation. The Task that drives the workflow is hosted on the server of the transferring organisation: "The Task instance SHALL be hosted on the server of the sending organisation" [11]. The draft eOverdracht Notifications guide [12] adds a topic-based notification layer on top: the transferring organisation creates a Subscription scoped to the receiver (`Task?owner=<URA of the receiving organisation>`), and on every relevant Task change sends a rest-hook notification with payload mode id-only. The notification is a history Bundle whose `notification-event.focus` carries the Task reference; the receiver dereferences it at the sender (`GET https://sender.example/fhir/Task/...`), follows `Task.input` to the nursing handover Composition, and pulls the content through a separately authorised request. This is the notify, fetch, and reference use cases in one exchange, which makes it a complete test case for the requirements.

One detail carries most of this document's weight. The notification reveals exactly one record-level data point to anyone who sees it: the Task reference. Whether that is harmless is decided entirely by the sender's identifier scheme, and neither the eOverdracht standard nor the notification guide says anything about how ids are constructed. That silence is what the trust-framework rules exist to fill. The notification protocol itself additionally carries an ordered counter (`event-number`) and a timestamp, so an observer of the channel learns per-relation event volume and timing regardless of the identifier scheme; that exposure is inherent to the subscriptions backport and is per subscription pair, not per record system.

#### The decision template, filled in

Applying the use-case table per business object in this exchange:

| Business object          | Recognize across channels, time, migration            | References outlive the processing window     | Identity used in the business process           | Verdict                     |
| ------------------------ | ----------------------------------------------------- | -------------------------------------------- | ----------------------------------------------- | --------------------------- |
| Task                     | no: one instance, hosted at the sender                | no: references resolve during the transfer   | yes: transfer coordinators discuss the transfer by number | issued identifier           |
| Advance notice           | yes: an updated notice must replace the earlier one   | no                                           | no                                              | issued identifier           |
| Nursing handover         | yes: the receiver persists it, and the same document can later reach the patient's PGO through MedMij | yes: the stored copy keeps references to source resources | no                          | issued identifier           |
| Resources in the document Bundle | no: identity is managed at document level     | no                                           | no                                              | logical id suffices         |
| Patient                  | out of scope: real-world entity, identified by BSN    |                                              |                                                 | never an input for record identifiers |
{:.grid .table-hover}

The Patient row is the scope boundary in action: the BSN appears in the exchange as content, but no record identifier in this exchange may be derived from it.

#### The fields, filled in

Below is an eOverdracht Task as the requirements demand it, trimmed to the identifier-relevant fields (the eOverdracht profile targets FHIR STU3, hence the `requester.agent` shape; the notification layer is R4 and indifferent to this):

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

#### Walking the rules that leave a choice

The baseline rules REQ-01 through REQ-04 leave nothing to decide: an implementation either meets them or violates them, regardless of the exchange. The rules below each contain a choice, and this is how eOverdracht makes it:

- **REQ-05** (namespace): the transfer number in `Task.identifier` uses the shared self-assigned system with a high-entropy value, mechanism (b). The system URI shown is a placeholder; designating the real one is a trust-framework decision. An issuer-owned system URI, mechanism (a), would work too, at the cost of naming the hospital in every copy of the identifier.
- **REQ-06** (issuer and integrity): the assigner carries the sender's URA. The receiver already knows the authenticated URA of the party behind the Subscription, because the Subscription was scoped with `Task?owner=<URA>`; verifying the assigner is comparing two values it already holds. When the handover Composition later reaches a PGO through MedMij, the PGO matches on system, value, and assigner together, and accepts the assigner claim only from a channel trusted to relay that hospital's records.
- **REQ-07** (business identifier mandate): the filled-in decision template above is precisely the homework this rule assigns to the information standard: identifiers required on the Task and both Compositions, none required on the resources inside the document Bundle.
- **REQ-08** (reference style): each style lands where it belongs. The notification focus and `Task.input` are references by URL, dereferenced at the sender during the processing window. `Task.requester` and `Task.owner` reference real-world entities by business identifier (URA), the in-scope entity use from the scope section, resolvable through addressing. The focus reference is relative (`Task/...`); that works because the Subscription pairing implies the sender's base URL, and it stops working the moment a broker or second source enters the route, at which point the full URL is needed.
- **REQ-09** (notification payload): id-only mode is this rule in its purest form: the payload is a reference for the fetch, nothing else. Deduplication of the handover happens on `Composition.identifier` after the pull, never on anything in the notification. The guide's empty payload mode is stricter still and equally conformant.
- **REQ-10** (scheme): the sender's vendor is free to store UUIDv4 values with the record or to derive both ids from the internal transfer key with a keyed transformation; nothing in the exchange can tell the difference, which is the point.
- **REQ-11** (identifier reuse): the sender is the authoritative source of the transfer number, and under mechanism (b) that number satisfies REQ-02 and REQ-03, so the vendor MAY reuse it as the Task's logical id (one value in both `Task.id` and `Task.identifier.value`). Reusing the BSN-derived internal patient number this way remains forbidden no matter who hosts the resource.

### Open issues

- Whether a notification refers to the business object or to one representation of it. This determines whether the payload carries a business identifier or a logical id, and it depends on the wider discussion of what subscriptions notify about.
- Key custody and rotation for keyed transformations: who holds the key, and what happens to already-issued identifiers on rotation.
- Where the decision framework itself should be laid down: this document, the generic functions IG, or per information standard.
- Alignment with Nictiz's Objectidentificatie project, which addresses the same gap for document identifiers [2].

### References

1. FHIR R4, Resource Identity: <https://hl7.org/fhir/R4/resource.html#id>
2. Nictiz, Richtlijn Deduplicatie bij MedMij gegevensdienst Documenten, v0.1, November 2024: <https://informatiestandaarden.nictiz.nl>
3. FHIR, Managing Resource Identity: <https://hl7.org/fhir/managing.html>
4. FHIR, RESTful API, section "Update as Create": <https://hl7.org/fhir/http.html>
5. FHIR, section "Consistent Resource Identification": <https://hl7.org/fhir/resource.html>
6. FHIR, References: <https://hl7.org/fhir/references.html>
7. IHE ITI mCSD, Volume 1, section "Federated and Cross-Jurisdictional Deployments": <https://profiles.ihe.net/ITI/mCSD/>
8. FHIR, Security, section "Access Denied Response Handling": <https://hl7.org/fhir/security.html>
9. US Core Organization profile: <https://hl7.org/fhir/us/core/>
10. NHS England FHIR policy on identifiers: <https://nhsconnect.github.io/fhir-policy/identifiers.html>
11. Nictiz, eOverdracht 4.0, FHIR implementation: <https://informatiestandaarden.nictiz.nl/wiki/vpk:V4.0_FHIR_eOverdracht>
12. eOverdracht Notifications Implementation Guide, v0.2 draft, based on TTA Notifications v0.4 (internal working document, not yet published).
