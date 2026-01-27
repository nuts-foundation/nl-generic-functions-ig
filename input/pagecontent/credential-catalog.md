### Credential Catalog

This section describes the various types of verifiable credentials used in the authentication framework.
Each credential type represents a specific set of claims about an entity within the healthcare ecosystem.

Credentials defined here use identifiers that are specified by the Generic Function Identification.

#### HealthcareProviderTypeCredential

The `HealthcareProviderTypeCredential` is a verifiable credential that asserts the type classification of a healthcare provider organization.

**Purpose**: To establish the category or type of healthcare services that a provider organization is authorized to offer (e.g., hospital, general practice, pharmacy, home care).
**Issuer**: A trusted authority responsible (e.g., Vektis).
**Subject**: The healthcare provider organization, identified by their DID.
**Claims**:
- `healthcareProviderType`: A code representing the [type of healthcare provider](identification.html#careprovider.type) (e.g., "A1" for a specific provider category).

**Non-normative example**:

```json
{
    "@context": ["https://www.w3.org/2018/credentials/v1"],
    "type": ["VerifiableCredential", "HealthcareProviderTypeCredential"],
    "credentialSubject": {
      "id": "did:web:wallet.example.com",
      "healthcareProviderType": "A1"
    },
    "issuer": "did:web:issuer.example.com",
    "issuanceDate": "2025-12-01T12:00:00Z"
}
```

**Use cases**:
- Data holders that check consent using Mitz need the healthcare provider type of the requesting organization to determine, as input for Mitz.
