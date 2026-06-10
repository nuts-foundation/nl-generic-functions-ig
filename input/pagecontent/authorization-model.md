<!--
SPDX-FileCopyrightText: 2026 Steven van der Vegt

SPDX-License-Identifier: CC-BY-SA-4.0
-->

### Introduction

Dutch healthcare data exchange runs under several trust frameworks (AORTA-on-FHIR, MedMij, Twiin, Nuts use-case communities). Each one has, over time, built its own authorization model. Each model is well documented within its own framework. But it is framework-local: it lives spread over registry definitions, policy documents, and wire conventions, in a vocabulary that only works inside that framework. No shared national model exists. The models overlap conceptually: qualifications, delegations, roles, and context checks appear in all of them. Yet they never align, and there is no shared vocabulary to compare them in.

This proposal makes the model explicit. It defines a shared _authorization information model_, layered on top of the Nictiz information-standard catalogue, and derives one concrete OAuth 2.0 wire convention from it.

The intended audience is architects of the trust frameworks listed above. The proposal is independent of how identity claims are attested and does not prescribe a wire format; the Specification lists the attestation forms in use today.

A note on terminology: this chapter uses English terms for the Nictiz catalogue concepts (transaction, system role, business role); the glossary contains the translation table. Concrete catalogue values (transaction names, role names, rolcodes) are quoted in their original Dutch.

### Problem

Each trust framework documents its own authorization model, but only its own. Four constructs recur in every framework, under different names, at different granularities, with different attestation formats:

- **Qualification**: every framework has a mechanism that admits a vendor product into a technical role, but each framework names a different part of that mechanism. AORTA names the registry that records the result of a successful qualification (TKID); MedMij names the roles a successful qualification admits a party into (DVA, DVP); Twiin has similar mechanisms. None separates the qualification from the role it leads to.
- **Delegation chain**: AORTA, MedMij, and Twiin each construct delegation chains between professionals, organisations, and service providers differently. The chain shape is usually similar; the attestations and granularities are not.
- **Role resolution**: every framework maps presented identity claims (rolcodes, organisation identifiers) onto something it permits actions for, but the mapping rules are buried in framework-specific policy documents such as the Autorisatierichtlijn, with no common structure.
- **Context checks**: consent (Mitz), the treatment relationship, and purpose-of-use gates exist everywhere, attached at different points in each framework and with no shared vocabulary (an explicit purposeOfUse field in the Nuts authorization credential, the distinct spoed situation in Mitz).

Because each model is stated only in its own framework's terms, the models cannot be compared, mapped, or composed. A developer building a system that participates in two frameworks must assemble two complete models from documentation scattered across wikis, registries, and policy documents, and invent the mapping between them. A policy author cannot tell whether two frameworks make the same access decision for the same situation. This is the core problem: cross-framework integration is expensive and brittle.

The divergence is most visible on the OAuth wire: each framework identifies the authorized work in the request scope with a different grammar, and differs in whether that identification survives onto the issued access token. The wire divergence is only the visible part: the grammars differ because each framework derived its wire convention from a different underlying model. Aligning the syntax without aligning the model would change nothing. This proposal therefore defines the model first, and the wire convention as its consequence.

### The model

The Examples section shows every construct introduced below as a filled-in table, for one concrete case (a GP consults a patient's medication agreements). Reading the model and that example side by side is the fastest route through this chapter.

#### Three layers

This proposal models authorization in three layers. The layering is a modelling decision, not a given: it is chosen because the layers have different owners, change at different rates, and answer different questions. A layer groups concerns, not authors; one governance body can author artefacts in more than one layer.

- **Layer 1, Information Standards** defines _what_ transactions exist and _what data_ they carry. In the Netherlands most information standards are maintained by Nictiz; this proposal adopts the Nictiz meta-model, per the [Handleiding Wiki documentatie](https://informatiestandaarden.nictiz.nl/wiki/Handleiding_Wiki_documentatie), as the layer-1 vocabulary. It catalogues information standards, use cases, transaction groups, transactions, system roles, business roles, and the datasets they operate on. The same for all trust frameworks.
- **Layer 2, Trust Framework** specifies _who_ may perform _which_ transactions, and under what conditions: role resolution, the permission matrix, qualifications, the delegation chain, identity claims, context claims. Today these constructs are filled per framework (VZVZ, MedMij, Twiin, Nuts-toepassingen). The model does not tie them to per-framework governance: with a shared vocabulary, layer-2 policies can be lifted to national governance where that is wanted.
- **Layer 3, Realisation and OAuth wire** specifies _how_ a transaction reaches the wire: the FHIR profiles that represent its data, the wire-level operations that carry it, and how a single authorization decision surfaces in an OAuth 2.0 exchange. The wire artefacts are the access-token request, the issued access token, and the minted SMART on FHIR scopes that the resource server enforces.

This proposal defines a uniform model for layers 2 and 3. Layer 1 is taken as given.

#### Layer 1: Information Standards

{% include authorization-model-nictiz.svg %}

Hierarchy from outer to inner:

- **Information standard** (informatiestandaard): top container (e.g. Medicatieproces 9).
- **Use case**: a sub-chapter of an information standard. Coarse business framing. The use case defines the intent; each transaction, belonging to exactly one use case, inherits it.
- **Transaction group** (transactiegroep): a named group of related transactions, e.g. `Verstrekkingsverzoek (raadplegen/beschikbaarstellen)`, bundling the `Raadplegen verstrekkingsverzoek` and `Beschikbaarstellen verstrekkingsverzoeken` transactions.
- **Transaction** (transactie): a single interaction within a transaction group. The transactions in a group form an exchange: in a pull exchange, `Raadplegen verstrekkingsverzoek` (the consumer queries a source; type `initial`) pairs with `Beschikbaarstellen verstrekkingsverzoeken` (the source returns the requested data; type `back`). A push exchange pairs a `Sturen ...` transaction with its receipt confirmation. The leaf functional unit: nothing sits between the transaction and the data it selects.
- **System role** (systeemrol): the role a system plays in a transaction (Raadplegend, Beschikbaarstellend, Sturend, Ontvangend, possibly refined per subject). Unit of qualification.
- **Business role** (bedrijfsrol): the role a person plays in a transaction (Voorschrijver, Verstrekker, ...). Cross-cutting actor type.
- **Dataset** and **DatasetConcept**: the data definitions. An information standard defines its primary datasets; building-block datasets (zibs) are defined by other standards and imported. A dataset is a tree of concepts (groups and items); a transaction selects a subset of those concepts and restricts them. That selection is the _transaction dataset_ (transactiedataset).

Two structural points matter for authorization:

- **Containment, not reuse.** A transaction group belongs to one use case, and a transaction to one transaction group, so a transaction belongs to exactly one use case. Reuse across standards happens at the dataset, template, and value-set level, not at the transaction level. Fetching the same data under a different use case is, by definition, a different transaction, because the use case carries the intent and therefore the conditions.
- **There is no operation concept in layer 1.** The functional model stops at the transaction. The fine-grained wire-level operations are realisation constructs and are introduced in layer 3.

The transaction dataset itself shows which constructs belong in layer 2; the design notes contain that derivation.

#### Layer 2: Trust Framework

Layer 2 adds the constructs that gate access on top of the layer-1 catalogue. It is presented in two views: first the concrete actors and the credentials that carry their claims in the Dutch context, then the general mechanism that turns those claims into an access decision. In both diagrams, layer-1 catalogue entities are shown in yellow (referenced, not redefined here), trust-framework policy and actors in pale blue, and identity claims in mid-blue.

**Actors and credentials.**

This view shows who the actors are, the credentials carrying the identity claims that the access decision consumes, and the context claims (such as the Enrollment) the actors produce.

{% include authorization-model-layer2.svg %}

- **HealthcareProfessional, HealthcareOrganization, ServiceProvider**: the three professional-side actor layers. The professional is employed by an organisation; the organisation is served by a service provider.
- **Patient**: the data subject, referenced via their BSN in the `patient` attribute of the AccessTokenRequest. In professional flows the request principal is the ServiceProvider acting for the professional and the organisation; in patient-channel (PHR) flows the patient is also the authenticated principal, requesting via their PGO (see the MedMij example).
- **IdentityClaim** (abstract): a typed assertion about the requester. Generalises rolcode, organisation identifiers, the system-role or business-role assertion, the Qualification, the Membership, and the two delegations. Each trust framework defines its own vocabulary.
- **Qualification**: the claim by which a ServiceProvider asserts that its product passed qualification for a given system role. The qualification itself is an upstream certification process; the claim asserts its result. AORTA records qualification results in TKID; a successful MedMij qualification admits the party into the DVA (provider-side) or DVP (PGO-side) role.
- **HealthcareProfessional-to-HealthcareOrganization delegation**: the credential by which a professional delegates a set of business roles to their organisation. It is the _mandaattoken_ behind the matrix's `delegatable` flag. It is needed whenever the role is exercised by someone other than the professional who holds it: the organisation acting unattended, or an authenticated user who lacks the required rolcode and works under the professional's responsibility. A professional with the required rolcode asserts the role directly. Whether the delegation surfaces as a wire credential at all depends on the enforcement topology (below).
- **ServiceProvider delegation**: the credential by which an organisation delegates a set of system roles to its service provider.
- **Membership**: the claim by which a HealthcareOrganization asserts its admission to a trust framework, or to a specific information standard within it. The organisational counterpart of the Qualification: where the Qualification certifies a product for a system role, the Membership certifies that the organisation meets the framework's non-technical requirements (participation agreements, security and privacy norms). Realisations: the MedMij and Twiin deelnemersovereenkomst, AORTA's aansluitvoorwaarden. Prerequisites reference it like any other identity claim; it is slow-changing and typically binds at registration time.
- **ContextClaim** (abstract) and **Enrollment**: assertions about the request and the patient, not the requester. `Enrollment` is the treatment relationship: the professional issues it to the organisation, attesting that they enrol or treat the patient. It feeds the use-case context gate, not role resolution.

The delegation chain runs at two layers: the professional-to-organisation delegation at business-role level, the service-provider delegation at system-role level. Each step delegates only what it can express; a professional is not a system, so cannot delegate a system role. The identity claims feed the role resolution below; the context claims, such as the Enrollment, feed the use-case context gate.

**Role resolution and permission.**

{% include authorization-model-role-resolution.svg %}

Authorization is decided in two decoupled steps on the professional side. First, _role resolution_: a `RolePrerequisite` resolves the presented identity claims to an `AuthorizationRole`, one business role refined by a set of claims (typically rolcodes). A role may have several prerequisites, and satisfying any one resolves the role; adding a new way to prove the same role means adding a prerequisite, without touching the permission rules. Second, _permission_: the `PermissionMatrix` keys on the `AuthorizationRole` and the `Transaction` and yields allow or deny plus a `delegatable` flag.

The PermissionMatrix is always present, but its content may be trivial. The AORTA realisation for medication is the _Autorisatierichtlijn medicatieveiligheid_, a table mapping (rolcode, transaction) to ja/nee. Acute Zorg and Labuitwisseling have no such policy; they attach professions directly to transactions. A standard without a policy realises the matrix as an explicitly published allow-all over its resolved roles. The matrix is never absent and an absent entry is always deny; "no policy" is expressed as a trivial matrix, not as a missing one.

The system side is evaluated independently of the professional side; the model implies no order between them. In the common case it is one check: the Qualification and the ServiceProvider delegation (both introduced above) must name the transaction's system role. That suffices because the transaction itself declares which system role it involves. No matrix is needed: naming the system role is naming the permitted transactions. In the diagram, both sides therefore end in an edge to the Transaction, and both edges mean the same thing: permission. The professional side mediates that permission through the matrix, because a business role carries no per-transaction verdicts; those are policy, such as the Autorisatierichtlijn.

One refinement exists, for standards whose system roles are coarse. Medicatieproces 9 defines roughly fifty system roles, one per subject-activity pair (e.g. `MedicatieafspraakRaadplegend`), so naming the system role pins down a single transaction and nothing more is needed. A standard with a handful of generic system roles would grant every transaction of the role with one qualification. For that case the trust framework MAY define a `QualifiedSystemRole`: a refinement of one system role that covers only a subset of its transactions. The `SystemRolePrerequisite` then resolves the ServiceProvider's claims to that refined role. Absent a refinement, the qualification grants every transaction of the system role. The two layer-2 roles compare as follows:

|                 | AuthorizationRole                | QualifiedSystemRole                               |
| --------------- | -------------------------------- | ------------------------------------------------- |
| refines         | one business role                | one system role                                   |
| refinement axis | requester claims (rolcodes)      | transaction coverage                              |
| answers         | who counts as this role          | which transactions does this qualification grant  |
| default         | none; every role must be defined | no refinement; grants all the role's transactions |
| permission via  | PermissionMatrix cell            | coverage directly permits                         |
{:.grid .table-hover}

**The patient channel.** The same machinery covers the citizen. The patient is an actor whose RolePrerequisite reads the DigiD-authenticated BSN claim and resolves to an AuthorizationRole refining the business role Patiënt. The PermissionMatrix rows for that role are the framework's allow-set for patient access (in MedMij terms: the gegevensdiensten). The system side is unchanged: the PGO operator is the ServiceProvider, its Qualification is the DVP admission, and the delegation is issued by the patient rather than by an organisation. The context gate degenerates: there is no treatment relationship, and consent is inherent in requesting one's own data. What remains is the data-subject equality check: the authenticated BSN must equal the `patient` attribute. The MedMij example in the Examples section shows the resulting token.

**Enforcement topology.** The model defines policy as facts and rules: claims, prerequisites, the matrix, the context gate. Where those rules are enforced, and how the evidence reaches the enforcer, is a deployment choice the model leaves open. The principle: a fact must surface as a wire claim exactly when the evaluating party cannot observe it directly. The consequences (why the two delegations behave differently, when evidence should bind, what the OAuth wire can and cannot carry) are worked out in the design notes, after the evaluation flow.

#### Layer 3: Realisation and OAuth wire

Layer 3 realises the transaction in FHIR and OAuth. Its first construct is the **Operation**: a single wire-level interaction, identified as `<verb>:<artifact>:<version>` (e.g. `search:mp-MedicationAgreement:1`). Operations are reusable building blocks: the same operation can realise transactions in different use cases. One transaction is realised by one or more operations, and each operation targets one FHIR resource type, which is what SMART on FHIR scopes are minted from. The construct is not new: the [AORTA-on-FHIR interactietabel](https://aorta-on-fhir.public.vzvz.nl/aorta-on-fhir-specificaties/Working-version/aorta-interactietabel) defines the same thing as its `interactionId`, including the reuse across use cases (one operation row carrying a list of context codes); this proposal adopts that shape.

{% include authorization-model-layer3.svg %}

The layer-1 entity (`Transaction`) appears in yellow; layer-2 entities (`IdentityClaim`, `ServiceProvider`) appear in blue. Layer-3 entities, including the `Operation` and `FHIRResource`, are shown in green.

- **AccessTokenRequest**: what the ServiceProvider sends to the AS. Carries one transaction scope token (the `tx`), an optional list of operations (interactie-ids) that narrow the minted scopes, the asserted identity claims, and the context claims. The `patient` attribute carries the data-subject BSN where the transaction concerns a patient; the AS enforces that the patient identifier in the eventual query equals the issued token's `patient` scope.
- **AccessToken**: the OAuth 2.0 artefact returned on success. Authorizes exactly one transaction, carries the verified identity claims, and carries the minted SMART on FHIR scopes.
- **SoFScope**: a [SMART on FHIR v2](https://www.hl7.org/fhir/smart-app-launch/scopes-and-launch-context.html) scope (`<context>/<Resource>.<crud>`). The unit of resource-server enforcement, minted at issue time from the requested operations via the profile and FHIR resource type.

Note the asymmetry between request and response: the **request carries the transaction token** (optionally narrowed by interactie-ids), the **response carries the transaction token plus the minted SMART on FHIR scopes**. The AS converts requested operations into scopes at mint time.

An AT is scoped to one transaction. The AS verifies that a resolved QualifiedSystemRole (backed by the Qualification and the ServiceProvider delegation) covers the transaction. Operations in the request only narrow the minted scopes. Why the transaction, and not the use case or the operation, is the scope unit is argued in the design notes.

Two mappings make this work, and both live in a realisation catalogue published alongside the trust framework's registry:

- transaction to operations: which operations realise which transaction. The AS uses it to validate requested operations (REQ-4).
- operation to scope: operation to profile to FHIR resource type to SMART on FHIR scope. The AS uses it at mint time.

The catalogue is owned by whoever realises the information standard for the framework. Today it exists per framework, the interactietabel being one realisation. The model requires only that it is published and that the AS resolves both mappings by lookup, not derivation.

### Specification

The subsections below state the normative rules. Cumulatively, they require the shared layer-2 model, a uniform transaction identifier format on the OAuth wire, a single transaction per request with the identifier preserved on the issued AT, and policy lookup by direct identifier match rather than derivation. The model is independent of how identity claims are attested.

The rules bind a trust framework that adopts this model; adoption itself is voluntary and per framework. They are written as conformance requirements so that adoption is testable, not because any framework is bound today. The Adoption section below sketches what adopting costs.

The rules come in two kinds. The model rules (the bullet list in the next subsection) bind the trust framework's registry content: how qualifications, prerequisites, and the matrix are expressed. The numbered requirements (REQ-1 through REQ-10, further down) bind runtime behaviour on the wire: what an AT request must contain, what an issued AT must carry, and what the AS must verify. The REQ identifiers exist because these rules are individually testable; implementations and test suites reference them by number.

#### Authorization information model

The normative model for layers 2 and 3 is the one shown in the Layer 2 and Layer 3 diagrams above. Implementations SHALL preserve the entity meanings as described in those subsections. Specifically:

- A ServiceProvider's Qualifications SHALL be expressed per system role.
- A HealthcareProfessional-to-HealthcareOrganization delegation SHALL be expressed per business role.
- A ServiceProvider delegation SHALL be expressed per system role.
- A RolePrerequisite SHALL resolve presented identity claims to an AuthorizationRole, which refines exactly one business role; a role MAY have several RolePrerequisites, and satisfying any one is sufficient.
- A SystemRolePrerequisite SHALL resolve a ServiceProvider's claims to a QualifiedSystemRole. A QualifiedSystemRole refines exactly one system role and covers one or more of the transactions that use that system role. Absent an explicit refinement, the QualifiedSystemRole SHALL default to the system role itself, covering all of that system role's transactions.
- Every trust framework SHALL publish a PermissionMatrix per use case, mapping (AuthorizationRole, Transaction) to allow or deny plus a delegatable flag. The matrix MAY be trivial (an explicit allow for every resolved AuthorizationRole), but SHALL NOT be absent; the absence of an entry SHALL be treated as deny.
- A trust framework MAY require a Membership claim (organisational admission to the framework or an information standard) for the HealthcareOrganization; prerequisites reference it like any other identity claim.
- An AccessTokenRequest SHALL be scoped to exactly one Transaction and MAY narrow to a subset of the operations that realise that transaction.
- An AccessToken SHALL authorize exactly one Transaction.

Trust frameworks MAY use additional concepts beyond these (framework-specific governance entities, for example), but SHALL NOT redefine the meaning of the concepts above.

#### Transaction scope token

Every AT request defines exactly one transaction scope token with the format:

```
<governance-body>.tx.<information-standard>.<transaction>.<version>
```

Examples:

```
aorta.tx.mp.verstrekkingsverzoek-raadplegen.3-0-0
aorta.tx.mp.medicatieafspraak-beschikbaarstellen.3-0-0
aorta.tx.mp.medicatieoverzicht-raadplegen.3-0-0
medmij.tx.medicatie.medicatieafspraak-raadplegen.1-0
```

Segment rules:

- `<governance-body>`: the body governing the namespace (`aorta`, `medmij`, `twiin`, `nuts`, ...).
- `tx`: literal marker, identifying the token as a transaction scope token.
- `<information-standard>`: the information-standard slug within the governance body (`mp` for Medicatieproces, `bgz`, `eoverdracht`, ...).
- `<transaction>`: kebab-case transaction identifier (e.g. `verstrekkingsverzoek-raadplegen`).
- `<version>`: hyphen-separated semantic version (`3-0-0`), or a single integer for major-only versioning (`3`). No `v` prefix, to match the operation token format below.

The use case the transaction belongs to is derivable from the catalogue and is not carried on the wire.

#### Operation token format

Operations are the fine-grained interactie-ids that MAY appear in the request scope alongside the transaction token, to narrow the scopes minted from it for least-privilege. Each must belong to the scoped transaction's realisation (the AS verifies this at mint time), and omitting them requests all of the transaction's operations. The general shape is `<verb>:<artifact>:<version>` (e.g. `search:mp-MedicationAgreement:1`); the exact format is information-standard-specific and registered in the realisation catalogue. The segment rules and the registered prefixes are listed in the [appendix](#appendix-operation-token-format-details).

#### Scope tokens are opaque identifiers

For the purpose of policy matching, both the transaction token and the operation tokens are treated as opaque strings: the AS looks them up in the trust framework's catalogue of registered transactions and operations, and matches against the policy by exact-string comparison. The format conventions are human-readable structure, not parsing requirements. Telling the two token kinds apart (REQ-1, REQ-3) needs only a shape check: the transaction token is dot-separated with a `tx` marker; operation tokens are colon-separated with a verb prefix.

#### Conformance: AT request

> **REQ-1 (SHALL).** An AT request SHALL contain exactly one transaction scope token.
>
> **REQ-2 (SHALL).** The AS SHALL reject the request if REQ-1 is violated (zero or more than one token).
>
> **REQ-3 (MAY).** The request scope MAY contain operation tokens (interactie-ids), each one belonging to the scoped transaction's realisation, to narrow the minted scopes for least-privilege.
>
> **REQ-4 (SHALL).** The AS SHALL reject any operation token that does not belong to the scoped transaction's realisation.

#### Conformance: issued AT

> **REQ-5 (SHALL).** The transaction scope token SHALL appear in the AT's `scope` alongside the minted SMART on FHIR scopes. The `scope` member is standard in both JWT access tokens and introspection responses, so the transaction identifier is visible to the resource server and the audit subsystem without any non-standard field.
>
> **REQ-6 (MAY).** The AT MAY additionally carry the transaction token as a dedicated `tx` claim, for consumers that prefer not to parse `scope`; when present, its value SHALL equal the token in `scope`.

#### Conformance: AS behaviour

> **REQ-7 (SHALL).** The AS SHALL select the applicable PermissionMatrix entry by direct match of the transaction and the resolved AuthorizationRole, not by derivation from other tokens or context.
>
> **REQ-8 (SHALL).** For the scoped transaction, the AS SHALL verify that:
>
> - the ServiceProvider's claims (its Qualification and the ServiceProvider delegation) resolve, via a SystemRolePrerequisite, to a QualifiedSystemRole whose coverage includes the scoped transaction;
> - the presented identity claims resolve, via a RolePrerequisite, to an AuthorizationRole that the PermissionMatrix permits for the transaction;
> - if the AuthorizationRole is exercised under mandate (defined as: the organisation acting unattended, or a user acting under the professional's responsibility), then (a) the PermissionMatrix entry SHALL be delegatable, and (b) a HealthcareProfessional-to-HealthcareOrganization delegation SHALL authorize the business role the AuthorizationRole refines;
> - the context gate passes (consent, treatment relationship, purpose-of-use, where required).
>
> **REQ-9 (SHALL).** The AS SHALL reject the request if the transaction is unknown, no PermissionMatrix entry permits the resolved AuthorizationRole, or any check in REQ-8 fails.

#### Identity claims, context, and verification

Identity claims are the typed assertions the AS resolves into roles. For the scoped transaction the set typically includes:

- The professional's identifier and rolcode, today issued under the UZI register (DEZI, its successor programme, keeps both concepts).
- The organisation's identifier (URA) and role type.
- The system role the transaction uses.
- The ServiceProvider's Qualification and the two delegation credentials in the chain.

In current Dutch implementations these claims appear in several forms, sometimes mixed within one request: signed claims in SAML tokens, Verifiable Credentials, JWT claims issued by a trusted Authorization Server, claims derived from an mTLS client certificate, or claims held in a registry the AS consults. The proposal works with any of these; it does not prescribe a wire format.

Which claims a request must carry follows from the prerequisites: exactly those the scoped transaction's RolePrerequisite and SystemRolePrerequisite read to resolve the AuthorizationRole and the QualifiedSystemRole. There is no separate required-claims list to maintain.

**Context gate.** Role resolution answers "who is the requester"; the context gate answers "is sharing this patient's data allowed". It evaluates ContextClaims about the request rather than the requester: the patient (BSN), the Enrollment (the treatment relationship), consent, and purpose-of-use. Purpose-of-use is the requester's declared purpose for the request; it is distinct from the legal basis (grondslag) that makes sharing lawful, although the declared purpose determines which legal basis must hold. The gate is attached to the use case because the claims it evaluates concern the intent, which all the use case's transactions share; attaching identical gates per transaction would only duplicate them. A trust framework MAY narrow the gate for an individual transaction, never loosen it. Because a transaction belongs to exactly one use case, the scoped transaction fixes which gate applies. The AS evaluates it alongside the PermissionMatrix (REQ-8).

> **REQ-10 (SHALL).** The client SHALL present the identity claims needed to resolve the AuthorizationRole and the QualifiedSystemRole for the scoped transaction, together with the ContextClaims the applicable context gate requires (the use case's gate, possibly narrowed for the scoped transaction). The AS SHALL verify role resolution, the matrix permission, and the context gate independently, and SHALL reject the request if any required claim is absent or any check fails.

### Adoption

The model claims no new governance body. Each construct already exists in every framework under a local name; adoption means publishing the existing artefact in the shared vocabulary:

| Existing artefact | Model construct |
|---|---|
| TKID (AORTA) | Qualification registry |
| Autorisatierichtlijn medicatieveiligheid (AORTA) | PermissionMatrix |
| AORTA-on-FHIR interactietabel | Realisation catalogue |
| Deelnemersovereenkomst (MedMij, Twiin), aansluitvoorwaarden (AORTA) | Membership |
| Mandaattoken (AORTA) | HCP-to-HCO delegation |
| DVA/DVP admission (MedMij) _(draft mapping, to be verified)_ | Qualification plus Membership |
{:.grid .table-hover}

The minimal first step is the transaction scope token format alone: it requires no registry changes beyond listing the tokens, is visible on the wire, and gives audit and cross-framework tooling a uniform identifier. The full layer-2 publication can follow per framework, per information standard.

Open issue: custodianship of the shared vocabulary (this chapter) once more than one framework adopts it. Candidates: Nictiz (owns layer 1), or the generieke functies programme. To be resolved with the trust framework architects.

### Evaluation flow

{% include authorization-model-evaluation.svg %}

Happy path. Any check failure results in rejection, not shown for clarity. The legend on the diagram marks each step's input sources: **R** for the AT request, **L1** for the layer-1 catalogue, **L2** for the trust framework registry (layer 2), **L3** for the realisation catalogue (the interactietabel). Steps that depend on derived context (e.g. "the required system role per operation") inherit their source from the step that resolved that context.

Because the AT is scoped to a single transaction, role resolution, the system-side coverage check, the matrix lookup, and the context gate are each evaluated once for that transaction; any operations in the request only narrow the minted scopes.

### Design notes

_This section is rationale, not specification: it argues the design decisions the model sections state._

#### Why the transaction is the scope unit

- The _transaction_ is the grain at which the PermissionMatrix decides: each cell maps `(AuthorizationRole, Transaction)` to allow or deny. Scoping the AT to one transaction aligns the wire with the decision: the AS reads the transaction, resolves the role, and looks up one cell.
- The prerequisites are per transaction: which conditions must hold (the role resolution, the system-side coverage, the delegation, the context check) are set by the transaction. Bundling several transactions into one AT would mean satisfying the union of their prerequisites, which is awkward to express and can even conflict.
- A _use case_ is too coarse for the AT scope: one AT would span many transactions with differing prerequisites, and an operation shared between them could not be attributed to a single cell. The use case is a catalogue grouping of transactions and the carrier of the context gate, not a key the matrix or the AT needs, and it does not appear on the wire.
- An _operation_ is too fine: it is a wire-level interactie-id used for least-privilege scope minting, below the grain at which permission is decided. It is also reusable across transactions, so an operation alone does not identify the intent.
- An AT covers one activity the requester performs (one transaction, e.g. `Raadplegen verstrekkingsverzoek`). A request that needs several transactions at once (a full medication overview for one patient) is served by an overview transaction such as Medicatieoverzicht, itself one transaction, or by issuing several ATs.

This makes the wire chattier, and that cost is accepted deliberately. A viewer that opens the full Medicatiebouwstenen use case touches seven raadplegen transactions and therefore needs seven token requests, each a round trip to the source-side AS (the AS is usually co-located with the RS). Three things bound the cost. The requests are independent, so they can be issued in parallel. The issued AT is cacheable per (transaction, patient) within its lifetime, so the volume is per viewer session, not per screen refresh. Batching several transactions into one AT was considered and rejected. The prerequisites and the context gate are per transaction. A bundled AT must either satisfy every bundled transaction's conditions at once, which fails entirely when one gate fails (and gates can conflict: consent may cover one data category but not another), or be evaluated loosely at bundle level. Loose evaluation erodes the per-transaction granularity of consent and audit; it is exactly the implicit-scope pattern this proposal removes. How many ATs one wire exchange may mint is a layer-3 profiling choice (a framework can adopt a batching or token-exchange profile without touching the model), as long as each issued AT stays scoped to one transaction.

#### Why consent, treatment relationship, and purpose are layer-2 constructs

The layer-2 constructs can be derived from the transaction dataset itself. A transaction carries a selection of dataset concepts, each optionally restricted: the concept holds a baseline conformance and cardinality, and the transaction may narrow them, never loosen. The kind of concept follows the transaction's direction. A query transaction (raadplegen) carries a `QueryParameters` group of identifiers and filters, project-specific. A delivery transaction (beschikbaarstellen, sturen) carries the zib payload; zibs enter as building-block datasets the payload concepts inherit from. That transaction dataset determines exactly what layer 2 can and cannot decide on. The bridge below maps the concepts of a query transaction onto the authorization constructs they touch.

{% include authorization-model-bridge.svg %}

- **The patient identifier (BSN) is the data-subject join key.** It appears in the query parameters as a layer-1 concept, and layer 2 joins on it: the AS enforces that the BSN in the query equals the `patient` scope of the access token, and the context claims (consent, treatment relationship) are about that same patient. Whether a patient is involved is itself a layer-1 fact: if the transaction dataset carries no patient identifier, there is no data-subject, the `patient` attribute on the access token is absent, and the patient-bound context claims do not apply.
- **Consent, treatment relationship, and purpose are absent from the dataset.** No dataset concept carries them. That confirms they are layer-2 constructs: ContextClaims evaluated by the trust framework, not data the transaction exchanges. The consent check is the source's responsibility, whether against a national facility (Mitz) or a local consent registration; it is not part of the requester-provided claim set, and the diagram marks it separately.

Everything else in the query stays in layer 1: record-narrowing identifiers (a behandeling-id, a record-id) map to no layer-2 claim, and payload actor concepts (a record's prescriber) relate to the requester's identity claims in type only, never in instance.

#### Enforcement topology and evidence

The model defines policy as facts and rules; this subsection works out where those rules can be enforced and how the evidence reaches the enforcer. Both are deployment choices of the trust framework, on two axes.

_Where._ The governing principle: a fact must surface as a wire claim exactly when the evaluating party cannot observe it directly. Each policy is enforced by the party that owns the duty, or by an intermediary acting for it. Three consequences:

- The source owns the decision to make data available (the beschikbaarstellen slice of the matrix). It enforces that itself, or a central intermediary enforces it on its behalf. The consumer is never the enforcer of source-side policy.
- The professional-to-organisation delegation is internal to the source: a source enforcing its own policy already knows its employment relations and mandates, and presents no credentials to itself. The mandate becomes a wire credential only under intermediary enforcement, when the intermediary cannot see inside the organisation.
- The ServiceProvider delegation is evaluated by the counterparty of the exchange, which can never observe that relationship directly. It therefore remains evidence in every topology, as a presented credential or a trusted registry entry. Where an organisation operates its own systems, the delegation degenerates into the organisation's own identity claim, but the evidence requirement stays.

_When._ Evidence can bind at three moments: at ecosystem registration (the enforcer verified the fact when the member joined), at decision time from a registry (the AS consults a store of member claims when issuing the token), or presented with the message itself. The same layer-2 facts feed all three; the binding time should match the volatility of the fact. Qualifications change rarely, so registration-time verification suffices. Delegations change more often. The treatment relationship and consent are per-patient and per-moment, so they bind at decision time.

The OAuth wire is asymmetric here: the request side has a claim-carrying convention (the AccessTokenRequest), the response side has none. A topology that wants a third party to verify source-side claims at response time therefore needs a wire convention that this proposal does not define. Verifying source-side claims at registration time or at token-issuance time avoids that gap, and fails before any data is assembled.

#### Delegation lifetimes: standing and session

Delegation has two lifetimes, and only one of them is a layer-2 credential. The _standing_ delegations (professional to organisation, organisation to service provider) change rarely and are governed by the matrix's `delegatable` flag and the qualification regime. The _session_ delegation, an authenticated user authorizing the system to act in their name for the duration of a session, is the authentication context itself; on the OAuth wire it is the grant behind the access token, not a credential the model adds. Attended means exactly that such a session delegation from an authenticated user exists; where it does not, a standing delegation must carry the role instead.

### Examples

_This section is non-normative._ Each example shows the request scope, the AS decision summary, and the token introspection response ([RFC 7662](https://datatracker.ietf.org/doc/html/rfc7662)) that the resource server or audit subsystem would receive for the issued AT. The introspection responses are illustrative and do not specify a wire format; specific identifier values are placeholders. Trust-anchored identity claims are shown abstractly; how they are proven is out of scope.

#### Worked example: a GP consults a patient's medication agreements

**Use case** Medicatiebouwstenen, **transaction** Raadplegen medicatieafspraak. The request scope is one transaction token plus, optionally, the operations that narrow the minted scopes:

```
aorta.tx.mp.medicatieafspraak-raadplegen.3-0-0
search:mp-MedicationAgreement:1
```

**Layer-2 registry for this transaction**

_System side, `SystemRolePrerequisite`._ The transaction's system role is `MedicatieafspraakRaadplegend`. Medicatieproces 9 cuts its system roles per transaction, so no refinement is needed: the qualification names the system role and thereby this one transaction. The check passes only when the request carries **both** a Qualification and a ServiceProvider delegation that name that system role:

| SystemRolePrerequisite              | for Raadplegen medicatieafspraak                |
| ----------------------------------- | ----------------------------------------------- |
| resolves                            | `MedicatieafspraakRaadplegend` (no refinement)  |
| requires Qualification              | naming `MedicatieafspraakRaadplegend`           |
| requires ServiceProvider delegation | naming `MedicatieafspraakRaadplegend`           |
{:.grid .table-hover}

_Professional side, `RolePrerequisite`._ An `AuthorizationRole` is a business role refined by a rolcode set, and the name carries the discriminator (e.g. `MedicatieRaadplegerArts`). Each row below is one filling: the rolcodes that resolve that role. All three refine the same business role `Medicatieraadpleger`, differing only in the rolcode set:

| AuthorizationRole                    | requires rolcode in                                                                                                |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------ |
| `MedicatieRaadplegerArts`            | 01.015 Huisarts and the other arts rolcodes (medisch specialisten, verpleegkundig specialisten, physician assistants, per the richtlijn) |
| `MedicatieRaadplegerApotheker`       | 17.000 Apotheker, 17.060 Ziekenhuisapotheker, 17.075 Openbaar apotheker                                            |
| `MedicatieRaadplegerVerpleegkundige` | 30.000 Verpleegkundige                                                                                             |
{:.grid .table-hover}

Under mandate (unattended, or a user without the rolcode working under the professional's responsibility), each row additionally requires a HCP-to-HCO delegation naming business role `Medicatieraadpleger`. A professional with the required rolcode asserts the role directly.

_`PermissionMatrix`_ (slice for this transaction), keyed on `(AuthorizationRole, Transaction)`:

| AuthorizationRole                    | Raadplegen medicatieafspraak | delegatable (mandaattoken) |
| ------------------------------------ | ---------------------------- | -------------------------- |
| `MedicatieRaadplegerArts`            | allow                        | yes                        |
| `MedicatieRaadplegerApotheker`       | allow                        | yes                        |
| `MedicatieRaadplegerVerpleegkundige` | deny                         | -                          |
{:.grid .table-hover}

The rolcode discriminator is what lets the matrix differ per rolcode set even within one business role: here a verpleegkundige is denied, and for the sibling transaction `Beschikbaarstellen medicatieafspraak` the Autorisatierichtlijn permits artsen but not apothekers.

_Context gate (on the use case)._ Medicatiebouwstenen requires, for this patient, an Enrollment (treatment relationship) and a Mitz consent that permits sharing medication data. ContextClaims: `patient` (BSN), `Enrollment`, `mitzConsent`.

**AS decision.** A huisarts requests it, authenticated and in the loop (attended). Role resolution: `rolcode=01.015` is in the `MedicatieRaadplegerArts` set, so the role resolves to `MedicatieRaadplegerArts`; no delegation is involved. System side: the Qualification and the ServiceProvider delegation both name `MedicatieafspraakRaadplegend`, so the QualifiedSystemRole resolves and covers the scoped transaction. Matrix: `(MedicatieRaadplegerArts, Raadplegen medicatieafspraak)` = allow, delegatable. Context gate: treatment relationship and Mitz consent pass. The AT is issued. Had the organisation's system made this request unattended (a background refresh, say), the role would only resolve with a HCP-to-HCO delegation naming `Medicatieraadpleger`, and only because the matrix cell says `delegatable = yes`.

**Issued AT (introspection).** The operation mints the SMART scope (`mp-MedicationAgreement` maps to FHIR `MedicationRequest`):

```json
{
  "active": true,
  "scope": "aorta.tx.mp.medicatieafspraak-raadplegen.3-0-0 patient/MedicationRequest.rs",
  "client_id": "...gp-ehr...",
  "sub": "uzi:00000123",
  "patient": "bsn:999999990",
  "token_type": "Bearer",
  "exp": 1760000000,
  "iat": 1759999100
}
```

#### Same dataset, different use case: a citizen via MedMij

The same medicatieafspraak fetched through a citizen's PGO is a **different transaction**, because the use case and its context gate differ: the citizen authenticates with DigiD, the role resolves to the patient rather than a professional, and there is no treatment-relationship gate. Only the operation (`search:...MedicationAgreement...`) is shared, illustrating that operations are reusable realisation blocks while transactions are use-case-bound.

```
medmij.tx.mp.medicatieafspraak-raadplegen.1-0
```

```json
{
  "active": true,
  "scope": "medmij.tx.mp.medicatieafspraak-raadplegen.1-0 patient/MedicationRequest.rs",
  "client_id": "...pgo-app...",
  "sub": "bsn:999999990",
  "patient": "bsn:999999990",
  "token_type": "Bearer",
  "exp": 1760000000,
  "iat": 1759999100
}
```

#### A write transaction: a voorschrijver sends a prescription

```
aorta.tx.mp.medicatievoorschrift-sturen.3-0-0
transaction:mp-MedicationPrescriptionProcessing-Bundle:1
```

Role resolution resolves `AuthorizationRole = VoorschrijverArts` (`rolcode=01.015`; the voorschrijver is the authenticated principal, so no delegation); the system side passes on system role `VoorschriftSturend` (Qualification and ServiceProvider delegation both naming it, no refinement involved); the matrix permits `(VoorschrijverArts, Sturen medicatievoorschrift)`; the bundle operation mints write scopes.

```json
{
  "active": true,
  "scope": "aorta.tx.mp.medicatievoorschrift-sturen.3-0-0 patient/MedicationRequest.cu",
  "client_id": "...gp-ehr...",
  "sub": "uzi:00000123",
  "patient": "bsn:999999990",
  "token_type": "Bearer",
  "exp": 1760000000,
  "iat": 1759999100
}
```

### Appendix: operation token format details

The operation token format adopts the `interactionId` shape of the [AORTA-on-FHIR interactietabel](https://aorta-on-fhir.public.vzvz.nl/aorta-on-fhir-specificaties/Working-version/aorta-interactietabel). Two shapes exist:

```
<verb>:<artifact>:<version>                       AORTA-internal style
<verb>:<artifact>:<version>:<request|response>    MedMij / PHR-facing style (PHR = Personal Health Record, the citizen-side PGO)
```

Examples (taken from the AORTA interactietabel for Medicatieproces 9):

```
search:mp-MedicationAgreement:1
search:mp-MedicationDispense:1
search:mp-AdministrationAgreement:1
search:mp-MedicationUse2:1
create:mp-MedicationAgreement:1
transaction:mp-MedicationPrescriptionProcessing-Bundle:1
search:MedicationStatement:1.0:request
```

Segment rules:

- `<verb>` is one of the FHIR interaction types from the closed set: `create`, `read`, `update`, `delete`, `search`, `batch`, `transaction`, `operation`. The verb determines the wire semantics: `transaction` is the FHIR transaction interaction (an atomic `Bundle` POST with `type=transaction`), unrelated to the Nictiz transaction of layer 1; `batch` is the looser-consistency sibling, `search` is FHIR search, and so on. Where this chapter means the verb, it writes "FHIR transaction interaction" in full.
- `<artifact>` identifies the target. It is either a bare FHIR resource type (PHR/MedMij interactions, e.g. `MedicationStatement`) or a profile name with a programme prefix. Prefixes seen in the AORTA interactietabel:
  - `zib-` for a Zorginformatiebouwsteen profile (`zib-MedicationAgreement`, `zib-LivingSituation`)
  - `mp-` for a Medicatieproces v9 artifact (`mp-MedicationDispense`, `mp-MedicationPrescriptionProcessing-Bundle`)
  - `mp612-` for a Medicatieproces v6.12 conversion artifact
  - `twiin-` for a Twiin infrastructure artifact (`twiin-TaskNotifiedPull`)
  - `aorta-` for an AORTA infrastructure artifact (`aorta-DataReference`)
  - The set is open-ended; new information standards may introduce their own prefix.
- `<version>` is the version of the interactie definition itself, not of the zib or FHIR resource. Bare integer for AORTA-internal style (`1`, `2`); dotted decimal for MedMij-facing style (`1.0`). This matches the version format of the transaction token (numeric, no `v` prefix).
- `<request|response>` (MedMij style only) marks the direction of the message in a paired exchange.

The exact shape of the operation token is information-standard-specific: each information standard registers its own artifact prefixes and version conventions. New information standards are encouraged to follow the `<verb>:<artifact>:<version>` shape above for cross-framework consistency, but the proposal does not mandate it.

### Glossary

Translation table for the layer-1 catalogue terms:

| English (this chapter) | Nictiz              |
| ---------------------- | ------------------- |
| Information standard   | informatiestandaard |
| Transaction group      | transactiegroep     |
| Transaction            | transactie          |
| Transaction dataset    | transactiedataset   |
| System role            | systeemrol          |
| Business role          | bedrijfsrol         |
| Qualification          | kwalificatie        |
{:.grid .table-hover}

- **AS**: Authorization Server, mints access tokens.
- **AT**: Access Token.
- **AccessTokenRequest**: the OAuth 2.0 request sent by the ServiceProvider to the AS, carrying the `tx` scope token, optional operations, asserted identity claims, and context claims.
- **AuthorizationRole**: the subject the PermissionMatrix keys on; one business role refined by a set of identity claims (typically rolcodes), resolved from presented claims by a RolePrerequisite.
- **Business role** (bedrijfsrol): the role a person plays in a transaction (Voorschrijver, Verstrekker, Toediener, ...). Unit of HealthcareProfessional-to-HealthcareOrganization delegation, and the role an AuthorizationRole refines.
- **Dataset**: a tree of dataset concepts; either a primary dataset of an information standard or an imported building-block dataset (such as a zib).
- **DatasetConcept**: one node of a dataset (a group or an item), carrying a baseline conformance and cardinality that a transaction may restrict.
- **DEZI**: the successor programme to the UZI register for identifying healthcare professionals; it keeps the identifier and rolcode concepts. This chapter uses UZI/rolcode terminology.
- **IdentityClaim**: a typed assertion about the requester that the policy evaluates. Carried in many wire formats (signed SAML claim, Verifiable Credential, JWT claim by a trusted AS, mTLS-derived claim, ...).
- **ContextClaim**: a typed assertion about the request context rather than the requester (patient, Enrollment, consent, purpose-of-use), evaluated by the use case's context gate.
- **Enrollment**: a ContextClaim for the patient's treatment relationship; the professional issues it to the organisation, attesting that they enrol or treat the patient.
- **Information standard** (informatiestandaard): a healthcare information standard (e.g. Medicatieproces, BgZ), in the Netherlands mostly maintained by Nictiz.
- **Legal basis** (grondslag): the legal ground that makes sharing lawful (consent, treatment relationship, statutory duty). Distinct from purpose-of-use.
- **Membership**: the claim by which a HealthcareOrganization asserts admission to a trust framework or an information standard within it; the organisational counterpart of the Qualification (deelnemersovereenkomst, aansluitvoorwaarden).
- **Operation**: a single wire-level interaction (`<verb>:<artifact>:<version>`), the interactionId of the AORTA-on-FHIR interactietabel. A layer-3 realisation construct, reusable across transactions; not a layer-1 concept.
- **PDP**: Policy Decision Point, see [Authorization](authorization.html).
- **PermissionMatrix**: a layer 2 entity, per use case, mapping (AuthorizationRole, Transaction) to allow or deny plus a delegatable flag. Always present; may be trivial (explicit allow-all); an absent entry is deny. The AORTA realisation for medication is the _Autorisatierichtlijn medicatieveiligheid_.
- **Purpose-of-use**: the requester's declared purpose for a request (treatment, emergency, ...), a ContextClaim. Distinct from the legal basis; the declared purpose determines which legal basis must hold.
- **Qualification** (kwalificatie): the claim by which a ServiceProvider asserts that its product passed qualification for a given system role. The qualification itself is the upstream certification process.
- **QualifiedSystemRole**: a layer 2 refinement of exactly one system role by transaction coverage, answering "which of the transactions using this system role does this qualification grant". Defaults to the system role itself, covering all its transactions. Resolved by a SystemRolePrerequisite.
- **RolePrerequisite**: a layer 2 rule that resolves a set of identity claims to an AuthorizationRole; a role may have several, and satisfying any one is enough.
- **RS**: Resource Server, enforces SMART on FHIR scopes on FHIR endpoints.
- **SoF scope**: SMART on FHIR v2 scope, e.g. `patient/MedicationRequest.s`.
- **System role** (systeemrol): the role a system plays in a transaction (Sturend, Ontvangend, Raadplegend, Beschikbaarstellend). Unit of qualification and of ServiceProvider delegation.
- **SystemRolePrerequisite**: a layer 2 rule that resolves a ServiceProvider's claims (notably its Qualification and delegation) to a QualifiedSystemRole; the system-side analogue of a RolePrerequisite, with no matrix.
- **Transaction** (transactie): a single interaction within a transaction group, e.g. `Raadplegen verstrekkingsverzoek` (the consumer queries a source) or `Beschikbaarstellen verstrekkingsverzoeken` (the source returns the requested data). The leaf functional unit of layer 1 and the unit the PermissionMatrix authorizes against; belongs to exactly one use case. Not to be confused with the FHIR transaction interaction (an atomic `Bundle` POST), which appears as a verb in operation tokens.
- **Transaction group** (transactiegroep): a named group of related transactions, e.g. `Verstrekkingsverzoek (raadplegen/beschikbaarstellen)`.
- **Transaction dataset** (transactiedataset): the subset of dataset concepts a transaction selects, each optionally restricted (conformance, cardinality, condition) relative to its baseline.
- **Trust framework**: an independently governed set of agreements for data exchange (afsprakenstelsel).
- **Use case**: a sub-chapter of an information standard. A catalogue grouping of transaction groups; defines the intent and the context gate; not carried on the wire.
- **Zib**: _zorginformatiebouwsteen_, a Dutch healthcare data model construct, published as a building-block dataset.

### References

**Nictiz**

- [Nictiz Handleiding Wiki documentatie](https://informatiestandaarden.nictiz.nl/wiki/Handleiding_Wiki_documentatie)
- [ART-DECOR Medicatieproces scenarios](https://decor.nictiz.nl/pub/medicatieproces/)
- [ART-DECOR object model documentation](https://docs.art-decor.org/)

**AORTA (VZVZ)**

- [AORTA-on-FHIR specificaties](https://aorta-on-fhir.public.vzvz.nl/aorta-on-fhir-specificaties/)
- [AORTA-on-FHIR Interactietabel (Working version)](https://aorta-on-fhir.public.vzvz.nl/aorta-on-fhir-specificaties/Working-version/aorta-interactietabel)
- [AORTA-on-FHIR Interfaces, common (v20250723)](https://aorta-on-fhir.public.vzvz.nl/aorta-on-fhir-specificaties/v20250723/interfaces-common)
- [AORTA-on-FHIR Interfaces, autorisatie-server MedMij (v20250328)](https://aorta-on-fhir.public.vzvz.nl/aorta-on-fhir-specificaties/v20250328/interfaces-autorisatie-server-medmij)
- [Autorisatierichtlijn medicatieveiligheid (AORTA-LSP)](https://www.aorta-lsp.nl/over-aorta-lsp/autorisatierichtlijnen/autorisatierichtlijn-medicatieveiligheid)

**MedMij**

- [MedMij afsprakenstelsel](https://afsprakenstelsel.medmij.nl/)

**Twiin**

- [Twiin afsprakenstelsel](https://twiin.nl/)

**Standards and conventions**

- [SMART on FHIR v2 scopes and launch context](https://www.hl7.org/fhir/smart-app-launch/scopes-and-launch-context.html)
- [RFC 6749 - The OAuth 2.0 Authorization Framework](https://datatracker.ietf.org/doc/html/rfc6749)
- [RFC 7662 - OAuth 2.0 Token Introspection](https://datatracker.ietf.org/doc/html/rfc7662)
- [RFC 2119 - Key words for use in RFCs to Indicate Requirement Levels](https://datatracker.ietf.org/doc/html/rfc2119)
