### Patient's Data Localization
For more details: [A short summary of Generieke Functie Lokalisatie (Generic Localization Function)](generieke-functie-lokalisatie.html)

#### API Implementation Approach

For implementing NVI (Network of Involved Care Providers - see [detailed description](https://github.com/minvws/generiekefuncties-lokalisatie/issues/15)), we have chosen to use a simple JSON-based REST API instead of FHIR resources. This decision was made to simplify the implementation and reduce complexity while still meeting the core requirements of tracking which organizations have data about a patient in specific care contexts.

#### API Specification

The NVI API is defined using OpenAPI 3.0.2 specification (see [nvi_openapi.yaml](data/nvi_openapi.yaml)). The API provides a straightforward interface for managing the network of involved care providers using standard REST operations.

##### Core Data Model

The API manages resources that represent the relationship between:
- **Pseudo-BSN**: A pseudonymized patient identifier (replacing the actual BSN for privacy)
- **Zorgcontext (Care Context)**: The medical context or specialty, represented by SNOMED CT codes
- **URA**: The organization identifier representing the care provider

##### Supported Care Contexts

The API supports the following care contexts (Zorgcontext), each represented by a SNOMED CT code:
- `http://snomed.info/sct|721912009` - Medication summary section
- `http://snomed.info/sct|371530004` - Imaging report
- `http://snomed.info/sct|77465005` - Patient summary document
- `http://snomed.info/sct|721963009` - Immunization summary document
- `http://snomed.info/sct|782671000000103` - Multidisciplinary care management

##### API Operations

###### Create Resource (POST /api)
Registers a new care provider relationship in the NVI network.

**Request Body:**
```json
{
  "pseudo-BSN": "string",
  "zorgcontext": "SNOMED_CT_CODE",
  "URA": "string"
}
```
- All fields are required
- Returns HTTP 201 (Created) on success

###### Delete Resource (DELETE /api)
Removes a care provider relationship from the NVI network.

**Query Parameters:**
- `pseudo-BSN` (required): The pseudonymized patient identifier
- `zorgcontext` (required): The care context SNOMED CT code
- `URA` (required): The organization identifier

Returns HTTP 204 (No Content) on successful deletion.

###### Retrieve Resources (GET /api)
Queries the NVI network to find which organizations have data for a patient in a specific care context.

**Query Parameters:**
- `pseudo-BSN` (required): The pseudonymized patient identifier
- `zorgcontext` (required): The care context SNOMED CT code

**Response:**
```json
{
  "created": "2024-01-01T10:00:00Z",
  "pseudo-BSN": "string",
  "zorgcontext": "SNOMED_CT_CODE",
  "URA": "string"
}
```
Returns HTTP 200 (OK) with the matching resource data.

#### Security and Privacy Considerations

##### Pseudonymization
The API uses pseudo-BSN instead of actual BSN (Burgerservicenummer) to enhance patient privacy. This pseudonymization layer ensures that patient identities are protected while still allowing organizations to coordinate care.

##### Authentication and Authorization
Authentication and authorization implementation is still under consideration. Potential approaches include:
- **NUTS URA Credential**: Utilizing verifiable credentials issued through the NUTS network for user authentication
- **URA Server Certificates**: Using server-side certificates for system-to-system authentication and authorization
- **Purpose of Use**: The API design includes consideration for Purpose of Use (PurposeOfUse) parameters to ensure data access is appropriate for the intended care scenario

#### Advantages of the JSON API Approach

1. **Simplicity**: The JSON-based API is straightforward to implement and integrate, reducing the learning curve for developers
2. **Focused Functionality**: The API is purpose-built for NVI requirements without the overhead of full FHIR compliance
3. **Clear Semantics**: Each operation has a single, well-defined purpose without ambiguity
4. **Efficient Operations**: Direct REST operations avoid the complexity of FHIR search parameters and resource constraints
5. **Easier Validation**: Simple JSON schema validation is sufficient, avoiding complex FHIR profile validation

#### Integration Considerations

While this API uses a simple JSON format rather than FHIR, it can still integrate with FHIR-based systems through appropriate adapters or transformation layers. Organizations using FHIR internally can map between their FHIR resources and the NVI API as needed.

#### Future Enhancements

Potential future enhancements to the API include:
- Batch operations for registering multiple care relationships
- Audit logging capabilities
- Extended metadata fields for additional context
- Support for temporal queries to track historical care relationships

---

### Appendix: FHIR Resource Considerations

During the design phase, we evaluated using FHIR resources for the NVI implementation before deciding on the simpler JSON API approach. This section documents those considerations for reference.

#### Candidates Evaluated

The following FHIR resources were considered for representing the relationship between a patient, the medical specialty or department, and the organizations providing care:
- EpisodeOfCare
- CarePlan
- CareTeam

#### EpisodeOfCare Analysis

The EpisodeOfCare resource was initially considered appropriate because it is designed to represent a period of care for a patient under the responsibility of a provider or organization. It naturally includes:
- The Patient (via `EpisodeOfCare.patient`)
- The Managing Organization (via `EpisodeOfCare.managingOrganization`)
- The medical specialty or department (via `EpisodeOfCare.type`)
- The temporal aspect (via `EpisodeOfCare.period`), the history of of the data is important for NVI, however, there is no need to track the period of involvement of the patient.

#### CareTeam Considerations

While CareTeam might initially seem like a suitable resource for tracking healthcare provider involvement, it presented several fundamental challenges for NVI implementation:

##### Structural Mismatch
The CareTeam resource holds a list of members rather than representing a single relationship. This fundamental difference creates complexity:
- The use of CareTeam could imply consolidation of multiple providers at the condition level, joining patient/condition pairs
- The list-based structure implies multiple parties are involved, requiring complex resource management
- NVI needs to track individual organization-patient relationships, not collaborative groups

##### Management Complexity
The multi-party nature of CareTeam complicates essential operations:
- **CRUD Management**: If one organization creates a CareTeam for a condition, and another organization independently creates one for the same care context, this creates ambiguity in data management
- **Access Control**: With multiple members in a single resource, determining who can view, update, or delete the resource becomes complex
- **Update Conflicts**: Changes by one member require elaborate update logic on the implementation

##### Semantic Differences
On a fundamental level, CareTeam and NVI serve different purposes:
- **CareTeam** represents active collaboration between healthcare providers working together on patient care
- **NVI** functions as an index - a registry of which organizations have data, without implying collaboration
- While NVI could potentially serve as a seed or starting point for collaboration initiatives like SCP (Shared Care Planning), conflating indexing with collaboration would compromise both functions

#### Distinction from Shared Care Planning

An important consideration was that the [Shared Care Planning](https://santeonnl.github.io/shared-care-planning/) initiative already uses CarePlan and CareTeam resources to manage the care network of a patient. Since NVI has a different goal and scope, using different resources would avoid semantic conflicts by not overloading the same entities (CarePlan and CareTeam) with different meanings in different contexts. For instance, SCP chooses to have one single CarePlan/CareTeam resource and add the Organizations as members. The SCP also manages Tasks, which NVI will never support.

#### Why We Chose JSON API Over FHIR

After careful consideration of these FHIR resources, we decided that a simple JSON API better serves the NVI requirements:
1. **Reduced Complexity**: Avoiding FHIR resource constraints and validation rules
2. **Clear Purpose**: The API is explicitly designed for NVI without semantic ambiguity
3. **Simpler Implementation**: Direct REST operations without FHIR overhead
4. **Easier Integration**: Organizations can adapt the simple API to their internal systems more easily
5. **No Semantic Conflicts**: Avoids confusion with existing FHIR-based initiatives like Shared Care Planning
