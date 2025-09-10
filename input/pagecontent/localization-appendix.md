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
2. **Focused Functionality**: The API is purpose-built for NVI requirements without the overhead of full FHIR compliance
3. **Clear Purpose**: The API is explicitly designed for NVI without semantic ambiguity
4. **Simpler Implementation**: Direct REST operations without FHIR overhead
5. **Easier Validation**: Simple JSON schema validation is sufficient, avoiding complex FHIR profile validation
6. **Easier Integration**: Organizations can adapt the simple API to their internal systems more easily
7. **No Semantic Conflicts**: Avoids confusion with existing FHIR-based initiatives like Shared Care Planning


##### Advantages of the JSON API Approach

1. **Simplicity**: The JSON-based API is straightforward to implement and integrate, reducing the learning curve for developers
2. **Focused Functionality**: The API is purpose-built for NVI requirements without the overhead of full FHIR compliance
3. **Clear Semantics**: Each operation has a single, well-defined purpose without ambiguity
4. **Efficient Operations**: Direct REST operations avoid the complexity of FHIR search parameters and resource constraints
5. **Easier Validation**: Simple JSON schema validation is sufficient, avoiding complex FHIR profile validation

##### Integration Considerations

While this API uses a simple JSON format rather than FHIR, it can still integrate with FHIR-based systems through appropriate adapters or transformation layers. Organizations using FHIR internally can map between their FHIR resources and the NVI API as needed.

#### Future Enhancements

Potential future enhancements to the API include:
- Audit logging capabilities (MUST HAVE, TODO)
- Extended metadata fields for additional context
