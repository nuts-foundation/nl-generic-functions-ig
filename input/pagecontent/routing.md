

> This is a copy of the Technical Agreement "Routering" and is maintained outside of this Implementation Guide. The reason to include it in this IG:
> - generate examples
> - consistency with the Generic Functions


| Titel | Technical Agreement 'Publishing, routing and defining requests between care providers' |
|Version| 1.1 |
|Published by| Twiin|
|Website| https://www.twiin.nl/ |
{:.grid .table-hover}


### Introduction
This Technical Agreement (TA) specifies responsibilities and patterns for routing referrals and orders between healthcare organizations, leveraging the IHE mCSD (Mobile Care Services Directory) model. The central principle is that routing is based on structured directory lookup.
The initial reason for drawing up this generic technical agreement is the need for a mechanism to address the notification, as described in the TA Notified Pull, at the right place within the receiving organization. Addressing the notification at the level of a healthcare organization isn’t sufficient for end users. 


#### Goal, scope, and principles

##### Goal
The mechanism defined in this document is intended to provide a single and simple mechanism of routing labels (persons, sub-organizations, locations, products, and services) within an organization and to allow organizations to define such routing labels. 

##### Scope of this proposal
This TA applies to scenarios where information exchange involves:

- Publishing (sub-)organizations, practitioners, and locations as routing labels in an mCSD Directory
- Selecting a (sub-)organization, practitioner, or location from a structured directory using activity types/definitions in healthcare services
- Creating (clinical) requests and (logistic) tasks for the (sub-)organization, practitioner, or location
- Sending notifications to the corresponding endpoint of the (sub-)organization, practitioner, or location

This technical agreement is intended to be infrastructure agnostic. Authorization is out of scope for now. Authorization can be useful to prevent that someone requests a service that he is not allowed to request. 

##### Examples of supported routing use cases:
- Requesting care at a specific geographic location 
- Referring to a department or specialist within an organization 
- Requesting a specific healthcare service (e.g., CT scan)

##### Targeted FHIR-version and profiles
This TA assumes use of FHIR STU3 or R4 resources and is compatible with IHE mCSD directory concepts. The IHE mCSD directory defines resource types for all the relevant concepts. In addition, the HCIMs define profiles on most of these resources: Location, Organization, Practitioner and PractitionerRole have HCIMs defined. Endpoint and HealthcareService are available in FHIR, but not as HCIM. 

##### Principles
The following principles are followed in this document:

- Use international standards where applicable
- Align with FHIR Workflow, Implementation Guide Clinical Order Workflow, and IHE mCSD
- Minimize custom extensions or non-standard patterns
- Ensure design longevity (3–5 years applicability)

#### Definition of terms

| Term | Definition |
|-|-|
| Endpoint | The base address for interfacing with a service |
| HealthcareService | A service offered by a healthcare organization (FHIR resource) |
| Organization | A grouping of people or organizations with a common purpose |
| Receiving Organization | The organization or party to receive a message or request |
| Receiving System | The system a message or request for the receiving organization is sent to |
| Sending Organization| The organization or party sending a message or request to the receiving organization |
| Sending System | The system sending a message or request on behalf of the sending organization |
| ServiceRequest | A request for service such as diagnostic investigations, treatments, or operations to be performed |
| System | Software used by (a) healthcare organization(s), such as an electronic health record or API service |
| Task | Workflow-related administrative activity in FHIR |
{:.grid .table-hover}

### Routing interactions
This chapter describes all relevant interactions on data level. 

#### mCSD-Based Directory Lookup
Routing is based on the IHE mCSD model, in which each care provider publishes Organization, Location, HealthcareService, and Endpoint resources in a mCSD Directory. 
Users (or their systems) search the directory for a suitable HealthcareService and construct a FHIR ServiceRequest (R4) or ReferralRequest (STU3) and Task.

<div>
{% include workflow-base-f.svg %}
</div>

##### Interaction flow:
1. Care providers publish structured addressable resources to the directory
1. The sender searches for the appropriate service (e.g. “initial consultation” for “radiology” near “Zwolle”)
1. The resulting HealthcareService (indirectly) refers to Organization, Location, Endpoint, etc.
1. This is used in the ServiceRequest and Task

##### Role of the ServiceRequest
The ServiceRequest represents the ‘clinical intent’ or ‘clinical authorization’ for a procedure. It shall have a ServiceRequest.code (representing e.g. ‘initial consultation’ or ‘nursing handoff’). Detailed ServiceRequests may use an ActivityDefinition to define what requested for the patient in ServiceRequest.instantiatesCanonical.

##### Role of the Task
The Task is used for state management and administrative routing (I.e ‘who’ and ‘where’ should do the referred ServiceRequest). The Task.code is used to define what the Task.owner is exepted do with the referred ServiceRequest, e.g. ‘fulfill’, ‘change’ or ‘approve’. 

##### Role of the HealthcareService
The HealthcareService is used to publish supported activities (using codeable concepts in element.type and references to ActivityDefinitions and PlanDefinitions in element.type.extension:supportedActivityDefinitions). These items are primarily used in the Request.

The HealthcareService also points to the (sub-)organization that provides the HealthcareService. This organization should be used as Task.owner. 

The HealthcareService.location may point to (multiple) physical locations where the service can be performed. If the HealthcareService does not specify a location, the location can be inherited from the organization (or, recursively, parent organizations) that provides the service.

The HealthcareService.endpoint may contain a suitable Endpoint resource (e.g. an Endpoint that is capable of receiving FHIR notifications like TA-NP specifies). If the HealthcareService does not specify an endpoint, the endpoint can be inherited from the organization (or, recursively, parent organizations) that provides the service. 




#### HealthcareService profile
The [NL-GF-HealthcareService profile](./StructureDefinition-nl-gf-healthcareservice.html) is based on the core FHIR R4 HealthcareService, incorporating changes from IHE mCSD, a valueset-binding on .type and .specialty and an extension on .type to refer to Activity/PlanDefinitions.


### Document management


#### Involved parties
This document is a co-creation of the companies listed below. The following people have been involved in creating this document.

|Company | Contact Person(s) | Email |
|-|-|-|
| Chipsoft | Olav Trauschke | o.trauschke@chipsoft.com |
| Nedap | Pieter Bos, Roald Dijkstra | |
| Nexus | Marcel Engels | marcel.engels@nexus-nederland.nl |
| Nictiz | Pieter Edelman | |
| Twiin | Marc Sandberg, Robin van Everdingen | |
| VZVZ1 | Ron van Holland | |
| ZorgDomein | Stephan Opdenberg, Ruben Pape | |
| Nuts | Bram Wesselo | |
{:.grid .table-hover}

#### Version control

| Rev | Release Date | Author | Description of change |
|-|-|-|-|
| 1.0.1 | December 19th 2024 | | An example of eOverdracht has been added. Example of BgZ has been supplemented for missing parts. An attribute in table 2.3 (assessment) has been removed because it added nothing. |
| 1.1 | August 28th 2025 | | The role of ActivityDefinition has been revised. Some elements are now covered by the concept of the HealthcareService. |
{:.grid .table-hover}

### Appendix: Examples

TODO


<!-- ### Summary of the notification framework in FHIR core

The [FHIR Subscription Framework](https://build.fhir.org/subscriptions.html) facilitates real-time event notifications from a FHIR server to other systems. It uses three core resources: SubscriptionTopic (defining events and triggers), Subscription (describing client requests for notifications), and notification Bundles (containing an event-notification, handshake-notification or heartbeat-notification). Clients request notifications based on specific topics, and servers send them using different communication channels. There are two subscription management styles: In-Band (client-managed) and Out-of-Band (server-managed). These interactions may involve technologies like REST hooks or websockets, allowing clients to receive notifications based on predefined conditions. 
In essence, the Out-of-Band (server-managed) style transfers much of the management burden from the client to the server, with the server being responsible for event processing, notification delivery, and system resilience.

### Notifications in NL Generic Functions IG

> Within NL Generic Functions IG, the Out-of-Band (server-managed) subscription style and REST hook channel shall be used. The default endpoint for notification bundles is the FHIR base url (a local API gateway or proxy should be able to handle/forward notification bundles). SCP uses a SubscriptionTopic, which is triggered if your organization is a participant in a SCP-Task or SCP-CarePlan.

### Example subscription sequence
If Organization-1 creates a Task for PractitionerRole-2 in the local SCP-node, the folowing steps are taken:
- the (local) subscription manager searches the care services directory to get to the FHIR endpoint of PractitionerRole-2 that supports Shared Care Planning. This may involve multiple queries from PractitionerRole-2 to parent organization(s) to an endpoint-resource
- the (local) subscription manager searches for an existing subscription-instance for this endpoint and SubscriptionTopic 'isParticipantInInstance'. If no subscription exists, a new subscription is created and a handshake-notification-bundle is send to the endpoint.
- the (local) subscription manager stores the notification-event (with incremented event-number) and sends the notification-event to the endpoint of PractitionerRole-2 (this may involve retries).
- the (local) subscription manager regularly sends a heartbeat-notification bundle that contains the subscription status and highest event-number. (this may involve retries)
- the subscription client checks each notification-bundle if it hasn't missed any events and it regularly checks if it missed a heartbeat-notification.

### Required capabilities: endpoint

A Shared Care Planning **endpoint** shall implement the following capabilities:
- support the `Subscription` resource
 - support the `read` interaction
 - support the `search` interaction
 - support searchparameters `status`,`criteria`, `channel.endpoint`, `channel.type` and `channel.payload`
 - support operations `$status` and `$event`
 - supports channel type `rest-hook`
 - supports payload type `id-only`. 

A Shared Care Planning endpoint may support additional capabilities like other payloads or channel types. It's up to subscription manager to decide which e.g. channel/payload type to use given the joint capabilities of both subscription manager and client.

### Required capabilities: subscription manager

A Shared Care Planning node shall implement the role of a **subscription manager** for out-of-band style subscriptions, i.e.:
- create/update subscriptions for the 'isParticipantInInstance' topic
- send handshake-notifcation-bundles when subscription.status is `requested` (which may involve retries) and update the subscription.status accordingly
- send heartbeat-notifcation-bundles at predefined intervals (which may involve retries) and update the subscription.status accordingly
- send event-notification-bundles (and incrementing the event-number in a concurrent-save way)

### Required capabilities: subscription client

A Shared Care Planning node shall implement the role of a **subscription client** for out-of-band style subscriptions, i.e.:
- receiving notification-bundles (and forwarding/acting on these notificatiuon-bundles)
- checks each notification-bundle if it hasn't missed any events (using the highest event-number it succesfully processed). Missed notifications are caught up using the $event operation
- checks at predefined intervals if it missed a heartbeat-notification. If a heartbeat-notification is missing, the subscription status is queried using the $status operation.

The subscription client, being responsible for resolving failures, should also track the subscription's state to highlight and fix any erroneous communication.

In order to implement this subscription framework in FHIR version R4, the [Subscriptions R5 Backport for R4](https://hl7.org/fhir/uv/subscriptions-backport/) is used.
Check out the example instances for a [subscription](Subscription-cps-sub-hospitalx.json.html) or [notification-bundle](Bundle-notification-hospitalx-01.json.html). -->