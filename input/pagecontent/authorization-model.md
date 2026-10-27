<!--
SPDX-FileCopyrightText: 2026 Steven van der Vegt

SPDX-License-Identifier: CC-BY-SA-4.0
-->

### Introduction

Dutch healthcare data exchange runs under several trust frameworks (AORTA-on-FHIR, MedMij, Twiin, Nuts use-case communities). Each one has, over time, built its own authorization model. Each model is well documented within its own framework. But it is framework-local: it lives spread over registry definitions, policy documents, and wire conventions, in a vocabulary that only works inside that framework. The models overlap conceptually: qualifications, delegations, roles, and context checks appear in all of them. Yet they never align: no shared vocabulary exists to compare them in.

This proposal makes the model explicit. Its goal is twofold. First, it defines a shared _authorization information model_ in which each trust framework can express its own policies, layered on top of the Nictiz information-standard catalogue as the common basis. Second, it derives from that model one OAuth 2.0 convention for requesting access tokens, so that the frameworks share a wire format where they interoperate.

The intended audience is architects of the trust frameworks listed above. The chapter is discussion input for alignment with those frameworks, not settled policy. The token request convention is the one wire format this chapter does prescribe; the proposal is independent of how identity claims are attested and does not prescribe a wire format for them. The Specification lists the attestation forms in use today.

A note on terminology: this chapter uses English terms for the Nictiz catalogue concepts (transaction, system role, business role); the glossary contains the translation table. Concrete catalogue values (transaction names, role names, rolcodes) are quoted in their original Dutch.

### Problem

Each trust framework documents its own authorization model, but only its own. Four constructs recur in every framework, under different names, at different granularities, with different attestation formats:

- **Qualification**: every framework has a mechanism that admits a vendor product into a technical role, but each framework names a different part of that mechanism. AORTA names the registry that records the result of a successful qualification (TKID); MedMij names the roles a successful qualification admits a party into (DVA, DVP); Twiin has similar mechanisms. None separates the qualification from the role it leads to.
- **Delegation chain**: AORTA, MedMij, and Twiin each construct delegation chains between professionals, organisations, and service providers differently. The chain shape is usually similar; the attestations and granularities are not.
- **Role resolution**: every framework maps presented identity claims (rolcodes, organisation identifiers) onto something it permits actions for, but the mapping rules are buried in framework-specific policy documents such as the Autorisatierichtlijn, with no common structure.
- **Context checks**: consent (Mitz), the treatment relationship, and purpose-of-use conditions exist everywhere, attached at different points in each framework and with no shared vocabulary (an explicit purposeOfUse field in the Nuts authorization credential, the distinct spoed situation in Mitz).

Because each model is stated only in its own framework's terms, the models cannot be compared, mapped, or composed. A developer building a system that participates in two frameworks must assemble two complete models from documentation scattered across wikis, registries, and policy documents, and invent the mapping between them. A policy author cannot tell whether two frameworks make the same access decision for the same situation. Cross-framework integration is expensive and brittle; authorization is not the only reason, but it is the part this chapter addresses.

The divergence is most visible on the wire. The frameworks do not even share one protocol family: AORTA's current interfaces carry SAML tokens, the others use OAuth 2.0. Where OAuth is used, each framework identifies the authorized work in the request scope with a different grammar, and differs in whether that identification survives onto the issued access token. The wire divergence is only the visible part: the grammars differ because each framework derived its wire convention from a different underlying model. Aligning the syntax without aligning the model would change nothing. This proposal therefore defines the model first, and the wire convention as its consequence.

### The model

The Examples section shows every construct introduced below as a filled-in table, for one concrete case (a GP consults a patient's medication agreements). Reading the model and that example side by side is the fastest route through this chapter.

#### Three layers

This proposal models authorization in three layers. The layering is a modelling decision, not a given: it is chosen because the layers have different owners, change at different rates, and answer different questions. A layer groups concerns, not authors; one governance body can author artefacts in more than one layer.

- **Layer 1, Information Standards** (the _information layer_) defines _what_ transactions exist and _what data_ they carry. In the Netherlands most information standards are maintained by Nictiz; this proposal adopts the Nictiz meta-model, per the [Handleiding Wiki documentatie](https://informatiestandaarden.nictiz.nl/wiki/Handleiding_Wiki_documentatie), as the layer-1 vocabulary. It catalogues information standards, use cases, transaction groups, transactions, system roles, business roles, and the datasets they operate on. The data definitions (datasets, zibs) are part of this layer; there is no separate data layer. This layer is the same for all trust frameworks.
- **Layer 2, Trust Framework** (the _trust layer_) specifies _who_ may perform _which_ transactions, and under what conditions: role resolution, the permission matrix, qualifications, the delegation chain, identity claims, context claims. Today these constructs are filled per framework (VZVZ, MedMij, Twiin, Nuts-toepassingen). The model does not tie them to per-framework governance: with a shared vocabulary, layer-2 policies can be lifted to national governance where that is wanted.
- **Layer 3, Realisation** (the _realisation layer_) specifies _how_ a transaction reaches the wire: the FHIR profiles that represent its data, the operations performed on those profiles, and how a single authorization decision surfaces in an OAuth 2.0 exchange. The wire artefacts are the access-token request, the issued access token, and the granted scopes that the resource server enforces. This proposal realises the granted scopes as SMART on FHIR v2 scopes; the model does not depend on that choice.

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

Three structural points matter for authorization:

- **Containment, not reuse.** A transaction group belongs to one use case, and a transaction to one transaction group, so a transaction belongs to exactly one use case. Reuse across standards happens at the dataset, template, and value-set level, not at the transaction level. Fetching the same data under a different use case is, by definition, a different transaction, because the use case carries the intent and therefore the conditions.
- **There is no operation concept in layer 1.** The functional model stops at the transaction. Operations belong to the realisation and are introduced in layer 3.
- **Lifecycle rules are layer-1 facts.** Where an information standard defines a lifecycle for its data (status values and the permitted transitions), that state machine belongs to this layer. It surfaces in authorization as state rules on layer-3 operations, enforced by the resource server at request time; layer 3 works out why such rules never ride the access token.

The transaction dataset itself shows what belongs in layer 2; the design notes contain that derivation.

#### Layer 2: Trust Framework

The trust layer (L2) adds the constructs that control access on top of the information layer (L1) catalogue. It is presented in two views: first the concrete actors and the credentials that carry their claims in the Dutch context, then the general mechanism that turns those claims into an access decision. In both diagrams, information-layer entities are shown in yellow (referenced, not redefined here), trust-layer policy and actors in pale blue, and claims in mid-blue, typed by their `<<IdentityClaim>>` or `<<ContextClaim>>` stereotype.

##### Actors and credentials

This view shows who the actors are, the credentials carrying the identity claims that the access decision consumes, and the context claims (such as the Enrollment) the actors produce. Requests reach a source through one of two channels: in the _professional channel_ a ServiceProvider requests on behalf of a professional and their organisation; in the _patient channel_ the patient requests their own data through a PGO. The actors below cover both.

{% include authorization-model-layer2.svg %}

- **HealthcareProfessional, HealthcareOrganization, ServiceProvider**: the three actors of the professional channel. The professional is employed by an organisation; the organisation is served by a service provider. The model names healthcare organisations because the trust frameworks do; organisations outside care are out of scope here, though the mechanism does not preclude them.
- **Patient**: the data subject, referenced via their BSN in the `patient` attribute of the AccessTokenRequest. In the professional channel the request principal is the ServiceProvider acting for the professional and the organisation; in the patient channel the patient is also the authenticated principal, requesting via their PGO (see the MedMij example).
- **IdentityClaim** (abstract): a typed assertion about the requester. Generalises rolcode, organisation identifiers, the system-role or business-role assertion, the Qualification, the Membership, the UserAssertion, and the two standing delegations. Each trust framework defines its own vocabulary.
- **Qualification**: the claim by which a ServiceProvider asserts that its product passed qualification for a given system role. The qualification itself is an upstream certification process; the claim asserts its result. AORTA records qualification results in TKID; a successful MedMij qualification admits the party into the DVA (provider-side) or DVP (PGO-side) role. Qualification here is product qualification: it certifies software for a system role. Professional competences (a nurse qualified for medicatie-toediening, say) are not Qualifications in this model; they travel as rolcodes or other identity claims and feed role resolution.
- **UserAssertion**: the claim by which the system asserts which professional is acting: their identifier and rolcode, valid for the working session. It is the professional's short-lived delegation of their identity to the system they are logged into. Attended means a UserAssertion is present; the design notes work out how it relates to the standing delegations below.
- **HealthcareProfessional-to-HealthcareOrganization delegation**: the credential by which a professional delegates a set of business roles to their organisation. It is the _mandaattoken_ behind the matrix's `delegatable` flag. It is needed whenever the role is exercised by someone other than the professional who holds it: the organisation acting unattended, or an authenticated user who lacks the required rolcode and works under the professional's responsibility. The delegation carries the professional's identifier and rolcode: under an unattended mandate it is the only claim that brings them, and role resolution reads the rolcode from it. A professional with the required rolcode asserts the role directly. Whether the delegation surfaces as a wire credential at all depends on the enforcement topology (below).
- **ServiceProvider delegation**: the credential by which an organisation delegates a set of system roles to its service provider.
- **Membership**: the claim by which a HealthcareOrganization asserts its admission to a trust framework, or to a specific information standard within it. The organisational counterpart of the Qualification: where the Qualification certifies a product for a system role, the Membership certifies that the organisation meets the framework's non-technical requirements (participation agreements, security and privacy norms). Realisations: the MedMij and Twiin deelnemersovereenkomst, AORTA's aansluitvoorwaarden. Prerequisites reference it like any other identity claim; it is slow-changing and typically binds at registration time.
- **ContextClaim** (abstract) and **Enrollment**: assertions about the request and the patient, not the requester. `Enrollment` is the treatment relationship: the professional issues it to the organisation, attesting that they enrol or treat the patient. It feeds the use case's context checks, not role resolution.

The delegation chain runs at two layers: the professional-to-organisation delegation at business-role level, the service-provider delegation at system-role level. Each step delegates only what it can express; a professional is not a system, so it cannot delegate a system role. The identity claims feed the role resolution below; the context claims, such as the Enrollment, feed the use case's context checks.

##### Role resolution and permission

{% include authorization-model-role-resolution.svg %}

The diagram shows two pipelines. Both start from the presented claims, and both end in the same thing: permission for one transaction. The business-role pipeline resolves the acting person's role and consults a policy; the system-role pipeline is a single check. The two pipelines are evaluated independently, in no particular order.

**The business-role pipeline.** A `RolePrerequisite` resolves the presented identity claims to an `AuthorizationRole`: one business role refined by a set of claims, typically rolcodes. A role may have several prerequisites; satisfying any one resolves the role. The resolved role is then looked up in the `PermissionMatrix`, which keys on (AuthorizationRole, Transaction) and yields allow or deny plus a `delegatable` flag. A slice of the AORTA medication matrix as illustration. Each row is one AuthorizationRole with its matrix verdict; the RolePrerequisites that resolve these roles (the rolcode sets) are separate registry entries, shown in the worked example:

| AuthorizationRole                    | refines business role | Raadplegen medicatieafspraak | delegatable |
| ------------------------------------ | --------------------- | ---------------------------- | ----------- |
| `MedicatieRaadplegerArts`            | Medicatieraadpleger   | allow                        | yes         |
| `MedicatieRaadplegerApotheker`       | Medicatieraadpleger   | allow                        | yes         |
| `MedicatieRaadplegerVerpleegkundige` | Medicatieraadpleger   | deny                         | -           |
{:.grid .table-hover}

The matrix is always present; its content may be trivial. For medication, AORTA publishes the _Autorisatierichtlijn medicatieveiligheid_, a table mapping (rolcode, transaction) to ja/nee. Standards without such a policy (Acute Zorg, Labuitwisseling) publish an explicit allow-all over their resolved roles instead. An absent entry is always deny; "no policy" is a trivial matrix, never a missing one.

**The system-role pipeline.** One check: the Qualification and the ServiceProvider delegation must name the transaction's system role. The transaction itself declares which system role it involves, so naming the role is naming the permitted transactions; no matrix is needed. The business-role pipeline does need one, because a business role carries no per-transaction verdicts.

One refinement exists, for standards whose system roles are coarse. Medicatieproces 9 defines roughly fifty system roles, one per subject-activity pair (e.g. `MedicatieafspraakRaadplegend`): naming the role pins down a single transaction. For a standard with a handful of generic system roles, one qualification would grant every transaction of the role. For that case the trust framework may refine: a `QualifiedSystemRole` covers a subset of one system role's transactions, and the `SystemRolePrerequisite` resolves the ServiceProvider's claims to that refined role. Without a refinement, the qualification grants every transaction of the system role.

The model has two role constructs, and they answer different questions. An AuthorizationRole answers: which requesters may act in this business role? A QualifiedSystemRole answers: which transactions of this system role does the qualification cover? Side by side:

|                 | AuthorizationRole                | QualifiedSystemRole                               |
| --------------- | -------------------------------- | ------------------------------------------------- |
| refines         | one business role                | one system role                                   |
| refinement axis | requester claims (rolcodes)      | transaction coverage                              |
| answers         | who counts as this role          | which transactions does this qualification grant  |
| default         | none; every role must be defined | no refinement; grants all the role's transactions |
| permission via  | PermissionMatrix cell            | coverage directly permits                         |
{:.grid .table-hover}

##### The patient channel

The same machinery covers the citizen. The patient is an actor whose RolePrerequisite reads the DigiD-authenticated BSN claim and resolves to an AuthorizationRole refining the business role Patiënt. The PermissionMatrix rows for that role are the framework's allow-set for patient access (in MedMij terms: the gegevensdiensten). The system-role pipeline is unchanged: the PGO operator is the ServiceProvider, its Qualification is the DVP admission, and the delegation is issued by the patient rather than by an organisation. Most of the context checks do not apply in this channel: there is no treatment relationship, and consent is inherent in requesting one's own data. What remains is the data-subject equality check: the authenticated BSN must equal the `patient` attribute. The MedMij example in the Examples section shows the resulting token.

##### Enforcement topology

The model defines policy as facts and rules: claims, prerequisites, the matrix, the context checks. Where those rules are enforced, and how the evidence reaches the enforcer, is a deployment choice the model constrains but does not fix. Two principles govern that choice. First, a granted scope is a decision, not a forwarded claim: by granting the transaction in the AT's scope, the AS asserts that the authorization decision was made. The holder of an issued AT can expect it to be accepted as-is at runtime; the resource server may still refuse the request itself, but only on checks whose inputs did not exist at issuance, such as state rules. Second, a fact must surface as a wire claim exactly when the evaluating party cannot observe it directly. The first principle splits the checks by input availability: the identity and permission checks bind at issuance (REQ-5), each context check's enforcement point is declared per use case (REQ-6), and state rules always evaluate at the resource server. The consequences (why the two delegations behave differently, when evidence should bind, what the OAuth wire can and cannot carry) are worked out in the design notes, after the evaluation flow.

#### Layer 3: Realisation

The realisation layer (L3) turns the transaction into FHIR and OAuth artefacts. The realisation has two halves. The transaction's data maps onto FHIR profiles: for zib payloads, the published zib-to-FHIR profiles. The exchange itself maps onto **Operations**: the FHIR interactions (search, create, a `Bundle` POST, ...) performed on those profiles. One transaction is realised by one or more operations; the same operation can realise transactions in different use cases; each operation targets one FHIR resource type, from which the granted scopes derive. The construct is not new: the [AORTA-on-FHIR interactietabel](https://aorta-on-fhir.public.vzvz.nl/aorta-on-fhir-specificaties/Working-version/aorta-interactietabel) catalogues exactly this as its `interactionId` rows (e.g. `search:mp-MedicationAgreement:1`), including the reuse across use cases (one row carrying a list of context codes); this proposal adopts that shape for the realisation catalogue.

Some rules can only be evaluated while handling the request, because they read the current state of the data. The Task workflow of a notified-pull exchange is the clearest example: whether the receiver may set a Task to `accepted` depends on the status the Task has now. This proposal calls these _state rules_ and defines them on layer 1, in plain text: the information standard states, per transaction, which role may perform which operation in which data state. For the eOverdracht Task: "the receiving organisation may move a Task from `requested` to `accepted` or `rejected`; it may not move a Task in any other state." The Nictiz meta-model has no formal construct for this today; plain text on the transaction suffices until it does. The realisation catalogue lists the state rules next to the operations they constrain, and the resource server enforces them while handling the request. How a resource server implements the check is out of scope: it depends on its technical stack. The access token never carries state rules, because the state they read does not exist at issuance. _(Draft: the eOverdracht wording above is illustrative; to be verified against the eOverdracht and Twiin realisations.)_

{% include authorization-model-layer3.svg %}

The information-layer entity (`Transaction`) appears in yellow; trust-layer entities (`IdentityClaim`, `ServiceProvider`) in blue; realisation-layer entities, including the `Operation` and `FHIRResource`, in green.

- **AccessTokenRequest**: what the ServiceProvider sends to the AS. Its `scope` parameter carries exactly one transaction identifier (the `tx`). The request further carries the asserted identity claims and the context claims. The `patient` attribute carries the data-subject BSN where the transaction concerns a patient; the AS binds it at issuance, and the resource server (or a policy decision point in front of it) enforces that the patient identifier in the query equals the issued AT's `patient` attribute.
- **AccessToken**: the OAuth 2.0 artefact returned on success. Authorizes exactly one transaction, carries the verified identity claims, and carries the granted SMART on FHIR scopes.
- **SoFScope**: a [SMART on FHIR v2](https://www.hl7.org/fhir/smart-app-launch/scopes-and-launch-context.html) scope (`<context>/<Resource>.<crud>`). The unit of resource-server enforcement, granted at issuance from the transaction's operations via the profile and FHIR resource type. A scope may carry additional search parameters (e.g. `patient/Observation.rs?category=...`) where the operation-to-scope mapping defines them.

The request and the response deliberately speak different vocabularies. The **request carries the transaction identifier**: the intent, in information-standard terms. The **response carries the transaction identifier plus the granted SMART on FHIR scopes**: the enforcement artefacts of the FHIR realisation. The AS is the only party that translates between the two, converting the transaction's operations into scopes at issuance; the design notes argue why the request carries no operation identifiers.

An AT is scoped to one transaction. The AS verifies that a resolved QualifiedSystemRole (backed by the Qualification and the ServiceProvider delegation) covers the transaction. Why the transaction, and not the use case or the operation, is the scope unit is argued in the design notes.

Three mappings make this work, all living in a realisation catalogue published alongside the trust framework's registry:

- transaction to operations: which operations realise which transaction. The AS uses it, together with the operation-to-scope mapping, to derive the granted scopes.
- operation to scope: operation to profile to FHIR resource type to SMART on FHIR scope. The AS uses it when granting scopes.
- operation to state rules: the plain-text state rules from the information standard, listed next to the operations they constrain. The resource server uses them while handling the request; the AS does not.

The catalogue is owned by whoever realises the information standard for the framework. Today it exists per framework, the interactietabel being one realisation. The model requires only that it is published and that the AS resolves its mappings by lookup, not derivation.

### Specification

The subsections below state the normative rules. Cumulatively, they require the shared layer-2 model, a uniform transaction identifier format on the OAuth wire, a single transaction per request with the identifier preserved on the issued AT, and policy lookup by direct identifier match rather than derivation. The model is independent of how identity claims are attested.

The rules bind a trust framework that adopts this model; adoption itself is voluntary and per framework. They are written as conformance requirements so that adoption is testable, not because any framework is bound today. The Adoption section below sketches what adopting costs.

The rules come in two kinds. The model rules (the bullet list in the next subsection) bind the trust framework's registry content: how qualifications, prerequisites, and the matrix are expressed. The numbered requirements (REQ-1 through REQ-8, further down) bind runtime behaviour on the wire: what an AT request must contain, what an issued AT must carry, and what the AS must verify. The REQ identifiers exist because these rules are individually testable; implementations and test suites reference them by number.

#### Authorization information model

The normative model for layers 2 and 3 is the one shown in the Layer 2 and Layer 3 diagrams above. Implementations SHALL preserve the entity meanings as described in those subsections. Specifically:

- A ServiceProvider's Qualifications SHALL be expressed per system role.
- A HealthcareProfessional-to-HealthcareOrganization delegation SHALL be expressed per business role.
- A ServiceProvider delegation SHALL be expressed per system role.
- A RolePrerequisite SHALL resolve presented identity claims to an AuthorizationRole, which refines exactly one business role; a role MAY have several RolePrerequisites, and satisfying any one is sufficient.
- A SystemRolePrerequisite SHALL resolve a ServiceProvider's claims to a QualifiedSystemRole. A QualifiedSystemRole refines exactly one system role and covers one or more of the transactions that use that system role. Absent an explicit refinement, the QualifiedSystemRole SHALL default to the system role itself, covering all of that system role's transactions.
- Every trust framework SHALL publish a PermissionMatrix per use case, mapping (AuthorizationRole, Transaction) to allow or deny plus a delegatable flag. The matrix MAY be trivial (an explicit allow for every resolved AuthorizationRole), but SHALL NOT be absent; the absence of an entry SHALL be treated as deny.
- A trust framework MAY require a Membership claim (organisational admission to the framework or an information standard) for the HealthcareOrganization; prerequisites reference it like any other identity claim.
- An AccessTokenRequest SHALL be scoped to exactly one Transaction.
- An AccessToken SHALL authorize exactly one Transaction.
- A realisation catalogue MAY list state rules per operation, taken from the information standard's lifecycle; where it does, the resource server SHALL enforce them while handling the request.

Trust frameworks MAY use additional concepts beyond these (framework-specific governance entities, for example), but SHALL NOT redefine the meaning of the concepts above.

#### Transaction identifier

Every AT request carries exactly one _transaction identifier_ in its `scope` parameter, with the format below. (RFC 6749 calls each space-separated entry in `scope` a scope-token; this chapter reserves the word token for the access token and writes identifier.)

```
<governance-body>.tx.<information-standard>.<transaction>.<version>
```

Examples:

```
aorta.tx.mp.verstrekkingsverzoek-raadplegen.3-0-0
aorta.tx.mp.medicatieafspraak-beschikbaarstellen.3-0-0
aorta.tx.mp.medicatieoverzicht-raadplegen.3-0-0
medmij.tx.mp.medicatieafspraak-raadplegen.1-0
```

Segment rules:

- `<governance-body>`: the body governing the namespace (`aorta`, `medmij`, `twiin`, `nuts`, ...).
- `tx`: literal marker, identifying this scope entry as a transaction identifier.
- `<information-standard>`: the information-standard slug within the governance body (`mp` for Medicatieproces, `bgz`, `eoverdracht`, ...).
- `<transaction>`: kebab-case transaction identifier (e.g. `verstrekkingsverzoek-raadplegen`).
- `<version>`: hyphen-separated semantic version (`3-0-0`), or a single integer for major-only versioning (`3`). No `v` prefix.

The use case the transaction belongs to is derivable from the catalogue and is not carried on the wire.

#### The transaction identifier is an opaque string

For the purpose of policy matching, the transaction identifier is treated as an opaque string: the AS looks it up in the trust framework's catalogue of registered transactions and matches against the policy by exact-string comparison. The format convention is human-readable structure, not a parsing requirement.

#### Conformance: AT request

> **REQ-1 (SHALL).** An AT request SHALL contain exactly one transaction identifier in its scope.
>
> **REQ-2 (SHALL).** The AS SHALL reject the request if REQ-1 is violated (zero or more than one transaction identifier).

#### Conformance: issued AT

> **REQ-3 (SHALL).** The transaction identifier SHALL appear in the AT's `scope` alongside the granted SMART on FHIR scopes.

_Rationale: the `scope` member is standard in both JWT access tokens and introspection responses, so the transaction identifier is visible to the resource server and the audit subsystem without any non-standard field._

#### Conformance: AS behaviour

> **REQ-4 (SHALL).** The AS SHALL select the applicable PermissionMatrix entry by direct match of the transaction and the resolved AuthorizationRole, not by derivation from other scope entries or context.
>
> **REQ-5 (SHALL).** For the scoped transaction, the AS SHALL verify at issuance that:
>
> - the ServiceProvider's claims (its Qualification and the ServiceProvider delegation) resolve, via a SystemRolePrerequisite, to a QualifiedSystemRole whose coverage includes the scoped transaction;
> - the presented identity claims resolve, via a RolePrerequisite, to an AuthorizationRole that the PermissionMatrix permits for the transaction;
> - if the AuthorizationRole is exercised under mandate (defined as: the organisation acting unattended, or a user acting under the professional's responsibility), then (a) the PermissionMatrix entry SHALL be delegatable, and (b) a HealthcareProfessional-to-HealthcareOrganization delegation SHALL authorize the business role the AuthorizationRole refines.
>
> **REQ-6 (SHALL).** The context checks of the scoped transaction's use case SHALL be enforced before data is released. The trust framework SHALL declare, per use case, the enforcement point of each check: the AS at token issuance, the AS at token introspection, or a policy decision point at the resource server. The AS SHALL evaluate the checks declared for issuance before issuing the AT.
>
> **REQ-7 (SHALL).** The AS SHALL reject the request if the transaction is unknown, any check in REQ-5 fails, or any context check declared for issuance fails.

#### Identity claims, context, and verification

Identity claims are the typed assertions the AS resolves into roles. For the scoped transaction the set typically includes:

- The professional's identifier and rolcode, today issued under the UZI register (DEZI, its successor programme, keeps both concepts).
- The organisation's identifier (URA) and role type.
- The system role the transaction uses.
- The ServiceProvider's Qualification and the two delegation credentials in the chain.

In current Dutch implementations these claims appear in several forms, sometimes mixed within one request: signed claims in SAML tokens, Verifiable Credentials, JWT claims issued by a trusted Authorization Server, claims derived from an mTLS client certificate, or claims held in a registry the AS consults. The proposal works with any of these; it does not prescribe a wire format.

Which claims a request must carry follows from the prerequisites: exactly those the scoped transaction's RolePrerequisite and SystemRolePrerequisite read to resolve the AuthorizationRole and the QualifiedSystemRole. There is no separate required-claims list to maintain.

**Context checks.** Role resolution answers "who is the requester"; the context checks answer "is sharing this patient's data allowed". They evaluate ContextClaims about the request rather than the requester: the patient (BSN), the Enrollment (the treatment relationship), consent, and purpose-of-use. Purpose-of-use is the requester's declared purpose for the request; it is distinct from the legal basis (grondslag) that makes sharing lawful, although the declared purpose determines which legal basis must hold. The checks are attached to the use case because the claims they evaluate concern the intent, which all the use case's transactions share; attaching identical checks per transaction would only duplicate them. A trust framework may narrow the checks for an individual transaction; it may never loosen them. Because a transaction belongs to exactly one use case, the scoped transaction fixes which checks apply. Where each check is enforced is declared per use case (REQ-6); the design notes discuss that choice.

> **REQ-8 (SHALL).** The client SHALL present the identity claims needed to resolve the AuthorizationRole and the QualifiedSystemRole for the scoped transaction, together with the ContextClaims required by the context checks declared for issuance (the use case's checks, possibly narrowed for the scoped transaction). The AS verifies these claims under REQ-5 and REQ-6 and rejects under REQ-7; an absent required claim fails the check that reads it.

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

The minimal first step is the transaction identifier format alone: it requires no registry changes beyond listing the identifiers, is visible on the wire, and gives audit and cross-framework tooling a uniform identifier. For AORTA-on-FHIR, whose request scopes today carry interactionIds, the transaction identifier replaces them rather than joining them. The full layer-2 publication can follow per framework, per information standard.

Open issue: custodianship of the shared vocabulary (this chapter) once more than one framework adopts it. Candidates: Nictiz (owns layer 1), or the generieke functies programme. To be resolved with the trust framework architects.

### Evaluation flow

{% include authorization-model-evaluation.svg %}

Happy path. Any check failure results in rejection; failure paths are omitted for clarity. The legend on the diagram marks each step's input sources: **R** for the AT request, **L1** for the information-layer catalogue, **L2** for the trust-layer registry, **L3** for the realisation-layer catalogue (the interactietabel). Steps that depend on derived context (e.g. the transaction's required system role) inherit their source from the step that resolved that context.

Because the AT is scoped to a single transaction, role resolution, the system-role coverage check, the matrix lookup, and the issuance-declared context checks are each evaluated once for that transaction.

### Design notes

_This section is rationale, not specification: it argues the design decisions the model sections state._

#### Why the transaction is the scope unit

- The _transaction_ is the unit the PermissionMatrix decides on: each cell maps `(AuthorizationRole, Transaction)` to allow or deny. Scoping the AT to one transaction aligns the wire with the decision: the AS reads the transaction, resolves the role, and looks up one cell.
- The prerequisites are per transaction: which conditions must hold (the role resolution, the system-role coverage, the delegation, the context check) are set by the transaction. Bundling several transactions into one AT would mean satisfying the union of their prerequisites, which is awkward to express and can even conflict.
- A _use case_ is too coarse for the AT scope: one AT would span many transactions with differing prerequisites, and an operation shared between them could not be attributed to a single cell. The use case is a catalogue grouping of transactions and the carrier of the context checks, not a key the matrix or the AT needs, and it does not appear on the wire.
- An _operation_ is too fine: permission is never decided per operation, and an operation is reusable across transactions, so it does not identify the intent on its own.
- An AT covers one activity the requester performs (one transaction, e.g. `Raadplegen verstrekkingsverzoek`). A request that needs several transactions at once (a full medication overview for one patient) is served by an overview transaction such as Medicatieoverzicht, itself one transaction, or by issuing several ATs.

This makes the wire chattier, and that cost is accepted deliberately. A viewer that opens the full Medicatiebouwstenen use case touches seven raadplegen transactions and therefore needs seven token requests, each a round trip to the source-side AS (the AS is usually co-located with the RS). Three things bound the cost. The requests are independent, so they can be issued in parallel. The issued AT is cacheable per (transaction, patient) within its lifetime, so the volume is per viewer session, not per screen refresh.

Batching several transactions into one AT was considered and rejected. The prerequisites and the context checks are per transaction. A bundled AT must either satisfy every bundled transaction's conditions at once, which fails entirely when one check fails (and checks can conflict: consent may cover one data category but not another), or be evaluated loosely at bundle level. Loose evaluation means consent and audit are no longer per transaction; it is exactly the ambiguity this proposal removes. How many ATs one wire exchange may issue is a layer-3 profiling choice (a framework can adopt a batching or token-exchange profile without touching the model), as long as each issued AT stays scoped to one transaction.

#### Why the request carries no operation identifiers

Letting the requester narrow the granted scopes by naming operation identifiers in the request scope was considered and rejected. The request and the response now split cleanly by vocabulary: the requester states its intent in the functional terms of layer 1 (the transaction), the AS translates that intent via the realisation catalogue, and the token returns the enforcement artefacts (the granted SMART on FHIR scopes). Three reasons:

- The request convention becomes independent of the realisation. With operation identifiers in the request, changing the FHIR mapping changes the request format; without them, only the response side changes. The frameworks diverge most at the realisation layer, so this is what lets them share one request convention.
- The client never needs the operation grammar. The requesting developer works with the information-standard catalogue; the AS and the realisation catalogue own the mapping; the resource server enforces the scopes.
- Narrowing had no policy meaning. The permission decision is per transaction; requested operations could never change the allow or deny, only trim the granted scopes. That least-privilege gain is small (most transactions are realised by a single operation, and the token is short-lived, patient-bound, and transaction-bound) and does not cover the cost of a second identifier grammar on the wire.

The removal has a real migration cost for AORTA: its current wire identifies work by interactionId, so this convention replaces those scope entries with a transaction identifier instead of adding one next to them. The Adoption section states this.

#### Why consent, treatment relationship, and purpose live in layer 2

Before a source shares data, it decides on two kinds of information. The first kind is defined by the information standard: which data elements a transaction exchanges, which query parameters it accepts, and which values those parameters may take. Checking it needs no one's word, because the standard itself is the reference. This is layer 1. The second kind is facts the standard cannot contain: who the requester is, that the patient is under treatment, that the patient consented. Such a fact is valid only because a trusted party attests it: a claim. This is layer 2. Consent, the treatment relationship, and purpose-of-use are facts of the second kind, which is why they live in layer 2. The bridge below shows the split for a query transaction.

{% include authorization-model-bridge.svg %}

- **The BSN sits in both layers, because each layer asks a different question about it.** Layer 1 defines that the query names a patient. Whether the requester may ask about this particular patient is a layer-2 question: the AS binds the `patient` attribute at issuance, the resource server (or a policy decision point in front of it) checks that the BSN in the query equals that attribute, and the context claims (consent, treatment relationship) are about that same patient. Whether a patient is involved at all is a layer-1 fact: if the transaction dataset carries no patient identifier, there is no data subject, the `patient` attribute is absent, and the patient-bound context claims do not apply.
- **The consent check is the source's responsibility.** Unlike the other context claims, consent is not presented by the requester: the source evaluates it itself, whether against a national facility (Mitz) or a local consent registration. The diagram marks it separately.

Everything else in the query stays in layer 1: record-narrowing identifiers (a behandeling-id, a record-id) map to no layer-2 claim, and payload actor concepts (a record's prescriber) relate to the requester's identity claims in type only, never in instance.

#### Enforcement topology and evidence

The model defines policy as facts and rules; this subsection works out where those rules can be enforced and how the evidence reaches the enforcer. Both are deployment choices of the trust framework, on two axes.

_Where._ The governing principle: a fact must surface as a wire claim exactly when the evaluating party cannot observe it directly. Each policy is enforced by the party that owns the duty, or by an intermediary acting for it. Three consequences:

- The source owns the decision to make data available (the beschikbaarstellen slice of the matrix). It enforces that itself, or a central intermediary enforces it on its behalf. The consumer is never the enforcer of source-side policy.
- The professional-to-organisation delegation is internal to the source: a source enforcing its own policy already knows its employment relations and mandates, and presents no credentials to itself. The mandate becomes a wire credential only under intermediary enforcement, when the intermediary cannot see inside the organisation.
- The ServiceProvider delegation is evaluated by the counterparty of the exchange, which can never observe that relationship directly. It therefore remains evidence in every topology, as a presented credential or a trusted registry entry. Where an organisation operates its own systems, the delegation reduces to the organisation's own identity claim, but the evidence requirement stays.

_When._ Evidence can bind at three moments: at ecosystem registration (the enforcer verified the fact when the member joined), at decision time from a registry (the AS consults a store of member claims when issuing the token), or presented with the message itself. The same layer-2 facts feed all three; the binding time should match the volatility of the fact. Qualifications change rarely, so registration-time verification suffices. Delegations change more often. The treatment relationship and consent are per-patient and per-moment, so they bind at decision time.

_Which point for the context checks._ The context checks have no single right enforcement point: their inputs are per-patient and volatile, and where the evidence lives differs per deployment. The model therefore only requires that the trust framework declares the enforcement point of each check per use case (REQ-6): the AS at issuance, the AS at introspection time, or a policy decision point at the resource server. Introspection is worth singling out: there the resource server's runtime question is answered by the AS, so volatile facts can be re-evaluated on fresh data without the resource server holding any policy. Whatever the declared point, an undeclared check is a missing check; the declaration exists so that no party assumes the other one checked.

The OAuth wire is asymmetric here: the request side has a claim-carrying convention (the AccessTokenRequest), the response side has none. A topology that wants a third party to verify source-side claims at response time therefore needs a wire convention that this proposal does not define. Verifying source-side claims at registration time or at token-issuance time avoids that gap, and fails before any data is assembled.

#### One delegation mechanism, two uses

Every delegation in this model is the same mechanism: a party authorizes another to act with its authority, for a bounded period. The professional uses it in two ways. Acting in person, the professional delegates the use of their identity to the system they are logged into; the system asserts this with a UserAssertion naming the professional and their rolcode, valid for the working session. Acting under mandate, the professional has delegated the business role itself to the organisation: standing, valid until revoked; whoever operates the system, or the system running unattended, acts in the professional's name.

The two uses differ in duration and in what is conveyed (an identity versus a business role). The model keeps them apart for one reason only: under mandate the authenticated actor, if there is one, is not the role holder. The PermissionMatrix keys on that fact with its delegatable flag, and REQ-5 tests it. Attended means a UserAssertion is present. For the audit trail the distinction changes nothing: the source logs the acting individual where one exists, and the mandate where one is used.

### Examples

_This section is non-normative._ Each example shows the request scope, the AS decision summary, and the token introspection response ([RFC 7662](https://datatracker.ietf.org/doc/html/rfc7662)) that the resource server or audit subsystem would receive for the issued AT. The introspection responses are illustrative and do not specify a wire format; specific identifier values are placeholders. Trust-anchored identity claims are shown abstractly; how they are proven is out of scope.

#### Worked example: a GP consults a patient's medication agreements

**Use case** Medicatiebouwstenen, **transaction** Raadplegen medicatieafspraak. The request scope is the transaction identifier:

```
aorta.tx.mp.medicatieafspraak-raadplegen.3-0-0
```

**Layer-2 registry for this transaction**

_System-role pipeline, `SystemRolePrerequisite`._ The transaction's system role is `MedicatieafspraakRaadplegend`. Medicatieproces 9 cuts its system roles per transaction, so no refinement is needed: the qualification names the system role and thereby this one transaction. The check passes only when the request carries **both** a Qualification and a ServiceProvider delegation that name that system role:

| SystemRolePrerequisite              | for Raadplegen medicatieafspraak                |
| ----------------------------------- | ----------------------------------------------- |
| resolves                            | `MedicatieafspraakRaadplegend` (no refinement)  |
| requires Qualification              | naming `MedicatieafspraakRaadplegend`           |
| requires ServiceProvider delegation | naming `MedicatieafspraakRaadplegend`           |
{:.grid .table-hover}

_Business-role pipeline, `RolePrerequisite`._ An `AuthorizationRole` is a business role refined by a rolcode set, and the name carries the discriminator (e.g. `MedicatieRaadplegerArts`). Each row below is one filling: the rolcodes that resolve that role. All three refine the same business role `Medicatieraadpleger`, differing only in the rolcode set:

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

_Context checks (on the use case)._ Medicatiebouwstenen requires, for this patient, an Enrollment (treatment relationship) and a Mitz consent that permits sharing medication data. ContextClaims: `patient` (BSN), `Enrollment`, `mitzConsent`. In this example both checks are declared for issuance (REQ-6).

**AS decision.** A huisarts requests it, authenticated and in the loop (attended). Role resolution: `rolcode=01.015` is in the `MedicatieRaadplegerArts` set, so the role resolves to `MedicatieRaadplegerArts`; no delegation is involved. System-role pipeline: the Qualification and the ServiceProvider delegation both name `MedicatieafspraakRaadplegend`, so the QualifiedSystemRole resolves and covers the scoped transaction. Matrix: `(MedicatieRaadplegerArts, Raadplegen medicatieafspraak)` = allow, delegatable. Context checks: treatment relationship and Mitz consent pass. The AT is issued. Had the organisation's system made this request unattended (a background refresh, say), the role would only resolve with a HCP-to-HCO delegation naming `Medicatieraadpleger`, and only because the matrix cell says `delegatable = yes`.

**Issued AT (introspection).** The AS grants the SMART on FHIR scope derived from the transaction's realising operation, `search:mp-MedicationAgreement:1` (`mp-MedicationAgreement` maps to FHIR `MedicationRequest`):

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

The same medicatieafspraak fetched through a citizen's PGO is a **different transaction**, because the use case and its context checks differ: the citizen authenticates with DigiD, the role resolves to the patient rather than a professional, and there is no treatment-relationship check. Only the operation (`search:...MedicationAgreement...`) is shared, illustrating that operations are reusable realisation blocks while transactions are use-case-bound.

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
```

Role resolution resolves `AuthorizationRole = VoorschrijverArts` (`rolcode=01.015`; the voorschrijver is the authenticated principal, so no delegation); the system-role pipeline passes on system role `VoorschriftSturend` (Qualification and ServiceProvider delegation both naming it, no refinement involved); the matrix permits `(VoorschrijverArts, Sturen medicatievoorschrift)`; the AS grants the write scopes derived from the transaction's bundle operation (`transaction:mp-MedicationPrescriptionProcessing-Bundle:1`).

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

### Glossary

Translation table for the information-layer (L1) catalogue terms:

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

- **AccessTokenRequest**: the OAuth 2.0 request sent by the ServiceProvider to the AS, carrying the transaction identifier (`tx`), asserted identity claims, and context claims.
- **AS**: Authorization Server, issues access tokens.
- **AT**: Access Token.
- **AuthorizationRole**: the subject the PermissionMatrix keys on; one business role refined by a set of identity claims (typically rolcodes), resolved from presented claims by a RolePrerequisite.
- **Business role** (bedrijfsrol): the role a person plays in a transaction (Voorschrijver, Verstrekker, Toediener, ...). Unit of HealthcareProfessional-to-HealthcareOrganization delegation, and the role an AuthorizationRole refines.
- **Context check**: a per-use-case rule that evaluates ContextClaims; its enforcement point (AS at issuance, AS at introspection, or a policy decision point at the resource server) is declared per use case (REQ-6).
- **ContextClaim**: a typed assertion about the request context rather than the requester (patient, Enrollment, consent, purpose-of-use), evaluated by the use case's context checks.
- **Credential**: a set of one or more claims made by an issuer, in the W3C Verifiable Credentials sense of the term (not the NIST sense). This chapter writes credential where claims travel bundled as one artefact (the two delegations) and claim for a single assertion.
- **Dataset**: a tree of dataset concepts; either a primary dataset of an information standard or an imported building-block dataset (such as a zib).
- **DatasetConcept**: one node of a dataset (a group or an item), carrying a baseline conformance and cardinality that a transaction may restrict.
- **DEZI**: the successor programme to the UZI register for identifying healthcare professionals; it keeps the identifier and rolcode concepts. This chapter uses UZI/rolcode terminology.
- **Enrollment**: a ContextClaim for the patient's treatment relationship; the professional issues it to the organisation, attesting that they enrol or treat the patient.
- **IdentityClaim**: a typed assertion about the requester that the policy evaluates. Carried in many wire formats (signed SAML claim, Verifiable Credential, JWT claim by a trusted AS, mTLS-derived claim, ...).
- **Information layer (L1)**: the layer of the information standards; the Nictiz catalogue of use cases, transactions, roles, and datasets.
- **Information standard** (informatiestandaard): a healthcare information standard (e.g. Medicatieproces, BgZ), in the Netherlands mostly maintained by Nictiz.
- **Legal basis** (grondslag): the legal ground that makes sharing lawful (consent, treatment relationship, statutory duty). Distinct from purpose-of-use.
- **Membership**: the claim by which a HealthcareOrganization asserts admission to a trust framework or an information standard within it; the organisational counterpart of the Qualification (deelnemersovereenkomst, aansluitvoorwaarden).
- **Operation**: one FHIR interaction (search, create, ...) performed on the FHIR profile that represents a transaction's data. The unit in which the realisation catalogue maps a transaction onto FHIR, identified by an interactionId (the AORTA-on-FHIR interactietabel shape); reusable across transactions. A layer-3 concept; it does not appear in the request scope.
- **PDP**: Policy Decision Point, see [Authorization](authorization.html).
- **PermissionMatrix**: a layer 2 entity, per use case, mapping (AuthorizationRole, Transaction) to allow or deny plus a delegatable flag. Always present; may be trivial (explicit allow-all); an absent entry is deny. The AORTA realisation for medication is the _Autorisatierichtlijn medicatieveiligheid_.
- **Purpose-of-use**: the requester's declared purpose for a request (treatment, emergency, ...), a ContextClaim. Distinct from the legal basis; the declared purpose determines which legal basis must hold.
- **Qualification** (kwalificatie): the claim by which a ServiceProvider asserts that its product passed qualification for a given system role. The qualification itself is the upstream certification process.
- **QualifiedSystemRole**: a layer 2 refinement of exactly one system role by transaction coverage, answering "which of the transactions using this system role does this qualification grant". Defaults to the system role itself, covering all its transactions. Resolved by a SystemRolePrerequisite.
- **Realisation layer (L3)**: the layer that turns transactions into FHIR and OAuth artefacts: profiles, operations, scope identifiers, access tokens.
- **RolePrerequisite**: a layer 2 rule that resolves a set of identity claims to an AuthorizationRole; a role may have several, and satisfying any one is enough.
- **RS**: Resource Server, enforces SMART on FHIR scopes on FHIR endpoints.
- **SoF scope**: SMART on FHIR v2 scope, e.g. `patient/MedicationRequest.s`.
- **State rule**: a rule from the information standard's lifecycle restricting an operation to given data states and roles, listed in the realisation catalogue and enforced by the resource server while handling the request. Never carried on the access token.
- **System role** (systeemrol): the role a system plays in a transaction (Sturend, Ontvangend, Raadplegend, Beschikbaarstellend). Unit of qualification and of ServiceProvider delegation.
- **SystemRolePrerequisite**: a layer 2 rule that resolves a ServiceProvider's claims (notably its Qualification and delegation) to a QualifiedSystemRole; the system-role counterpart of a RolePrerequisite, with no matrix.
- **Transaction** (transactie): a single interaction within a transaction group, e.g. `Raadplegen verstrekkingsverzoek` (the consumer queries a source) or `Beschikbaarstellen verstrekkingsverzoeken` (the source returns the requested data). The leaf functional unit of layer 1 and the unit the PermissionMatrix authorizes against; belongs to exactly one use case. Not to be confused with the FHIR transaction interaction (an atomic `Bundle` POST), which appears as a verb in operation identifiers.
- **Transaction dataset** (transactiedataset): the subset of dataset concepts a transaction selects, each optionally restricted (conformance, cardinality, condition) relative to its baseline.
- **Transaction group** (transactiegroep): a named group of related transactions, e.g. `Verstrekkingsverzoek (raadplegen/beschikbaarstellen)`.
- **Transaction identifier**: the identifier of the scoped transaction, carried in the OAuth `scope` of the AT request and the issued AT; format `<governance-body>.tx.<information-standard>.<transaction>.<version>`.
- **Trust framework**: an independently governed set of agreements for data exchange (afsprakenstelsel).
- **Trust layer (L2)**: the layer of the trust-framework constructs: role resolution, the permission matrix, qualifications, delegations, identity and context claims.
- **Use case**: a sub-chapter of an information standard. A catalogue grouping of transaction groups; defines the intent and the context checks; not carried on the wire.
- **UserAssertion**: the IdentityClaim by which the system asserts the acting professional's identity and rolcode, valid for the working session; the professional's short-lived delegation of their identity to the system. Attended means a UserAssertion is present.
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
