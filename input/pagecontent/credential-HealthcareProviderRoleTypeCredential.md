<!--
SPDX-FileCopyrightText: 2026 Rein Krul <info@reinkrul.nl>
SPDX-FileCopyrightText: 2026 Steven van der Vegt <github@svandervegt.nl>

SPDX-License-Identifier: EUPL-1.2
-->

### HealthcareProviderRoleTypeCredential

The `HealthcareProviderRoleTypeCredential` is a verifiable credential that establishes the category or type of healthcare services,
that a provider organization is authorized to offer (e.g., hospital, general practice, pharmacy, home care).

**Issuer**: A trusted authority responsible for governing and issuing the attribute (e.g., Vektis).
**Subject**: The healthcare provider organization, identified by their DID.
**Status**: draft

#### Attributes

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
