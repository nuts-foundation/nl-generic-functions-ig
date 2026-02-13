### X509Credential

The `X509Credential` is a verifiable credential that bridges traditional X.509 Public Key Infrastructure (PKI) with
decentralized identity systems.
It enables organizations and systems that rely on existing X.509 certificate implementations (such as healthcare or
government frameworks) to leverage
those certificates within the Nuts decentralized identity ecosystem using the `did:x509` DID method.

**Data model**: [W3C Verifiable Credentials Data Model 1.1](https://www.w3.org/TR/vc-data-model-1.1/)

**Issuer**: A `did:x509` identifier, anchored in a trusted Certificate Authority (CA) through the certificate chain.

**Subject**: Any entity identified by a DID (e.g., `did:web`), typically a healthcare provider organization or system.

**Status**: production use

**Proof type**: [JWT](https://www.w3.org/TR/vc-data-model-1.1/#json-web-token)

**Signature algorithm**: `ES256`, `RS256` or `PS256`

**Revocation method**: [Bitstring Status List v1.0](https://www.w3.org/TR/vc-bitstring-status-list/)

**Proof of Possession**: presenter is holder: the identifier of the presenter must equal the credential subject
identifier.

#### Standards used

- [DID:X509 Method Specification](https://trustoverip.github.io/tswg-did-x509-method-specification/)
- [Verifiable Credentials Data Model v1.1](https://www.w3.org/TR/vc-data-model/)
- [X.509 Certificate Standards (RFC 5280)](https://datatracker.ietf.org/doc/html/rfc5280)
- [JSON Web Signature (JWS)](https://datatracker.ietf.org/doc/html/rfc7515)

#### Background

The `did:x509` DID method creates a Decentralized Identifier based on an X.509 certificate chain, with trust anchored
through a `ca-fingerprint` property that references a trusted Certificate Authority (CA). This enables organizations
with existing X.509 PKI infrastructure to use their certificates within the Nuts decentralized identity ecosystem.

#### Attributes

The `X509Credential` credentialSubject contains fields from the certificate's DID policies, grouped by policy type:

| JSON Path                          | `did:x509` policy | Attribute   | Description                                 | Example               |
|------------------------------------|-------------------|-------------|---------------------------------------------|-----------------------|
| `credentialSubject.subject.C`      | `subject`         | `C`         | Country                                     | `NL`                  |
| `credentialSubject.subject.CN`     | `subject`         | `CN`        | Common Name                                 | `example.com`         |
| `credentialSubject.subject.L`      | `subject`         | `L`         | Locality                                    | `Amsterdam`           |
| `credentialSubject.subject.ST`     | `subject`         | `ST`        | State/Province                              | `Noord-Holland`       |
| `credentialSubject.subject.O`      | `subject`         | `O`         | Organisation                                | `Ziekenhuis Oost`     |
| `credentialSubject.subject.OU`     | `subject`         | `OU`        | Organisation Unit                           | `Cardiology`          |
| `credentialSubject.subject.STREET` | `subject`         | `STREET`    | Street Address                              | `Oosterpark 101`      |
| `credentialSubject.san.email`      | `san`             | `email`     | Email address from Subject Alternative Name | `info@example.com`    |
| `credentialSubject.san.dns`        | `san`             | `dns`       | DNS name from Subject Alternative Name      | `example.com`         |
| `credentialSubject.san.uri`        | `san`             | `uri`       | URI from Subject Alternative Name           | `https://example.com` |
| `credentialSubject.san.otherName`  | `san`             | `otherName` | Free-form attribute (e.g., URA number)      | `90000380`            |
| `credentialSubject.eku.<OID>`      | `eku`             | Any OID     | Extended Key Usage                          | `1.3.6.1.5.5.7.3.2`   |

Every field in the `credentialSubject` expresses an attribute from the certificate, through the `did:x509` policies.
The fields in the `credentialSubject` are nested with their DID policies as keys, so `subject:L:Amsterdam`, becomes:

```json
{
  "sub": "did:x509:subject:O:Amsterdam",
  "credentialSubject": {
    "id": "did:x509:subject:O:Amsterdam",
    "subject": {
      "L": "Amsterdam"
    }
  }
}
```

**Non-normative example**:

JWT Header:

```json
{
  "alg": "PS256",
  "typ": "JWT",
  "x5c": [
    "<base64 encoded leaf certificate>",
    "<base64 encoded intermediate CA certificate>",
    "<base64 encoded root CA certificate>"
  ],
  "x5t#S256": "WE4P5dd8DnLHSkyHaIjhp4udlkF9LqoKwCvu9gl38jk",
  "kid": "did:x509:0:sha256:WE4P5dd8DnLHSkyHaIjhp4udlkF9LqoKwCvu9gl38jk::subject:O:OLVG::subject:L:Amsterdam::san:otherName:90000380#0"
}
```

JWT Payload:

```json
{
  "vc": {
    "@context": [
      "https://www.w3.org/2018/credentials/v1",
      "https://nuts.nl/credentials/v1"
    ],
    "type": [
      "VerifiableCredential",
      "X509Credential"
    ],
    "issuer": "did:x509:0:sha256:WE4P5dd8DnLHSkyHaIjhp4udlkF9LqoKwCvu9gl38jk::subject:O:OLVG::subject:L:Amsterdam::san:otherName:90000380",
    "issuanceDate": "2024-12-01T00:00:00Z",
    "credentialSubject": {
      "id": "did:web:example.com",
      "subject": {
        "O": "OLVG",
        "L": "Amsterdam"
      },
      "san": {
        "otherName": "90000380"
      }
    }
  },
  "sub": "did:web:example.com",
  "iss": "did:x509:0:sha256:WE4P5dd8DnLHSkyHaIjhp4udlkF9LqoKwCvu9gl38jk::subject:O:OLVG::subject:L:Amsterdam::san:otherName:90000380",
  "iat": 1733011200
}
```

#### Revocation

Credentials are considered to be revoked if either:

- The certificate used to issue the credential is revoked (check using OCSP or CRL).
  This MUST be reflected in the `did:x509` DID resolution result, so it's technically not part of the credential revocation checks.
- The credential is listed as revoked in the Bitstring Status List

#### Validation

Aside from standard JWT, Verifiable Credential, and `did:x509` validation steps (DID resolution, signature, expiration,
revocation),
verifiers MUST perform the following, additional checks specific to the `X509Credential` below.

1. Issuer is a `did:x509` DID
2. All fields in `credentialSubject` are present in the `did:x509` DID policies.
3. Check that he JWT's `sub` claim matches the `credentialSubject.id` field.
4. Check credential time validity:
    - `issuanceDate` is equal to or later than certificate's `notBefore`
    - `expirationDate` (if present) is equal to or earlier than certificate's `notAfter`

If any of these checks fail, the credential MUST be rejected as invalid.

#### Example use cases

- Healthcare organizations using UZI server certificates to authenticate and establish organizational identity in the Nuts network.
- Data holders verifying the organizational identity of a data requester based on their X.509 certificate attributes (e.g., organization name, URA number).
- Systems requiring both traditional PKI trust and decentralized identity verification.

#### Security Considerations

Implementers MUST be aware of the following security considerations:

- **Trust anchor verification**: Always verify the `ca-fingerprint` matches an accepted CA (e.g., UZI register for
  healthcare certificates)
- **Revocation checks**: Failure to check certificate revocation status may allow compromised certificates to be trusted
- **Credential subject validation**: All attributes must align with the certificate's DID policies to prevent
  impersonation

#### Original work

The `X509Credential` was originally defined by the Nuts Foundation as [RFC023](https://nuts-foundation.gitbook.io/drafts/rfc/rfc023-x509credential).