

> This is a copy of the Technical Agreement "Routering" and is maintained outside this Implementation Guide. The reason to include it in this IG:
> - generate examples
> - consistency with the Generic Functions


| Titel | Technical Agreement 'Defining and publishing types of requests for routing requests between care providers ' |
|Version| 1.3 (trial)|
|Published by| Twiin|
|Website| https://www.twiin.nl/ |
{:.grid .table-hover}


### Introduction
This Technical Agreement (TA) specifies mechanisms for receivers of referrals and orders that were received from other organizations, to route them internally, leveraging the IHE mCSD (Mobile Care Services Directory) model. The central principle is that routing is based on structured directory lookup. 

The initial reason for drawing up this generic technical agreement is the need for a mechanism to address the notification, as described in the TA Notified Pull, at the right place within the receiving organization. Addressing the notification at the level of a healthcare organization isn’t sufficient for end users. 


#### Goal, scope, and principles

##### Goal
The mechanism defined in this document is intended to provide a single and simple mechanism of routing labels (persons, sub-organizations, locations, products, and services) within an organization and to allow organizations to define such routing labels.

##### Scope
This TA applies to scenarios where information exchange involves:  
- Publishing healthcare services, (sub-)organizations, practitioners and locations as routing labels in an mCSD Directory 
- Selecting a (sub-)organization, practitioner or location from a structured directory using activity-types/definitions in healthcare services 
- Creating (clinical) requests and (logistic) tasks for the healthcare service, (sub-)organization, practitioner or location 
- Sending notifications to the corresponding endpoint of the healthcare service, (sub-)organization, practitioner or location 

All information exchanges described in this TA are based on FHIR standards and profiles, ensuring semantic and technical interoperability between participating systems. 

This technical agreement is intended to be infrastructure agnostic. Authorization is out of scope for now. Authorization can be useful to prevent that someone requests a service that he is not allowed to request.  

##### Examples of supported routing use cases:
- Requesting care at a specific geographic location 
- Referring to a department or specialist within an organization 
- Requesting a specific healthcare service (e.g., CT scan)

##### Targeted FHIR-version and profiles
This TA assumes use of FHIR R4 resources and is compatible with IHE mCSD directory concepts. The IHE mCSD directory defines resource types for all the relevant concepts. In addition, the HCIMs define profiles on most of these resources: Location, Organization, Practitioner and PractitionerRole have HCIMs defined. Endpoint and HealthcareService are available in FHIR, but not as HCIM.  

##### Principles
The following principles are followed in this TA: 
- Use international standards where applicable  
- Align with FHIR Workflow, Implementation guide [Clinical Order Workflow](https://build.fhir.org/ig/HL7/fhir-cow-ig/) and [IHE mCSD](https://profiles.ihe.net/ITI/mCSD/) 
- Minimize custom extensions or non-standard patterns  
- Ensure design longevity (3-5 years applicability)

#### Definition of terms

| Term                   | Definition                                                                                          |
|------------------------|-----------------------------------------------------------------------------------------------------|
| Endpoint               | An address for interfacing with a service                                                      |
| HealthcareService      | A service offered by a healthcare organization (FHIR resource)                                      |
| Organization           | A grouping of people or (sub)organizations with a common purpose                                         |
| Receiving Organization | The organization or party to receive a message or request                                           |
| Receiving System       | The system a message or request for the receiving organization is sent to                           |
| ReferralRequest        | A request for referral or transfer of care |
| Sending Organization   | The organization or party sending a message or request to the receiving organization                |
| Sending System         | The system sending a message or request on behalf of the sending organization                       |
| ServiceRequest         | A request for a service, such as a diagnostic procedure, surgery or other treatment to be performed on a patient  |
| System                 | Software used by (a) healthcare organization(s), such as an electronic health record or API service |
| Task                   | Workflow related activity in FHIR                                                    |
{:.grid .table-hover}

### Routing interactions
This chapter describes all relevant interactions on data level. 

#### mCSD-Based Directory Lookup
Routing is based on the IHE mCSD model, in which each care provider publishes Organization, Location, HealthcareService, and Endpoint resources in a mCSD Directory.  In this mCSD Directory, a sender can search for the appropriate service (e.g. “initial consultation” for “radiology” near “Zwolle”). See this [example content of a Query Directory](./Bundle-query-directory.html).

Users (or their systems) first determine ***what*** they'd want to order for or refer the patient to. The `HealthcareService.type` in the mCSD Directory contains one or more orderable items or service types. These can be represented as a (simple) code or as an ActivityDefinition/PlanDefinition. When a selection has been made, the request resource is created (using either a simple `.code` or `.instantiatesCanonical` in the case of an ActivityDefinition/PlanDefinition). See [example](./ServiceRequest-53a41e63-e826-45fa-9076-9be4b18399c8.html) Servicerequest. 

The FHIR Task is used to determine to ***who*** and ***where*** the request should be delivered. The location is specified in `Task.location` and the healthcare service should be linked in `Task.owner` like in this [example](./Task-a0fc5221-bcd9-46f1-922f-c2913dae5d63.html).


##### Role of the ServiceRequest
The ServiceRequest represents the ‘clinical intent’ or ‘clinical authorization’ for a procedure. It shall have a `ServiceRequest.code` (representing e.g. ‘initial consultation’ or ‘nursing handoff’) and may be instantiated by an ActivityDefinition or PlanDefinition

##### Role of the ActivityDefinition
Using ActivityDefinitions in directories can define more precisely how a service needs to be requested or distinguish between different activities that can be provided by a single service. Using PlanDefinitions (consisting of multiple ActivityDefinitions) allows for defining more complex workflows. 

When the service directory defines an ActivityDefinition for the requested service, the server may decline a ServiceRequest for that service that does not refer to that ActivityDefinition in `ServiceRequest.instantiatesCanonical` or does not adhere to the requirements specified in that definition. 

##### Role of the Task
The Task is used for coordination, i.e. state management and administrative routing (i.e ‘who’ and ‘where’ should do the referred ServiceRequest). The `Task.code` is used to define what the `Task.owner` is expected to do with the referred ServiceRequest, e.g. ‘fulfill’, ‘change’ or ‘approve’. `Task.owner` should refer to the HealthcareService responsible for carrying out the Request

##### Role of the HealthcareService
The HealthcareService is used to publish supported activities (using codeable concepts in element `.type` and optionally references to ActivityDefinitions and PlanDefinitions in element `.type.extension:supportedActivityDefinitions` ). These items are primarily used in the Request. 

The `HealthcareService.location` may point to (multiple) physical locations where the service can be performed. If the HealthcareService does not specify a location, the location can be inherited from the organization (or, recursively, parent organizations) that provides the service. 

Either the `HealthcareService.endpoint` or `ActivityDefinition.endpoint` must contain a suitable Endpoint resource (e.g. an Endpoint that is capable of receiving FHIR notifications like TA-NP specifies). If both an ActivityDefinition and a HealthcareService define an endpoint, the one defined on the ActivityDefinition must be used. 



#### HealthcareService profile
The [HealthcareService-profile](https://build.fhir.org/ig/nuts-foundation/nl-generic-functions-ig/StructureDefinition-nl-gf-healthcareservice.html) is based on the core FHIR R4 HealthcareService, incorporating changes from IHE mCSD and adding extra constraints for the Dutch realm: 
- requirement for .providedBy 
- valueset binding of .type 
- extension:supportedActivityDefinitions 


#### Support for FHIR STU3 Task

To support the current [eOverdracht specification](https://informatiestandaarden.nictiz.nl/wiki/vpk:V4.0_FHIR_eOverdracht), (a FHIR STU3 Implementation Guide), 2 extension are added to the eOverdracht Task profile  (see the new [profile](./eOverdracht-Task-STU3-profile.json), this [example](./eOverdracht-Task-eov-test-1_1b-REQUESTED.xml) (original [example](https://github.com/Nictiz/Nictiz-testscripts/blob/main/src/eOverdracht-4-0/Test/_reference/resources/resources-specific/eOverdracht-Task-eov-test-1_1b-REQUESTED.xml) from NictiZ test-resources)):
- .location: Reference to the Location
- .healthcareservice: Reference to the HealthcareService

These references SHOULD also include an Author-assigned-identifier (required in the profiles for [NL-GF-Location](./StructureDefinition-nl-gf-location.html) and [NL-GF-HealthcareService](./StructureDefinition-nl-gf-healthcareservice.html)). *Without* such an identifier, the eOverdracht-sender *SHALL* make the resources available to eOverdracht-receiver (support read-operations for Location and HealthcareService, using [this](./CapabilityStatement-nl-gf-query-directory-query-client-reads.html) capabilitystatement)


```
<extension url="http://nuts-foundation.github.io/nl-generic-functions-ig/StructureDefinition/task-stu3-healthcareservice">
    <valueReference>
        <reference value="HealthcareService/b48826dc-2d58-479a-bfd3-80b7a9d69757" />
        <display value="Organization 3 - HealthcareService Verpleging"/>
    </valueReference>
</extension>
<extension url="http://nuts-foundation.github.io/nl-generic-functions-ig/StructureDefinition/task-stu3-location">
    <valueReference>
        <reference value="Location/9a2b8f1c-4e7d-42a1-b3c9-2d5e8f7a6c1b" />
        <display value="Organization 3 - Location Nursing Department"/>
    </valueReference>
</extension>
```
In FHIR R4, the reference to Location and HealthcareService (part of `.owner`) are natively supported. Using these extensions, no breaking changes are introduced.


### Document management


#### Involved parties
This document is a co-creation of the companies listed below. The following people have been involved in creating this document.

| Company    | Contact Person(s)                   | Email                            |
|------------|-------------------------------------|----------------------------------|
| Chipsoft   | Olav Trauschke                      | o.trauschke@chipsoft.com         |
| Nedap      | Pieter Bos, Roald Dijkstra          |                                  |
| Nexus      | Marcel Engels                       | marcel.engels@nexus-nederland.nl |
| Nictiz     | Pieter Edelman                      |                                  |
| Twiin      | Marc Sandberg, Robin van Everdingen |                                  |
| VZVZ       | Ron van Holland                     |                                  |
| ZorgDomein | Stephan Opdenberg, Ruben Pape       |                                  |
| Nuts       | Bram Wesselo                        |                                  |
{:.grid .table-hover}

#### Version control

| Rev   | Release Date       | Author | Description of change                                                                                                                                                               |
|-------|--------------------|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1.0.1 | December 19th 2024 |        | An example of eOverdracht has been added. Example of BgZ has been supplemented for missing parts. An attribute in table 2.3 (assessment) has been removed because it added nothing. |
| 1.1   | August 28th 2025   |        | The role of ActivityDefinition has been revised. Some elements are now covered by the concept of the HealthcareService.                                                             |
| 1.3   | January 8th 2026   |        | Consultation feedback resolved.                                                             |
{:.grid .table-hover}


### Appendix: Examples

TA Routing specifies the ***what***, ***who*** and ***where*** of Requests and (coordination) Tasks. These can be applied in workflows like [eOverdracht](https://informatiestandaarden.nictiz.nl/wiki/vpk:V4.0_FHIR_eOverdracht) or the workflows defined in the [Clinical Order Workflow IG](https://build.fhir.org/ig/HL7/fhir-cow-ig/) (COW). 

In the COW-example [Simple Lab Order Flow](https://build.fhir.org/ig/HL7/fhir-cow-ig/en/ex1-simple-lab-order-flow.html), the mCSD Directory represents the 'Order Catalog' mentioned. For routing, a care provider should publish the glucose test (LOINC 2345-7) in a HealthcareService.type element (possibly along with a more fine-grained ActivityDefinition). Using the code or ActivityDefinition, a ServiceRequest can be initiated. The HealthcareService (and a HealthcareService.location) are referred in `Task.owner` and `Task.location` respectively. 