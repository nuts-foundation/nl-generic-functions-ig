### Introduction


### Solution overview


<img src="localization-overview-transactions.png" width="60%" style="float: none" alt="Overview of transactions in the Data Localization solution."/>


### API Implementation Approach

For implementing NVI (Network of Involved Care Providers - see [detailed description](https://github.com/minvws/generiekefuncties-lokalisatie/issues/15)), we have chosen to use a simple JSON-based REST API instead of FHIR resources. This decision was made to simplify the implementation and reduce complexity while still meeting the core requirements of tracking which organizations have data about a patient in specific care contexts.

### API Specification

The [NVI API](./localization.openapi.json) is defined using OpenAPI 3.0.2 specification (you may render this using [swagger.editor.html](https://editor.swagger.io/)). The API provides a straightforward interface for managing the network of involved care providers using standard REST operations.

#### Core Data Model

The API manages resources that represent the relationship between:
- **BSN/pseudoBsn**: The patient identifier. The initial implementation uses plain BSN (Burgerservicenummer), which will be replaced by pseudoBsn in a later stage for enhanced privacy
- **zorgContext (Care Context)**: The medical context or specialty, represented by SNOMED CT codes
- **ura**: The organization identifier representing the care provider
- **organizationType**: The type of healthcare organization (e.g., hospital, pharmacy, laboratory)

#### Supported Care Contexts

The API supports the following care contexts (zorgContext), each represented by a SNOMED CT code:
- `http://snomed.info/sct|721912009` - Medication summary section
- `http://snomed.info/sct|371530004` - Imaging report
- `http://snomed.info/sct|77465005` - Patient summary document
- `http://snomed.info/sct|721963009` - Immunization summary document
- `http://snomed.info/sct|782671000000103` - Multidisciplinary care management

[FHIR Valueset Data localization context](./ValueSet-nl-gf-data-localization-context-vs.html)

#### Supported Organization Types

The API supports the following organization types (OrganisatieType):
- `2.16.840.1.113883.2.4.15.1060|H1` - Huisartsinstelling (General Practitioner)
- `2.16.840.1.113883.2.4.15.1060|V4` - Ziekenhuis (Hospital)
- `2.16.840.1.113883.2.4.15.1060|A1` - Apotheekinstelling (Pharmacy)
- `2.16.840.1.113883.2.4.15.1060|X3` - Verplegings- of verzorgingsinstelling (Nursing/Care Institution)
- `2.16.840.1.113883.2.4.15.1060|L1` - Laboratorium (Laboratory)
- `2.16.840.1.113883.2.4.15.1060|G5` - Geestelijke Gezondheidszorg (Mental Health Care)
- `2.16.840.1.113883.5.1008|OTH` - Overige (Other)

[FHIR Valueset Organization types](./ValueSet-2.16.840.1.113883.2.4.3.11.60.40.2.17.2.3--20200901000000.html)

#### API Operations

##### Create Resource (POST /api)
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

### Security and Privacy Considerations

#### Pseudonymization
The initial implementation uses plain BSN (Burgerservicenummer) for simplicity. In a later stage, this will be replaced with pseudoBsn to enhance patient privacy. The pseudonymization layer will ensure that patient identities are protected while still allowing organizations to coordinate care.

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

### Advantages of the JSON API Approach

1. **Simplicity**: The JSON-based API is straightforward to implement and integrate, reducing the learning curve for developers
2. **Focused Functionality**: The API is purpose-built for NVI requirements without the overhead of full FHIR compliance
3. **Clear Semantics**: Each operation has a single, well-defined purpose without ambiguity
4. **Efficient Operations**: Direct REST operations avoid the complexity of FHIR search parameters and resource constraints
5. **Easier Validation**: Simple JSON schema validation is sufficient, avoiding complex FHIR profile validation

### Integration Considerations

While this API uses a simple JSON format rather than FHIR, it can still integrate with FHIR-based systems through appropriate adapters or transformation layers. Organizations using FHIR internally can map between their FHIR resources and the NVI API as needed.

### Future Enhancements

Potential future enhancements to the API include:
- Audit logging capabilities (MUST HAVE, TODO)
- Extended metadata fields for additional context

---

## Example Use Cases

### Use Case: Physician Searching for Available Imaging Data

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


## Appendices
[Appendix: FHIR Resource Considerations](./localization-appendix.html) 