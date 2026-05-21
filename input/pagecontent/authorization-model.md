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
- **Transactiegroep**: a bundle of related transactions, e.g. `Medicatiegegevens (MGR/MGB)` for the pull variant or `Medicatievoorschrift (VOS/VOO)` for the push variant. The smallest unit that names a complete interaction.
- **Transactie**: one direction of one exchange, e.g. `Raadplegen medicatiegegevens` or `Beschikbaarstellen medicatiegegevens`. FHIR or CDA profiles attach at this level.
- **Operation** (interactie-id on the wire): a single wire-level operation within a transactie, identified as `<verb>:<artifact>:<version>` (e.g. `search:zib-MedicationAgreement:2`). One transactie has one or more operations; an artifact is a Zib or a FHIR Bundle profile.
- **Systeemrol**: the role a system plays in a transactie. Four kinds: Sturend, Ontvangend, Raadplegend, Beschikbaarstellend. Unit of qualification.
- **Bedrijfsrol**: the role a person plays in a transactie (Voorschrijver, Verstrekker, ...). Cross-cutting actor type.

The **use case is the unit of authorization** in this proposal. A single user-facing data request often needs operations from more than one transactiegroep within the same use case. For example, the *Medicatiebouwstenen* use case in Medicatieproces 9 contains `Medicatiegebruik (raadplegen/beschikbaarstellen)` and `Medicatietoediening (raadplegen/beschikbaarstellen)` among others; a "show me everything about this patient's medication" view needs operations from both. Scoping the AT at the use-case level reflects that. The transactiegroep remains the unit of conformity (qualification, policy granularity per direction), but is not surfaced on the OAuth wire.

#### Layer 2: Trust Framework

{% include authorization-model-layer2.svg %}

The Nictiz-layer entities `UseCase`, `Systeemrol`, and `Bedrijfsrol` appear in yellow because they are referenced from layer 1; they are not redefined here. Layer-2 entities are shown in blue.

**Governance and policy:**

- **TrustFramework**: an independently governed authorization regime (afsprakenstelsel). Owns the qualification programme, the identity-claim vocabulary, the authentication profiles, and the authorization policies used within its boundary.
- **AuthenticationProfile** (the *presence* gate): defined per use case, lists the identity-claim *types* that must be present and valid on a request. Answers the question "is this request well-formed for the use case". For example, "any request for use case X must carry a rolcode claim, an organisation_id claim, a systeemrol claim, and an attest claim". Says nothing about which values of those claims are permitted. Shown in the diagram with `required_claim_types[]` as an attribute, rather than an explicit edge to `IdentityClaim`, to keep the diagram readable.
- **AuthorizationPolicy** (the *permission* gate): defined per use case, specifies which combinations of identity-claim *values* are permitted for each operation in the use case. Answers the question "does this caller, with these specific claim values, have permission to perform this specific operation". For example, "rolcode `01.015` (Huisarts) is allowed to raadplegen MA, but not to beschikbaarstellen MA". Says nothing about which claim types must be present (that is the AuthenticationProfile's job). The AORTA realisation for medication is the *Autorisatierichtlijn medicatieveiligheid* published by VZVZ: a matrix mapping (rolcode, action, dataset) to ja/nee that the AS consults at mint time. Shown in the diagram with `allowed_combinations[]` as an attribute rather than explicit edges to `IdentityClaim` and `Operation`, for the same readability reason as `AuthenticationProfile`.

The two are deliberately separated along the standard authentication-vs-authorization split. Presence and integrity is checked first via the AuthenticationProfile; permission given values is checked second via the AuthorizationPolicy. Mixing them into one entity is possible in implementation, but the conceptual gates remain distinct.

**Actors:**

- **HealthcareProfessional, HealthcareOrganization, ServiceProvider**: the three professional-side actor layers. The professional is employed by an organisation; the organisation is served by a service provider.
- **Patient**: the data subject. In professional flows the patient is referenced via their BSN as the data-scope of the access token; the request principal is the ServiceProvider acting for the HealthcareProfessional and HealthcareOrganization. In *patient-channel (PHR) flows*, the patient becomes the asserting principal: they authenticate via DigiD with their PGO, and the PGO operator (a ServiceProvider qualified as a Dienstverlener Persoon under MedMij) makes the access-token request on their behalf. In both flows the `patient` attribute on the AccessTokenRequest carries the data-subject BSN; in PHR flows that BSN coincides with the authenticating principal's BSN.

**Identity claims (asserted by the requester):**

- **IdentityClaim** (abstract): a typed assertion about the requester that the policy evaluates. Generalises systeemrol, bedrijfsrol, rolcode, organisation identifiers, attest grounds, and similar. Each trust framework defines its own vocabulary. The Qualification and both delegations below are shown in the diagram as concrete subtypes of `IdentityClaim`.
- **Qualification**: the certification that a vendor product (used by a service provider) may act in a given systeemrol. Issued by the trust framework. AORTA term: kwalificatie, recorded in TKID. MedMij splits this into DVA (provider-side) and DVP (PGO-side). Upstream of OAuth; the AS treats it as a precondition.
- **HealthcareProfessional-to-HealthcareOrganization delegation**: the credential by which a healthcare professional grants their healthcare organisation authority to act on their professional responsibility, scoped to a set of bedrijfsrollen. The professional can only delegate what they ARE (a Voorschrijver, a Verstrekker, ...), so the delegation is at bedrijfsrol granularity.
- **ServiceProvider delegation**: the credential by which a healthcare organisation grants a service provider authority to act for it on the wire, scoped to a set of systeemrollen. The healthcare organisation delegates technical capability.

The delegation chain runs at two different layers: the HealthcareProfessional-to-HealthcareOrganization delegation operates at bedrijfsrol level, and the ServiceProvider delegation operates at systeemrol level. Each step delegates at the layer it can actually express. A healthcare professional is not a system; they cannot delegate a systeemrol.

#### Layer 3: OAuth wire artefacts

{% include authorization-model-layer3.svg %}

Layer 1 entities (`UseCase`, `Operation`, `FHIRResource`) appear in yellow; layer 2 entities (`IdentityClaim`, `ServiceProvider`) appear in blue. Layer-3 entities are shown in green.

- **AccessTokenRequest**: what the ServiceProvider sends to the AS. Carries one use-case scope token (the `uc`), the list of requested operations (interactie-ids), the asserted identity claims, and the patient context.
- **AccessToken**: the OAuth 2.0 artefact returned on success. Authorizes exactly one use case, carries the verified identity claims, and carries the minted SMART on FHIR scopes.
- **SoFScope**: a [SMART on FHIR v2](https://www.hl7.org/fhir/smart-app-launch/scopes-and-launch-context.html) scope (`<context>/<Resource>.<crud>`). The unit of resource-server enforcement, minted at issue time from the requested operations via the Zib and FHIRResource chain.

Note the asymmetry between request and response: the **request carries interactie-ids**, the **response carries SMART on FHIR scopes**. The AS converts the former into the latter at mint time.

An AT scoped to a use case can cover multiple transactiegroepen, each potentially using a different systeemrol. The AS verifies, per requested operation, that the matching systeemrol is qualified and delegated.

#### Why use case is the scope unit

- A *transactie* is too fine: a single direction (raadplegen without beschikbaarstellen) is meaningless on its own.
- A *transactiegroep* is conceptually coherent but operationally inconvenient. Most real data requests span multiple transactiegroepen within one use case. Forcing one AT per transactiegroep multiplies round-trips and complicates correlation.
- A *use case* matches how Nictiz organises related transacties and how data consumers think about a data request. Per-direction enforcement (systeemrol, bedrijfsrol, attest) still happens via the asserted identity claims and the operation-membership check at mint time.

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

The Problem section above sets out what the convention has to address. The subsections below state the normative rules. Cumulatively, they require a shared layer-2 model, a uniform use-case identifier format on the OAuth wire, a single use case per request with the identifier preserved on the issued AT, and policy lookup by direct identifier match rather than derivation. The model is independent of how identity claims are attested.

#### Authorization information model

The normative model for layers 2 and 3 is the one shown in the Layer 2 and Layer 3 diagrams above. Implementations SHALL preserve the entity meanings as described in those subsections. Specifically:

- A ServiceProvider's Qualifications SHALL be expressed per systeemrol.
- A HealthcareProfessional-to-HealthcareOrganization delegation SHALL be expressed per bedrijfsrol.
- A ServiceProvider delegation SHALL be expressed per systeemrol.
- An AuthenticationProfile SHALL be defined per use case and SHALL enumerate the identity-claim types required for that use case.
- An AccessTokenRequest SHALL reference exactly one UseCase and zero-or-more Operations.
- An AccessToken SHALL authorize exactly one UseCase.

Trust frameworks MAY use additional concepts beyond these (framework-specific governance entities, for example), but SHALL NOT redefine the meaning of the concepts above.

#### Use-case scope token

Every AT request defines exactly one use-case scope token with the format:

```
<governance-body>.uc.<information-standard>.<use-case>.<version>
```

Examples:

```
aorta.uc.mp.medicatiegegevens.3-0-0
aorta.uc.mp.medicatievoorschrift.3-0-0
aorta.uc.bgz.bgz.1-0
medmij.uc.medicatie.actueel.1-0
nuts.uc.eoverdracht.notifying.1-0
```

Segment rules:

- `<governance-body>`: the body governing the namespace (`aorta`, `medmij`, `twiin`, `nuts`, ...).
- `uc`: literal marker, identifying the token as a use-case scope token.
- `<information-standard>`: the informatiestandaard slug within the governance body (`mp` for Medicatieproces, `bgz`, `eoverdracht`, ...).
- `<use-case>`: kebab-case use-case identifier within the information standard.
- `<version>`: hyphen-separated semantic version (`3-0-0`), or a single integer for major-only versioning (`3`). No `v` prefix, to match the operation token format below.

#### Operation token format

Operations are the fine-grained interactie-ids that appear in the request scope alongside the use-case token. The format is defined by the [AORTA-on-FHIR interactietabel](https://aorta-on-fhir.public.vzvz.nl/aorta-on-fhir-specificaties/Working-version/aorta-interactietabel). Two shapes exist:

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

Each operation in a request scope must belong to a transactiegroep within the scoped use case. The AS verifies this at mint time.

The exact shape of the operation token is information-standard-specific: each informatiestandaard registers its own artifact prefixes and version conventions. New information standards are encouraged to follow the `<verb>:<artifact>:<version>` shape above for cross-framework consistency, but the proposal does not mandate it.

#### Scope tokens are opaque identifiers

For the purpose of policy matching, both the use-case token and the operation tokens are treated as opaque strings: the AS looks them up in the trust framework's catalogue of registered use cases and operations, and matches against the policy by exact-string comparison. The format conventions above are human-readable structure, not parsing requirements.

The two formats are deliberately distinguishable at a glance (the use-case token uses dot-separation with an explicit `uc` marker; operation tokens use colon-separation with a verb prefix). An AS implementation needs to identify which tokens in a request scope are which (per REQ-1 and REQ-3), but a simple shape check is sufficient; no internal-format parsing is required for policy evaluation.

#### Conformance: AT request

> **REQ-1 (SHALL).** An AT request SHALL contain exactly one use-case scope token.
>
> **REQ-2 (SHALL).** The AS SHALL reject the request if REQ-1 is violated (zero or more than one token).
>
> **REQ-3 (MAY).** The request scope MAY contain additional scope tokens (fine-grained operation requests as interactie-ids, channel tags), to be evaluated against the use case's allowed set.
>
> **REQ-4 (SHOULD).** Clients SHOULD include only the operation tokens they actually intend to use (least-privilege).

#### Conformance: issued AT

> **REQ-5 (SHALL).** The issued AT SHALL carry the use-case identifier as a `uc` claim, whose value equals the request's use-case scope token.
>
> **REQ-6 (SHALL).** The use-case scope token SHALL also appear in the AT's `scope` claim alongside the minted SMART on FHIR scopes.

#### Conformance: AS behaviour

> **REQ-7 (SHALL).** The AS SHALL select the applicable policy by direct lookup of the use-case identifier, not by derivation from other tokens or context.
>
> **REQ-8 (SHALL).** For every requested operation, the AS SHALL verify that:
>
> - the operation belongs to a transactiegroep within the scoped use case;
> - the matching systeemrol is qualified for the ServiceProvider and authorized by the ServiceProvider delegation;
> - the corresponding bedrijfsrol is authorized by the HealthcareProfessional-to-HealthcareOrganization delegation issued by the asserting healthcare professional;
> - the asserted rolcode is permitted to perform the operation per the use case's AuthorizationPolicy.
>
> **REQ-9 (SHALL).** The AS SHALL reject requests whose use-case identifier maps to no known policy.

#### Identity claims and verification

Identity claims are the typed assertions the AS evaluates. The set asserted on a single request typically includes:

- The professional's identifier (UZI) and rolcode.
- The organisation's identifier (URA) and role type.
- The systeemrol (or systeemrollen, if the request spans multiple transactiegroepen).
- The bedrijfsrol (or bedrijfsrollen) the asserting professional is acting under.
- The relevant attest grounds (treatment relationship, consent, ...).
- The ServiceProvider's Qualification.
- The two delegation credentials in the chain.

In current Dutch implementations these claims appear in several forms, sometimes mixed within one request: signed claims in SAML tokens, Verifiable Credentials, JWT claims issued by a trusted Authorization Server, or claims derived from an mTLS client certificate. The proposal works with any of these; it does not prescribe a wire format.

The use case's AuthenticationProfile lists which identity-claim types must be present. The AS checks the asserted claims against that list at request time. The further per-operation verifications (systeemrol, qualification, delegations, rolcode permission) are specified in REQ-8 under the AS behaviour conformance subsection.

**Multi-systeemrol and multi-bedrijfsrol requests.** A single AT request can cover multiple transactiegroepen within the use case, each potentially requiring a different systeemrol or bedrijfsrol. The convention is that the client presents all relevant role claims up front, and the AS resolves the appropriate role per operation. Concretely:

> **REQ-10 (SHALL).** The client SHALL present, as asserted identity claims on the request, all systeemrollen and all bedrijfsrollen that may apply to any of the requested operations within the use case. The AS SHALL resolve, per operation, which asserted systeemrol matches the operation's initiating systeemrol and which asserted bedrijfsrol applies; it SHALL verify each independently against the relevant Qualification, ServiceProvider delegation, and HealthcareProfessional-to-HealthcareOrganization delegation.

A delegation at one systeemrol does not imply any other systeemrol; the same holds for bedrijfsrollen. The AS reasons over the asserted set as a whole, but each per-operation check is independent.

### Evaluation flow

{% include authorization-model-evaluation.svg %}

Happy path. Any check failure results in rejection, not shown for clarity. The legend on the diagram marks each step's input sources: **R** for the AT request, **L1** for the Nictiz catalogue (layer 1), **L2** for the trust framework registry (layer 2). Steps that depend on derived context (e.g. "the required systeemrol per operation") inherit their source from the step that resolved that context.

When the AT request spans multiple transactiegroepen within the use case, the qualification and the two delegation checks happen per operation: each operation may require a different systeemrol or bedrijfsrol.

### Examples

*This section is non-normative.* Each example shows the request scope, the AS decision summary, and the token introspection response ([RFC 7662](https://datatracker.ietf.org/doc/html/rfc7662)) that the resource server or audit subsystem would receive for the issued AT. The introspection responses are illustrative and do not specify a wire format; specific identifier values are placeholders. Trust-anchored identity claims are shown abstractly; how they are proven is out of scope.

#### MedMij: PGO fetches medication data

Request scope:

```
medmij.uc.medicatie.actueel.1-0
search:MedicationRequest:1.0:request
search:MedicationStatement:1.0:request
```

Asserted identity claims: `subject_id` (citizen via DigiD).

AS decision: the use case exists, both operations belong to transactiegroepen within it, the asserted claims satisfy the policy.

Token introspection response:

```json
{
  "active": true,
  "uc": "medmij.uc.medicatie.actueel.1-0",
  "scope": "medmij.uc.medicatie.actueel.1-0 patient/MedicationRequest.s patient/MedicationStatement.s",
  "client_id": "...pgo-app...",
  "sub": "bsn:999999990",
  "patient": "bsn:999999990",
  "token_type": "Bearer",
  "exp": 1760000000,
  "iat": 1759999100
}
```

#### AORTA professional pull: GP queries medication overview

A GP queries the medication overview of a specific patient. The request spans operations from multiple transactiegroepen within the `medicatiegegevens` use case.

Request scope:

```
aorta.uc.mp.medicatiegegevens.3-0-0
search:mp-MedicationAgreement:1
search:mp-MedicationDispense:1
search:mp-AdministrationAgreement:1
search:mp-MedicationUse2:1
```

Asserted identity claims:

- `subject_id` (behandelaar UZI)
- `rolcode=Huisarts`
- `organisation_id` (URA)
- `organisation_role=Huisarts`
- `systeemrol=MedicatieGegevensRaadplegend`
- `bedrijfsrol=Medicatieraadpleger`

AS decision: the use case exists; for each requested operation, the asserted `MedicatieGegevensRaadplegend` is the initiating systeemrol of the matching transactie; the ServiceProvider's Qualification covers that systeemrol; the ServiceProvider delegation authorizes it; the HealthcareProfessional-to-HealthcareOrganization delegation issued by the GP to their organisation authorizes the required `Medicatieraadpleger` bedrijfsrol.

Token introspection response:

```json
{
  "active": true,
  "uc": "aorta.uc.mp.medicatiegegevens.3-0-0",
  "scope": "aorta.uc.mp.medicatiegegevens.3-0-0 patient/MedicationRequest.s patient/MedicationDispense.s patient/MedicationStatement.s",
  "client_id": "...gp-ehr...",
  "sub": "uzi:00000123",
  "patient": "bsn:999999990",
  "token_type": "Bearer",
  "exp": 1760000000,
  "iat": 1759999100
}
```

#### AORTA professional push: voorschrijver sends prescription

Request scope:

```
aorta.uc.mp.medicatievoorschrift.3-0-0
transaction:mp-MedicationPrescriptionProcessing-Bundle:1
```

Asserted identity claims:

- `subject_id` (behandelaar UZI)
- `rolcode=Huisarts`
- `organisation_id` (URA)
- `organisation_role=Huisarts`
- `systeemrol=VoorschriftSturend`
- `bedrijfsrol=Voorschrijver`

AS decision: the use case exists; the bundle operation belongs to the `medicatievoorschrift` use case via its transactiegroep; the asserted `VoorschriftSturend` is the initiating systeemrol; the ServiceProvider is qualified and delegated for that systeemrol; the HealthcareProfessional-to-HealthcareOrganization delegation authorizes the `Voorschrijver` bedrijfsrol.

Token introspection response:

```json
{
  "active": true,
  "uc": "aorta.uc.mp.medicatievoorschrift.3-0-0",
  "scope": "aorta.uc.mp.medicatievoorschrift.3-0-0 patient/MedicationRequest.cu patient/MedicationRequest.s",
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
- **AccessTokenRequest**: the OAuth 2.0 request sent by the ServiceProvider to the AS, carrying the `uc` scope token, requested operations, asserted identity claims, and patient context.
- **AuthenticationProfile**: a layer 2 entity defined per use case that enumerates the identity-claim types the use case requires. Checked at request time against the asserted claims.
- **AuthorizationPolicy**: a layer 2 entity defined per use case that lists which combinations of identity-claim values (typically rolcode) are permitted for which operations. The AORTA realisation for medication is the *Autorisatierichtlijn medicatieveiligheid*.
- **Bedrijfsrol**: the role a person plays in a transactie (Voorschrijver, Verstrekker, Toediener, ...). Unit of HealthcareProfessional-to-HealthcareOrganization delegation in this proposal.
- **IdentityClaim**: a typed assertion about the requester that the policy evaluates. Carried in many wire formats (signed SAML claim, Verifiable Credential, JWT claim by a trusted AS, mTLS-derived claim, ...).
- **Informatiestandaard**: a Nictiz healthcare information standard (e.g. Medicatieproces, BgZ).
- **Kwalificatie**: qualification, the upstream certification that a vendor product may act as a given systeemrol.
- **PDP**: Policy Decision Point, see [Authorization](authorization.html).
- **RS**: Resource Server, enforces SMART on FHIR scopes on FHIR endpoints.
- **SoF scope**: SMART on FHIR v2 scope, e.g. `patient/MedicationRequest.s`.
- **Systeemrol**: the role a system plays in a transactie (Sturend, Ontvangend, Raadplegend, Beschikbaarstellend). Unit of qualification and of ServiceProvider delegation.
- **Transactie**: one direction of one exchange within a transactiegroep.
- **Transactiegroep**: a bundle of related transactions that together form a complete interaction. Unit of conformity but not surfaced on the OAuth wire by this proposal.
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
