<!--
SPDX-FileCopyrightText: 2026 Steven van der Vegt

SPDX-License-Identifier: CC-BY-SA-4.0
-->

Disclosure risks, identifier schemes, and who decides what. Status: draft.

### Problem statement

More parties see a record's identifier than see the record itself. Identifiers appear in notifications, in references from other records, in URLs, and in access logs, so a party that never reads a record still sees its identifiers. Receivers also depend on identifiers: to fetch a record from its source, to keep references valid in copies that outlive the exchange, and to recognize two copies of the same record as one. The last of these, deduplication, fails in practice. Nictiz's deduplication guideline for MedMij documents describes patients who received the same letter twice in their PGO because each source system issued its own identifier (see [related work](#related-work)).

Identifier design can fail in two ways. The first is disclosure: an identifier that encodes order, volume, timing, or content leaks information to everyone who sees it. The second is a matching error: a receiver draws the wrong conclusion about whether two representations are the same record. It stores one record twice (an undetected duplicate) or treats two different records as one (a false merge). The same design decisions cause or prevent both, so this document treats them together. A third problem, the dangling reference (an identifier that no longer resolves), is only partly an identifier problem. No identifier scheme keeps a reference valid after a server migration. Referencing by business identifier instead of by logical id does, but that is reference design. This document covers it only where it depends on identifier decisions.

Existing guidance does not cover identifier construction; the guides reviewed are listed under [related work](#related-work). The FHIR specification declares logical ids opaque and tells readers not to inspect their structure, but it gives producers no rules for constructing them. Its security pages do not mention disclosure through identifiers. This document specifies which schemes are acceptable and who decides: the vendor, the information standard, or the trust framework.

### Terminology and scope

FHIR has two identifier constructs on a resource. The logical id (`Resource.id`) is assigned by the server that stores the resource. On its own it is unique only within its namespace, usually one resource type on one server. Prefixed with the server's base URL it becomes a globally unique address, which is what a reference by URL points to.

The business identifier (`Resource.identifier`) is a system URI plus a value, unique within that system, assigned by the authoritative source of the information. It is part of the resource content, so a copy keeps it. The FHIR specification calls it the preferred basis to recognize the same content on different systems. A business identifier also serves the business process itself: an order number appears on letters and in phone calls, not only in exchanges.

A logical id is always a record identifier. A business identifier is a record identifier only when it names a record, such as an order number. One that names a real-world entity, such as a BSN, is not.

This document focuses on the logical id. The requirements and schemes below apply unchanged to business identifiers that an organisation issues itself, such as order and transfer numbers. REQ-05, REQ-07, and REQ-10 apply only to those.

In scope are record identifiers whose format the implementer controls. Out of scope are identifiers of real-world entities: BSN, URA, internal patient numbers. Other bodies govern their formats; REQ-03 restricts how record identifiers may relate to them.

### Risks

This section lists what can go wrong through the identifier itself. Disclosure and guessing come from how the identifier is constructed. Matching errors and dangling references come from how identifiers are issued, matched, and referenced.

Three categories of parties see identifiers without being authorized for the content:

1. The addressed but unauthorized recipient. A notification tells a party that a record exists before, or instead of, granting access to its content.
2. The observer. Brokers, proxies, logs, and backups keep identifiers in transit and at rest, often long after the exchange.
3. The colluding parties. Parties that each hold identifiers legitimately and compare them, to link records that neither could link alone.

Identifier scheme anti-patterns:

- **Ordered identifiers** (sequential counters): reveal creation order and volume, are guessable, and let a reader infer that records exist between two identifiers it has seen.
- **Time-encoding identifiers** (UUIDv1, UUIDv7): reveal the moment of creation.
- **Concatenated identifiers** (department plus patient number plus date): reveal content directly.
- **Derived identifiers** (an unkeyed hash of sensitive input; UUIDv5 is in this class): reveal content to anyone who can try every possible input, such as every patient number.
- **Low-entropy identifiers**: guessable. An attacker with an overbroad or forged token can try candidate identifiers, and a mistyped identifier still resolves to a valid record. Entropy limits the damage when access control fails.
- **Volatile identifiers** (freshly generated per request): opaque but not stable. They break lookup and deduplication for every receiver.

The parties that misuse a disclosed identifier, observers and colluding parties, are outside the organisation that disclosed it. That organisation cannot see or stop what happens to an identifier after it leaves, so its own risk assessment cannot address this risk. The rules have to be shared. That is why the baseline requirements below are trust framework rules and not choices per implementation.

Matching errors and dangling references come mostly from how identifiers are issued, matched, and referenced, not from the scheme. The requirements address them as well:

- **Undetected duplicates**: a source issues a new identifier every time it shares the same record, or two channels deliver copies without a shared business identifier. The receiver stores one record twice (REQ-01, REQ-07).
- **False merges**: a receiver treats two different records as one. Either two issuers collide in one namespace (REQ-05), or a receiver matches on system and value alone while a source, through a bug or deliberate spoofing, assigns another party's identifier to its own record (REQ-06). Matching logical ids alone, without their source, fails the same way, because a logical id is unique only within its namespace, usually one resource type on one server. A receiver can match correctly by combining the id with its source, for example by recording `meta.source` on the local copy and comparing incoming ids per source. That recognizes the same representation at the same server, but fails after the source migrates, and an inbound `meta.source` filled by another party is unverified, like an assigner.
- **Dangling references**: a reference by logical id stays in use after the server it points to is gone, for example after the source migrates to another vendor. No scheme prevents this. Referencing by business identifier does, where copies outlive the exchange (REQ-07, REQ-08). The one cause at scheme level is the volatile identifier, which is invalid on the next request (REQ-01).

### Acceptable schemes

- **Random identifiers** (UUIDv4). Fully opaque and high-entropy. For a system of record, storing the identifier with the record is the only state to keep.
- **Keyed transformations** of the source system's internal key: an HMAC under a secret key, or deterministic encryption of the internal key. Stable, and opaque to anyone without the key. Generation is stateless. The encryption variant makes resolution stateless too, which suits facades that build resources at request time. Both depend on key management.
- **Per-recipient identifiers**: a different identifier for the same record for each receiving party. Prevents correlation between receivers, but every receiver must then match through the source. Included for completeness; probably out of scope for this ecosystem (see open issues).

A secret key is needed whenever the input is not itself random and known only to the source. Without a key, anyone can try every possible input and check which identifier it produces. The input is the record's internal key, never a real-world entity identifier: a keyed derivation from a BSN makes every record identifier a pseudonym of the person, so one key leak links the person's whole history (REQ-03).

#### Scheme examples

Each example identifies the same internal record, key `4711` in the source system's database. The values are illustrative.

**Random (UUIDv4).** Generate once at record creation, with any UUID library, and store with the record:

```
Task.id = "5f2f9a4e-8c1d-4b6e-9d3a-7c0e2f4b8a1d"
```

**Keyed transformation (HMAC).** Compute from the internal key and a secret `k` held by the source; generation needs no storage per record:

```
Task.id = base32( HMAC-SHA256(k, "Task/4711") )
        = "j5xw6z3vnfxgk4ttmvwgc3dj"
```

The output cannot be reversed, so inbound lookup needs an index of computed identifiers, or the deterministic-encryption variant, which the source decrypts to `4711`. Rotating `k` changes every identifier. The input is the internal key, never a BSN or patient number.

**Per-recipient.** Derive a key per receiver, so each receiver sees a different identifier for the same record:

```
k_receiver = KDF(k, URA_receiver)
Task.id    = base32( HMAC-SHA256(k_receiver, "Task/4711") )
```

Receivers can no longer correlate the record with each other, and for the same reason they can no longer deduplicate across channels. Deduplication between receivers needs a matching step at the source.

### Requirements

The rules below use RFC 2119 keywords and are numbered REQ-nn. They are grouped by who decides: the trust framework, the information standard, or the vendor. A rule belongs to the party that sets its content.

The trust framework sets the baseline for every identifier that leaves a source system (REQ-01 to REQ-06). These rules are shared because a disclosed identifier harms parties outside the organisation that disclosed it, and no single organisation can manage that risk alone. Joining the trust framework is voluntary. Once joined, the rules bind every participant.

The information standard decides what its exchange needs (REQ-07 to REQ-10): whether records carry an issued business identifier, whether people handle that identifier by hand, and what references and notifications contain. The answers differ per exchange.

The vendor chooses the identifier scheme and manages the keys (REQ-11, REQ-12). Any choice that meets the baseline is allowed.

The three levels depend on each other. Deduplication is an example. The trust framework sets how a receiver verifies who issued an identifier before it merges two records (REQ-06). The information standard decides whether its exchange deduplicates at all, and on which identifier (REQ-07). The vendor builds the check.

#### Trust framework level

- **REQ-01** (stability): a source SHALL return the same identifier for the same record on every request.
- **REQ-02** (opacity): a record identifier SHALL NOT reveal creation order, volume, creation time, or content.
- **REQ-03** (unpredictability): a record identifier SHALL NOT be guessable. It SHALL NOT be a real-world entity identifier, such as a BSN or patient number, or be derived from one.
- **REQ-04** (consumer opacity): a consumer SHALL treat a received identifier as an opaque string. It SHALL NOT parse the identifier, derive meaning from it, or assume a format when it queries.
- **REQ-05** (uniqueness): an issued business identifier SHALL be globally unique through one of two mechanisms: (a) an `Identifier.system` URI that the issuer has registered and controls, with values unique within it; or (b) the system `urn:ietf:rfc:3986` with a `urn:uuid:` value whose entropy meets REQ-03. Mechanism (a) guarantees uniqueness through ownership of the namespace and names the issuer in every copy. Mechanism (b) guarantees uniqueness through entropy and names no issuer. That makes (b) the default: it does not tell every party that sees the identifier where the patient is treated. The examples below show both.
- **REQ-06** (identifier authenticity): an identifier in received content does not prove who issued it; the party that presents the content may have put it there. A receiver SHALL merge two representations into one record only after it has verified that the presenter is the issuer, or is a party trusted to relay the issuer's records. Which party is the issuer depends on the identifier used for matching. For a business identifier whose system URI is owned by the issuer, it is the owner of that URI. For a business identifier with a `urn:uuid:` value, it is the party in `Identifier.assigner`. Such an identifier SHALL carry its assigner, and receivers SHALL match on system, value, and assigner together, never on system and value alone. For a logical id, it is the server the copy was fetched from, taken from the authenticated connection and never from inbound content. Which identifier an exchange deduplicates on is decided by the information standard, not by this document. This check prevents the spoofed false merge described under risks. The examples below list the verification steps for the assigner case.

#### Information standard level

- **REQ-07** (business identifier mandate): an information standard SHALL require an issued business identifier on a record type if (a) receivers must recognize the record across channels, over time, or after a server migration, or (b) references to it are stored in copies that outlive the exchange, or (c) the record is identified in the business process outside the exchange. If none of these hold, a standard SHOULD NOT require one.
- **REQ-08** (reference style): within notified pull, references SHOULD be by URL. References by business identifier are for contexts without a resolvable source endpoint. Documents SHOULD contain the resources they reference.
- **REQ-09** (notification payload): a notification SHOULD carry the reference by URL, which the receiver uses to fetch the record. A receiver that stores the record deduplicates on the business identifier in the fetched content, not on the notification payload.
- **REQ-10** (human use): an information standard SHALL determine whether people handle an issued business identifier by hand: read it aloud on the phone, copy it from a letter, quote it in correspondence. If so, the standard SHALL require a transcription-friendly form: a case-insensitive alphabet without ambiguous characters, grouped in short blocks, optionally with a check digit. This constrains the encoding, not the entropy. A shorter value weakens REQ-03, and that decision belongs to the trust framework.

REQ-08 and REQ-09 govern the use of identifiers in references and notifications, not their construction. They are placed here until a page on referencing and resolving records exists. That page would then hold them, and this document would keep only the construction rules.

On the payload choice in REQ-09: a payload without any reference does not always disclose less. The receiver must then find the record by searching, and a search response can contain more records than the notification concerned. A reference that meets REQ-02 and REQ-03, retrieved by direct read, discloses exactly one opaque reference and nothing else. The examples below show such a payload.

#### Vendor level

- **REQ-11** (scheme): a vendor MAY use random identifiers stored with the record, or a keyed transformation of the internal key. Both meet REQ-01 through REQ-03. With a keyed scheme, the vendor is responsible for key custody.
- **REQ-12** (identifier reuse): a business identifier MAY also serve as the logical id, but only if (a) the server is the authoritative source of the identified entity and (b) the identifier itself meets REQ-02 and REQ-03. A URA in a national directory meets this; a BSN never does.

### Examples

The following examples cover REQ-05, REQ-06 and REQ-09 with FHIR snippets that show how to meet them. The values are illustrative.

**Business identifier uniqueness (REQ-05).** A transfer number under each mechanism. Under mechanism (a) the issuer owns the system URI, which names the issuer in every copy of the record. The namespace guarantees uniqueness, so the value needs no entropy for that. REQ-03 still requires it to be unguessable:

```json
"identifier": [{
  "system": "https://fhir.hospital-x.example/id/transfer",
  "value": "wm3q7kzt5c6yjn2ohfxu4dpb"
}]
```

Everyone who sees this identifier learns that hospital X created the record: the unauthorized recipient, the observer, and the colluding parties alike.

Under mechanism (b) uniqueness comes from the entropy of the value. The system follows from a FHIR rule: when the value is a full URI, such as a UUID in urn form, the system SHALL be `urn:ietf:rfc:3986`. All issuers share that system, so the identifier reveals nothing about who created the record. The issuer is in the separate `assigner` element. That element is part of the resource content, but not of the system plus value pair used in references, URLs, and search tokens. REQ-06 says when the assigner must be present:

```json
"identifier": [{
  "system": "urn:ietf:rfc:3986",
  "value": "urn:uuid:e2b1c9d4-7a3f-4e8b-9c5d-1f6a8b2e4c7d",
  "assigner": {
    "identifier": { "system": "http://fhir.nl/fhir/NamingSystem/ura", "value": "12345678" }
  }
}]
```

Deduplication compares values exactly. RFC 4122 defines the canonical UUID form (lowercase), so no extra formatting agreement is needed.

**Validating identifier authenticity (REQ-06).** A record arrives over a connection authenticated as URA `87654321`, and its identifier names assigner URA `12345678`. The receiver:

1. Takes the presenter's identity from the authenticated connection, never from the resource content.
2. Reads the issuer from `Identifier.assigner`.
3. Accepts the identifier as authentic if the presenter is the assigner, or if the exchange trusts the presenter to relay the assigner's records. Here the two differ, so acceptance depends on that relay trust.
4. Deduplicates on system, value, and assigner together. An identifier that was not accepted as authentic is stored as received, but never used to merge records.

Without step 3, any connected party could assign another organisation's identifier to a record of its own, and receivers would merge the two records without noticing. An alternative to `urn:ietf:rfc:3986` is a system URI designated by the trust framework, with the bare UUID as value. Such a system could signal what `urn:ietf:rfc:3986` cannot: that the value is meant to meet the baseline of this document. The cost is a new namespace and a deviation from common practice; see open issues. Under either system the entropy guarantee comes from REQ-03, not from the system.

**Id-only notification (REQ-09).** The notification as every party on the channel sees it, reduced to the relevant fields: a history Bundle whose first entry reports the event, and whose second entry carries the focus reference without the resource:

```json
{
  "resourceType": "Bundle",
  "type": "history",
  "entry": [
    {
      "fullUrl": "urn:uuid:c3a5d8f1-9b2e-4d67-8a4c-5e1f7b9d2a36",
      "resource": {
        "resourceType": "Parameters",
        "parameter": [
          { "name": "subscription", "valueReference": { "reference": "Subscription/7f3e9a2c-5d18-4b6f-9c3a-8e2d4f6b1a59" } },
          { "name": "status", "valueCode": "active" },
          { "name": "type", "valueCode": "event-notification" },
          {
            "name": "notification-event",
            "part": [
              { "name": "event-number", "valueString": "42" },
              { "name": "timestamp", "valueInstant": "2026-07-16T09:15:00Z" },
              { "name": "focus", "valueReference": { "reference": "Task/5f2f9a4e-8c1d-4b6e-9d3a-7c0e2f4b8a1d" } }
            ]
          }
        ]
      }
    },
    {
      "fullUrl": "https://sender.example/fhir/Task/5f2f9a4e-8c1d-4b6e-9d3a-7c0e2f4b8a1d",
      "request": { "method": "GET", "url": "Task/5f2f9a4e-8c1d-4b6e-9d3a-7c0e2f4b8a1d" },
      "response": { "status": "200" }
    }
  ]
}
```

With REQ-02 and REQ-03 met, the Task reference reveals one thing: a Task exists at the sender. The receiver retrieves it by direct read; no search is needed. The event-number and timestamp belong to the notification protocol itself and reveal per-channel volume and timing regardless of the identifier scheme.

### Related work

- Nictiz, [Richtlijn Deduplicatie bij MedMij gegevensdienst Documenten](https://informatiestandaarden.nictiz.nl/images/8/8b/Richtlijn_Deduplicatie_MedMij_gegevensdienst_Documenten_3.0.pdf) (v0.1, November 2024): PGOs deduplicate documents on the business identifier `DocumentReference.masterIdentifier`. Describes two failures seen in practice: sources that create the identifier only when sharing, so a second retrieval yields a new one, and providers that assign their own identifier to documents they did not author. Concludes that sector-wide agreements on identifier use are needed. FHIR R5 removes `masterIdentifier` in favour of the plain `identifier` element, so the guidance transfers to `Resource.identifier`.
- Nictiz, Objectidentificatie project: addresses the same gap for document identifiers; this document should align with its outcome.
- [NHS England FHIR policy on identifiers](https://nhsconnect.github.io/fhir-policy/identifiers.html): prescribes reference styles per exchange paradigm (by URL in REST, by identifier in messaging, contained in documents), precedent for REQ-08.
- [HL7 US Core](https://hl7.org/fhir/us/core/): mandates the NPI as business identifier on Organization, precedent for a standard-level identifier mandate (REQ-07).
- [IHE ITI mCSD](https://profiles.ihe.net/ITI/mCSD/): expects jurisdictions, not implementers, to mandate the source of truth for directory identities, precedent for allocating identifier decisions above the implementer.
- FHIR core specification: [resource identity](https://hl7.org/fhir/resource.html), [references](https://hl7.org/fhir/references.html), [the Identifier datatype](https://hl7.org/fhir/datatypes.html#Identifier) (if the value is a full URI, the system SHALL be `urn:ietf:rfc:3986`), and [security](https://hl7.org/fhir/security.html) (a server supporting client-assigned ids cannot honestly answer "not found", which is why entropy matters).

### Open issues

- Key custody and rotation for keyed transformations: who holds the key, and what happens to already-issued identifiers on rotation.
- Whether the intended audience of a record should determine notification design. A Task is addressed to one receiver; an Observation or Patient may be accessible to many parties. For broadly accessible records, notifying by a stable identifier lets colluding parties link records, and an information standard may need per-recipient identifiers or empty notification payloads instead. This depends on the wider discussion of what subscriptions notify about.
- Whether self-assigned identifiers should use a system URI designated by the trust framework, with a bare UUID value, instead of `urn:ietf:rfc:3986`, so that the system itself signals that the value meets the baseline of this document. The cost is a new namespace and a deviation from common practice.
- Alignment with Nictiz's Objectidentificatie project and the MedMij deduplication guideline, which address the same gap for document identifiers.
