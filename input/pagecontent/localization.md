### Introduction
This FHIR Implementation Guide specifies the Generic Function 'Medical Record Localization' (GF Localization), a national initiative led by the Dutch Ministry of Health, Welfare and Sport (VWS). GF-Localization provides a standardized framework that enables healthcare professionals to discover which organizations hold relevant patient data of a specific type, ensuring GDPR compliance through proportionality and subsidiarity principles while facilitating secure and efficient health information exchange.

Patient data is divided over multiple data holders. In today’s healthcare landscape organizations rely on several different types of indices to find data concerning a specific patient and context. However, none of these indices are complete and
all of these indices have different requirements for usage, hindering interoperability and timely access to health information. GF-Localization addresses this challenge by providing a unified framework that ensures an index of all data holders concerning a specific patient and type is easily and securely accessible.

This guide outlines the technical requirements and architectural principles underlying GF-Localization, with a focus on trust, authenticity, and data integrity. Key design principles include:

- International standards: The solution should be based on international standards, lowering the bar for international (European) data exchange and adoption by internationally operating software vendors.
- Single Source of Truth: Each localization record originates from exactly one organization: the data holder itself.
- Stakeholder Responsibility: Data holders are accountable for maintaining the accuracy of localization records at the Localization service.

By adhering to these principles, this Implementation Guide supports consistent and secure data holder discovery, fostering improved interoperability within the healthcare ecosystem.

### Solution overview

GF-Localization follows the choices made by the MinvWS Localization working group, see [GF-Lokalisatie, ADR's](https://github.com/orgs/minvws/projects/70/views/1). This guide specifies the choices made. Most impactful/striking choice are:

- using one national Medical Record Localization Service: the 'Nationale Verwijs Index' (NVI)
- using a local metadata registry (LMR) per data holder
- reusing the FHIR-interface of the data source to act as LMR
- using one national service for pseudonymizing and depseudonymizing citizen service numbers (BSN's): the Pseudonymization Service

Here is a brief overview of the processes that are involved: 
1. Every data holder registers the presence of data concerning a specific patient and data category at the Localization service
2. A data user (practitioner and/or system (EHR)) can now use the Localization service to discover data holders for a specific patient and data category
3. Both processes require the use of pseudonyms that are generated and resolved using a national Pseudonymization Service

<img src="localization-overview-transactions.png" width="60%" style="float: none" alt="Overview of transactions in the Medical Record Localization solution."/>

For more detail on the topology of GF-Localization, see [GF-Lokalisatie, ADR-2](https://github.com/minvws/generiekefuncties-lokalisatie/issues/15). Each component, data model, and transaction will be discussed in more detail.

### Components (actors)

#### Localization Service

A (Medical Record) Localization Service is responsible for managing the registration, maintenance, and publication of localization records. It should be able to create and update localization records. A Localization Service MUST implement these [FHIR capabilities](./CapabilityStatement-nl-gf-localization-repository.html) and basically involves creating and searching for FHIR DocumentReferences (see [](#localization-record))

#### Local Metadata Register
A Local Metadata Register (LMR) is responsible for managing the registration, maintenance, and publication of the metadata of one data holder (the custodian or the healthcare organization). To implement an LMR, existing FHIR-APIs of data sources can be used. This decision was made to simplify the implementation and reduce complexity while still meeting the core requirements of metadata-based searching. [Resource Metadata](https://hl7.org/fhir/R4/resource.html#Meta) is registered in every FHIR resource type and can be found by standard [search-parameters](https://hl7.org/fhir/R4/resource.html#search). In the Netherlands, both [FHIR R4](https://hl7.org/fhir/R4/http.html) and [FHIR STU3](https://www.hl7.org/fhir/STU3/http.html) are used.

#### Pseudonymization Service
The Pseudonymization Service is responsible for creating and retrieving Polymorphic Pseudonyms of Patient identifiers. It involves multiple interactions for both a FHIR request and a FHIR response:
- the sender (of the request or response) posts their identifier/pseudonym AND the target organization to the Pseudonymization Service, which returns an opaque value.
- the receiver (of the request or response)  exchanges the opaque value for a pseudonym at the Pseudonymization Service. 
This version of the IG will not go into the details of this Pseudonymization Service and the effect on FHIR transactions. For information on this topic, see the [Logius BSNk-pp service](https://www.logius.nl/onze-dienstverlening/toegang/voorzieningen/bsnk-pp).

### Data models

#### Localization record

Within GF-Localization the [NL-gf-localization-DocumentReference profile](./StructureDefinition-nl-gf-localization-documentreference.html) is used to register, search, and validate localization records ([NL-GF-IG, ADR#10](https://github.com/nuts-foundation/nl-generic-functions-ig/issues/10)).
This data model basically states ***"Care provider X has data of type Y for Patient Z"***. It contains the following elements:
- **Organization identifier**: The care provider identifier (URA) representing the data holder/custodian.
- **Patient identifier** (BSN/pseudoBsn). The initial implementation uses plain BSN (Burgerservicenummer), which will be replaced by pseudoBsn in a later stage for enhanced privacy.
- **Type**: Represents type of data stored at the data holder/custodian. ***No ValueSet has been decided upon yet [GF-Lokalisatie, ADR#62](https://github.com/minvws/generiekefuncties-lokalisatie/issues/62), so in this IG-version, a fixed LOINC code '55188-7' is used: "Patient data Document"***

A [Location record example](./DocumentReference-52b792ba-11ae-42f3-bcc1-231f333f2317.html) is in the IG artifacts.


### Security and Privacy Considerations

#### Pseudonymization
The initial implementation uses plain BSN (Burgerservicenummer) for simplicity. In a later stage, this will be replaced with pseudo-BSNs to enhance patient privacy. The pseudonymization service will ensure that patient identities are protected while still allowing organizations to use a joint index.([GF-Lokalisatie, ADR-1](https://github.com/minvws/generiekefuncties-lokalisatie/issues/8))


#### Authentication and Authorization
Authentication and authorization follows the [GF Authorization](./authorization.html) specification. The required ***authentication and authorization*** attributes for Localization Service are:

**For POST operations (registering localization records):**
- **Organization identifier** (URA): The organization identifier of the registering organization

**For GET operations (querying localization records):**
- **Organization identifier** (URA): The organization identifier of the requesting organization (URA)
- **Organization type**: The [type of healthcare organization](./ValueSet-2.16.840.1.113883.2.4.3.11.60.40.2.17.2.3--20200901000000.html) making the query
- **Practitioner identifier** (UZI/DEZI): The unique healthcare professional identifier of the requester
- **Role code**: The [professional role code](./ValueSet-uzi-rolcode-vs.html) of the requester
- **Patient identifier** (BSN/pseudoBSN): The Patient identifier, used to check/fetch a Consent

These attributes ensure proper access control and auditing while maintaining the security requirements outlined in the [GF Authorization](./authorization.html) specification.

---

### Example Use Cases

#### Use case: Radiologist registering Imaging Data
**Scenario**: Dr. Carter, a radiologist at a care provider organization, performs an imaging study for a patient. To enable data discovery by other healthcare professionals, Dr. Carter's organization must register the existence of this imaging data in the national localization index (NVI). This process involves pseudonymizing the patient's identifier, creating a localization record, and submitting it to the NVI with the appropriate authorization attributes.

The following diagram illustrates the registration workflow, including interactions between the radiologist, the PACS system and the NVI. For brevity, interactions to the Pseudonymization Service are left out here.


{% include localization-internist-registration.svg %}


#### Use Case: Cardiologist searching for Imaging Data

**Scenario**: Dr. Smith, a cardiologist at Hospital A, is treating a patient who was recently referred from another hospital. She needs to know what imaging data (X-rays, CT scans, MRIs) might be available from other healthcare providers to avoid unnecessary duplicate examinations and to get a complete picture of the patient's medical history.

For brevity, interactions to the Pseudonymization Service are left out here.

{% include localization-cardiologist-search.svg %}


### Roadmap for GF Localization


#### Localization Service
Potential future enhancements to the Localization Service include:
- Audit logging capabilities (MUST HAVE, TODO)
- ValueSet constraint on DocumentReference.type and/or DocumentReference.category

#### Pseudonymization Service
- Specification of Pseudonymization Service API
- Specification of how to include/combine Pseudonymization transactions in FHIR request/responses