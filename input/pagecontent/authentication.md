### Introduction

Authentication is the process of verifying the identity of an entity. In the context of healthcare, authentication is used to verify the identity of healthcare professionals and care organisations. This is important to ensure that only authorized entities can access sensitive information and resources.

The verified identity is often used downstream for authorization and accounting purposes. Authorization is the process of granting access to resources based on the identity of an entity. Accounting is the process of tracking the actions of an entity.

#### Requirements

There exists a multitude of authentication solutions, therefore it is important to define the requirements for a authentication in the context of healthcare. The requirements are:

- Work with identity claims from the authoritative sources
- Support combinations of identity claims from different trusted issuers
- Support for use-cases with and without a end-user (healthcare professional)
- Support for authorizing vendors to act on behalf of an (care) organisation
- Support for limiting the scope of an authorization of a vendor
- Support for authorizing (care) organisations to act on behalf of a healthcare professional
- User-friendly solution for healthcare professionals
- Cost efficient solution for care organisations
- Flexible solution that can be adapted to different use-cases
- No single point of failure
- Privacy by design
- Securty by design
- Support for leveraging existing identity solutions

#### Terminology

Throughout this document the following terminology is used:

- Entity: An actor in the system (person or organisation)
- Agent: A digital representation of an entity that acts on its behalf, also often called an identity wallet
- Vendor: A party that offers Agents to its customers (care organisations and healthcare professionals)
- Identity: A set of claims about an entity (person or organisation) which is relevant in a specific context
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

A tipical scenario in healthcare is that a healthcare professional needs to access a resource (e.g. patient data) which is located at a different organisation (e.g. a hospital).
In the Netherlands, the custodian of the patient data is by law forbidden to share the data with third parties. Several exceptions to that rule exists. One responsibility of the custodian is to ensure that the requesting party is authorized to access the data. In order to do so, the custodian needs to verify the identity of the requesting party.

In practice, many of these data exchanges are not done directly between the healthcare professionals, but between computers and systems. Often these systems are operated by vendors on behalf of the care organisations.

On top of that, use-cases are often described and governed by a governing body. The governing body certifies healthcare organisations and vendors to operate in a specific use-case. The governing body defines the trust framework in which the use-case operates. The custodian also needs to verify that the entities operate within the trust framework of the use-case.

The custodian needs to verify the identity of the requesting healthcare professional, working for an organisation which is a customer of a vendor. The custodian needs to verify the following:

- The identity of the healthcare professional, identifier, role, and affiliation with the care organisation
- The identity of the care organisation, identifier, and its relationship with the healthcare professional
- The identity of the vendor, identifier, and its relationship with the care organisation

### Solution overview

The solution is based on exchanging verifiable identity claims between the involved parties. The claims can be flexibily combined to form a complete identity for a specific use-case. The claims can be verified by the verifier without the need of a central authority using cryptographic techniques.

#### Layered approach

Autentication is vast and complex topic. To keep the information structured we will use a layered approach. The layers are:

1. Trust layer
2. Peer-to-peer layer
3. Identity claims layer
4. Application layer

##### Trust layer

The trust layer defines techniques and governance to establish trust between entities. Each entity needs an identity in in the form of an identifier.
In order to establish trust into an entity, a party must be able to verify the identifier of the entity. Some identifiers are easier to verify than other. Identifiers that can be verified are called verifiable identifiers (VIDs).
How a verifier can verify a VID depends on the type of identifier.
Identifiers can either be externally verified by an authority (XVIDs), or self-certifying (SCIDs). Many identifiers we know are externally verified, such as your phone number or bank account. Self-certifying identifiers can be verified by a verifier without the need of a third party. An example of a self-certifying identifier is a DID (Decentralized Identifier).

Self-certifying identifiers are very useful in peer-to-peer scenarios, because they do not require a central authority to verify the identifier. This makes them suitable for use-cases where entities need to interact with each other without the need of a central authority.

Once an entity has a verifiable identifier, it can use this identifier to link non-verifiable identifiers to its identity. This will be explained in the identity claims layer.

##### Peer-to-peer layer

The peer-to-peer layer defines the protocols and mechanisms to establish a secure communication channel between two entities.

Each entity needs a digital agent to act on its behalf. The digital agent is responsible for managing the SCID, establishing secure communication channels, issuing and presenting identity claims.

This layer describes the protocols and data standards which can be used between the digital agents of the involved parties to aqcuire, present, and verify identity claims.

The identity of the above trust layer itself is not that useful in the real world. But when it is combined with identity claims it becomes useful. Identity claims are statements about an entity that can be used to verify its identity in a specific context. By combining the SCID with identity claims, an entity can prove the ownership of the claims.

##### Identity claims

The identity claims layer defines the workings of specific identity claims. Identity claims contain inforarmation about the entity such as its name, role, and affiliation. Identity claims can also be XVIDs which can not be self-certified.
These claims are usual managed by existing governance structures such as professional branches and governmental bodies. A chamber of commerce number is an result of such a governance structure.
This layer describes the information in the specific claim, how the claim can be acquired, presented, and verified. It also describes the assurance levels and the lifecycle of the claim, and the trust framework in which the claim can be used.

In order for use-case designers to choose from the available claims, a repository is needed that keeps track of the all available claims, their properties and governance bodies.

##### Application layer

The application layer defines the specific use-cases in which authentication and authorization are required. This includes the specific set of identity claims that are required to be presented, the trust framework in which the entities operate, and the protocols and mechanisms to establish a secure communication channel. It uses the lower layers of the stack to achieve this.

#### Choice of technologies per layer

| Layer              | Technology / Standard                                             | Description                                                                                                                          |
| ------------------ | ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Trust layer        | DID (Decentralized Identifier)                                    | DID web, a domain name based identifier that hosts the DID document conaining the public key                                         |
| Trust layer        | PKI (Public Key Infrastructure)                                   | X.509 certificates for the service providers of the digital agents                                                                   |
| Peer-to-peer layer | OpenID Connect for Verifiable Credential Issuance (OIDC4VCI)      | Protocol to request and issue verifiable credentials between digital agents and authoritative registries                             |
| Peer-to-peer layer | [RFC 7523](https://www.rfc-editor.org/rfc/rfc7523)                | JWT Profile for OAuth 2.0 Client Authentication and Authorization Grants to request Access tokens based on a Verifiable Presentation |
| Peer-to-peer layer | DPoP (Demonstrating Proof-of-Possession at the Application Layer) | Mechanism to bind an access token to a public key to prevent token theft                                                             |
| Peer-to-peer layer | StatusList 2021 (Revocation mechanism for VCs)                    | Standard for revoking verifiable credentials                                                                                         |
| Identity claims    | Verifiable Credentials (VC)                                       | Standard for expressing identity claims in a cryptographically verifiable way                                                        |
| Identity claims    | Verifiable Presentations (VP)                                     | Standard for presenting a set of verifiable credentials in a cryptographically verifiable way                                        |
| Application layer  | Digital Credential Query Language (DCQL)                          | Standard for expressing the required identity claims in a specific use-case                                                          |

#### Identity claims repository

Several identity claims are required to be presented. Which claims are required depends on the use-case. Each of the claims have different properties such as:

- Who can issue the claim
- How can the claim be verified
- What is the level of assurance of the claim
- Under which conditions can the claim be used
- Lifecycle of the claim (expiration, revocation, renewal)

In order for use-case writers to define which claims are required, a repository is needed that keeps track of the claims and its properties.

#### Mechanics

### The actors

- Care organisation
- Healthcare professional
- Vendor
- Verifier
- Claim Issuer

#### Relations between the actors

Vendors get authorized by care organisations to act on their behalf.
The care organisation's identity can be represented by one of the trusted Vendors.

### Use-cases

Different use-cases have different requirements for identity claims.

Each use-case requires its own governance in which it defines the needed identity claims and the trust framework in which the actors operate.

The following steps are required to establish the identity of a healthcare organisation and professional in a specific use-case.

##### Setup for organisations

- Choose a identity wallet provider
- Acuire identity claims
- Choose a vendor and authorize it to act on your behalf for a specific use-case
- Issue relationship credentials to each healthcare professional

##### Setup for healthcare professionals

- Choose a wallet
- Acquire identity claims from DEZI and your branch organization
- Acquire relationship credentials from your care organisation
- authorize the organisation to act on your behalf for a limited amount of time (e.g. 1 day)

##### Asserting identity

In the context of a use-case, several identity claims are required to be presented to the verifier.

- Get a fresh nonce from the nonce endpoint of the verifier
- Gather the required claims from your wallet or other sources
- Create a verifiable presentation including the nonce
- Present the verifiable presentation to the verifier

##### Verifying identity

- Verify the verifiable presentation
  - Verify the nonce
  - verify the signature
  - verify the expiration date
- verify the claims
  - Verify the signatures
  - Verify the revocation status
  - verify the issuer
  - verify the expiration date
- Respond with a bearer token

##### Interacting with the resource server

- Present the bearer token to the resource server along side the request
- Check the DPoP proof (or other token binding mechanism)
- The resource server verifies the bearer token by introspecting it at the oauth-authorization server
- The oauth-authorization server replies with the token status and the the provided identity claims
- The resource server verifies the token status
- The resource server verifies the identity claims and the relationships

### Sercurity considerations

#### Token binding

#### No sharing of Private Keys of certificates

#### use of TLS

Use of TLS for the vendor

#### replay attacks

nonce and timestamps
