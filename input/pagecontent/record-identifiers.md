<!--
SPDX-FileCopyrightText: 2026 Steven van der Vegt

SPDX-License-Identifier: CC-BY-SA-4.0
-->

Disclosure risks, identifier schemes, and who decides what. Status: draft. Condensed revision of [Record Identifiers](./record-identifiers.html); the full analysis and the eOverdracht worked example live there.

### Problem statement

Record identifiers travel further than the records they name. They appear in notifications, in references from other records, in URLs, and in access logs, so parties that never read a record still see its identifiers. At the same time receivers depend on them: to fetch a record from its source, to keep references valid in copies that outlive the exchange, and to recognize two copies of the same record as one. That last job, deduplication, is documented failing in the field: Nictiz's deduplication guideline for MedMij documents describes patients receiving the same letter twice in their PGO because each source system issued its own identifier (see [related work](#related-work)).

When identifier design fails, it fails in two ways. Disclosure: an identifier that encodes order, volume, timing, or content leaks information to everyone who sees it. Recognition errors: a receiver deciding whether two representations are the same record can err in both directions, storing one record twice (an undetected duplicate) or treating two different records as one (a false merge). The same design decisions cause or prevent both, so this document addresses them together. A third problem, the dangling reference (an identifier that no longer leads anywhere), is only partly an identifier problem: no scheme survives a server migration. What survives one is referencing by business identifier instead of by logical id, and that is reference design, covered here only where identifier decisions touch it.

Existing guidance does not cover identifier construction; the guides reviewed are listed under [related work](#related-work). The FHIR specification declares logical ids opaque and tells readers not to inspect their structure, but it gives producers no rules for constructing them, and its security pages do not mention disclosure through identifiers. This document fills that gap: which schemes are acceptable, and who gets to decide, the vendor, the information standard, or the trust framework.

### Terminology and scope

FHIR has two identifier constructs on a resource. The logical id (`Resource.id`) is assigned by the server that stores the resource. On its own it is unique only within one resource type on one server; prefixed with the server's base URL it becomes the globally unique address that a reference by URL points at. The business identifier (`Resource.identifier`) is a system URI plus a value, unique within that system, assigned by the authoritative source of the information. It travels as content, so it survives copying; the FHIR specification calls it the preferred basis to recognize the same content on different systems. A business identifier also serves the business process itself: an order number appears on letters and in phone calls, not only in exchanges. A logical id is always a record identifier. A business identifier is a record identifier only when it names a record, such as an order number; one that names a real-world entity, such as a BSN, is not.

This document focuses on the logical id. The requirements and schemes below apply unchanged to business identifiers that an organisation issues itself, such as order and transfer numbers; REQ-05, REQ-07, and REQ-10 exist for them alone.

In scope are record identifiers whose format is under the implementer's control. Out of scope are identifiers of real-world entities: BSN, URA, internal patient numbers. Their formats are governed elsewhere, but one rule about them belongs here: record identifiers must never be derivable from them.

### Risks

A risk, here, is what can go wrong through the identifier itself: first disclosure and guessing, which come from how the identifier is constructed, then recognition errors and dangling references, which come from how identifiers are issued, matched, and referenced.

Three categories of parties see identifiers without being authorized for the content:

1. The addressed but unauthorized recipient. A notification tells a party that a record exists before, or instead of, granting access to its content.
2. The observer. Brokers, proxies, logs, and backups hold identifiers in transit and at rest, long after the exchange.
3. The coalition. Parties that each hold identifiers legitimately and compare them to link records neither could link alone.

Schemes that fail:

- **Ordered identifiers** (sequential counters): reveal creation order and volume, are guessable, and let a reader infer that a record exists between two identifiers it has seen.
- **Time-encoding identifiers** (UUIDv1, UUIDv7): reveal the moment of creation.
- **Concatenated identifiers** (department plus patient number plus date): reveal content directly.
- **Derived identifiers** (an unkeyed hash of sensitive input; UUIDv5 is in this class): reveal content to anyone who can brute-force the input space, such as the space of patient numbers.
- **Low-entropy identifiers**: guessable. An attacker with an overbroad or forged token can probe candidates, and operational mistakes silently hit valid records. Entropy is a layer of defense for the moment access control fails.
- **Volatile identifiers** (freshly generated per request): opaque but not stable; they break lookup and deduplication for every receiver downstream.

Most of this leakage lands at observers and coalitions outside the disclosing organisation, so no single organisation's risk assessment can see or contain it. That is why the baseline requirements below are trust-framework material rather than per-implementation trade-offs.

Recognition errors and dangling references come mostly from issuing, matching, and referencing practice rather than from the scheme, and the requirements address them alongside:

- **Undetected duplicates**: a source issues a fresh identifier every time it shares the same record, or two channels deliver copies that never shared a business identifier. The receiver stores one record twice (REQ-01, REQ-07).
- **False merges**: two different records silently become one. Either two issuers collide in one namespace (REQ-05), or a receiver matches on system and value alone while a source, through a bug or deliberate spoofing, stamps another party's identifier on its own record (REQ-06). Matching bare logical ids across sources fails the same way: a logical id is unique only within one resource type on one server. A receiver can match soundly by scoping the id to its source, for example by recording `meta.source` on the local copy and comparing incoming ids per source; that recognizes the same representation at the same server, but breaks when the source re-issues its addresses, and an inbound `meta.source` filled by another party is an unverified claim like any assigner.
- **Dangling references**: a reference by logical id outlives the server it points at, for example after the source migrates to another vendor. No scheme prevents this; referencing by business identifier does, where copies outlive the exchange (REQ-07, REQ-08). The one scheme-level cause is the volatile identifier, which dangles immediately (REQ-01).

### Schemes that pass

- **Random identifiers** (UUIDv4). Fully opaque and high-entropy. For a system of record, storing the identifier alongside the record is all the bookkeeping there is.
- **Keyed transformations** of the source system's internal key: an HMAC under a secret key, or deterministic encryption of the internal key. Stable and opaque to anyone without the key. Generation is stateless; the encryption variant makes resolution stateless too, which suits facades that compose resources on the fly. Both stand or fall with key management.
- **Per-recipient identifiers**: a different identifier for the same record per receiving party. Defeats cross-party correlation at the cost of matching complexity at every boundary. Included for completeness; likely out of scope for this ecosystem (see open issues).

A secret key is unnecessary only when the input is itself genuinely random and known only to the source. Enumerable inputs such as patient numbers, dates, and counters always require one: the key blocks brute force, and it prevents a party holding a candidate input from confirming that an identifier belongs to it.

### Examples

The first three examples show the passing schemes, each identifying the same internal record, key `4711` in the source system's database. The fourth shows the two uniqueness mechanisms of REQ-05. The values are illustrative.

**Random (UUIDv4).** Generate once at record creation, with any UUID library, and store with the record:

```
Task.id = "5f2f9a4e-8c1d-4b6e-9d3a-7c0e2f4b8a1d"
```

**Keyed transformation (HMAC).** Compute from the internal key and a secret `k` held by the source; no per-record storage is needed for generation:

```
Task.id = base32( HMAC-SHA256(k, "Task/4711") )
        = "j5xw6z3vnfxgk4ttmvwgc3dj"
```

The output cannot be reversed, so inbound lookup requires an index of computed identifiers, or the deterministic-encryption variant, which the source decrypts straight back to `4711`. Rotating `k` changes every identifier. The input is the internal key, never a BSN or patient number.

**Per-recipient.** Derive a key per receiver, so each receiver sees a different identifier for the same record:

```
k_receiver = KDF(k, URA_receiver)
Task.id    = base32( HMAC-SHA256(k_receiver, "Task/4711") )
```

Receivers can no longer correlate the record with each other, and for the same reason they can no longer deduplicate across channels; every boundary needs a matching step at the source.

**Business identifier uniqueness (REQ-05).** A transfer number under each mechanism. Under mechanism (a) the issuer owns the system URI, which names the issuer in every copy of the record. The namespace guarantees uniqueness, so the value needs no entropy for that; REQ-03 still requires it to be unguessable:

```json
"identifier": [{
  "system": "https://fhir.hospital-x.example/id/transfer",
  "value": "wm3q7kzt5c6yjn2ohfxu4dpb"
}]
```

Everyone who sees this identifier learns that hospital X created the record: the unauthorized recipient, the observer, and the coalition alike.

Under mechanism (b) uniqueness comes from the entropy of the value. The system follows from a FHIR rule: when the value is a full URI, such as a UUID in urn form, the system SHALL be `urn:ietf:rfc:3986`. That system is shared by all issuers, so the identifier reveals nothing about who created the record. The issuer sits in the separate `assigner` element, which is part of the resource content but not of the system plus value pair that travels in references, URLs, and search tokens. REQ-06 says when the assigner must be present:

```json
"identifier": [{
  "system": "urn:ietf:rfc:3986",
  "value": "urn:uuid:e2b1c9d4-7a3f-4e8b-9c5d-1f6a8b2e4c7d",
  "assigner": {
    "identifier": { "system": "http://fhir.nl/fhir/NamingSystem/ura", "value": "12345678" }
  }
}]
```

Deduplication matches values exactly, and RFC 4122 fixes the canonical UUID form (lowercase), so no extra formatting agreement is needed.

**Validating identifier authenticity (REQ-06).** A record arrives over a connection authenticated as URA `87654321`, and its identifier claims assigner URA `12345678`. The receiver:

1. Takes the presenter's identity from the authenticated connection, never from the resource content.
2. Reads the claimed issuer from `Identifier.assigner`.
3. Accepts the claim if the presenter is the assigner, or if the exchange trusts the presenter to relay the assigner's records. Here the two differ, so everything rests on that relay trust.
4. Deduplicates on system, value, and assigner together. An identifier whose assigner claim was not accepted is stored as received, but never used to merge records.

Without step 3, any connected party could stamp another organisation's identifier on a record of its own, spoofing the issuer, and receivers would merge the two records silently. An alternative to `urn:ietf:rfc:3986` is a system URI designated by the trust framework, carrying the bare UUID as value. Such a system could signal what `urn:ietf:rfc:3986` cannot: that the value claims to meet the baseline of this document. It costs an invented namespace and deviates from common practice; whether the signal is worth that is an open question. Under either system the entropy guarantee comes from REQ-03, not from the system.

### Requirements

The rules use RFC 2119 keywords and are numbered **REQ-nn**. Each rule sits at the decision level that owns it, where owning means setting the rule's content. The levels still interact: a trust-framework rule can be conditional, the information standard then decides for its exchange whether the condition holds, and the vendor implements the result. REQ-06 shows the chain: the trust framework fixes how an identity claim is verified, whether an exchange requires deduplication at all and on which identifier is an information-standard decision (REQ-07), and the vendor builds the check. Adoption of the trust-framework rules is voluntary in the sense that joining the trust framework is; once adopted, they bind every participant.

- Trust framework: the baseline for every identifier that leaves a source system (REQ-01 to REQ-06). The harm from leaking identifiers lands outside the disclosing organisation, so it needs shared rules.
- Information standard: whether records carry an issued business identifier, whether that identifier must be fit for human use, and what references and notifications carry (REQ-07 to REQ-10). These depend on the exchange.
- Vendor: the identifier scheme and key management (REQ-11, REQ-12), free within the baseline.

#### Trust framework level

- **REQ-01** (stability): a source SHALL return the same identifier for the same record on every request.
- **REQ-02** (opacity): a record identifier SHALL NOT reveal creation order, volume, creation time, or content.
- **REQ-03** (unpredictability): a record identifier SHALL NOT be guessable, and SHALL NOT be computable or confirmable from real-world entity identifiers by anyone who does not hold a secret of the source.
- **REQ-04** (consumer opacity): a consumer SHALL treat received identifiers as opaque strings. It SHALL NOT parse them, derive meaning from them, or assume a format when querying.
- **REQ-05** (uniqueness): an issued business identifier SHALL be globally unique through one of two mechanisms: (a) an `Identifier.system` URI registered to and controlled by the issuer, with values unique within it; or (b) the system `urn:ietf:rfc:3986` with a `urn:uuid:` value whose entropy meets REQ-03. Mechanism (a) guarantees uniqueness by namespace ownership and names the issuer in every copy; mechanism (b) guarantees it by entropy and names nobody, which makes it the default for identifiers that travel beyond the care relationship. The examples show both.
- **REQ-06** (identity claim verification): an identifier in received content is a claim by the party that presents it, not a fact. A receiver SHALL merge two representations into one record only after verifying that claim: the presenter is the issuer, or a party trusted to relay the issuer's records. Who the issuer is follows from the identifier used for matching. For a business identifier under mechanism (a), it is the owner of the system URI. Under mechanism (b), the identifier SHALL carry its issuer in `Identifier.assigner`, and receivers SHALL match on system, value, and assigner together, never on system and value alone. For a logical id, it is the server the copy was fetched from, taken from the authenticated connection and never from inbound content. Which of these identifiers an exchange deduplicates on is a decision for the information standard, not for this document. This is an authenticity check: it blocks the spoofed false merge of the risks chapter. The examples walk through the verification steps for the assigner case.

#### Information standard level

- **REQ-07** (business identifier mandate): an information standard SHALL require an issued business identifier on a record type if (a) receivers must recognize the record across channels, time, or server migrations, or (b) references to it live in copies that outlast the exchange, or (c) its identity is used in the business process outside the exchange. Where none of these hold, a standard SHOULD NOT require one.
- **REQ-08** (reference style): within notified pull, references SHOULD be by URL. References by business identifier are for contexts without a resolvable source endpoint. Documents SHOULD contain the resources they reference.
- **REQ-09** (notification payload): a notification SHOULD carry the reference by URL, for the fetch. Receivers that persist the record deduplicate on the business identifier found in the fetched content, not on the notification payload.
- **REQ-10** (human use): an information standard SHALL determine whether an issued business identifier is used by people: read aloud on the phone, typed over from a letter, quoted in correspondence. If it is, the standard SHALL require a transcription-friendly form: a case-insensitive alphabet without ambiguous characters, grouped in short blocks, optionally with a check digit. This constrains the encoding, not the entropy. Making the value itself shorter weakens REQ-03, and that decision belongs to the trust framework.

REQ-08 and REQ-09 govern the use of identifiers in references and notifications rather than their construction. They are parked here because no better home exists yet; a future page on referencing and resolving records would be their natural place, and this document would then keep only the construction rules.

#### Vendor level

- **REQ-11** (scheme): a vendor MAY use random identifiers stored with the record, or a keyed transformation of the internal key; both meet REQ-01 through REQ-03. The vendor is responsible for key custody where a keyed scheme is used.
- **REQ-12** (identifier reuse): a business identifier MAY double as the logical id only if (a) the server is the authoritative source of the identified entity and (b) the identifier itself satisfies REQ-02 and REQ-03. A URA in a national directory satisfies this; a BSN never does.

### Related work

- Nictiz, [Richtlijn Deduplicatie bij MedMij gegevensdienst Documenten](https://informatiestandaarden.nictiz.nl/images/8/8b/Richtlijn_Deduplicatie_MedMij_gegevensdienst_Documenten_3.0.pdf) (v0.1, November 2024): PGOs deduplicate documents on the business identifier `DocumentReference.masterIdentifier`. Documents two field failures: sources that create the identifier only when sharing, so a second retrieval yields a fresh one, and providers that stamp their own identifier on documents they did not author. Concludes that sector-wide agreements on identifier use are needed. FHIR R5 removes `masterIdentifier` in favour of the plain `identifier` element, so the guidance transfers to `Resource.identifier`.
- Nictiz, Objectidentificatie project: addresses the same gap for document identifiers; this document should align with its outcome.
- [NHS England FHIR policy on identifiers](https://nhsconnect.github.io/fhir-policy/identifiers.html): prescribes reference styles per exchange paradigm (by URL in REST, by identifier in messaging, contained in documents), precedent for REQ-08.
- [HL7 US Core](https://hl7.org/fhir/us/core/): mandates the NPI as business identifier on Organization, precedent for a standard-level identifier mandate (REQ-07).
- [IHE ITI mCSD](https://profiles.ihe.net/ITI/mCSD/): expects jurisdictions, not implementers, to mandate the source of truth for directory identities, precedent for allocating identifier decisions above the implementer.
- FHIR core specification: [resource identity](https://hl7.org/fhir/resource.html), [references](https://hl7.org/fhir/references.html), [the Identifier datatype](https://hl7.org/fhir/datatypes.html#Identifier) (if the value is a full URI, the system SHALL be `urn:ietf:rfc:3986`), and [security](https://hl7.org/fhir/security.html) (a server supporting client-assigned ids cannot honestly answer "not found", which is why entropy matters).

### Open issues

- Key custody and rotation for keyed transformations: who holds the key, and what happens to already-issued identifiers on rotation.
- Whether the intended audience of a record should steer notification design. A Task is addressed to one receiver; an Observation or Patient may be accessible to many parties. For broadly accessible records, notifying by a stable identifier gives a coalition material to cross-reference, and an information standard may need per-recipient identifiers or empty notification payloads instead. This depends on the wider discussion of what subscriptions notify about.
- Whether self-assigned identifiers should use a trust-framework-designated system URI with a bare UUID value instead of `urn:ietf:rfc:3986`, so that the system itself signals that the value meets the baseline of this document. The signal comes at the cost of an invented namespace and a deviation from common practice.
- Alignment with Nictiz's Objectidentificatie project and the MedMij deduplication guideline, which address the same gap for document identifiers.
