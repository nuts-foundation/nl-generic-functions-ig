### Introduction
This FHIR Implementation Guide specifies the Generic Function Localization (GFL), a national initiative led by the Dutch Ministry of Health, Welfare and Sport (VWS). GFL aims to establish a standardized, interoperable system that makes data concerning a specific patient and context findable to data users in a way that complies with the proportionality and subsidiarity principles of the GDPR, enabling reliable and efficient exchange of health data across systems.

Patient data is divided over muliple data holders. In today’s healthcare landscape organizations rely on several different types of indices to find data concerning a specific patient and context. However, none of these indices are complete and
all of these indices have different requirements for usage, hindering interoperability and timely access to health information. GFL addresses this challenge by providing a unified framework that ensures a nation-wide index of all data holders concerning a specific patient and context is easily and securely accessible.

This guide outlines the technical requirements and architectural principles underlying GFL, with a focus on trust, authenticity, and data integrity. Key design principles include:

- International standards: The solution should be based on international standards, lowering the bar for international (European) data exchange and adoption by internationally operating software vendors.
- Single Source of Truth: Each localization record originates from exactly one organization: the data holder itself.
- Stakeholder Responsibility: Data holders are accountable for maintaining the accuracy of localization records in the nation-wide index.

By adhering to these principles, this Implementation Guide supports consistent and secure data holder discovery, fostering improved interoperability within the healthcare ecosystem.

### Solution overview

GFL follows the choices made by the MinvWS Data Localization working group, see [GF-Lokalisatie, ADR's](https://github.com/orgs/minvws/projects/70/views/1). This guide specifies the choices made. Most impactful/striking choice are:

- using one national localization index: the NVI ('nationale verwijsindex')
- using a local metadata registry (LMR) per data holder
- reusing the FHIR-interface of the data source to act as LMR
- using one national service for pseudonymizing and depseudonymizing citizen service numbers (BSN's): the pseudo-bsn-service

Here is a brief overview of the processes that are involved: 
1. Every data holder registers the presence of data concering a specific patient and context at the NVI
2. A data user (practitioner and/or system (EHR)) can now use the NVI to discover data holders for a specific patient and context
3. Both processes require the use of BSN-pseudonyms that are generated and resolved using a national Pseudo-BSN-service

<img src="localization-overview-transactions.png" width="60%" style="float: none" alt="Overview of transactions in the Data Localization solution."/>

For more detail on the topology of GF Localization, see [GF-Lokalisatie, ADR-2](https://github.com/minvws/generiekefuncties-lokalisatie/issues/15). Each component, data model, and transaction will be discussed in more detail.

### Components (actors)

#### NVI

The NVI ('nationale verwijsindex') is responsible for managing the registration, maintenance and publication of localization records. It should be able to create, update, and delete localization records. Localization records MUST conform to the [Localization Record data model](#Localization-record). NVI MUST implement the [NVI API specifications](#NVI-API).

#### LMR
A LMR ('lokaal metadata-register') is responsible for managing the registration, maintenance and publication of the metadata of one data holder (healthcare organization). It should be able to create, update, and delete metadata. Metadata MUST conform to the [Metadata data model](#Metadata). LMR's MUST implement the [LMR API specifications](#LMR-API).

#### Pseudo-BSN-service
The pseudo-bsn-service is responsible for managing the registration, maintenance and publication of bsn peudonyms. It should be able to create bsn pseudonyms. BSN pseudonyms MUST conform to the [BSN-pseudonym data model](#Pseudo-BSN). The pseudo-bsn-service MUST implement the [bsn-pseudo-service API specifications](#pseudo-bsn-service-api).

### Data models

Within GF Localization, valuesets are used to validate data. Ideally, these valuesets are merged in the nl-core-profiles in the future.

A brief description of the data models and their profile for this guide:

#### Localization record

Localization records represent the relationship between:
- **BSN/pseudoBsn**: The patient identifier. The initial implementation uses plain BSN (Burgerservicenummer), which will be replaced by pseudoBsn in a later stage for enhanced privacy.
- **zorgContext (Care Context)**: The medical context or specialty, represented by SNOMED CT codes. The Localization record data model supports the care contexts (zorgContext) specified in [FHIR Valueset Data localization context](./ValueSet-nl-gf-data-localization-context-vs.html).
- **ura**: The organization identifier representing the data holder (care provider).
- **organizationType**: The type of healthcare organization (e.g., hospital, pharmacy, laboratory) of the data holder. The Localization record data model supports the organization types (OrganisatieType) specified in [FHIR Valueset Organization types](./ValueSet-2.16.840.1.113883.2.4.3.11.60.40.2.17.2.3--20200901000000.html).

#### Metadata

Metadata has to follow this and that fhir documentation. Bram?

#### Pseudo-BSN

Pseudo-BSN's follow this data model. Later!

### API specifications

#### NVI API

For implementing NVI, we have chosen to use a simple JSON-based REST API instead of FHIR resources. This decision was made to simplify the implementation and reduce complexity while still meeting the core requirements of tracking which organizations have data about a patient in specific care contexts.

The [NVI API](./localization.openapi.json) is defined using OpenAPI 3.0.2 specification (you may render this using [swagger.editor.html](https://editor.swagger.io/)). The API provides a straightforward interface for managing the network of involved care providers using standard REST operations.

##### Operations
###### Create Resource (POST /api)
Registers a new care provider relationship in the NVI network.

**Request Body:**
```json
{
  "pseudoBsn": "string",
  "zorgContext": "SNOMED_CT_CODE",
  "ura": "string",
  "organizationType": "ORGANIZATION_TYPE_CODE"
}
```
- All fields are required
- Returns HTTP 201 (Created) on success

###### Delete Resource (DELETE /api)
Removes a care provider relationship from the NVI network.

**Query Parameters:**
- `pseudoBsn` (required): The pseudonymized patient identifier
- `zorgContext` (required): The care context SNOMED CT code
- `ura` (required): The organization identifier
- `organizationType` (required): The organization type code

Returns HTTP 204 (No Content) on successful deletion.

###### Retrieve Resources (GET /api)
Queries the NVI network to find which organizations have data for a patient in a specific care context.

**Query Parameters:**
- `pseudoBsn` (required): The pseudonymized patient identifier
- `zorgContext` (required): The care context SNOMED CT code
- `organizationType` (required): The organization type code

**Response:**
```json
{
  "datalocations": [
    {
      "created": "2024-01-01T10:00:00Z",
      "pseudoBsn": "string",
      "zorgContext": "SNOMED_CT_CODE",
      "ura": "string",
      "organizationType": "ORGANIZATION_TYPE_CODE"
    }
  ]
}
```
Returns HTTP 200 (OK) with an array of matching data locations.

##### Integration Considerations

While this API uses a simple JSON format rather than FHIR, it can still integrate with FHIR-based systems through appropriate adapters or transformation layers. Organizations using FHIR internally can map between their FHIR resources and the NVI API as needed.

#### LMR API

For implementing LMR, we have chosen to reuse the existing FHIR-API of data sources. This decision was made to simplify the implementation and reduce complexity while still meeting the core requirements of metadata-based searching. In the Netherlands, both [FHIR R4](https://r4.fhir.space/http.html) and [FHIR STU3](https://www.hl7.org/fhir/STU3/http.html) are used.

#### Pseudo-BSN-service API

This API spec will follow later.


### Security and Privacy Considerations

#### Pseudonymization
The initial implementation uses plain BSN (Burgerservicenummer) for simplicity. In a later stage, this will be replaced with pseudoBsn to enhance patient privacy. The pseudonymization layer will ensure that patient identities are protected while still allowing organizations to use a joint index.

#### Authentication and Authorization
Authentication and authorization follows the [GF Authorization](./authorization.html) specification. The required attributes for NVI API access are:

**For PUT operations (registering care provider relationships):**
- **URA**: The organization identifier of the registering organization
- **OrganizationType**: The type of healthcare organization registering the data

**For GET operations (querying the network):**
- **URA**: The organization identifier of the requesting organization  
- **OrganizationType**: The type of healthcare organization making the query
- **UZI**: The unique healthcare professional identifier of the requester
- **Rolcode**: The professional role code of the requester

These attributes ensure proper access control and auditing while maintaining the security requirements outlined in the [GF Authorization](./authorization.html) specification.

---

### Example Use Cases

#### Use Case: Physician Searching for Available Imaging Data

**Scenario**: Dr. Smith, a cardiologist at Hospital A, is treating a patient who was recently referred from another hospital. She needs to know what imaging data (X-rays, CT scans, MRIs) might be available from other healthcare providers to avoid unnecessary duplicate examinations and to get a complete picture of the patient's medical history.

{% include localization-physician-imaging-search.svg %}

**Process**:

1. **Registration of Care Provider Relationships**: Healthcare organizations register their data availability when they have imaging data for a patient. For example:
   - A Hospital registers that it has imaging data for the patient
   - A Laboratory registers that it also has imaging data for the same patient
   
   Each registration requires the following authorization attributes:
   - **URA**: The organization identifier of the registering organization
   - **OrganizationType**: The type of healthcare organization (e.g., `2.16.840.1.113883.2.4.15.1060|V4` for Hospital, `2.16.840.1.113883.2.4.15.1060|L1` for Laboratory)

2. **Authentication**: Dr. Smith authenticates according to the [GF Authorization](./authorization.html) specification, providing the following required attributes:
   - **URA**: The organization identifier of the requesting organization
   - **OrganizationType**: The organization type (e.g., `2.16.840.1.113883.2.4.15.1060|V4` for Hospital)
   - **UZI**: Dr. Smith's unique healthcare professional identifier
   - **Rolcode**: Her professional role code

3. **Query the NVI**: With proper authentication established per the GF Authorization specification, a GET request is sent to find all organizations that have imaging data for this patient:
   ```
   GET /api?pseudoBsn=<patient-id>&zorgContext=http://snomed.info/sct|371530004
   ```
   
   Where:
   - `pseudoBsn`: The patient's pseudonymized BSN
   - `zorgContext`: SNOMED code for "Imaging report" (371530004)

4. **Response**: The NVI returns a list of organizations that have imaging data for this patient:
   ```json
   {
     "datalocations": [
       {
         "created": "2024-02-20T09:15:00Z",
         "pseudoBsn": "<patient-id>",
         "zorgContext": "http://snomed.info/sct|371530004",
         "ura": "URA-HOSPITAL",
         "organizationType": "2.16.840.1.113883.2.4.15.1060|V4"
       },
       {
         "created": "2024-02-25T11:30:00Z",
         "pseudoBsn": "<patient-id>",
         "zorgContext": "http://snomed.info/sct|371530004", 
         "ura": "URA-LABORATORY",
         "organizationType": "2.16.840.1.113883.2.4.15.1060|L1"
       }
     ]
   }
   ```

5. **Display Results**: Dr. Smith can now see that both a Hospital and a Laboratory have imaging data for this patient. She can then:
   - Contact these organizations through the appropriate channels to request the imaging data
   - Use other Generic Functions (like authorization and consent) to obtain access to the actual images
   - Review the imaging history to determine if new scans are needed

**Benefits**:
- **Efficiency**: Avoids duplicate imaging examinations
- **Completeness**: Ensures all relevant imaging data is considered for diagnosis
- **Cost Reduction**: Reduces unnecessary healthcare costs
- **Patient Safety**: Minimizes patient exposure to radiation from redundant scans

### Future Enhancements

Potential future enhancements to the API include:
- Audit logging capabilities (MUST HAVE, TODO)
- Extended metadata fields for additional context

### Appendices
[Appendix: FHIR Resource Considerations](./localization-appendix.html) 
