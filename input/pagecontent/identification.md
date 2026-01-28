### Introduction

This FHIR Implementation Guide specifies the Generic Function Identification, a national initiative led by the Dutch Ministry of Health, Welfare and Sport (VWS). The GF Identification aims to establish a standardized, interoperable system for identifying healthcare organizations, IT vendor organizations, healthcare professionals, patients and data-objects, enabling reliable and efficient exchange of health data across healthcare systems and organizations.

This guide specifies the identifiers and authentic sources to be used. Key design principles include:
- Conform to national healthcare information models ('Zorginformatiebouwstenen')
- Conform to national FHIR-profiles ('nl-core profiles')
- Each identifier originates from one authentic source

By adhering to these principles, this Implementation Guide supports consistent and secure identification fostering improved interoperability within the healthcare ecosystem.

### Solution overview

The GF Identification follows the national FHIR-profiles for patient, healthcare provider and health professional. For the identification of non-care-provider organizations the GF Identification uses the Chamber of Commerce. For data-object identification a globally resolvable URL is used.

### Data-object Identification

Data objects (e.g. a FHIR resource) are frequently copied, federated, or accessed via intermediary platforms. This complicates tracking of provenance, authenticity, and the long‑term ability to locate the original source. To avoid uncontrolled dispersion of data and data redundancy (multiple version-of-the-truth), each data object SHALL be assigned an identifier by the author/owner/responsible care provider of the (original) object. 

This identifier is applied in the profiles specified in this IG (e.g. [NL-GF-Organization](./StructureDefinition-nl-gf-organization.html) or [NL-GF-HealthCareService](./StructureDefinition-nl-gf-healthcareservice.html)) and example FHIR-resources (e.g. [Organization](./Organization-631cf10e-42d6-4165-9907-11e2333d4a85.json.html) (department), [Condition](./Condition-5a7f34e7-9b7b-4e5c-ba7c-890edbc4d757.json.html) and [Task](./Task-a0fc5221-bcd9-46f1-922f-c2913dae5d63.json.html) that references the example Organization/department). For discussion and other solutions that were considered, see [GF-Identification, ADR#48](https://github.com/nuts-foundation/nl-generic-functions-ig/issues/48) and [GF-Identification, ADR#33](https://github.com/nuts-foundation/nl-generic-functions-ig/issues/33).

### Patient Identification

Patients are identified by BSN as specified in the [nl-core-Patient profile](http://nictiz.nl/fhir/StructureDefinition/nl-core-Patient). The authentic source for this identifier is Basisregistratie Personen (BRP) that is administered by Rijksdienst voor Identiteitsgegevens (RvIG). The pseudonymization service may be used to transform the BSN to/from a pseudonymized BSN (or from one pseudonymized BSN to another pseudonymized BSN). See namingsystem ['http://fhir.nl/fhir/NamingSystem/pseudo-bsn'](./NamingSystem-pseudo-bsn.html) for the specification of this identifier. 

### Practitioner Identification

Practitioners' main identifier is the UZI number (to be renamed in DEZI number) as specified in the [nl-core-HealthProfessional-Practitioner profile](http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthProfessional-Practitioner). The authentic source for this identifier is Dezi-register that is administered by CIBG.

### Care Provider Identification

Care providers' main identifier is the URA number as specified in the [nl-core-HealthcareProvider-Organization profile](http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthcareProvider-Organization). The authentic source for this identifier is URA-register that is administered by CIBG. However, organization departments, locations and healthcare services aren't registered in the LRZa (URA-register). These entities can be identified by the mandatory [local data-object identifier](#data-object-identification).

#### Role
<a name="careprovider.role"></a>
Care provider organizations are further classified by their role using the [Nictiz healthcare provider roles](https://decor.nictiz.nl/ad/#/nictiz2bbr-/terminology/codesystems/2.16.840.1.113883.2.4.15.1060/2024-11-14T22:13:01).

The system for this classification is `2.16.840.1.113883.2.4.15.1060`.

### Organization Identification

Non-care-provider organizations, like EHR software vendors, are identified by their (Dutch) Chamber of Commerce number (`identifier.system: http://www.kvk.nl/`). The authentic source for this identifier is handelsregister that is administered by Kamer van Koophandel.
