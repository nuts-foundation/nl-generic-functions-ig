### Introduction

This FHIR Implementation Guide defines the specifications for Generic Function Addressing (GFA), a national initiative led by the Dutch Ministry of Health, Welfare and Sport (VWS). GFA aims to establish a standardized, interoperable system for discovering and sharing current (digital) addresses of healthcare providers, enabling reliable and efficient exchange of health data across systems.

In today’s healthcare landscape, organizations rely on both physical and digital addresses for communication and data exchange. However, access to accurate and up-to-date digital addressing information is often inconsistent or unavailable, hindering interoperability and timely access to health information. GFA addresses this challenge by providing a unified framework that ensures all current, valid addresses for data exchange are easily accessible and traceable to authoritative sources.

This guide outlines the technical requirements and architectural principles underlying GFA, with a focus on trust, authenticity, and data integrity. Key design principles include:

- International standards: The solution should be based on international standards, lowering the bar for international (European) data exchange and adoption by internationally operating softwqre vendors.
- Single Source of Truth: Each address record originates from one definitive and authoritative source.
- Stakeholder Responsibility: Healthcare providers are accountable for maintaining the accuracy of address data in their source systems.

By adhering to these principles, this Implementation Guide supports consistent and secure address discovery, fostering improved interoperability within the healthcare ecosystem.

### Solution overview

GFA follows the IHE [mCSD profile](https://profiles.ihe.net/ITI/mCSD/index.html). The [mCSD profile](https://profiles.ihe.net/ITI/mCSD/index.html) provides multiple options for deployment. This guide specifies the choices that were made for The Netherlands. Most impactfull/striking choice are:
- using Dutch 'nl-core' FHIR-profiles on top of IHE mCSD-profiles
- using the Landelijke Register Zorgaanbieders (LRZa) as the source/master-list of all other sources. 

Here is a brief overview of the processes that are involved: 
1. Every care provider registers it's addressable entities in an 'Administration Directory'.
1. Every care provider registers the endpoint (url) of it's 'Administration Directory' at the LRZa registry.
1. An 'Update client' uses the LRZa and the Administration Directories to consolidate all data into a 'Query Directory'
1. A practitioner and/or system (EHR) can now use the Query Directory to search for a service, organization, department, location, endpoint or practitioner

Each component, data model and transaction will be discussed in more detail.

<img src="careservices-overview-transactions.png" width="100%" style="float: none"/>


### Components (actors)

#### Administration Client
The Administration Client is responsible for managing the registration and maintenance of addressable entities within a healthcare organization. It should be able to create, update, and delete records for organizations, departments, practitioners, locations, endpoints, and healthcare services in the Administration Directory. Addressable entities MUST conform to the [Data models](#data-models).

The Administration Client of the LRZa provides an user interface for healthcare providers to administer their Administration Directory endpoint (url).


#### Administration Directory
The Administration Directory persist all addressable entities of one or more healthcare organizations. The Administration Directory MAY implement [these capabilities](./CapabilityStatement-nl-gf-admin-directory-admin-client.html) for an Administration Client to create, update and delete resources. If you've implemented both an Administration Client & Directory, you can also choose to use propriatairy formats/APIs/transactions between these components. 

The Administration Directory MUST implement [these capabilities](./CapabilityStatement-nl-gf-admin-directory-update-client.html) to publish changes of addressable entities. These changes are consumed by an Update Client.

The performance/availability requirements for an Administration Directory:
- **Query Response Time:** 95% of _history requests should be answered within 2000ms.
- **Availability:** Minimum uptime of 99% between 8PM and 6AM.


#### Update Client

The Update Client is responsible for aggregating and synchronizing addressable entity data from multiple Administration Directories. It periodically retrieves updates, including new, modified, or deleted records, and consolidates this information into a Query Directory. 

The Update Client uses a [FHIR 'history-type' transactions](http://hl7.org/fhir/R4/http.html#history) and (optionally) parameter '_since' to get updates from Administration Directories, for example:

```
GET https://somecareprovider.nl/fhirR4/Organization/_history?_since=2025-02-07T13:28:17.239+02:00&_format=application/fhir+json
```
Besides using the 'history-type' transaction, the Update Client should be able to do query everything in the Administration Directory using a search transaction. Either for the inial load or periodically for a full reload to fix edge-case scenario's (e.g. Administration Directory backup restores). 

During consolidation, multiple Administration Directories may have overlapping or conflicting entities. An Update Client MUST obey these guidelines:
- The LRZa Administration Directory is authoritative for Organization instances with `identifier` of system `http://fhir.nl/fhir/NamingSystem/ura` (URA), it's `name` and `status`. When the Healthcare provider's Administration Directory also provides a `name` or `status` value (for an Organization-instance with a URA-identifier), it should be ignored. Other elements from the Healthcare provider's Administration Directory should be added. This way, a Healthcare Provider can add an `alias` or `endpoint` using it's own Administration Directory.
- The LRZa Administration Directory contains a list of healthcare providers (identified by a URA) and the healthcare provider's Administration Directory Endpoint (url). An Administration Directory is only authoritative for the Healthcare Providers that registered this Administration Directory Endpoint (url) at the LRZa. Information from other Healthcare Providers should be disregarded.
- All HealthcareServices, Locations, PractitionerRoles and Organization-entities of a single healthcare provider should (indirectly) link to a top-level Organization-instance with a URA-identifier:
  - All HealthcareService, Location, PractitionerRole entities MUST be directly linked to an Organization-instance (could be 'sub-Organization' like a department).
  - All Organization-instances MUST either link to a parent-Organization or have a URA-identifier (being a top-level Organization instance)

After consolidation, the Update Client writes the updates to a Query Directory. For each instance, the `meta.source` element is populated with the url of that instance at the (source) Administration Directory. The Update Client MAY use the same interactions a Administration Client uses to register entities in an Administration Directory.


#### Query Directory
The Query Directory persist all addressable entities it receives from the Update Client. The Query Directory MAY implement [these capabilities](./CapabilityStatement-nl-gf-admin-directory-admin-client.html) for an Update Client to create, update and delete resources. If you've implemented both an Update Client & Query Directory, you can also choose to use propriatairy formats/APIs/transactions between these components. 

The Query Directory serves/exposes all addressable entities to one or more Query Clients. The Query Directory MAY implement [these capabilities](./CapabilityStatement-nl-gf-query-directory-query-client.html) for a Query Client to search and read resources. If you've implemented both an Query Client & Query Directory, you can also choose to use propriatairy formats/APIs/transactions between these components. 

#### Query Client
The Query Client is used to search and retrieve information from the Query Directory, which contains consolidated data from all Administration Directories. It enables practitioners, EHR systems, and other healthcare applications to discover organizations, departments, practitioners, locations, endpoints, and healthcare services across the entire ecosystem. By querying the Query Directory, users can efficiently find up-to-date and authoritative addressable entities for care coordination, referrals, and electronic data exchange.


### Data models

Within GF Addressing, profiles are used to validate data. They are based both mCSD-profiles and nl-core-profiles (TODO: use Nictiz nl-core package as soon as dependancy-bug is fixed)

- [Organization](./StructureDefinition-nl-gf-organization.html): no extra constraints on top of mCSD & nl-core
- [Endpoints](./StructureDefinition-nl-gf-endpoint.html): extra value set constraint on .payloadType (ref: [ADR 8]()) and additional extention 'replacedBy'. This can be used to point to a new endpoint if the old one has changed or is deprecated. 
- [HealthcareService](./StructureDefinition-nl-gf-healthcareservice.html): value set constraint on .type and .specialty
- [Location](./StructureDefinition-nl-gf-location.html): no extra constraints on top of mCSD & nl-core. 
- [Practitioner](./StructureDefinition-nl-gf-practitioner.html): no extra constraints on top of mCSD & nl-core
- [PractitionerRole](./StructureDefinition-nl-gf-practitionerrole.html): no extra constraints on top of mCSD & nl-core
- [OrganizationAffiliation](./StructureDefinition-nl-gf-organizationaffiliation.html): no extra constraints on top of mCSD & nl-core

Ideally, these profiles are merged in the nl-core-profiles in the future.


### Changing endpoints and the continued integrity of references
Healthcare records (e.g. conditions, observations or procedures) will contain links (references) to addressable entities. Some entities may be referenced by an *identifier* (e.g. a URA or DEZI-number), but most references will use either a local *ID* (e.g. Patient/880e50a3-6516-4861-8dcd-483714b4e1f2) or URL (https://somecareprovider.nl/fhirR4/Patient/880e50a3-6516-4861-8dcd-483714b4e1f2). The (local) IDs and (remote) URLs are definitive and widely supported in the FHIR ecosystem. Identifiers may be harder to resolve, may expose sensitive data (like a Citizen number; Dutch BSN) and can be ambiguous (multiple instances carrying the same identifier).
IDs and URLs are easy in use and (should be) resolvable, but they may break over time which leads to broken references and unresolvable medical records. Try to use endpoints that can remain stable for long periods (5-10 years) and use universally unique IDs (UUIDs) in stead of e.g. incrementing numeric values. If the Endpoint.address (the base part of URLs) must be changed, use the `status` and `replacedBy` extension to properly redirect and fix broken links, ensuring continued integrity of references. Don't delete Endpoint-instances.

For example, care provider 'CP1' uses an EHR from software vendor 'SV1'. This vendor SV1 uses endpoint-url 'https://sv1/fhirR4' for every customer (care provider). Now if CP1 wants to switch to a new vendor, this endpoint-url may risk lots of broken references in many EHR-systems. A better option would be url 'https://sv1/**cp1**/fhirR4' where a change can be applied to all references in a system OR url 'https://cp1/fhirR4' that may prevent a change alltogether (untill fhirR4 is outdated...).

### Security
The service provider of an Administration Directory may choose whether to require mTLS certificates. Certificate Authority PKI-O should be trusted. For cross-border data exchange using mTLS, support for additional CA's is required. If mTLS is not used, Administration Directory endpoints must be unconditionally available to everyone.

### Example use cases

#### Use Case #1: Healthcare service Query
The patient, Vera Brooks, consults with her physician who recommends surgery. The physician can assist the patient in finding a suitable care provider, taking into consideration the location and specialty for orthopedic surgeons.
- Vera Brooks sees her family physician, Dr. West, regarding a recent knee injury.
- Dr. West diagnoses the problem as a torn ACL and decides to refer Vera to an clinic that provides orthopedic specialists.
- Dr. West uses her EHR query tool, which implements a Query Client to search for orthopedic healthcareservices within 30km of Vera’s home.
- The EHR retrieves the information from a Query Directory and displays it to Dr. West.
- Vera and Dr. West decide on the Orthopedic department at Hospital East; Dr. West prepares a referral.
<div>
{% include care-services-use-case-1.svg %}
</div>

#### Use Case #2: Endpoint Discovery
Dr. West just created a referral (for patient Vera Brooks from use case #1). The EHR has to notify Hospital East and the Orthopedic department of this referral. This may include some recurring requests:
- The EHR looks up the Healthcareservice instance of the Orthopedic department at the Query Directory, fetches the related endpoints and checks if these support a 'Transfer of care' payload. If none found:
    - The EHR looks up the associated Organization of the Healthcareservice at the Query Directory, fetches related endpoints and checks if these support a 'Transfer of care' payload. If none found:
        - The EHR looks up the associated/parent Organization of the Organization at the Query Directory, fetches related endpoints and checks if these support a 'Transfer of care' payload. If none found: repeat last step.
- As soon as an endpoint is found, the EHR sends the notification and referral-workflow continues.

<div>
{% include care-services-use-case-2.svg %}
</div>