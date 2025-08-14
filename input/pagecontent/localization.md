### Patient's Data Localization
For more details: [Generieke Functie Lokalisatie](generieke-functie-lokalisatie.html)

#### Rationale for choosing Episode of Care
For implementing NVI (Network of Involved Care Providers - see [detailed description](https://github.com/minvws/generiekefuncties-lokalisatie/issues/15)), we need a FHIR resource that can represent the relationship between a patient, their conditions, and the organizations providing care.

Candidates for a FHIR resource that holds the triplet Patient - Condition - Organization are:
 * EpisodeOfCare
 * CarePlan
 * CareTeam 

##### Why EpisodeOfCare is appropriate
The EpisodeOfCare resource is designed to represent a period of care for a patient under the responsibility of a provider or organization. This aligns well with NVI requirements as it naturally includes:
- The Patient (via `EpisodeOfCare.patient`)
- The Managing Organization (via `EpisodeOfCare.managingOrganization`)
- The Conditions that are the reason for the care episode (via `EpisodeOfCare.diagnosis.condition`)
- The temporal aspect (via `EpisodeOfCare.period`), which is crucial for NVI as it needs to track when organizations are involved in a patient's care network, allowing for proper management of care provider relationships over time

##### Distinction from Shared Care Planning
An important consideration is that the [Shared Care Planning](https://santeonnl.github.io/shared-care-planning/) initiative already uses CarePlan and CareTeam resources to manage the care network of a patient. Since NVI has a different goal and scope, using EpisodeOfCare avoids semantic conflicts by not overloading the same entities (CarePlan and CareTeam) with different meanings in different contexts. For instance, SCP chooses to have one single CarePlan / CareTeam resource and add the Organizations as members. The SCP also manages Tasks, which NVI will never support.

#### FHIR API Implementation

The NVI implementation exposes a subset of the FHIR API specification, focusing on the essential operations needed for managing the network of involved care providers.

##### Supported Interactions

###### Search
Query EpisodeOfCare resources with required and optional parameters:
- **Required parameter**: Patient BSN (Burgerservicenummer) - all searches must include the patient identifier
- **Common parameter**: `EpisodeOfCare.diagnosis.condition` - typically required to filter episodes by specific conditions
- **Default behavior**: If status is not specified as a search parameter, the search automatically filters for `status=active` only
- **Example**: `GET [base]/EpisodeOfCare?patient.identifier=http://fhir.nl/fhir/NamingSystem/bsn|999999999&diagnosis.condition=http://snomed.info/sct|73211009`
- Returns a Bundle containing matching EpisodeOfCare resources

###### Create
Add new EpisodeOfCare instances with comprehensive validation:
- **Required fields**: Patient reference (with BSN), managing organization, and diagnosis condition
- **Validation**: System checks for uniqueness of BSN + diagnosis + overlapping periods combination
- **Example**: `POST [base]/EpisodeOfCare` with EpisodeOfCare resource in request body
- Returns HTTP 201 (Created) with the new resource, or HTTP 422 (Unprocessable Entity) if validation fails

###### Update
Modify existing EpisodeOfCare resources with restricted field updates:
- **Allowed updates**: Only status changes (planned, active, onhold, finished) and period adjustments are permitted
- **Restricted fields**: Patient reference, diagnosis, and managing organization cannot be modified after creation
- **Validation**: Same uniqueness constraints as Create operation - checks BSN + diagnosis + overlapping periods combination
- **Required**: Resource ID and current version (via ETag for conditional updates)
- **Example**: `PUT [base]/EpisodeOfCare/[id]` with `If-Match: W/"2"` header
- Returns HTTP 200 (OK) with updated resource, HTTP 412 if version conflict, or HTTP 422 if validation fails or attempting to modify restricted fields

###### Delete
Soft delete implemented as a special case of Update:
- **Implementation**: Sets the status to "finished" rather than physical removal
- **Behavior**: Essentially an Update operation that changes the status field
- **Preservation**: Maintains full resource and history for audit purposes
- Returns HTTP 200 (OK) when performed via Update operation

###### History
Full versioning support for audit trails:
- **Resource history**: `GET [base]/EpisodeOfCare/[id]/_history` - returns all versions of a specific episode
- **Type history**: `GET [base]/EpisodeOfCare/_history` - returns history across all episodes
- Returns a Bundle of type "history" with version entries

##### Supported FHIR Operations
- **FHIR Versioning / History Management**: Full support for resource versioning, allowing tracking of all changes to EpisodeOfCare resources over time through the `_history` operation (accessed via `[base]/EpisodeOfCare/[id]/_history`)
- **Conditional Updates with ETag**: Implementation of optimistic concurrency control using ETags to prevent lost updates when multiple clients modify the same resource. For example, when updating an EpisodeOfCare, the client must include the `If-Match` header with the current ETag value (e.g., `If-Match: W/"3"`). If the resource has been modified by another client since retrieval, the server returns HTTP 412 (Precondition Failed), preventing accidental overwrites
- **No Pagination**: The implementation does not support pagination for search results or history operations - all matching resources are returned in a single Bundle response

##### Security and Privacy Considerations
- Initial implementation uses raw BSN for patient identification
- Future iterations will implement anonymization techniques to enhance privacy

##### Authentication and Authorization
Authentication and authorization will likely be implemented using one of the following approaches:
- **NUTS URA Credential**: Utilizing verifiable credentials issued through the NUTS network for user authentication
- **URA Server Certificates**: Using server-side certificates for system-to-system authentication and authorization

#### Open Questions and Discussion

##### Soft Delete vs Period Management
- Is soft delete actually required given that the period field could serve the same purpose? Setting an end date in the period might be sufficient to indicate that an episode is no longer active, making the status change to "finished" redundant.

##### Implicit Period Filtering in Search
- Should we automatically apply an additional period range search filter based on the current time (`now()`) when no period parameter is specified in the search query? This would ensure that only currently active episodes (where period includes the current date) are returned by default.
