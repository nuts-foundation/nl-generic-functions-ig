### Credential Catalog

This section describes the various types of verifiable credentials used in the authentication framework.
Each credential type represents a specific set of claims about an entity within the healthcare ecosystem.

Credentials defined here use identifiers that are specified by the Generic Function Identification.

#### Profile

Unless specified otherwise, every credential uses the following Verifiable Credential traits:

- **Data model**: [W3C Verifiable Credentials Data Model 1.1](https://www.w3.org/TR/vc-data-model-1.1/)
- **Proof type**: [JWT](https://www.w3.org/TR/vc-data-model-1.1/#json-web-token)
- **Signature algorithm**: `ES256`, `RS256` or `PS256`
- **Revocation method**: [Bitstring Status List v1.0](https://www.w3.org/TR/vc-bitstring-status-list/)
- **Proof of Possession**: presenter is holder: the identifier of the presenter must equal the credential subject identifier.

#### HealthcareProviderRoleTypeCredential

The `HealthcareProviderRoleTypeCredential` is a verifiable credential that establishes the category or type of healthcare services,
that a provider organization is authorized to offer (e.g., hospital, general practice, pharmacy, home care).

**Issuer**: A trusted authority responsible for governing and issuing the attribute (e.g., Vektis).
**Subject**: The healthcare provider organization, identified by their DID.
**Status**: trial use

##### Attributes

| Path         | Code or system                  | Description                                                                                   | Example |
|--------------|---------------------------------|-----------------------------------------------------------------------------------------------|---------|
| `roleCodeNL` | `2.16.840.1.113883.2.4.15.1060` | A code representing the [role of healthcare provider](identification.html#careprovider.role). | `A1`    |

**Non-normative example**:

```json
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1"
  ],
  "type": [
    "VerifiableCredential",
    "HealthcareProviderRoleTypeCredential"
  ],
  "credentialSubject": {
    "id": "did:web:wallet.example.com",
    "roleCodeNL": "A1"
  },
  "issuer": "did:web:issuer.example.com",
  "issuanceDate": "2025-12-01T12:00:00Z"
}
```

**Example use cases**:

- Data holders that check consent using Mitz, need to determine the role of the requesting organization and provide
  this as input to the Mitz closed question.
