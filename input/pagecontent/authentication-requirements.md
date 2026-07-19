# General Authentication Requirements

This section defines the high-level requirements for authentication in Dutch healthcare data exchange. These requirements are technology-agnostic and focus on the functional and security needs that any authentication solution must address.

## Claims & Credential Handling

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **AUTH-001** | Identity claims SHALL be issued by the authoritative source that governs the claimed attribute | Each identity attribute (professional qualification, organization registration, role assignment) has a designated authoritative source responsible for its accuracy and lifecycle. Claims issued by parties other than the governing authority cannot be trusted and create accountability gaps. For example, a professional qualification claim must be issued by the registry that maintains professional registrations, not by an intermediary. |
| **AUTH-002** | Support presenting a combination of claims from different authoritative sources in a single transaction | A single interaction may require proof of organization identity (from URA registry), professional qualification (from BIG registry), and role assignment (from employer) - all from different authoritative sources. |
| **AUTH-003** | Verifiers SHALL be able to validate the complete chain of trust without runtime contact to the credential issuer | Runtime dependencies on external systems create availability risks and performance bottlenecks. Verification must be possible using only publicly available information and the presented credentials. |

## Delegation

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **AUTH-004** | Enable service providers to act on behalf of care organizations for authorized operations | Care organizations commonly outsource IT operations to service providers (EHR vendors, MSPs). The authentication mechanism must explicitly identify both parties in these delegated scenarios. |
| **AUTH-005** | Delegation relationships between Care Organizations and Service Providers SHALL be cryptographically verifiable | Implicit delegation (e.g., through shared certificates) undermines accountability and creates security risks. The verifier must be able to prove that delegation was explicitly authorized. |
| **AUTH-006** | A single Care Organization must be able to work with multiple Service Providers without duplicating or sharing key material | Care organizations often work with multiple vendors (EHR, imaging, lab systems). Each relationship must be independently manageable and revocable. |
| **AUTH-007** | Service Providers SHALL be able to identify themselves independently and demonstrate their qualifications and certifications | Service providers may need to prove compliance with standards (NEN 7510 certification, MedMij qualification) independent of any specific care organization relationship. |
| **AUTH-008** | For audit and compliance purposes, it must be unambiguous which Service Provider performed an action on behalf of which Care Organization | Regulatory requirements (NEN 7510, AVG/GDPR) demand clear audit trails. Both the acting party and the responsible organization must be explicitly identifiable in every transaction. |
| **AUTH-009** | Clients SHALL be able to verify the delegation from a Care Organization to a Service Provider before sending identity claims or protected health information | Clients must not leak sensitive data to unauthorized parties. Delegation verification must occur before the client sends any credentials or patient data, not as part of a response after data has already been transmitted. |
| **AUTH-010** | Service Providers operating on behalf of Care Organizations SHALL publish verifiable delegation credentials in a discoverable location | Clients need a reliable way to obtain and verify delegation proofs before initiating authenticated requests. This enables pre-flight verification without requiring custom challenge-response protocols. |

## Security & Key Material

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **AUTH-011** | Authentication flows SHALL support minimal disclosure - only claims necessary for a specific transaction should be shared with the verifier | Privacy regulations (AVG/GDPR) require data minimization. Sharing unnecessary identity information increases privacy risks and potential for misuse. |
| **AUTH-012** | Each party (Care Organization, Service Provider) SHALL maintain its own key material - no certificate/key sharing | Sharing private keys or certificates between organizations eliminates individual accountability, complicates revocation, and violates security best practices. |
| **AUTH-013** | Authentication between two parties SHALL NOT depend on the runtime availability of third parties | National-scale healthcare infrastructure cannot depend on components whose downtime would block authentication. If an authorization server or resource server is available, authentication must succeed regardless of the availability of credential issuers or other infrastructure components. |

## General & Non-Functional

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **AUTH-014** | Support use cases with and without direct end-user involvement (automated systems) | The healthcare sector requires both human-initiated access (professional accessing patient data) and automated system-to-system communication (lab results delivery, notifications). |
| **AUTH-015** | Be user-friendly for healthcare professionals (authenticate once per session/day, not per transaction) | Healthcare professionals work under time pressure. Repeated authentication interrupts clinical workflow and reduces adoption. Back-channel mechanisms should minimize user interaction. |
| **AUTH-016** | New claim types and authoritative sources SHALL be addable without requiring changes to existing infrastructure or implementations | The healthcare sector continuously develops new data exchange scenarios. Adding a new type of credential (e.g., a new professional qualification or organizational certification) must not require changes to authorization servers, clients, or resource servers that do not use that claim type. |
| **AUTH-017** | Support multiple deployment models (integrated systems, managed services, cloud solutions) without specification changes | Organizations have varying technical maturity and vendor relationships. The specification must define interoperability at the boundary, not internal implementation choices. |
| **AUTH-018** | Authentication overhead SHALL NOT noticeably impact clinical workflow | Healthcare professionals work under time pressure. Authentication delays interrupt patient care and reduce system adoption. |
| **AUTH-019** | The authentication framework SHALL integrate with existing Dutch healthcare identity infrastructure (UZI/DEZI, URA, BSN) and be based on established international standards | The Dutch healthcare sector has significant investments in existing identity systems. New solutions must build upon this infrastructure rather than replace it. Using established standards (OAuth, OpenID Connect, etc.) ensures interoperability and reduces implementation risk. |

---

# Entity Identification Requirements

## Digital Signatures & Public Key Infrastructure

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **ID-001** | Actors in the network (issuers, verifiers, service providers, care organizations) SHALL be able to assert claims by creating digital signatures | Trust between parties is established through cryptographic proof. Digital signatures enable parties to make verifiable statements about themselves and others. |
| **ID-002** | A public key infrastructure SHALL exist that allows any party to resolve the public key material for any other party | Verifiers need to obtain public keys to validate signatures on credentials and assertions. The resolution mechanism must be reliable and not depend on the signing party being online at the time of verification. |
| **ID-003** | Each actor in the network SHALL have a unique technical identifier that can be resolved to its public key material | To verify a signature, the verifier must be able to look up the signer's public key. This requires a stable technical identifier that maps to current key material. |
| **ID-004** | Technical identifiers SHALL be distinct from business identifiers (such as URA, KVK, UZI) | Business identifiers serve different purposes (legal registration, professional qualification) and have different lifecycle and governance. Coupling technical PKI identifiers to business registries creates dependencies and limitations. |
| **ID-005** | Identifier resolution SHALL be secured against tampering and impersonation, and the link between an entity's technical identifier and its public key material SHALL be cryptographically verifiable | Attackers could redirect identifier resolution to fraudulent key material or tamper with the response. The resolution mechanism must provide authenticity guarantees, and verifiers must be certain that a public key belongs to the claimed entity through tamper-evident, independently verifiable binding. |

## Key Material Management

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **ID-006** | Organizations SHALL be able to maintain multiple keys for different purposes (e.g., signing presentations vs. issuing credentials) | Key separation limits the impact of key compromise and enables fine-grained delegation. A party authorized to present credentials should not automatically be able to issue new credentials. |
| **ID-007** | Key material associated with a technical identifier SHALL be replaceable without changing the identifier itself | Keys may need rotation due to compromise, expiration, or policy changes. The identifier should remain stable to preserve references and audit history. |

## Authoritative Sources for Business Identity Claims

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **ID-008** | Each business identity claim type SHALL originate from one designated authoritative source | Authoritative sources provide trust anchors for identity claims. Multiple sources for the same claim type create ambiguity and verification complexity. |
| **ID-009** | Patients SHALL be identified using the BSN (Burgerservicenummer) with BRP as the authoritative source | The BSN is the legally mandated identifier for patients in Dutch healthcare. The BRP (Basisregistratie Personen) administered by RvIG is the authoritative source. |
| **ID-010** | Healthcare professionals SHALL be identified using the UZI/DEZI number with the CIBG registry as the authoritative source | The UZI/DEZI number uniquely identifies qualified healthcare professionals. The Dezi-register administered by CIBG is the authoritative source. |
| **ID-011** | Healthcare provider organizations SHALL be identified using the URA number with the CIBG registry as the authoritative source | The URA number uniquely identifies healthcare organizations. The URA-register (LRZa) administered by CIBG is the authoritative source. |
| **ID-012** | Non-care-provider organizations (e.g., EHR vendors, service providers) SHALL be identified using the Chamber of Commerce (KVK) number as business identifier | Service providers and IT vendors are not registered in healthcare-specific registries. The Handelsregister administered by Kamer van Koophandel is the authoritative source for legal entities. |
| **ID-013** | Healthcare provider organizations SHALL be classifiable by their role/type using a standardized classification system | Different use cases require knowledge of organization type (hospital, GP practice, pharmacy, etc.). Role classification enables policy decisions based on organization category. |
| **ID-014** | Sub-organizational entities (departments, locations, healthcare services) SHALL be identifiable through locally assigned identifiers | The URA-register does not cover sub-organizational units. These entities require local identifiers while maintaining a link to the parent organization's URA. |

## Pseudonymization

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **ID-015** | The identification framework SHALL support pseudonymization of patient identifiers where required | Privacy regulations and specific use cases may require that the BSN is not directly exchanged. A pseudonymization service must be able to transform identifiers while maintaining linkability where authorized. |

---

# OAuth Profile Requirements

This section specifies requirements for an OAuth 2.0 profile that implements the authentication and identification requirements defined above. The profile builds upon the established requirements as follows:

- **Client identification** uses the technical identifier infrastructure (ID-003, ID-005) rather than traditional OAuth client registration, enabling clients to authenticate using cryptographic proof of their identity.
- **Claims from authoritative sources** (ID-008 through ID-014) are incorporated into the token request flow, allowing verifiers to make authorization decisions based on trusted identity information.
- **Delegation relationships** (AUTH-004 through AUTH-010) are expressed through the token request, explicitly identifying all parties involved in a transaction.
- **Key material management** (ID-006, ID-007, AUTH-012) enables secure token binding and proof-of-possession mechanisms.

The profile addresses both human-initiated interactions requiring end-user authentication and automated system-to-system communication (AUTH-014), while ensuring that authentication overhead remains minimal for healthcare professionals (AUTH-015, AUTH-018).

## Client Registration & Discovery

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **OAUTH-001** | The OAuth profile SHALL NOT require pre-registration of clients at each authorization server | Traditional OAuth client registration does not scale when many clients need to interact with many authorization servers. Registration overhead must be eliminated or automated. |
| **OAUTH-002** | Newly added clients SHALL be able to request tokens from any authorization server without requiring prior configuration at that authorization server | The network must scale to many clients interacting with many authorization servers. Requiring configuration changes for each new client-server relationship creates operational burden and delays onboarding. |
| **OAUTH-003** | Authorization servers SHALL be able to identify and authenticate clients based on their technical identifier and associated key material (see ID-003, ID-005) | Client identity can be established through the same PKI infrastructure used for other actors, eliminating the need for client secrets or pre-shared credentials. |
| **OAUTH-004** | Clients SHALL be able to present verifiable claims about their identity and qualifications as part of the token request | Authorization decisions may depend on client properties (e.g., NEN 7510 certification). These claims must be verifiable without prior registration. |
| **OAUTH-005** | A trusted authority SHALL be able to issue verifiable claims about a client's identity and capabilities (e.g., software certification, network membership) | Authorization servers need assurance that clients meet certain standards. A network authority or certification body can provide verifiable claims about client qualifications without requiring bilateral registration. |
| **OAUTH-006** | Authorization servers SHALL NOT require maintained lists of approved parties or pre-configuration for each client | Centralized or distributed lists of approved parties do not scale, require synchronization, and introduce risks when not cryptographically signed. Client eligibility must be determined from verifiable claims presented at runtime. |

## Token Request Flow

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **OAUTH-007** | The OAuth profile SHALL support a back-channel token request flow (no user-agent redirect required) | Many healthcare interactions are system-to-system without user involvement (AUTH-014). Back-channel flows also improve user experience by avoiding repeated browser redirects (AUTH-015). |
| **OAUTH-008** | The token request SHALL support presenting claims about multiple subjects (e.g., care organization, healthcare professional, service provider) in a single request | A single transaction may require proof of multiple identities (AUTH-002). The token request must accommodate claims from different authoritative sources about different subjects. |
| **OAUTH-009** | The token request SHALL clearly distinguish between the entity requesting the token (client) and the entities on whose behalf access is requested (subjects) | Delegation scenarios require explicit identification of all parties (AUTH-004, AUTH-008). The client authentication and the authorization grant serve different purposes. |
| **OAUTH-010** | Claims presented in the token request SHALL be cryptographically signed by the appropriate party | The verifier must be able to validate that claims originate from the claimed issuer and are presented by the legitimate holder (AUTH-005, ID-001). |

## Audience & Scope

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **OAUTH-011** | The authorization server and resource server SHALL be identifiable by their technical identifiers | Token audience binding requires unambiguous identification of the intended recipient. Technical identifiers (ID-003) provide this. |
| **OAUTH-012** | Access tokens SHALL be bound to a specific audience (authorization server or resource server) | Tokens must not be usable at unintended resource servers. Audience restriction limits the impact of token theft. |
| **OAUTH-013** | The OAuth profile SHALL support scope-based access control aligned with use-case specific requirements | Different use cases require different levels of access (e.g., read-only vs. read-write, specific resource types). Scope-based access control is required for compatibility with SMART-on-FHIR and other healthcare OAuth profiles. |

## Token Binding & Proof-of-Possession

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **OAUTH-014** | Access tokens SHALL be bound to the client's key material to prevent token theft and replay | Bearer tokens can be stolen and replayed. Binding tokens to client keys ensures only the legitimate client can use them. |
| **OAUTH-015** | The client SHALL demonstrate proof-of-possession of the bound key material when using the access token | Key binding is only effective if the client proves possession at the time of use. Each request must include fresh proof. |
| **OAUTH-016** | Proof-of-possession mechanisms SHALL include replay protection (e.g., unique token per request, timestamps) | Attackers could capture and replay proof-of-possession tokens. Each proof must be usable only once. |

## End-User Authentication

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **OAUTH-017** | The OAuth profile SHALL support incorporating end-user authentication claims into the token request | Healthcare professional identity must be included for access control and audit (AUTH-002). User authentication may occur separately from the token request. |
| **OAUTH-018** | End-user authentication SHALL be decoupled from the token request flow | Users should authenticate once per session, not per token request (AUTH-015). The authentication result must be presentable in subsequent back-channel requests. |
| **OAUTH-019** | End-user authentication claims SHALL originate from authoritative sources (e.g., Dezi) | Professional identity claims must be trustworthy. Self-asserted user identity is insufficient for healthcare access control. |
| **OAUTH-020** | The OAuth profile SHALL support a front-channel flow for end-user authentication when user interaction is required | Some scenarios require interactive user authentication (e.g., initial login, step-up authentication). The profile must accommodate browser-based authentication flows that redirect the user to an identity provider. |

## Multi-Tenancy & Delegation

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **OAUTH-021** | The OAuth profile SHALL support authorization servers operating on behalf of multiple care organizations (multi-tenant) | Many care organizations use shared infrastructure or managed services. The token request must identify the specific organization context. |
| **OAUTH-022** | Access tokens SHALL be bound to the specific care organization context, not just the authorization server | A multi-tenant authorization server issues tokens for different organizations. The token must unambiguously identify the responsible care organization. |
| **OAUTH-023** | The OAuth profile SHALL support service providers requesting tokens on behalf of care organizations (delegation) | Service providers act on behalf of care organizations (AUTH-004). The delegation relationship must be expressed in the token request. |
| **OAUTH-024** | Authorization servers SHALL publish the delegation relationships with the Care Organizations they operate on behalf of in a discoverable location | Clients need to obtain delegation information before sending identity claims (AUTH-009, AUTH-010). This can be achieved through OAuth Authorization Server Metadata (RFC 8414), a well-known endpoint, or other discoverable mechanisms. |
| **OAUTH-025** | Clients SHALL verify the delegation from the Care Organization to the Service Provider operating the authorization server before initiating a token request | Sending identity claims to an unauthorized party leaks sensitive information. Verification must occur before any credentials are transmitted (AUTH-009). |
| **OAUTH-026** | Published delegation relationships SHALL be cryptographically verifiable using the Care Organization's public key material without runtime contact to the Care Organization | Unsigned or self-asserted delegation claims cannot be trusted. Clients must be able to verify that the Care Organization explicitly authorized the delegation. This verification must not introduce runtime dependencies (AUTH-013). |

## Token Format & Introspection

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **OAUTH-027** | Access tokens SHALL be opaque to clients | Clients must not parse or depend on token contents. This decouples the client implementation from the authorization server's internal token format, allowing authorization servers to evolve their token structure without breaking clients. It also prevents clients from making authorization decisions based on token contents - that responsibility lies with the resource server. |
| **OAUTH-028** | Resource servers SHALL be able to validate access tokens and extract identity claims | Resource servers need identity information for authorization decisions and audit logging. This may be through introspection or self-contained tokens. |
| **OAUTH-029** | Token validation SHALL be possible without synchronous calls to the authorization server | Runtime dependencies create availability risks (AUTH-003, AUTH-013). Resource servers should be able to validate tokens independently. |

## Revocation

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **OAUTH-030** | The OAuth profile SHALL support revocation of credentials used in token requests | Compromised or withdrawn credentials must be detectable. Verifiers must be able to check credential status. |
| **OAUTH-031** | Revocation status SHALL be checkable without synchronous calls to the credential issuer | Revocation checks must not create runtime dependencies (AUTH-003). Status information must be retrievable asynchronously and cacheable. |

## Privacy

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **OAUTH-032** | Token requests SHALL support minimal disclosure - only claims necessary for the specific transaction should be included | Privacy-by-design requires that verifiers receive only the information needed for their authorization decision (AUTH-011). |

## Key Rotation

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **OAUTH-033** | The OAuth profile SHALL support key rotation without requiring changes to identifiers or configuration at other parties | Operational security requires periodic key replacement. The token request flow must accommodate updated key material without disrupting established relationships or requiring coordinated configuration changes (ID-007). |

## Performance

| ID | Requirement | Rationale |
|----|-------------|-----------|
| **OAUTH-034** | Token requests SHALL complete within 400ms under normal conditions | Healthcare applications require responsive user experiences (AUTH-018). Authentication overhead must be minimized. |
