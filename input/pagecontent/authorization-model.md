<!--
SPDX-FileCopyrightText: 2026 Steven van der Vegt

SPDX-License-Identifier: CC-BY-SA-4.0
-->

### Introduction

Dutch healthcare data exchange runs under several authorization regimes (AORTA-on-FHIR, MedMij, Twiin, Nuts use-case communities). Each one has, over time, built its own internal authorization model: its own vocabulary for qualifications, its own delegation structures, its own scope-token grammar, its own way of pairing identity claims with policy. The models overlap conceptually, but never align. Cross-framework integration is therefore expensive and brittle.

This chapter proposes a shared *authorization information model* and derives one concrete OAuth 2.0 wire convention from it. The model is layered: a layer 1 that adopts the Nictiz "Handleiding Wiki documentatie" structure verbatim, and a layer 2 that adds the authz-specific concepts that the Nictiz model does not address (qualifications, delegations, identity claims, the access token itself).

The intended audience is architects of the trust frameworks listed above. The proposal is independent of how identity claims are attested. In current Dutch implementations identity claims appear in several forms, sometimes mixed within one request: signed claims in SAML tokens, Verifiable Credentials, JWT claims issued by a trusted Authorization Server, and claims derived from an mTLS client certificate. The proposal works with any of these; it does not prescribe a wire format.

### Background

#### Layered model

Three layers are involved in defining how authorization works for Dutch healthcare data exchange:

- **Layer 1, Information Standards (Nictiz)** defines *what* transactions exist. Owned by Nictiz via the [Handleiding Wiki documentatie](https://informatiestandaarden.nictiz.nl/wiki/Handleiding_Wiki_documentatie). Catalogues informatiestandaarden, use cases, transactiegroepen, transacties, systeemrollen, bedrijfsrollen, and the zibs they operate on. The same for all trust frameworks.
- **Layer 2, Trust Framework** specifies *who* may perform *which* transactions, and under what conditions. Owned by the trust frameworks (VZVZ, MedMij, Twiin, Nuts working groups) and by this IG. Adds the governance constructs that gate access: authentication profiles, authorization policies, qualifications, the delegation chain, identity claims, and the actor model.
- **Layer 3, OAuth wire** specifies *how* a single authorization decision surfaces in an OAuth 2.0 exchange. The access-token request, the issued access token, and the minted SMART on FHIR scopes that the resource server enforces.

This chapter proposes a uniform model for layers 2 and 3. Layer 1 is taken as given.

#### Layer 1: Information Standards (Nictiz)

{% include authorization-model-nictiz.svg %}

Hierarchy from outer to inner:

- **Informatiestandaard**: top container (e.g. Medicatieproces 9). Owned by Nictiz.
- **Use case**: a sub-chapter of an informatiestandaard, equal to a "scenario" in ART-DECOR. Coarse business framing.
- **Transactiegroep**: a named group of related transacties, e.g. `Verstrekkingsverzoek (raadplegen/beschikbaarstellen)`, bundling the `Raadplegen verstrekkingsverzoek` and `Beschikbaarstellen verstrekkingsverzoek` transacties.
- **Transactie**: a single interaction within a transactiegroep, e.g. `Raadplegen verstrekkingsverzoek` (consult or request from a source) or `Beschikbaarstellen verstrekkingsverzoek` (publish, for instance to an index). FHIR or CDA profiles attach at this level.
- **Operation** (interactie-id on the wire): a single wire-level operation within a transactie, identified as `<verb>:<artifact>:<version>` (e.g. `search:zib-MedicationAgreement:2`). One transactie has one or more operations; an artifact is a Zib or a FHIR Bundle profile.
- **Systeemrol**: the role a system plays in a transactie. Four kinds: Sturend, Ontvangend, Raadplegend, Beschikbaarstellend. Unit of qualification.
- **Bedrijfsrol**: the role a person plays in a transactie (Voorschrijver, Verstrekker, ...). Cross-cutting actor type.

The **use case is the unit of authorization** in this proposal. A single user-facing data request often needs operations from more than one transactiegroep within the same use case. For example, the *Medicatiebouwstenen* use case in Medicatieproces 9 contains `Medicatiegebruik (raadplegen/beschikbaarstellen)` and `Medicatietoediening (raadplegen/beschikbaarstellen)` among others; a "show me everything about this patient's medication" view needs operations from both. Scoping the AT at the use-case level reflects that. The transactiegroep remains the unit of conformity (qualification, policy granularity per direction), but is not surfaced on the OAuth wire.

#### Layer 2: Trust Framework

Layer 2 is where the trust framework adds the constructs that gate access on top of the Nictiz catalogue. It is presented in two views: first the general mechanism that turns presented claims into an access decision, then the concrete actors and credentials that supply those claims in the Dutch context. In both diagrams, Nictiz catalogue entities are shown in yellow (referenced from layer 1, not redefined here), trust-framework policy and actors in pale blue, and identity claims and credentials in mid-blue.

**Role resolution and permission.**

{% include authorization-model-role-resolution.svg %}

Authorization is decided in two decoupled steps. First, *role resolution*: a `RolePrerequisite` resolves the identity claims a requester presents to an `AuthorizationRole`, which is one Nictiz `Bedrijfsrol` refined by a set of claims (typically rolcodes). A role may have several RolePrerequisites and satisfying any one is enough, so a new credential route can be added without touching the permission rules; this also subsumes the presence check (the required claim types are exactly what the prerequisites read). Second, *permission*: the `PermissionMatrix` keys on the `AuthorizationRole` and the `Transactie` and yields allow or deny plus a `delegatable` flag. The AORTA realisation of the matrix is the *Autorisatierichtlijn medicatieveiligheid*, a table mapping (rolcode, transactie) to ja/nee.

The system side mirrors the first step but needs no matrix: a `SysteemrolPrerequisite` resolves the product's claims (its qualification) directly to a `Systeemrol`. Because Nictiz defines a fine-grained systeemrol per transactie endpoint, being qualified for the systeemrol already is per-transactie permission; the matrix is only needed on the professional side, where the bedrijfsrol is coarse.

**Actors and credentials.**

Role resolution treats the claims abstractly. This view fills that in for the Dutch context: who the actors are, the credentials carrying the identity claims that role resolution consumes, and the context claims (such as the Enrollment) the actors produce for the context gate.

{% include authorization-model-layer2.svg %}

- **HealthcareProfessional, HealthcareOrganization, ServiceProvider**: the three professional-side actor layers. The professional is employed by an organisation; the organisation is served by a service provider.
- **Patient**: the data subject. In professional flows the patient is referenced via their BSN as the data-scope of the access token; the request principal is the ServiceProvider acting for the HealthcareProfessional and HealthcareOrganization. In *patient-channel (PHR) flows* the patient becomes the asserting principal: they authenticate via DigiD with their PGO, and the PGO operator (a ServiceProvider qualified as a Dienstverlener Persoon under MedMij) makes the access-token request on their behalf. In both flows the `patient` attribute on the AccessTokenRequest carries the data-subject BSN; in PHR flows that BSN coincides with the authenticating principal's BSN.
- **IdentityClaim** (abstract): a typed assertion about the requester. Generalises rolcode, organisation identifiers, the systeemrol or bedrijfsrol assertion, the Qualification and the two delegations. Each trust framework defines its own vocabulary.
- **Qualification**: certifies that a vendor product (used by a service provider) may act in a given systeemrol. AORTA term: kwalificatie, recorded in TKID; MedMij splits it into DVA (provider-side) and DVP (PGO-side).
- **HealthcareProfessional-to-HealthcareOrganization delegation**: the credential by which a professional delegates a set of bedrijfsrollen to their organisation. It is the *mandaattoken* behind the matrix's `delegatable` flag.
- **ServiceProvider delegation**: the credential by which an organisation delegates a set of systeemrollen to its service provider.
- **ContextClaim** (abstract) and **Enrollment**: assertions about the request and the patient, not the requester. `Enrollment` is the treatment relationship: the professional issues it to the organisation, attesting that they enrol or treat the patient. It feeds the use-case context gate, not role resolution.

The delegation chain runs at two layers: the professional-to-organisation delegation at bedrijfsrol level, the service-provider delegation at systeemrol level. Each step delegates only what it can express; a professional is not a system, so cannot delegate a systeemrol. The identity claims feed role resolution and the matrix above; the context claims, such as the Enrollment, feed the use-case context gate.

#### Layer 3: OAuth wire artefacts

{% include authorization-model-layer3.svg %}

Layer 1 entities (`Transactie`, `Operation`, `FHIRResource`) appear in yellow; layer 2 entities (`IdentityClaim`, `ServiceProvider`) appear in blue. Layer-3 entities are shown in green.

- **AccessTokenRequest**: what the ServiceProvider sends to the AS. Carries one transactie scope token (the `tx`), an optional list of operations (interactie-ids) that narrow the minted scopes, the asserted identity claims, and the context claims.
- **AccessToken**: the OAuth 2.0 artefact returned on success. Authorizes exactly one transactie, carries the verified identity claims, and carries the minted SMART on FHIR scopes.
- **SoFScope**: a [SMART on FHIR v2](https://www.hl7.org/fhir/smart-app-launch/scopes-and-launch-context.html) scope (`<context>/<Resource>.<crud>`). The unit of resource-server enforcement, minted at issue time from the requested operations via the Zib and FHIRResource chain.

Note the asymmetry between request and response: the **request carries the transactie token** (optionally narrowed by interactie-ids), the **response carries the transactie token plus the minted SMART on FHIR scopes**. The AS converts requested operations into scopes at mint time.

An AT is scoped to one transactie, which uses one systeemrol; the AS verifies that systeemrol is qualified and delegated. Operations in the request only narrow the minted scopes.

#### Why the transactie is the scope unit

- The *transactie* is the grain at which the PermissionMatrix decides: each cell maps `(AuthorizationRole, Transactie)` to allow or deny. Scoping the AT to one transactie aligns the wire with the decision, the AS reads the transactie, resolves the role, and looks up one cell.
- The prerequisites are per transactie: which conditions must hold (the role resolution, the systeemrol qualification, the delegation, the context check) are set by the transactie. Bundling several transacties into one AT would mean satisfying the union of their prerequisites, which is awkward to express and can even conflict.
- A *use case* is therefore too coarse for the AT scope: one AT would span many transacties with differing prerequisites, and an operation shared between them could not be attributed to a single cell. The use case is only a catalogue grouping of transacties, not a key the matrix or the AT needs, and it does not appear on the wire.
- An *operation* is too fine: it is a wire-level interactie-id used for least-privilege scope minting, below the grain at which permission is decided.
- An AT covers one activity the requester performs (one transactie, e.g. `raadplegen verstrekkingsverzoek`). A request that needs several transacties at once (a full medication overview for one patient) is served by an overview transactie such as Medicatieoverzicht, itself one transactie, or by issuing several ATs.

### Problem

Each trust framework today carries its own authorization model. The models overlap conceptually but never align, which makes cross-framework integration disproportionately expensive. The same patterns appear in different vocabularies at different layers:

- **Qualification**: TKID in AORTA, DVA/DVP in MedMij, similar mechanisms in Twiin. All express "this product may act in this technical role", but with different names, registries, and APIs.
- **Delegation chain**: AORTA, MedMij, and Twiin each construct delegation chains between professionals, organisations, and service providers differently. The chain shape is usually similar; the credentials and granularities are not.
- **Scope on the OAuth wire**: each framework has a different convention for how the authorized work is identified in a request and on the issued token.

| Trust framework | What identifies the authorized work in the request scope | Survives onto issued AT? |
|---|---|---|
| AORTA professional (read) | implicit, derived from `(aorta.systeemrol.X, aorta.contextcode.Y)` | absent |
| AORTA professional (write) | partially explicit, via `transaction:mp-X-Bundle:V` | partially preserved |
| MedMij | explicit, tilde-attached `~medmij.gegevensdienst.<n>` | preserved |
| Twiin | explicit, `twiin.gegevensdienst.<id>` | preserved |
| Nuts use-case communities | varies per working group | varies |
{:.grid .table-hover}

Concrete consequences:

1. **Implicit identification (AORTA read)**: the AS reconstructs intent from a pair of scope tokens. This is fragile to catalogue evolution and pushes semantic work into the AS.
2. **Asymmetric AT contents**: MedMij carries the identifier on the issued AT, AORTA professional does not. Resource servers cannot uniformly audit by use case.
3. **Inconsistent grammar across the wire**: verb-style, tilde-attached, category-style. Three vocabularies for the same semantic concept.
4. **Composability is undefined**: what does a request with five interactie-ids mean? All required, any acceptable, an intersection? Each AS invents an answer.
5. **Cross-framework reasoning is hard**: a developer writing a system that participates in two frameworks needs to learn two complete models and the unstated mapping between them.

### Specification

The Problem section above sets out what the convention has to address. The subsections below state the normative rules. Cumulatively, they require a shared layer-2 model, a uniform transactie identifier format on the OAuth wire, a single transactie per request with the identifier preserved on the issued AT, and policy lookup by direct identifier match rather than derivation. The model is independent of how identity claims are attested.

#### Authorization information model

The normative model for layers 2 and 3 is the one shown in the Layer 2 and Layer 3 diagrams above. Implementations SHALL preserve the entity meanings as described in those subsections. Specifically:

- A ServiceProvider's Qualifications SHALL be expressed per systeemrol.
- A HealthcareProfessional-to-HealthcareOrganization delegation SHALL be expressed per bedrijfsrol.
- A ServiceProvider delegation SHALL be expressed per systeemrol.
- A RolePrerequisite SHALL resolve presented identity claims to an AuthorizationRole, which refines exactly one Bedrijfsrol; a role MAY have several RolePrerequisites, and satisfying any one is sufficient.
- A SysteemrolPrerequisite SHALL resolve a ServiceProvider's claims to a Systeemrol.
- The PermissionMatrix SHALL map (AuthorizationRole, Transactie) to allow or deny plus a delegatable flag.
- An AccessTokenRequest SHALL be scoped to exactly one Transactie and MAY narrow to a subset of that transactie's operations.
- An AccessToken SHALL authorize exactly one Transactie.

Trust frameworks MAY use additional concepts beyond these (framework-specific governance entities, for example), but SHALL NOT redefine the meaning of the concepts above.

#### Transactie scope token

Every AT request defines exactly one transactie scope token with the format:

```
<governance-body>.tx.<information-standard>.<transactie>.<version>
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
- `tx`: literal marker, identifying the token as a transactie scope token.
- `<information-standard>`: the informatiestandaard slug within the governance body (`mp` for Medicatieproces, `bgz`, `eoverdracht`, ...).
- `<transactie>`: kebab-case transactie identifier (e.g. `verstrekkingsverzoek-raadplegen`).
- `<version>`: hyphen-separated semantic version (`3-0-0`), or a single integer for major-only versioning (`3`). No `v` prefix, to match the operation token format below.

The use case the transactie belongs to is derivable from the catalogue and is not carried on the wire.

#### Operation token format

Operations are the fine-grained interactie-ids that MAY appear in the request scope alongside the transactie token, to narrow the scopes minted from it for least-privilege; each must belong to the scoped transactie, and omitting them requests all of the transactie's operations. The format is defined by the [AORTA-on-FHIR interactietabel](https://aorta-on-fhir.public.vzvz.nl/aorta-on-fhir-specificaties/Working-version/aorta-interactietabel). Two shapes exist:

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

- `<verb>` is one of the FHIR interaction types from the closed set: `create`, `read`, `update`, `delete`, `search`, `batch`, `transaction`, `operation`. The verb determines the wire semantics: `transaction` is a FHIR `Bundle` POST with `type=transaction`, `batch` is the looser-consistency sibling, `search` is FHIR search, and so on.
- `<artifact>` identifies the target. It is either a bare FHIR resource type (PHR/MedMij interactions, e.g. `MedicationStatement`) or a profile name with a programme prefix. Prefixes seen in the AORTA interactietabel:
  - `zib-` for a Zorginformatiebouwsteen profile (`zib-MedicationAgreement`, `zib-LivingSituation`)
  - `mp-` for a Medicatieproces v9 artifact (`mp-MedicationDispense`, `mp-MedicationPrescriptionProcessing-Bundle`)
  - `mp612-` for a Medicatieproces v6.12 conversion artifact
  - `twiin-` for a Twiin infrastructure artifact (`twiin-TaskNotifiedPull`)
  - `aorta-` for an AORTA infrastructure artifact (`aorta-DataReference`)
  - The set is open-ended; new informatiestandaarden may introduce their own prefix.
- `<version>` is the version of the interactie definition itself, not of the zib or FHIR resource. Bare integer for AORTA-internal style (`1`, `2`); dotted decimal for MedMij-facing style (`1.0`). This matches the version format of the use-case token (numeric, no `v` prefix).
- `<request|response>` (MedMij style only) marks the direction of the message in a paired exchange.

Each operation in a request scope must belong to the scoped transactie. The AS verifies this at mint time.

The exact shape of the operation token is information-standard-specific: each informatiestandaard registers its own artifact prefixes and version conventions. New information standards are encouraged to follow the `<verb>:<artifact>:<version>` shape above for cross-framework consistency, but the proposal does not mandate it.

#### Scope tokens are opaque identifiers

For the purpose of policy matching, both the use-case token and the operation tokens are treated as opaque strings: the AS looks them up in the trust framework's catalogue of registered use cases and operations, and matches against the policy by exact-string comparison. The format conventions above are human-readable structure, not parsing requirements.

The two formats are deliberately distinguishable at a glance (the use-case token uses dot-separation with an explicit `uc` marker; operation tokens use colon-separation with a verb prefix). An AS implementation needs to identify which tokens in a request scope are which (per REQ-1 and REQ-3), but a simple shape check is sufficient; no internal-format parsing is required for policy evaluation.

#### Conformance: AT request

> **REQ-1 (SHALL).** An AT request SHALL contain exactly one transactie scope token.
>
> **REQ-2 (SHALL).** The AS SHALL reject the request if REQ-1 is violated (zero or more than one token).
>
> **REQ-3 (MAY).** The request scope MAY contain operation tokens (interactie-ids), each one belonging to the scoped transactie, to narrow the minted scopes for least-privilege.
>
> **REQ-4 (SHALL).** The AS SHALL reject any operation token that does not belong to the scoped transactie.

#### Conformance: issued AT

> **REQ-5 (SHALL).** The issued AT SHALL carry the transactie identifier as a `tx` claim, whose value equals the request's transactie scope token.
>
> **REQ-6 (SHALL).** The transactie scope token SHALL also appear in the AT's `scope` claim alongside the minted SMART on FHIR scopes.

#### Conformance: AS behaviour

> **REQ-7 (SHALL).** The AS SHALL select the applicable PermissionMatrix entry by direct match of the transactie and the resolved AuthorizationRole, not by derivation from other tokens or context.
>
> **REQ-8 (SHALL).** For the scoped transactie, the AS SHALL verify that:
>
> - the transactie's systeemrol is qualified for the ServiceProvider (via a SysteemrolPrerequisite) and authorized by the ServiceProvider delegation;
> - the presented identity claims resolve, via a RolePrerequisite, to an AuthorizationRole that the PermissionMatrix permits for the transactie;
> - the HealthcareProfessional-to-HealthcareOrganization delegation authorizes the Bedrijfsrol that the AuthorizationRole refines;
> - the context gate passes (Mitz consent, treatment relationship, purpose-of-use, where required).
>
> **REQ-9 (SHALL).** The AS SHALL reject the request if the transactie is unknown, no PermissionMatrix entry permits the resolved AuthorizationRole, or any check in REQ-8 fails.

#### Identity claims, context, and verification

Identity claims are the typed assertions the AS resolves into roles. For the scoped transactie the set typically includes:

- The professional's identifier (UZI) and rolcode (the DEZI-role).
- The organisation's identifier (URA) and role type.
- The systeemrol the transactie uses.
- The ServiceProvider's Qualification and the two delegation credentials in the chain.

In current Dutch implementations these claims appear in several forms, sometimes mixed within one request: signed claims in SAML tokens, Verifiable Credentials, JWT claims issued by a trusted Authorization Server, or claims derived from an mTLS client certificate. The proposal works with any of these; it does not prescribe a wire format.

There is no separate presence profile. The claims a request must carry are exactly those the transactie's RolePrerequisite and SysteemrolPrerequisite read to resolve the AuthorizationRole and the Systeemrol. Adding a credential route means adding a prerequisite, not editing a list.

**Context gate.** Role resolution answers "who is the requester"; the context gate answers "is sharing this patient's data allowed". It evaluates ContextClaims about the request rather than the requester, typically the patient (BSN), the Enrollment (the patient's treatment relationship, issued by the professional to the organisation), Mitz consent, and purpose-of-use. The gate belongs to the use case, which carries the intent; because a transactie belongs to exactly one use case, the scoped transactie fixes which context gate applies. The AS evaluates it alongside the PermissionMatrix (REQ-8).

> **REQ-10 (SHALL).** The client SHALL present the identity claims needed to resolve the AuthorizationRole and the Systeemrol for the scoped transactie, together with the ContextClaims the use case's context gate requires. The AS SHALL verify role resolution, the matrix permission, and the context gate independently, and SHALL reject the request if any required claim is absent or any check fails.

### Evaluation flow

{% include authorization-model-evaluation.svg %}

Happy path. Any check failure results in rejection, not shown for clarity. The legend on the diagram marks each step's input sources: **R** for the AT request, **L1** for the Nictiz catalogue (layer 1), **L2** for the trust framework registry (layer 2). Steps that depend on derived context (e.g. "the required systeemrol per operation") inherit their source from the step that resolved that context.

Because the AT is scoped to a single transactie, role resolution, the systeemrol qualification and delegation check, the matrix lookup, and the context gate are each evaluated once for that transactie; any operations in the request only narrow the minted scopes.

### Examples

*This section is non-normative.* Each example shows the request scope, the AS decision summary, and the token introspection response ([RFC 7662](https://datatracker.ietf.org/doc/html/rfc7662)) that the resource server or audit subsystem would receive for the issued AT. The introspection responses are illustrative and do not specify a wire format; specific identifier values are placeholders. Trust-anchored identity claims are shown abstractly; how they are proven is out of scope.

#### Worked example: a GP consults a patient's medication agreements

**Use case** Medicatiebouwstenen, **transactie** Raadplegen medicatieafspraak. The request scope is one transactie token plus, optionally, the operations that narrow the minted scopes:

```
aorta.tx.mp.medicatieafspraak-raadplegen.3-0-0
search:mp-MedicationAgreement:1
```

**Layer-2 registry for this transactie**

*System side, `SysteemrolPrerequisite`.* The transactie's systeemrol is `MedicatieafspraakRaadplegend`. It is filled only when the request carries **both** a Qualification and a ServiceProvider delegation that name that systeemrol:

| resolves Systeemrol | requires Qualification (value) | and ServiceProvider delegation (value) |
|---|---|---|
| `MedicatieafspraakRaadplegend` | `systeemrol = MedicatieafspraakRaadplegend` | `systeemrol = MedicatieafspraakRaadplegend` |
{:.grid .table-hover}

*Professional side, `RolePrerequisite`.* An `AuthorizationRole` is a `Bedrijfsrol` refined by a rolcode set, and the name carries the discriminator (e.g. `MedicatieRaadplegerArts`). Each row below is one filling: the claims that must be present to resolve that role. All three refine the same bedrijfsrol `Medicatieraadpleger`, differing only in the rolcode set:

| resolves AuthorizationRole | requires rolcode in | and HCP-to-HCO delegation (value) |
|---|---|---|
| `MedicatieRaadplegerArts` | `{ 01.015 Huisarts, ... (artsen, MS'en, VS'en, PA's per richtlijn) }` | `bedrijfsrol = Medicatieraadpleger` |
| `MedicatieRaadplegerApotheker` | `{ 17.000 Apotheker, 17.060 Ziekenhuisapotheker, 17.075 Openbaar apotheker }` | `bedrijfsrol = Medicatieraadpleger` |
| `MedicatieRaadplegerVerpleegkundige` | `{ 30.000 Verpleegkundige }` | `bedrijfsrol = Medicatieraadpleger` |
{:.grid .table-hover}

*`PermissionMatrix`* (slice for this transactie), keyed on `(AuthorizationRole, Transactie)`:

| AuthorizationRole | Raadplegen medicatieafspraak | delegatable (mandaattoken) |
|---|---|---|
| `MedicatieRaadplegerArts` | allow | ja |
| `MedicatieRaadplegerApotheker` | allow | ja |
| `MedicatieRaadplegerVerpleegkundige` | deny | - |
{:.grid .table-hover}

The rolcode discriminator is what lets the matrix differ per rolcode set even within one bedrijfsrol: here a verpleegkundige is denied, and for the sibling transactie `beschikbaarstellen medicatieafspraak` the Autorisatierichtlijn permits artsen but not apothekers.

*Context gate (on the use case).* Medicatiebouwstenen requires, for this patient, an Enrollment (treatment relationship) and a Mitz consent that permits sharing medication data. ContextClaims: `patient` (BSN), `Enrollment`, `mitzConsent`.

**AS decision.** A huisarts requests it. Role resolution: `rolcode=01.015` is in the `MedicatieRaadplegerArts` set and the HCP-to-HCO delegation names `Medicatieraadpleger`, so the role resolves to `MedicatieRaadplegerArts`. System side: the Qualification and the ServiceProvider delegation both name `MedicatieafspraakRaadplegend`, so the systeemrol resolves. Matrix: `(MedicatieRaadplegerArts, Raadplegen medicatieafspraak)` = allow, delegatable. Context gate: treatment relationship and Mitz consent pass. The AT is issued.

**Issued AT (introspection).** The operation mints the SMART scope (`mp-MedicationAgreement` maps to FHIR `MedicationRequest`):

```json
{
  "active": true,
  "tx": "aorta.tx.mp.medicatieafspraak-raadplegen.3-0-0",
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

The same medicatieafspraak fetched through a citizen's PGO is a **different transactie**, because the use case and its context gate differ: the citizen authenticates with DigiD, the role resolves to the patient rather than a professional, and there is no treatment-relationship gate. Only the operation (`search:...MedicationAgreement...`) is shared.

```
medmij.tx.mp.medicatieafspraak-raadplegen.1-0
```
```json
{
  "active": true,
  "tx": "medmij.tx.mp.medicatieafspraak-raadplegen.1-0",
  "scope": "medmij.tx.mp.medicatieafspraak-raadplegen.1-0 patient/MedicationRequest.rs",
  "client_id": "...pgo-app...",
  "sub": "bsn:999999990",
  "patient": "bsn:999999990",
  "token_type": "Bearer",
  "exp": 1760000000,
  "iat": 1759999100
}
```

#### A write transactie: a voorschrijver sends a prescription

```
aorta.tx.mp.medicatievoorschrift-sturen.3-0-0
transaction:mp-MedicationPrescriptionProcessing-Bundle:1
```

Role resolution resolves `AuthorizationRole = VoorschrijverArts` (`rolcode=01.015` plus the HCP-to-HCO delegation for bedrijfsrol `Voorschrijver`); the systeemrol is `VoorschriftSturend` (Qualification and ServiceProvider delegation both naming it); the matrix permits `(VoorschrijverArts, Sturen medicatievoorschrift)`; the bundle operation mints write scopes.

```json
{
  "active": true,
  "tx": "aorta.tx.mp.medicatievoorschrift-sturen.3-0-0",
  "scope": "aorta.tx.mp.medicatievoorschrift-sturen.3-0-0 patient/MedicationRequest.cu",
  "client_id": "...gp-ehr...",
  "sub": "uzi:00000123",
  "patient": "bsn:999999990",
  "token_type": "Bearer",
  "exp": 1760000000,
  "iat": 1759999100
}
```

### Glossary

- **AS**: Authorization Server, mints access tokens.
- **AT**: Access Token.
- **AccessTokenRequest**: the OAuth 2.0 request sent by the ServiceProvider to the AS, carrying the `tx` scope token, optional operations, asserted identity claims, and context claims.
- **AuthorizationRole**: the subject the PermissionMatrix keys on; one Nictiz Bedrijfsrol refined by a set of identity claims (typically rolcodes), resolved from presented claims by a RolePrerequisite.
- **Bedrijfsrol**: the role a person plays in a transactie (Voorschrijver, Verstrekker, Toediener, ...). Unit of HealthcareProfessional-to-HealthcareOrganization delegation, and the role an AuthorizationRole refines.
- **IdentityClaim**: a typed assertion about the requester that the policy evaluates. Carried in many wire formats (signed SAML claim, Verifiable Credential, JWT claim by a trusted AS, mTLS-derived claim, ...).
- **ContextClaim**: a typed assertion about the request context rather than the requester (patient, Enrollment, Mitz consent, purpose-of-use), evaluated by the use case's context gate.
- **Enrollment**: a ContextClaim for the patient's treatment relationship; the professional issues it to the organisation, attesting that they enrol or treat the patient.
- **Informatiestandaard**: a Nictiz healthcare information standard (e.g. Medicatieproces, BgZ).
- **Kwalificatie**: qualification, the upstream certification that a vendor product may act as a given systeemrol.
- **PDP**: Policy Decision Point, see [Authorization](authorization.html).
- **PermissionMatrix**: a layer 2 entity, per use case, mapping (AuthorizationRole, Transactie) to allow or deny plus a delegatable flag. The AORTA realisation for medication is the *Autorisatierichtlijn medicatieveiligheid*.
- **RolePrerequisite**: a layer 2 rule that resolves a set of identity claims to an AuthorizationRole; a role may have several, and satisfying any one is enough.
- **RS**: Resource Server, enforces SMART on FHIR scopes on FHIR endpoints.
- **SoF scope**: SMART on FHIR v2 scope, e.g. `patient/MedicationRequest.s`.
- **Systeemrol**: the role a system plays in a transactie (Sturend, Ontvangend, Raadplegend, Beschikbaarstellend). Unit of qualification and of ServiceProvider delegation.
- **SysteemrolPrerequisite**: a layer 2 rule that resolves a ServiceProvider's claims (notably its qualification) to a Systeemrol; the system-side analogue of a RolePrerequisite, with no matrix.
- **Transactie**: a single interaction within a transactiegroep, e.g. `Raadplegen verstrekkingsverzoek` (consult) or `Beschikbaarstellen verstrekkingsverzoek` (publish). The unit the PermissionMatrix authorizes against.
- **Transactiegroep**: a named group of related transacties, e.g. `Verstrekkingsverzoek (raadplegen/beschikbaarstellen)`.
- **Trust framework**: an independently governed authorization regime (afsprakenstelsel).
- **Use case**: a sub-chapter of an informatiestandaard, equal to a "scenario" in ART-DECOR. The unit of authorization in this proposal.
- **Zib**: *zorginformatiebouwsteen*, a Dutch healthcare data model construct.

### References

**Nictiz**

- [Nictiz Handleiding Wiki documentatie](https://informatiestandaarden.nictiz.nl/wiki/Handleiding_Wiki_documentatie)
- [ART-DECOR Medicatieproces scenarios](https://decor.nictiz.nl/pub/medicatieproces/)

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
