### Introduction

User authentication establishes the identity of an end-user (typically a healthcare professional) in cross-organizational data exchanges. While the [Authentication](authentication.html) section describes how organizations and service providers authenticate using Verifiable Credentials, this section extends that model to include authenticated end-users.

The result of user authentication is a **User Consent Credential** - a short-lived Verifiable Credential issued by a trusted Identity Provider (IDP) that attests that an authenticated user has authorized their organization to act on their behalf. This credential can be included in the Verifiable Presentation sent to an Authorization Server as part of the [Request Access Token \[GFI-004\]](GFI-004.html) transaction.

### Problem Overview

Healthcare professionals need to access patient data across organizational boundaries. The receiving organization's Authorization Server must verify:

1. **Organization identity** - Which care organization is requesting access?
2. **User identity** - Which healthcare professional is initiating the request?

The generic authentication model (see [Authentication](authentication.html)) addresses organization and service provider identity through long-lived Verifiable Credentials issued by authoritative registries. However, user identity presents additional challenges:

- Users should not authenticate for every access token request (user experience)
- Users may work for multiple healthcare organizations
- Users may have different roles at different organizations
- User authentication must prove "liveness" - that the user is actively present
- The solution must work for both internal EHR access and cross-organizational exchanges

### Requirements

The user authentication solution must:

- **Integrate with the existing VC/VP model** - User identity is expressed as a Verifiable Credential that can be combined with other credentials in a Verifiable Presentation.
- **Support session-based authentication** - Users authenticate once and can perform multiple operations without re-authenticating for each request.
- **Provide user liveness guarantees** - The credential must prove the user was recently authenticated.
- **Support audience restriction** - Presentations should be bound to specific recipients to prevent replay attacks.
- **Enable user consent** - Users must consent to sharing their identity with specific parties.
- **Leverage existing identity solutions** - Build on established authentication methods (e.g., DigiD, eHerkenning, European Digital Identity Wallet).
- **Be compatible with various (trusted) IDP implementations** - Support possible different trusted Identity Providers.

### Terminology

In addition to the terminology defined in [Authentication](authentication.html), this section uses:

- **User**: An end-user, typically a healthcare professional, who initiates data access requests.
- **Identity Provider (IDP)**: A trusted party that authenticates users and attests to their consent.
- **Authentication Session**: A time-limited session between the user and the IDP, established through user authentication.
- **Relying Party (RP)**: The client application (e.g., EHR system) that relies on the IDP to authenticate users.

### Solution Overview

#### Consent Model

When a user at Organization A accesses resources at Organization B, the fundamental question is: "Is Organization A authorized to act on behalf of this user?"

The solution models this as a **delegation of authority**:

**Statement**: "User Alice consents to Organization A acting on her behalf"

```
┌───────────┐                      ┌────────────────┐
│   Alice   │ ── delegates to ──▶  │ Organization A │
│  (User)   │                      │  (Employer)    │
└───────────┘                      └────────────────┘
      │                                    │
      │ authenticates at                   │ presents delegation to
      ▼                                    ▼
┌───────────┐                      ┌────────────────┐
│    IDP    │                      │ Organization B │
│           │                      │   (Verifier)   │
└───────────┘                      └────────────────┘
```

The IDP acts as a trusted third party that:

1. Authenticates the user (proves who they are)
2. Captures the user's consent (proves they agreed to delegate)
3. Attests to both facts for the verifier

This is fundamentally different from:

- A pure identity assertion ("This is Alice") - which only proves identity, not delegation
- An employment claim ("Alice works for Org A") - which would be issued by the organization, not the user

#### Consent Scope

The consent represents **broad delegation** - the user trusts their employer to act appropriately on their behalf. This aligns with the employment relationship:

- The user works for the organization
- The organization is accountable for appropriate use
- Audit trails track actions taken on behalf of users

This is distinct from **specific consent** where each recipient (verifier) would need to be explicitly named. Specific consent would require more user interactions but provides stronger guarantees about where the user's identity is shared.

#### Audience Binding

Audience binding (restricting who can use the attestation) happens at **presentation time**, not at consent time:

- The consent itself has no audience restriction
- When presenting to a specific verifier, the presentation is bound to that verifier
- Short validity periods provide temporal binding (user liveness)

This approach keeps the consent portable while still preventing misuse through presentation-level binding.

#### Flow Overview

The user authentication flow consists of two phases:

1. **Session Establishment** - The user authenticates with an Identity Provider, creating an authentication session.
2. **Consent Attestation** - When accessing external resources, the IDP attests to the user's consent for their organization to act on their behalf.

This attestation is encoded as a Verifiable Credential (the User Consent Credential) and included in the Verifiable Presentation alongside other credentials when requesting access tokens via [GFI-004](GFI-004.html).

#### Architecture

The following diagram shows the complete flow from initial login through credential issuance to accessing external resources.

<div>
{% include user-authentication.svg %}
</div>

**Note**: Steps 10-12 (the authorization redirect for credential issuance) are near-instant if the user has a valid browser session with the IDP and has previously consented. The user may only see a brief loading indicator.

#### Actors and Transactions

**Table: User Authentication - Actors and Transactions**

| Actor             | Transaction                     | Initiator or Responder | Optionality | Reference                                           |
| ----------------- | ------------------------------- | ---------------------- | ----------- | --------------------------------------------------- |
| User              | Authenticate with IDP           | Initiator              | R           | [Session Establishment](#session-establishment)     |
|                   | Consent to credential issuance  | Responder              | R           | [Credential Issuance](#credential-issuance)         |
| Identity Provider | Authenticate User               | Responder              | R           | [Session Establishment](#session-establishment)     |
|                   | Issue User Consent Credential   | Initiator              | R           | [Credential Issuance](#credential-issuance)         |
|                   | Resolve key material [GFI-001]  | Responder              | R           | [\[GFI-001\]](GFI-001.html)                         |
| Client (RP/EHR)   | Initiate user authentication    | Initiator              | R           | [Session Establishment](#session-establishment)     |
|                   | Request User Consent Credential | Initiator              | R           | [Credential Issuance](#credential-issuance)         |
|                   | Request Access Token [GFI-004]  | Initiator              | R           | [\[GFI-004\]](GFI-004.html)                         |
| Verifier (AS)     | Verify User Consent Credential  | Responder              | R           | [Credential Verification](#credential-verification) |
|                   | Resolve key material [GFI-001]  | Initiator              | R           | [\[GFI-001\]](GFI-001.html)                         |

{: .grid .table-striped}

### Session Establishment

The user establishes an authentication session with the Identity Provider using standard OpenID Connect flows.

#### Trigger Events

- User opens the client application (EHR) and needs to login/authenticate.
- User's existing session has expired during a credential issuance.

#### Message Flow

1. The client redirects the user to the IDP's authorization endpoint.
2. The user authenticates using a trusted authentication method (e.g., DigiD, UZI-smart card, Wallet).
3. Upon successful authentication, the IDP redirects back to the client with an authorization code.
4. The client exchanges the authorization code for tokens (ID token, access token, optionally refresh token).

#### Referenced Standards

- [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)
- Authentication methods as required by the IDP's trust framework (e.g., DigiD, UZI-Smart card, EUDI Wallet)

#### Session Characteristics

- The authentication session is established between the user's browser and the IDP.
- Session lifetime should balance security (shorter) with user experience (longer).
- The client may receive a refresh token to maintain access without requiring re-authentication.
- The session does NOT directly result in a Verifiable Credential - that happens in the next phase.

### Credential Issuance

When the client needs to access external resources on behalf of the user, it requests a User Consent Credential from the IDP using the [OpenID4VCI 1.0](https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html) Authorization Code Flow. This credential is short-lived to provide user liveness guarantees.

#### Trigger Events

- The client needs to request an access token from an external Authorization Server.
- The use-case or external Authorization Server requires proof of user identity.

#### Why Authorization Code Flow

The Authorization Code Flow is used for credential issuance because it:

- **Guarantees user liveness** - The browser redirect proves the user is present at the time of credential issuance.
- **Enables explicit consent** - The IDP can display what identity information will be shared and with whom.
- **Is near-instant with active session** - If the user has a valid browser session with the IDP, the redirects happen in milliseconds. The user may only see a brief loading state.
- **Uses standard protocols** - Built on OAuth 2.0 and OpenID4VCI, widely supported.
- **Handles session expiry gracefully** - If the session has expired, the user is prompted to re-authenticate.

#### Message Flow

<div>
{% include openid4vci-consent-issuance.svg %}
</div>

With an active session and pre-approved consent, steps 2-5 complete in milliseconds.

#### Authorization Request

The client initiates credential issuance by redirecting the user to the IDP's authorization endpoint. The request uses [RFC 9396 Rich Authorization Requests](https://datatracker.ietf.org/doc/html/rfc9396) to specify the credential type:

```
GET /authorize?
  response_type=code&
  client_id=ehr.care-org.example.com&
  redirect_uri=https://ehr.care-org.example.com/credential-callback&
  authorization_details=%5B%7B%22type%22%3A%22openid_credential%22%2C%22credential_configuration_id%22%3A%22UserIdentityCredential%22%7D%5D&
  code_challenge=E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM&
  code_challenge_method=S256&
  state=xyz789
Host: idp.example.com
```

The `authorization_details` parameter (URL-decoded) contains:

```json
[
  {
    "type": "openid_credential",
    "credential_configuration_id": "UserIdentityCredential"
  }
]
```

##### Request Parameters

| Parameter               | Required | Description                                                         |
| ----------------------- | -------- | ------------------------------------------------------------------- |
| `response_type`         | R        | Must be `code`                                                      |
| `client_id`             | R        | The client's identifier at the IDP                                  |
| `redirect_uri`          | R        | Where to send the authorization code                                |
| `authorization_details` | R        | JSON array specifying the credential type per RFC 9396              |
| `code_challenge`        | R        | PKCE challenge (SHA256 of code_verifier, base64url-encoded)         |
| `code_challenge_method` | R        | Must be `S256`                                                      |
| `state`                 | R        | Opaque value for CSRF protection                                    |
| `issuer_state`          | O        | Binds request to previous IDP context (e.g., from credential offer) |
| `prompt`                | O        | Controls IDP behavior (see below)                                   |

{: .grid .table-striped}

##### The `prompt` Parameter

Since the credential represents user consent for delegation, the user should always be aware when a credential is issued. The `prompt` parameter controls the level of user interaction:

| Value     | Behavior                                   | Use Case                                                |
| --------- | ------------------------------------------ | ------------------------------------------------------- |
| `consent` | Show consent screen (if session valid)     | Default - user confirms delegation                      |
| `login`   | Force re-authentication, then show consent | For sensitive operations requiring fresh authentication |

{: .grid .table-striped}

The `prompt=none` option (silent authentication) is not appropriate for consent credentials, as the user should be aware when authorizing their organization to act on their behalf.

#### User Consent

When the user is redirected to the IDP:

1. **Session check** - IDP verifies the user has a valid browser session. If not, the user must authenticate.
2. **Consent check** - IDP determines if user consent is needed for this credential type.
3. **Consent display** (if needed) - IDP shows what identity information will be included in the credential.
4. **Authorization code** - Upon approval, IDP redirects back with an authorization code.

The consent screen should clearly indicate:

- That the user is authorizing their organization to act on their behalf
- What identity claims will be included in the credential
- That the credential may be used to access external resources

If the user has previously consented to this credential type, the IDP may skip the consent screen (unless `prompt=consent` is specified).

#### Token Exchange

The client exchanges the authorization code for an access token, including the PKCE verifier:

```
POST /token HTTP/1.1
Host: idp.example.com
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code&
code=SplxlOBeZQQYbYS6WxSbIA&
redirect_uri=https://ehr.care-org.example.com/credential-callback&
client_id=ehr.care-org.example.com&
code_verifier=dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk
```

#### Credential Request

Using the access token, the client requests the User Consent Credential from the credential endpoint. The request includes a `proof` parameter - a JWT signed by the organization's key. The IDP uses the `kid` from the proof JWT header to determine which DID should be used as the credential subject:

```
POST /credential HTTP/1.1
Host: idp.example.com
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "format": "jwt_vc_json",
  "credential_definition": {
    "type": ["VerifiableCredential", "UserConsentCredential"]
  },
  "proof": {
    "proof_type": "jwt",
    "jwt": "eyJhbGciOiJFUzI1NiIsInR5cCI6Im9wZW5pZDR2Y2ktcHJvb2Yrand0Iiwia2lkIjoiZGlkOndlYjpjYXJlLW9yZy1hLmV4YW1wbGUuY29tI2tleTEifQ..."
  }
}
```

The proof JWT structure:

```json
// Header
{
  "typ": "openid4vci-proof+jwt",
  "alg": "ES256",
  "kid": "did:web:care-org-a.example.com#key1"
}
// Payload
{

  "iss": "ehr.care-org.example.com",
  "aud": "https://idp.example.com",
  "iat": 1704067200,
}
```

The IDP extracts the DID from the `kid` header (the part before `#`) and uses it as the `credentialSubject.id` in the issued credential. By verifying the proof signature, the IDP ensures the requesting organization controls the private key associated with that DID.

#### Credential Response

The IDP returns a User Consent Credential as a JWT-encoded Verifiable Credential:

```json
{
  "iss": "did:web:idp.example.com",
  "sub": "did:web:care-org-a.example.com",
  "iat": 1704067200,
  "exp": 1704070800,
  "nbf": 1704067200,
  "jti": "urn:uuid:3978344f-8596-4c3a-a978-8fcaba3903c5",
  "vc": {
    "@context": [
      "https://www.w3.org/2018/credentials/v1",
      "https://nuts.nl/credentials/v1"
    ],
    "type": ["VerifiableCredential", "UserConsentCredential"],
    "credentialSubject": {
      "id": "did:web:care-org-a.example.com",
      "actingFor": {
        "id": "did:web:idp.example.com:users:alice",
        "givenName": "Alice",
        "familyName": "Smith",
        "identifier": {
          "system": "urn:oid:2.16.528.1.1007.3.1",
          "value": "123456789"
        }
      },
      "consentGiven": "2024-01-01T10:30:00Z"
    }
  }
}
```

The credential states: "The IDP attests that user Alice has consented to Organization A acting on her behalf."

#### Credential Characteristics

| Property | Value                      | Rationale                                       |
| -------- | -------------------------- | ----------------------------------------------- |
| Lifetime | Short (e.g., 5-60 minutes) | Provides user liveness guarantee                |
| Subject  | Organization's DID         | The entity receiving the delegation             |
| Issuer   | IDP's DID                  | Trusted third party that authenticated the user |

{: .grid .table-striped}

### Including User Consent in Access Token Requests

The User Consent Credential is included in the Verifiable Presentation sent to the Authorization Server as part of [GFI-004](GFI-004.html).

#### Verifiable Presentation Structure

The VP contains multiple credentials:

1. **Organization Credential** - Identifies the requesting care organization
2. **User Consent Credential** - Attests user consent for the organization to act on their behalf
3. **Service Provider Credential** (optional) - Identifies the software/service provider

The VP's `aud` claim specifies the intended verifier, providing audience binding for the entire presentation:

```json
{
  "iss": "did:web:care-org-a.example.com",
  "aud": "did:web:care-org-b.example.com",
  "iat": 1704067200,
  "exp": 1704067260,
  "jti": "urn:uuid:6c46d6e2-5b3a-4e7d-9f8a-1b2c3d4e5f6a",
  "vp": {
    "@context": ["https://www.w3.org/2018/credentials/v1"],
    "type": ["VerifiablePresentation"],
    "verifiableCredential": [
      "<organization-credential-jwt>",
      "<user-consent-credential-jwt>"
    ]
  }
}
```

Note that the VP is signed by `care-org-a` (the holder) and the `aud` is set to `care-org-b` (the verifier). The verifier checks that the User Consent Credential's subject matches the VP issuer.

### Credential Verification

The Authorization Server verifies the User Consent Credential as part of processing the access token request.

#### Verification Steps

1. **Verify VP audience** - Confirm the VP's `aud` claim matches the Authorization Server's identifier.
2. **Verify VP signature** - Verify the VP is signed by the presenting organization. The VP's `iss` claim identifies the presenter.
3. **Extract credentials** - Identify the User Consent Credential among the presented credentials.
4. **Verify credential signature** - Resolve the IDP's DID ([GFI-001](GFI-001.html)) and verify the credential signature.
5. **Verify holder binding** - Confirm the credential's subject (`credentialSubject.id`) matches the VP's issuer (`iss`). This ensures the organization presenting the VP is the same organization that received the user's consent.
6. **Verify temporal validity** - Check `iat`, `nbf`, and `exp` claims on the credential.
7. **Verify issuer trust** - Confirm the IDP is trusted for issuing User Consent Credentials.
8. **Extract user claims** - Use the `actingFor` claims for authorization decisions and audit logging.

#### Holder Binding Verification

The holder binding check (step 5) is critical. It ensures that only the organization named in the credential can present it:

```
VP:
  iss: did:web:care-org-a.example.com  ← presenter
  aud: did:web:care-org-b.example.com  ← verifier

User Consent Credential (inside VP):
  credentialSubject.id: did:web:care-org-a.example.com  ← must match VP.iss
```

If `VP.iss` ≠ `credentialSubject.id`, the credential is being presented by an organization other than the one that received the consent, and MUST be rejected.

#### Trust Framework Considerations

The Authorization Server must maintain a list of trusted Identity Providers. This trust can be established through:

- A published trust list of approved IDPs
- Mutual agreements between organizations
- A federated trust framework (e.g., based on eIDAS)

### User Consent Credential Schema

The User Consent Credential contains claims about the delegation of authority from user to organization.

#### Credential Subject Claims

| Claim          | Required | Description                                                  |
| -------------- | -------- | ------------------------------------------------------------ |
| `id`           | R        | The organization's DID (the entity receiving the delegation) |
| `actingFor`    | R        | Object containing the user's identity claims                 |
| `consentGiven` | O        | Timestamp when consent was given                             |

{: .grid .table-striped}

#### User Claims (within `actingFor`)

| Claim            | Required | Description                                           |
| ---------------- | -------- | ----------------------------------------------------- |
| `id`             | R        | The user's DID at the IDP                             |
| `givenName`      | O        | User's given name                                     |
| `familyName`     | O        | User's family name                                    |
| `identifier`     | O        | National identifier (e.g., BSN pseudonym, UZI number) |
| `assuranceLevel` | O        | Level of identity assurance (e.g., eIDAS level)       |

{: .grid .table-striped}

The specific claims required depend on the use case and should be defined by the applicable trust framework.

### Security Considerations

#### Credential Lifetime

User Consent Credentials should be short-lived (recommended: 5-60 minutes) to:

- Ensure user liveness - the credential proves recent authentication
- Limit exposure if credentials are compromised
- Align with session timeout policies

#### Audience Binding

Audience binding occurs at the **Verifiable Presentation level**, not the credential level (see [Credential Semantics](#credential-semantics)). The VP's `aud` claim specifies the intended recipient:

- The Authorization Server MUST verify the VP's `aud` claim matches its own identifier
- The short credential lifetime limits the window for potential misuse
- The organization (holder) is accountable for appropriate use of credentials

#### Key Management

- The IDP's signing keys must be properly secured (e.g., HSM)
- Key rotation should be supported through DID document updates
- Verifiers should cache DID documents appropriately (respecting cache headers)

#### Session Security

- Authentication sessions should be protected against session hijacking
- Refresh tokens should be sender-constrained where possible
- Session revocation should invalidate the ability to issue new credentials

### Privacy Considerations

#### Minimal Disclosure

- Only include necessary claims in the User Consent Credential
- Consider using pseudonymous identifiers where full identity is not required
- Support selective disclosure where the trust framework allows

#### User Consent

- Users must be informed about what identity information is shared
- Users should have the ability to deny credential issuance
- Consent should be specific to the intended recipient

#### Audit Trail

- Both the IDP and the client should log credential issuance events
- Logs should support accountability without unnecessarily exposing user data

### Relationship to Other Specifications

| Specification                         | Relationship                                                                |
| ------------------------------------- | --------------------------------------------------------------------------- |
| [Authentication](authentication.html) | User authentication extends the base authentication model with user consent |
| [GFI-001](GFI-001.html)               | IDP's DID is resolved to verify credential signatures                       |
| [GFI-002](GFI-002.html)               | User Consent Credential issuance uses OpenID4VCI                            |
| [GFI-004](GFI-004.html)               | User Consent Credential is included in the VP for access token requests     |
| [Identification](identification.html) | User identifiers follow the identification guidelines                       |

{: .grid .table-striped}

### Example Flow

This example shows the complete flow for a healthcare professional accessing patient data at an external care provider.

#### 1. Session Establishment - User Authenticates with IDP

The user logs into the EHR system. The client redirects to the IDP for authentication:

```http
GET /authorize?response_type=code&client_id=ehr.care-org.example.com&redirect_uri=https://ehr.care-org.example.com/callback&scope=openid%20profile&code_challenge=E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM&code_challenge_method=S256&state=abc123 HTTP/1.1
Host: idp.example.com
```

User authenticates via DigiD. IDP redirects back:

```http
HTTP/1.1 302 Found
Location: https://ehr.care-org.example.com/callback?code=SplxlOBeZQQYbYS6WxSbIA&state=abc123
```

#### 2. Client Exchanges Code for Session Tokens

```http
POST /token HTTP/1.1
Host: idp.example.com
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code&code=SplxlOBeZQQYbYS6WxSbIA&redirect_uri=https%3A%2F%2Fehr.care-org.example.com%2Fcallback&client_id=ehr.care-org.example.com&code_verifier=dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk
```

Response:

```json
{
  "access_token": "session_token_xyz",
  "token_type": "Bearer",
  "expires_in": 3600,
  "id_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

User now works in the EHR system...

#### 3. Credential Issuance - User Accesses External Resource

When the user needs to access data at Care Provider X, the client initiates OpenID4VCI authorization code flow:

```http
GET /authorize?response_type=code&client_id=ehr.care-org.example.com&redirect_uri=https://ehr.care-org.example.com/credential-callback&authorization_details=%5B%7B%22type%22%3A%22openid_credential%22%2C%22credential_configuration_id%22%3A%22UserIdentityCredential%22%7D%5D&code_challenge=E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM&code_challenge_method=S256&state=xyz789 HTTP/1.1
Host: idp.example.com
```

Since the user has a valid session, the IDP immediately redirects back (or shows a brief consent screen for first-time access):

```http
HTTP/1.1 302 Found
Location: https://ehr.care-org.example.com/credential-callback?code=Qcb0Orv1zh&state=xyz789
```

#### 4. Client Exchanges Code for Credential Access Token

```http
POST /token HTTP/1.1
Host: idp.example.com
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code&code=Qcb0Orv1zh&redirect_uri=https%3A%2F%2Fehr.care-org.example.com%2Fcredential-callback&client_id=ehr.care-org.example.com&code_verifier=another_verifier_string
```

#### 5. Client Requests User Consent Credential

The client includes a proof JWT signed with the organization's key:

```http
POST /credential HTTP/1.1
Host: idp.example.com
Authorization: Bearer {credential_access_token}
Content-Type: application/json

{
  "format": "jwt_vc_json",
  "credential_definition": {
    "type": ["VerifiableCredential", "UserConsentCredential"]
  },
  "proof": {
    "proof_type": "jwt",
    "jwt": "eyJhbGciOiJFUzI1NiIsInR5cCI6Im9wZW5pZDR2Y2ktcHJvb2Yrand0Iiwia2lkIjoiZGlkOndlYjpjYXJlLW9yZy1hLmV4YW1wbGUuY29tI2tleTEifQ..."
  }
}
```

#### 6. IDP Returns User Consent Credential

```json
{
  "credential": "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImlkcC1rZXktMSJ9...",
  "format": "jwt_vc_json"
}
```

#### 7. Client Requests Access Token at Resource Server (GFI-004)

The client creates a Verifiable Presentation containing the Organization Credential and the User Consent Credential:

```http
POST /oauth/token HTTP/1.1
Host: auth.care-provider-x.example.com
Content-Type: application/x-www-form-urlencoded

grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9...&client_assertion_type=urn%3Aietf%3Aparams%3Aoauth%3Aclient-assertion-type%3Ajwt-bearer&client_assertion=eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9...
```

The `assertion` JWT contains a VP (with `aud` set to Care Provider X) containing:

- Organization Credential (identifies Care Organization)
- User Consent Credential (attests user consent for Care Organization to act on their behalf)

#### 8. Resource Server Returns Access Token

```json
{
  "access_token": "resource_access_token_abc",
  "token_type": "DPoP",
  "expires_in": 300
}
```

The client can now access protected resources at Care Provider X using this access token.

### Open Issues

1. **IDP Discovery** - How does the Authorization Server discover which IDPs are trusted?
2. **Role Claims** - Should role/function claims be included in the User Consent Credential (in `actingFor`) or in a separate Employment Credential issued by the organization?
3. **Specific Consent** - Should there be an option for audience-specific consent (naming the intended recipient in the credential) for use cases requiring stronger guarantees?
