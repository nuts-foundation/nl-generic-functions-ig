### Introduction

Authentication verifies the identity of entities — such as healthcare professionals and organizations — within healthcare systems.
Verified identities support down stream processes such as secure authorization (access control) and accounting (audit logging).

#### Requirements

The authentication solution must:

- Support identity claims issued by authoritative sources.
- Support presenting a combination of claims from multiple trusted issuers.
- Support use cases with and without direct end-user involvement.
- Enable vendors to act on behalf of care organizations, with scope-limited authorization.
- Allow care organizations to act on behalf of healthcare professionals, with time-limited authorization.
- Be user-friendly for healthcare professionals.
- Be cost-effective for care organizations.
- Be flexible and adaptable to various healthcare use cases.
- Support peer-to-peer trust, enabling direct interactions without involvement of third parties.
- Avoid single points of failure.
- Adhere to privacy-by-design and security-by-design principles.
- Leverage existing identity solutions where possible.

#### Terminology

Throughout this document the following terminology is used:

- Entity: An actor in the system (person or organization)
- Agent: A digital representation of an entity that acts on its behalf, also often called an identity wallet
- Vendor: A party that offers Agents to its customers (care organizations and healthcare professionals)
- Identity: A set of claims about an entity (person or organization) which is relevant in a specific context
- Verifiable Identifier (VID): An identifier that can be (cryptographically) verified
- Claim: A statement about an entity (e.g. name, role, affiliation)
- Verifiable Claim: A claim that can be cryptographically verified
- Issuer: An entity that issues claims about another entity
- Authoritative source: An issuer that is trusted to issue claims about a specific entity
- Verifier: An entity that verifies the identity of another entity based on its claims
- Holder: An entity that holds claims about itself or is authorized to present claims about another entity
- Authentication: The process of verifying the identity of an entity
- Authorization: The process of granting access to resources based on the identity of an entity
- Use-case: A specific scenario in which authentication and authorization are required

#### Problem overview

Healthcare professionals often require access to patient data managed by other organizations (e.g., hospitals). Legal and regulatory frameworks restrict data sharing, requiring strong verification of:

- The professional’s identity, role, and organizational affiliation.
- The care organization’s identity.
- The vendor’s identity, if involved.

### Solution overview

This guide proposes requesting Access Tokens using an extension to the OAuth 2.0 standard, specifically [RFC 7523](https://www.rfc-editor.org/rfc/rfc7523).
This extension allows the use of a JWT Authorization Grant combined with a Client Authentication assertion to request Access Tokens.
The JWT Authorization Grant contains a Verifiable Presentation with the required identity claims. The Client Authentication assertion contains the identity of the client according to an authoritative registry.

#### Actors and Transactions

<img src="authentication-overview-transactions.png" width="100%" style="float: none" alt="Overview of transactions in the authentication function."/>

**Table 7.2-1: GF Authentication - Actors and Transactions**

| Actor     | Transaction                             | Initiator or Responder | Optionality | Reference                   |
| --------- | --------------------------------------- | ---------------------- | ----------- | --------------------------- |
| Verifier  | Request key material [GFI-001]          | Initiator              | R           | [\[GFI-001\]](GFI-001.html) |
|           | Request Revocation status [GFI-003]     | Initiator              | R           | [\[GFI-003\]](GFI-003.html) |
|           | Request Access Token [GFI-004]          | Responder              | R           | [\[GFI-004\]](GFI-004.html) |
|           | Introspect Access Token [GFI-006]       | Responder              | O           | [\[GFI-006\]](GFI-006.html) |
| Holder    | Issue Claims \[GFI-002\]                | Responder              | O           | [\[GFI-002\]](GFI-002.html) |
|           | Request Access Token [GFI-004]          | Initiator              | R           | [\[GFI-004\]](GFI-004.html) |
|           | Authenticated Interaction [\[GFI-005\]] | Initiator              | R           | [\[GFI-005\]](GFI-005.html) |
| Issuer    | Issue Claims [GFI-002]                  | Initiator              | O           | [\[GFI-002\]](GFI-002.html) |
|           | Request key material [GFI-001]          | Responder              | R           | [\[GFI-001\]](GFI-001.html) |
|           | Request Revocation status [GFI-003]     | Responder              | R           | [\[GFI-003\]](GFI-003.html) |
| Custodian | Authenticated Interaction [GFI-005]     | Responder              | R           | [\[GFI-005\]](GFI-005.html) |
|           | Introspect Access Token [GFI-006]       | Initiator              | O           | [\[GFI-006\]](GFI-006.html) |

{: .grid .table-striped}

#### Layered approach

Because authentication is a complex topic, this IG tries to structure the solution in a layered approach. Each layer has its own responsibilities and can be implemented using different technologies. The layers are:

1. Trust layer
2. Peer-to-peer layer
3. Identity claims layer
4. Application layer

#### Trust layer

##### Overview

The trust layer defines techniques and governance to establish trust between entities. Each entity needs to be referenced by an identifier.
To establish trust into an entity, a verifier must be able to verify the ownership of the identifier by the entity. Some identifiers are easier to verify than others. Identifiers that can be verified are called verifiable identifiers (VIDs).
How a verifier can verify a VID depends on the type of identifier.
Identifiers can either be externally verified by an authority (XVIDs), or self-certifying (SCIDs). Many identifiers we know are externally verified, such as your phone number or bank account.
Self-certifying identifiers can be verified by a verifier without the need of a third party. An example category of a self-certifying identifier is DIDs (Decentralized Identifiers).

Self-certifying identifiers are instrumental in peer-to-peer scenarios because they do not require a central authority to verify the identifier. This makes them suitable for use-cases where entities need to interact with each other without the need of a central authority.

Once an entity has a verifiable identifier, it can use this identifier to link non-verifiable identifiers to its identity. This will be explained in the identity claims layer.

##### Choice of self-certifying identifier

The chosen solution for the trust layer is the [Decentralized Identifiers v1.0 standard](https://www.w3.org/TR/did-1.0/) with the [did:web method](https://w3c-ccg.github.io/did-method-web/). This method uses a domain name as the identifier. The domain name is owned by the entity and ownership can be verified by the verifier by resolving the public key hosted at the domain. This method is secured by DNSSEC and HTTPS which guarantees the domainname resolves to the correct webservice and the traffic is not altered.

#### Peer-to-peer layer

##### Overview

The peer-to-peer layer defines the protocols and mechanisms to establish a secure communication channel between two entities.

Each entity needs a digital agent to act on its behalf. The digital agent is responsible for managing the SCID, establishing secure communication channels with other parties, receiving and presenting identity claims.

This layer describes the protocols and data standards which can be used between the digital agents of the involved parties to acquire, present, and verify identity claims.

The identifier of the underlying trust layer is not that useful by itself. But when it is combined with identity claims, it becomes useful. Identity claims are statements about an entity that can be used to verify its identity in a specific context. By combining the SCID with identity claims, an entity can prove the ownership of the claims.

##### Choice of protocols and standards

The dataformat to express identity claims is the [Verifiable Credentials Data Model 1.1](https://www.w3.org/TR/vc-data-model/). This standard defines how to express claims in a cryptographically verifiable way. The claims can be issued by an issuer and presented by a holder to a verifier.

To prove the ownership of a set of claims, the holder can create a [Verifiable Presentation](https://www.w3.org/TR/vc-data-model/#presentations-0) which contains one or more verifiable credentials. The verifiable presentation is signed by the holder key (which can be resolved using the method defined by the trust layer) and can be verified by the verifier.

Verifiable credentials and presentations can be expressed in different formats. We here choose to use the JWT format, because it is widely used and supported by many libraries and tools and is compatible with existing OAuth 2.0 and OpenID Connect implementations.

The protocol to request and issue verifiable credentials is [OpenID Connect for Verifiable Credential Issuance (OIDC4VCI)](https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html). This protocol is based on OpenID Connect and OAuth 2.0 and defines how to request and issue verifiable credentials between a digital agent and an authoritative registry.

The protocol to request access tokens is based on [RFC 7523](https://www.rfc-editor.org/rfc/rfc7523), an extension to the OAuth 2.x standard, which defines how to request access tokens using a JWT Authorization Grant combined with a Client Authentication assertion. The JWT Authorization Grant contains a Verifiable Presentation with the required identity claims. The Client Authentication assertion contains the identity of the client according, issued by an authoritative registry.

In order to prevent token theft, the access token must be bound to the client. This can be done using [DPoP (Demonstrating Proof-of-Possession at the Application Layer)](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-dpop). DPoP is a mechanism to bind an access token to a private key, which is used to sign an additional DPoP access token which is uniquely created for each request to the resource server.

Verifiable credentials have a long lifetime, often several years. To be able to revoke a verifiable credential, a revocation mechanism is needed. The chosen revocation mechanism is [StatusList 2021](https://w3c-ccg.github.io/vc-status-list/), which defines a standard for revoking verifiable credentials using a bitstring. The verifier periodically retrieves (and caches) the status list and verifies the existence of the credential in the status list.

#### Identity claims

The identity claims layer defines the workings of specific identity claims.
Identity claims contain information about the entity such as its name, role, and affiliation.
Identity claims can also be identifiers that cannot be self-certified.
These claims are usually managed by existing governance structures such as professional branches and governmental bodies. A chamber of commerce number is a result of such a governance structure.

The identity claims layer can be seen as the "Identification" part of the Generic Function "Identification & Authentication."

This layer describes the information in the specific claim such as its schema. The issuer or issuers that are authorized to issue the claim and the trust framework in which the claim can be used.
It also describes the assurance levels and the lifecycle of the claim.

In order for use-case designers to choose from the available claims, a repository is needed that keeps track of all available claims, their properties, and governance bodies.

This IG will not define specific claims. Eventually a national repository of available claims should be established which can be used in healthcare.

One of the challenges in architecture is crossing a gap between two technologies. Many existing identity claim technologies exist and are, for example, based on X.509 certificates or SAML assertions. These technologies are not directly compatible with the verifiable credentials technology. To bridge this gap, a mapping between the existing technologies and verifiable credentials is needed.

This layer can specify techniques to solve interoperability, such as introducing custom proof types, introducing a trusted party which can map the information, or define custom verification methods. None of these solutions are ideal. Each solution has its own trade-offs. This layer can be used to specify building blocks to solve these interoperability challenges.

#### Application layer

The application layer defines requirements for specific use-cases in which authentication and authorization are required. This includes the specific set of identity claims that are required to be presented, the trust framework in which the entities operate, and the protocols and mechanisms to establish a secure communication channel. It uses the lower layers of the stack to achieve this.

To define the required identity claims, the [Digital Credential Query Language (DCQL)](https://identity.foundation/dcql/) can be used. This standard defines a way to express the required identity claims in a machine-readable way. The holder can use the DCQL query as a form of digital contract to gather the required claims from its wallet (or other sources) and by the verifier to verify the presented claims.

The DCQL language does not have to be implemented directly by holders or verifiers, but can be used by specifications to define the required claims in a machine-readable way.

#### Summary of layers, technologies, and standards

| Layer              | Transaction | Technology / Standard                                             | Description                                                                                                                          |
| ------------------ | ----------- | ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------- |
| Trust layer        | GFI-001     | DID (Decentralized Identifier)                                    | DID method did:web, a domain name based identifier that hosts the DID document conaining the public key                              |
| Peer-to-peer layer | GFI-001     | OpenID Connect for Verifiable Credential Issuance (OIDC4VCI)      | Protocol to request and issue verifiable credentials between digital agents and authoritative registries                             |
| Peer-to-peer layer | GFI-003     | [RFC 7523](https://www.rfc-editor.org/rfc/rfc7523)                | JWT Profile for OAuth 2.0 Client Authentication and Authorization Grants to request Access tokens based on a Verifiable Presentation |
| Peer-to-peer layer | GFI-005     | DPoP (Demonstrating Proof-of-Possession at the Application Layer) | Mechanism to bind an access token to a public key to prevent token theft                                                             |
| Peer-to-peer layer | GFI-003     | StatusList2021 (Revocation mechanism for VCs)                     | Standard for revoking verifiable credentials                                                                                         |
| Peer-to-peer layer | GFI-[002    | 003]                                                              | Verifiable Credentials (VC)                                                                                                          | Standard for expressing identity claims in a cryptographically verifiable way |
| Peer-to-peer layer | GFI-003     | Verifiable Presentations (VP)                                     | Standard for presenting a set of verifiable credentials in a cryptographically verifiable way                                        |
| Application layer  | None        | Digital Credential Query Language (DCQL)                          | Standard for expressing the required identity claims in a specific use-case                                                          |

{: .grid .table-striped}

#### Identity claims repository

Several identity claims are required to be presented. Which claims are required depends on the use-case. Each of the claims have different properties such as:

- Who can issue the claim?
- How can the claim be verified?
- What is the level of assurance of the claim?
- Under which conditions can the claim be used?
- Lifecycle of the claim (expiration, revocation, renewal)

In order for use-case writers to define which claims are required, a repository is needed that keeps track of the claims and their properties.

#### Mechanics

### The actors

- Care organization
- Healthcare professional
- Vendor
- Verifier
- Claim Issuer

#### Relations between the actors

Vendors get authorized by care organizations to act on their behalf.
The care organization's identity can be represented by one of the trusted Vendors.

### Use-cases

Different use-cases have different requirements for identity claims.

Each use-case requires its own governance in which it defines the necessary identity claims and the trust framework in which the actors operate.

The following steps are required to establish the identity of a healthcare organization and professional in a specific use-case.

##### Setup for organizations

- Choose an identity wallet provider
- Acquire identity claims
- Choose a vendor and authorize it to act on your behalf for a specific use-case
- Issue relationship credentials to each healthcare professional

##### Setup for healthcare professionals

- Choose a wallet
- Acquire identity claims from DEZI and your branch organization
- Acquire relationship credentials from your care organization
- Authorize the organization to act on your behalf for a limited amount of time (e.g. 1 day)

##### Asserting identity

In the context of a use-case, several identity claims are required to be presented to the verifier.

- Get a fresh nonce from the nonce endpoint of the verifier
- Gather the required claims from your wallet or other sources
- Create a verifiable presentation including the nonce
- Present the verifiable presentation to the verifier

##### Verifying identity

- Verify the verifiable presentation
  - Verify the nonce
  - Verify the signature
  - Verify the expiration date
- Verify the claims
  - Verify the signatures
  - Verify the revocation status
  - Verify the issuer
  - Verify the expiration date
- Respond with a bearer token

##### Interacting with the resource server

- Present the bearer token to the resource server alongside the request
- Check the DPoP proof (or other token-binding mechanism)
- The resource server verifies the bearer token by introspecting it at the oauth-authorization server
- The oauth-authorization server replies with the token status and the provided identity claims
- The resource server verifies the token status
- The resource server verifies the identity claims and the relationships

### Security considerations

#### Token binding

#### No sharing of private keys or certificates

#### Use of TLS

Use of TLS for the vendor

#### Replay attacks

nonce and timestamps
