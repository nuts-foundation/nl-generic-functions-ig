### Introduction

This FHIR Implementation Guide specifies the Generic Function Identification, a national initiative led by the Dutch Ministry of Health, Welfare and Sport (VWS). The GF Identification aims to establish a standardized, interoperable system for identifying healthcare organizations, IT vendor organizations, healthcare professionals, patients and data-objects, enabling reliable and efficient exchange of health data across healthcare systems and organizations.

This guide specifies the identifiers and authentic sources to be used. Key design principles include:
- Conform to national healtcare information models ('Zorginformatiebouwstenen')
- Conform to national FHIR-profiels ('nl-core profiles')
- Each identifer originates from one authentic source

By adhering to these principles, this Implementation Guide supports consistent and secure identication fostering improved interoperability within the healthcare ecosystem.

### Solution overview

The GF Identification follows the national FHIR-profiels for patient, healthcare provider and health professional. For the identification of non-care-provider organizations the GF Identification uses the Chamber of Commerce. For data-object identification a globally resolvable URL is used.

### Patient Identification

Patients are identified by BSN as specified in the [nl-core-Patient profile](http://nictiz.nl/fhir/StructureDefinition/nl-core-Patient). The authentic source for this identifier is Basisregistratie Personen (BRP) that is administered by Rijksdienst voor Identiteitsgegevens (RvIG). The pseudonymization service may be used to transform the BSN to/from a pseudonymized BSN (or from one pseudonymized BSN to another pseudonymized BSN). See namingsystem ['http://fhir.nl/fhir/NamingSystem/pseudo-bsn'](./NamingSystem-pseudo-bsn.html) for the specification of this identifier. 

### Practitioner Identification

Practitioners' main identifier is the UZI number (to be renamed in DEZI number) as specified in the [nl-core-HealthProfessional-Practitioner profile](http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthProfessional-Practitioner). The authentic source for this identifier is Dezi-register that is administered by CIBG.

### Care Provider Identification

Care providers' main identifier is the URA number as specified in the [nl-core-HealthcareProvider-Organization profile](http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthcareProvider-Organization). The authentic source for this identifier is URA-register that is administered by CIBG. However, organization departments, locations and healthcare services aren't registered in the LRZa (URA-register). These entities can be identified by the mandatory [local data-object identifier](#data-object-identification). 

### Organization Identification

Non-care-provider organizations, like EHR software vendors, are identified by their (Dutch) Chamber of Commerce number (`identifier.system: http://www.kvk.nl/`). The authentic source for this identifier is handelsregister that is administered by Kamer van Koophandel.
