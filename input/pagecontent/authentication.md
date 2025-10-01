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
- Peer-2-peer trust which allows direct interactions between the involved parties without involvement of a third party
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

The solution is based on exchanging verifiable identity claims between the involved parties.
The claims can be flexibily combined to form a complete identity for a specific use-case.
The claims can be verified by the verifier without the need of a central authority, using cryptographic techniques.

#### Layered approach

Because authentication is a complex topic, this IG tries to structure the solution in a layered approach. Each layer has its own responsibilities and can be implemented using different technologies. The layers are:

1. Trust layer
2. Peer-to-peer layer
3. Identity claims layer
4. Application layer

#### Trust layer

##### Overview

The trust layer defines techniques and governance to establish trust between entities. Each entity needs an to be referenced by an identifier.
In order to establish trust into an entity, a verifier must be able to verify the ownership of the identifier by the entity. Some identifiers are easier to verify than other. Identifiers that can be verified are called verifiable identifiers (VIDs).
How a verifier can verify a VID depends on the type of identifier.
Identifiers can either be externally verified by an authority (XVIDs), or self-certifying (SCIDs). Many identifiers we know are externally verified, such as your phone number or bank account.
Self-certifying identifiers can be verified by a verifier without the need of a third party. An example category of a self-certifying identifiers are DIDs (Decentralized Identifiers).

Self-certifying identifiers are very useful in peer-to-peer scenarios, because they do not require a central authority to verify the identifier. This makes them suitable for use-cases where entities need to interact with each other without the need of a central authority.

Once an entity has a verifiable identifier, it can use this identifier to link non-verifiable identifiers to its identity. This will be explained in the identity claims layer.

##### Choice of self-certifying identifier

The chosen solotion for the trust layer is the [Decentralized Identifiers v1.0 standard](https://www.w3.org/TR/did-1.0/) with the [did:web method](https://w3c-ccg.github.io/did-method-web/). This method uses a domain name as the identifier. The domain name is owned by the entity and ownership can be verified by the verifier by resolving the public key hosted at the domain. This method is secured by DNSSEC and HTTPS which gearentees the domainname resolves to the correct webservice and the traffic is not altered.

##### Examples

Example did:web

```
did:web:example.com:user:alice
```

Which resolves to the DID document at:

```
https://example.com/user/alice/did.json
```

Which contains the following DID Document:

```json
{
  "@context": "https://www.w3.org/ns/did/v1",
  "id": "did:web:example.com:user:alice",
  "verificationMethod": [
    {
      "id": "did:web:example.com:user:alice#key-1",
      "type": "JsonWebKey2020",
      "controller": "did:web:example.com:user:alice",
      "publicKeyJwk": {
        "kty": "EC",
        "crv": "P-256",
        "x": "...",
        "y": "..."
      }
    }
  ],
  "authentication": ["did:web:example.com:user:alice#key-1"]
}
```

#### Peer-to-peer layer

##### Overview

The peer-to-peer layer defines the protocols and mechanisms to establish a secure communication channel between two entities.

Each entity needs a digital agent to act on its behalf. The digital agent is responsible for managing the SCID, establishing secure communication channels with other parties, receiving and presenting identity claims.

This layer describes the protocols and data standards which can be used between the digital agents of the involved parties to aqcuire, present, and verify identity claims.

The identifier of the underlaying trust layer is not that useful by itself. But when it is combined with identity claims it becomes useful. Identity claims are statements about an entity that can be used to verify its identity in a specific context. By combining the SCID with identity claims, an entity can prove the ownership of the claims.

##### Choice of protocols and standards

The dataformat to express identity claims is the [Verifiable Credentials Data Model 1.1](https://www.w3.org/TR/vc-data-model/). This standard defines how to express claims in a cryptographically verifiable way. The claims can be issued by an issuer and presented by a holder to a verifier.

To prove the ownership of a set of claims, the holder can create a [Verifiable Presentation](https://www.w3.org/TR/vc-data-model/#presentations-0) which contains one or more verifiable credentials. The verifiable presentation is signed by the holder key (which can be resolved using the method defined by the trusr layer) and can be verified by the verifier.

Verifiable credentials and presentations can be expressed in different formats. We here choose to use the JWT format, because it is widely used and supported by many libraries and tools and is comparetible with existing OAuth 2.0 and OpenID Connect implementations.

The protocol to request and issue verifiable credentials is [OpenID Connect for Verifiable Credential Issuance (OIDC4VCI)](https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html). This protocol is based on OpenID Connect and OAuth 2.0 and defines how to request and issue verifiable credentials between a digital agent and an authoritative registry.

The protocol to request access tokens is based on [RFC 7523](https://www.rfc-editor.org/rfc/rfc7523), an extension to the OAuth 2.x standard, which defines how to request access tokens using a JWT Authorization Grant combined with a Client Authentication assertion. The JWT Authorization Grant contains a Verifiable Presentation with the required identity claims. The Client Authentication assertion contains the identity of the client according, issued by an authoritative registry.

In order to prevent token theft, the access token must be bound to the client. This can be done using [DPoP (Demonstrating Proof-of-Possession at the Application Layer)](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-dpop). DPoP is a mechanism to bind an access token to a private key, which is used to sign an aditional DPoP access token which is uniquely created for each request to the resource server.

Verifiable credentials have a long lifetime, often several years. In order to be able to revoke a verifiable credential, a revocation mechanism is needed. The chosen revocation mechanism is [StatusList 2021](https://w3c-ccg.github.io/vc-status-list/), which defines a standard for revoking verifiable credentials using a bitstring. The verifier periodically retrieves (and caches) the statuslist and verifies the existance of the credential in the statuslist.

##### Examples

Example Verifiable Credential (VC) in JWT format:

```json
{
  "iss": "did:web:example.com:issuer",
  "sub": "did:web:example.com:user:alice",
  "iat": 1516239022,
  "exp": 1672531199,
  "jti": "http://example.edu/credentials/3732",
  "vc": {
    "@context": [
      "https://www.w3.org/2018/credentials/v1",
      "https://www.w3.org/2018/credentials/examples/v1"
    ],
    "type": ["VerifiableCredential", "AlumniCredential"],
    "credentialSubject": {
      "id": "did:web:example.com:user:alice",
      "alumniOf": {
        "id": "did:web:example.com:university:example",
        "name": [
          {
            "value": "Example University",
            "lang": "en"
          },
          {
            "value": "Voorbeeld Universiteit",
            "lang": "nl"
          }
        ]
      }
    },
    "credentialStatus": {
      "id": "https://example.com/status/24#94567",
      "type": "StatusList2021Entry",
      "statusPurpose": "revocation",
      "statusListIndex": "94567",
      "statusListCredential": "https://example.com/status/24"
    }
  }
}
```

Example of a Verifiable Presentation (VP) in JWT format:

```json
{
  "iss": "did:web:example.com:user:alice",
  "aud": "https://verifier.example.com",
  "iat": 1516239022,
  "exp": 1516239322,
  "jti": "http://example.edu/presentations/3732",
  "vp": {
    "@context": [
      "https://www.w3.org/2018/credentials/v1",
      "https://www.w3.org/2018/credentials/examples/v1"
    ],
    "type": ["VerifiablePresentation"],
    "verifiableCredential": [
      {
        // verifiable credential 1
      },
      {
        // verifiable credential 2
      }
    ]
  }
}
```

Example of an tokenn request using RFC 7523 with a VP in the JWT Authorization Grant:

```
POST /token HTTP/1.1
Host: oauth.example.com
Content-Type: application/x-www-form-urlencoded
grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&
assertion=eyJhbGciOiJSUzI1NiIsImtpZCI6IjIyIn0...&
client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer&
client_assertion=eyJhbGciOiJSUzI1NiIsImtpZCI6IjIyIn0...
```

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
