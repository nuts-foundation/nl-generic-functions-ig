### Introduction

Authentication verifies the identity of entities, such as healthcare professionals and organizations, within healthcare systems.
Verified identities support downstream processes such as secure authorization (access control) and accounting (audit logging).

### Problem overview

When healthcare professionals work together across organizational boundaries, they need access to patient health data and related logisitical resources.
Legal and regulatory frameworks restrict data sharing between organizations and requiring strong verification of:

- The professional’s identity, role, and organizational affiliation.
- The care organization’s identity.
- The IT service provider’s identity, if involved.

In small eco-systems, these verifications can be managed through direct agreements and trusting relationships between entities (e.g., hospitals trusting each other's staff and HR systems).
However, in national-scale healthcare eco-systems with many organizations and professionals, direct agreements become impractical.

Also, traditional authentication topologies relying on a central trusted authority introduce single points of failure and may not scale well. Downtime of such a central authority can disrupt access for all dependent entities. Also, these schemes often have a use-case tailored design, providing a limited set of identity claims, making them inflexible for future use-cases. Adding new identity claims require these central authorities to expand their systems and governance, which is often a slow process.

#### Requirements

This IG is focused on establishing a robust authentication mechanism that scales in a national healthcare context. This national context requires a solution that is scalable, cost-effective, and user-friendly for healthcare professionals.
Also, it must support various (not yet known) use-cases, including those without direct end-user involvement (e.g., automated systems).
To create a robust and safe solution in a hostile global internet, the topology must avoid a single point of failure and support peer-to-peer trust, enabling direct interactions between entities without relying on the availability of third parties.

To summarize, the authentication solution must:

- Support portable identity claims issued by authoritative sources.
- Support presenting a combination of claims from different authoritative sources in a single transaction.
- Support use cases with and without direct end-user involvement.
- Enable service providers to act on behalf of care organizations, for authorized operations.
- Allow care organizations to act on behalf of healthcare professionals, for a limited time.
- Be user-friendly for healthcare professionals.
- Be flexible and adaptable to various healthcare use cases.
- Avoid single points of failure.
- Adhere to privacy-by-design and security-by-design principles.
- Leverage existing identity solutions such as x.509 certificates where possible.
- Be using existing standards and and technologies where possible.

### Terminology

Throughout this document the following terminology is used:

- Entity: Anything that can be referenced in statements as an abstract or concrete noun. Entities include but are not limited to people, organizations, physical things. Any entity might perform roles in the ecosystem.
- Subject: A thing about which claims are made.
- Agent: Software that representation a subject, either by user interaction or predefined rules.
- Service Provider: A party that offers software and/or services to its customers (e.g. healthcare organizations and healthcare professionals).
- Identity: A set of claims about a subject (e.g. person or organization) which is relevant in a specific context.
- Claim: A statement about a property of an entity (e.g. identifier, name, role, affiliation).
- Credential: A set of one or more claims made by the same entity.
- Verifiable Credential: A credential that can be cryptographically verified.
- Client: An agent that requests access to a resource on behalf of another entity.
- Issuer: A role an entity can perform by asserting claims about one or more subjects, creating a verifiable credential from these claims, and transmitting the verifiable credential to a holder.
- Authoritative source: An entity that is the authentic source of a claim
- Verifier: A role an entity performs by receiving one or more verifiable credentials, optionally inside a verifiable presentation for processing. Other specifications might refer to this concept as a relying party.
- Holder: A role an entity might perform by possessing one or more verifiable credentials and generating verifiable presentations from them. A holder is often, but not always, a subject of the verifiable credentials they are holding.
- Authentication: The process of verifying the identity of an entity.
- Authorization: The process of granting access (to resources or operations) based on the identity of an entity.
- Use-case: A specified cross organization data exchange in which authentication and authorization requirements are defined.

### Solution Overview

This guide defines the GF Authentication which is based on the _OAuth 2.0_ standard. It enables clients to obtain _Access Tokens_ using the extension defined in [RFC 7523](https://www.rfc-editor.org/rfc/rfc7523).

The involved entities in the transaction are authenticated with a [JWT Authorization Grant](https://www.rfc-editor.org/rfc/rfc7523#section-2.1).
The client itself is authenticated through a [Client Authentication Assertion](https://www.rfc-editor.org/rfc/rfc7523#section-2.2).

The _Authorization Grant_ carries verifiable identity claims for the involved parties (e.g., a healthcare provider and healthcare professional), and the _Client Authentication Assertion_ conveys the client’s own identity.

Identity claims could be long-lived and are issued in advance by their authoritative sources (such as registries responsible for maintaining identity information). These claims are represented in a cryptographically verifiable format compliant with the [Verifiable Credentials Data Model 1.1](https://www.w3.org/TR/2022/REC-vc-data-model-20220303/).

Each use case may define its own required set of claims and the corresponding trust framework governing how entities interact. _Authorization Services_ can validate the presented claims without contacting the authoritative sources at the time of authentication.

#### Actors and Transactions

The following diagram provides an overview of the actors and transactions involved in the authentication function.
The dotted lines represent the trust relations: Access tokens are trusted by the resource server if they are issued by a trusted authorization server. The authorization server implements the use-case specific trust framework and verifies the required identity claims.

<img src="authentication-overview-transactions.png" width="100%" style="float: none" alt="Overview of transactions in the authentication function."/>

**Table 7.2-1: GF Authentication - Actors and Transactions**

| Actor     | Transaction                             | Initiator or Responder | Optionality | Reference                   |
| --------- | --------------------------------------- | ---------------------- | ----------- | --------------------------- |
| Verifier  | Resolve key material [GFI-001]          | Initiator              | R           | [\[GFI-001\]](GFI-001.html) |
|           | Request Revocation status [GFI-003]     | Initiator              | R           | [\[GFI-003\]](GFI-003.html) |
|           | Request Access Token [GFI-004]          | Responder              | R           | [\[GFI-004\]](GFI-004.html) |
|           | Introspect Access Token [GFI-006]       | Responder              | O           | [\[GFI-006\]](GFI-006.html) |
| Holder    | Request key material [GFI-001]          | Responder              | R           | [\[GFI-001\]](GFI-001.html) |
|           | Issue Claims \[GFI-002\]                | Responder              | O           | [\[GFI-002\]](GFI-002.html) |
|           | Request Access Token [GFI-004]          | Initiator              | R           | [\[GFI-004\]](GFI-004.html) |
|           | Authenticated Interaction [\[GFI-005\]] | Initiator              | R           | [\[GFI-005\]](GFI-005.html) |
| Issuer    | Issue Claims [GFI-002]                  | Initiator              | O           | [\[GFI-002\]](GFI-002.html) |
|           | Request key material [GFI-001]          | Responder              | R           | [\[GFI-001\]](GFI-001.html) |
|           | Request Revocation status [GFI-003]     | Responder              | R           | [\[GFI-003\]](GFI-003.html) |
| Custodian | Authenticated Interaction [GFI-005]     | Responder              | R           | [\[GFI-005\]](GFI-005.html) |
|           | Introspect Access Token [GFI-006]       | Initiator              | O           | [\[GFI-006\]](GFI-006.html) |

{: .grid .table-striped}

### Trust Model Background

This section describes the trust model used in this IG. It introduces the key concepts and technologies that underpin the authentication approach.

#### Entity Identifiers

Traditional digital identity systems rely on centralized authorities to issue and manage identifiers. In enterprise environments, this is commonly achieved through systems like SAML or OpenID Connect, where identity providers (IdPs) act as trusted intermediaries that assert user attributes to relying parties. Similarly, X.509 certificates use a hierarchical trust model, where certificate authorities (CAs) vouch for the authenticity of a subject’s public key. These approaches work well within controlled ecosystems, for example, within a managed infrastructure, (regional) platform or between a limited set of pre-approved healthcare organisations, because all participants agree on which authorities to trust and can manage those relationships centrally.

However, they become difficult to extend across these managed boundaries or into dynamic environments such as multi-party collaborations, or peer-to-peer networks. For this reason, a lot of effort is spent on consolidating existing infrastructures and their trust frameworks.

Decentralized Identifiers (DIDs) address this limitation by replacing the notion of a centrally issued identifier with a self-controlled, globally resolvable identifier. A DID is an URI that uniquely represents an entity (a person, organization, or device) and resolves to a DID Document, a small piece of JSON-based metadata containing the entity’s public keys, service endpoints, and related cryptographic material. This document enables other parties to verify signatures or encrypt data for the DID subject without relying on a central registry or certificate authority.
In this scheme, the trust stems from cryptographic proofs rather than institutional intermediaries.

The `did:web` method offers a pragmatic bridge between traditional and decentralized systems and are published under a domain name controlled by the organization e.g., `did:web:example.com`. This leverages the existing DNS and HTTPS infrastructure to provide authenticity and discovery, ensuring that organizations can adopt decentralized identifiers without being part of a trust network such as a blockchain.

#### Verifiable Credentials

The W3C Verifiable Credentials (VC) standard defines a model for encoding, signing, and verifying claims about an entity. Conceptually, VCs are similar to SAML assertions or X.509 attribute certificates: an issuer makes claims (e.g., “Alice is a certified healthcare practitioner”) about a subject, and these claims are cryptographically signed so that verifiers can validate their authenticity and integrity. However, unlike SAML assertions that depend on live trust relationships and real-time exchanges, VCs are designed to be storable/portable: they can be presented by the holder at any time, to any verifier, without requiring the issuer to be online. This enables more flexible, privacy-preserving interactions.

Ownership of a Verifiable Credential is established through the holder’s control of the private key associated with the DID referenced in the credential’s `credentialSubject.id`. When a holder presents a credential, they prove possession of this private key by producing a cryptographic proof, for example, by signing a challenge provided by the verifier. The verifier can then use the public key found in the holder’s DID Document (resolved via HTTPS, in the case of `did:web`) to confirm that the proof is valid and indeed signed by the holder. This demonstrates that the holder controls the identifier linked to the credential.

In combination, DIDs and Verifiable Credentials enable a trust model that is decentralized yet verifiable. Authoritative registries continue to act as issuers of claims, much like certificate authorities or identity providers today, but the system no longer depends on a single central operator. This enables the combination of multiple claims to be provided to the verifier in a single transaction. The separation of claim issuer and verifier creates interoperability across administrative domains, e.g., the same healthcare organization identity can be used in different use-cases or even outside the healthcare domain.

### Choice of technologies and standards

#### Entity Identifiers

The chosen solution for the entity identifier is the [Decentralized Identifiers v1.0 standard](https://www.w3.org/TR/did-1.0/) with the [did:web method](https://w3c-ccg.github.io/did-method-web/). This method uses a domain name as the identifier. The domain name is owned by the entity and ownership can be verified by the verifier by resolving the public key hosted at the domain. This method is secured by DNSSEC and HTTPS which guarantees the domainname resolves to the correct webservice and the traffic is not altered.

#### Peer-to-peer standards

The peer-to-peer layer defines the protocols and mechanisms to establish a secure communication channel between two entities.

The dataformat to express identity claims is the [Verifiable Credentials Data Model 1.1](https://www.w3.org/TR/vc-data-model/). This standard defines how to express claims in a cryptographically verifiable way. The claims can be issued by an issuer and presented by a holder to a verifier.

To prove the ownership of a set of claims, the holder can create a [Verifiable Presentation](https://www.w3.org/TR/vc-data-model/#presentations-0) which contains one or more verifiable credentials. The verifiable presentation is signed by the holder key (which can be resolved using the method defined by the trust layer) and can be verified by the verifier.

Verifiable credentials and presentations can be encoded in different formats. We here choose to use the JWT format, because it is widely used and supported by many libraries and tools and is compatible with existing OAuth 2.0 and OpenID Connect implementations.

The protocol to request and issue verifiable credentials is [OpenID Connect for Verifiable Credential Issuance (OIDC4VCI)](https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html). This protocol is based on OpenID Connect and OAuth 2.0 and defines how to request and issue verifiable credentials between a digital agent and an authoritative registry.

The protocol to request access tokens is based on [RFC 7523](https://www.rfc-editor.org/rfc/rfc7523), an extension to the OAuth 2.x standard, which defines how to request access tokens using a JWT Authorization Grant combined with a Client Authentication assertion. The JWT Authorization Grant contains a Verifiable Presentation with the required identity claims. The Client Authentication assertion contains the identity of the client according, issued by an authoritative registry.

To prevent token theft, access tokens should be bound to the client by using [DPoP (Demonstrating Proof-of-Possession at the Application Layer)](https://www.rfc-editor.org/rfc/rfc9449). DPoP is a mechanism to bind an access token to a private key, which is used to sign an additional DPoP access token which is uniquely created for each request to the resource server.

Verifiable credentials have a long lifetime, up to several years. To be able to revoke a verifiable credential, a revocation mechanism is needed. The chosen revocation mechanism is [Bitstring Status List v1.0](https://www.w3.org/TR/vc-bitstring-status-list/), which defines a standard for revoking verifiable credentials using a bitstring. The verifier periodically retrieves (and caches) the status list and verifies the existence of the credential in the status list.

#### Summary technologies, and standards per transaction

| Transaction   | Technology / Standard                                                                                                                           | Description                                                                                                                                                                                     |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GFI-001       | [DID (Decentralized Identifier) 1.0](https://www.w3.org/TR/did-1.0/)                                                                            | DID method did:web, a domain name based identifier that hosts the DID document containing the public key                                                                                        |
| GFI-002       | [OpenID Connect for Verifiable Credential Issuance 1.0 (OpenID4VCI)](https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html) | Protocol to request and issue verifiable credentials between digital agents and authoritative registries                                                                                        |
| GFI-00\[2,4\] | [Verifiable Credentials (VC) 1.1](https://www.w3.org/TR/2022/REC-vc-data-model-20220303/)                                                       | Standard for expressing identity claims in a cryptographically verifiable way                                                                                                                   |
| GFI-00\[2,4\] | [Verifiable Presentations (VP) 1.1](https://www.w3.org/TR/2022/REC-vc-data-model-20220303/#presentations-0)                                     | Standard for presenting a set of verifiable credentials in a cryptographically verifiable way                                                                                                   |
| GFI-003       | [Bitstring Status List 1.0](https://www.w3.org/TR/vc-bitstring-status-list/) (Revocation mechanism for VCs)                                     | Standard for revoking verifiable credentials                                                                                                                                                    |
| GFI-004       | OAuth 2.0 with JWT Authorization Grant and Client Authentication Assertion                                                                      | [RFC 7523](https://www.rfc-editor.org/rfc/rfc7523) Protocol to request access tokens using a JWT Authorization Grant containing a Verifiable Presentation and a Client Authentication Assertion |
| GFI-005       | [RFC 9449 (DPoP)](https://datatracker.ietf.org/doc/html/rfc9449) (Demonstrating Proof-of-Possession at the Application Layer)                   | Mechanism to bind an access token to a public key to prevent token theft                                                                                                                        |

{: .grid .table-striped}

### Use Cases

#### Use Case 1: Healthcare Professional Accessing Patient Data

#### Use Case 2: Care Organization notifying another Care Organization

#### Use Case 3: Care Organization authenticating to a Generic Function

### Notes on user experience

TODO: Expand this section with more details and examples.

Don't let users authenticate for each access token. Let users authenticate once a day (or what is acceptable for a specific scenario) and then use this information together with organization identity to request access tokens. This is also the reason we use a back-channel OAuth 2.0 flow, so the user does not have to interact with the authorization server for each access token request.
