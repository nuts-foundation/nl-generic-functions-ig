<!--
SPDX-FileCopyrightText: 2026 Rein Krul
SPDX-FileCopyrightText: 2026 Steven van der Vegt

SPDX-License-Identifier: CC-BY-SA-4.0
-->

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
- **Proof of Possession**: presenter is holder: the identifier of the presenter must equal the credential subject
  identifier.

#### Credentials

This IG defined the following credential types.

| Credential                                                                                   | Description                                                                                                  | Status         |
|----------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|----------------|
| [HealthcareProviderRoleTypeCredential](credential-HealthcareProviderRoleTypeCredential.html) | Establishes the category or type of healthcare services a provider organization is authorized to offer.      | draft          |
| [DeziIDTokenCredential](credential-DeziIDTokenCredential.html)                               | Wraps a Dezi OIDC ID-Token to assert the identity of a healthcare worker and their employment relationship.  | draft          |
| [X509Credential](credential-X509Credential.html)                                             | Represents attributes from an X.509 certificate, anchored in a trusted CA through the `did:x509` DID method. | production use |

##### Credential type status

- **draft**: the credential is being developed and meant to be prototyped in non-production environments.
- **trial use**: the credential can be used in small scale pilots and production environments. Future changes might not be backwards compatible.
- **production use**: the credential is standardized and can be used in production environments. Future changes will be backwards compatible.