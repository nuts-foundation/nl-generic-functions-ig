### Introduction

Why is authentication important?

#### Requirements

- Peer 2 peer authentication without the need of a central authority
- Support of multiple identity claims from different issuers
- Support for use-cases with and without a end-user (healthcare professional)
- Support for authorizing vendors to act on behalf of an (care) organisation
- Support for authorizing (care) organisations to act on behalf of a healthcare professional
- User-friendly solution for healthcare professionals
- Cost efficient solution for care organisations
- Flexible solution that can be adapted to different use-cases
- Privacy by design
- Securty by design
- Support for leveraging existing identity solutions

#### Terminology

- Identity: A set of claims about an entity (person or organisation)
- Claim: A statement about an entity (e.g. name, role, affiliation)
- Authentication: The process of verifying the identity of an entity
- Authorization: The process of granting access to resources based on the identity of an entity
- Use-case: A specific scenario in which authentication and authorization are required

### Solution overview

The solution is based on requesting identity tokens from a OpenID Connect (OIDC) authorization server based on identity claims presented in a verifiable presentation (VP).

#### Identity claims repository

Several identity claims are required to be presented. Which claims are required depends on the use-case. Each of the claims have different properties such as:

- Who can issue the claim
- How can the claim be verified
- What is the level of assurance of the claim
- Under which conditions can the claim be used
- Lifecycle of the claim (expiration, revocation, renewal)

In order for use-case writers to define which claims are required, a repository is needed that keeps track of the claims and its properties.

#### Mechanics

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

### Sercurity considerations

#### Token binding

#### No sharing of Private Keys of certificates

#### use of TLS

Use of TLS for the vendor

#### replay attacks

nonce and timestamps
