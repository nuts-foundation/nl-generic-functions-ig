### Introduction
This FHIR Implementation Guide specifies the Generic Function 'Medical Record Localization' (GF Localization), a national initiative led by the Dutch Ministry of Health, Welfare and Sport (VWS). GF-Localization provides a standardized framework that enables healthcare professionals to discover which organizations hold relevant patient data of a specific type, ensuring GDPR compliance through proportionality and subsidiarity principles while facilitating secure and efficient health information exchange.

Patient data is divided over multiple data holders. In today’s healthcare landscape organizations rely on several different types of indices to find data concerning a specific patient and context. However, none of these indices are complete and
all of these indices have different requirements for usage, hindering interoperability and timely access to health information. GF-Localization addresses this challenge by providing a unified framework that ensures an index of all data holders concerning a specific patient and type that is easily and securely accessible.

This guide outlines the technical requirements and architectural principles underlying GF-Localization, with a focus on trust, authenticity, and data integrity. Key design principles include:

- International standards: The solution should be based on international standards, lowering the bar for international (European) data exchange and adoption by internationally operating software vendors.
- Single Source of Truth: Each localization record originates from exactly one organization: the data holder itself.
- Stakeholder Responsibility: Data holders are accountable for maintaining the accuracy of localization records at the Localization service.

By adhering to these principles, this Implementation Guide supports consistent and secure data holder discovery, fostering improved interoperability within the healthcare ecosystem.

### Solution overview

GF-Localization follows the choices made by the MinVWS Localization working group, see [GF-Lokalisatie, ADR's](https://github.com/orgs/minvws/projects/70/views/1). This guide specifies the choices made. Most impactful/striking choice are:

- Each General Practitioner hosts a Localization Service for their patients, which can be used by the care providers of that patient. 
- If the GP is unknown and cannot be established during patient-registration (e.g. patient is unconscious in an emergency situation), a GP-citizen-index (e.g. NVI, ION or Mitz) can be used to lookup the GP. (***out-of-scope for this version***)

Here is a brief overview of the processes that are involved: 
1. Every data holder registers care episodes at the GP-localization-service (when patient consents)
1. A data user (practitioner and/or system (EHR)) can now use the GP-localization-service to discover data holders and episodes of care for a specific patient.

The Localization service-response provides a list of data holders; the endpoints of these data holders (e.g. FHIR or DICOM-urls) need to be resolved using a [Care service (Query) Directory](./care-services.html#query-directory). 

<img src="localization-gp-overview-transactions.png" width="60%" style="float: none" alt="Overview of transactions in the Medical Record Localization solution."/>

For more detail on the topology of GF-Localization, see [GF-Lokalisatie, ADR-2](https://github.com/minvws/generiekefuncties-lokalisatie/issues/15). In this Localization-solution, the decentralized topology was chosen instead of a centralized setup
Each component, data model, and transaction will be discussed in more detail.

### Components (actors)

#### Localization Service

A (Medical Record) Localization Service is responsible for managing the registration, maintenance, and publication of localization records. It should be able to create and update localization records internally. A Localization Service MUST implement these [FHIR capabilities](./CapabilityStatement-nl-gf-localization-gp-repository.html) which basically involves searching for FHIR EpisodeOfCare records (see [Localization record](#localization-record)). 
The [TA Notified Pull](https://www.twiin.nl/tanp) is used for create/update transactions, so the Localization Service shall expose an endpoint capable of receiving Twiin-TA-notification payloads. The Localization Service is expected to handle the notification (i.e. get the EpisodeOfCare, rewriting remote/local references and create/update the local repository).

#### Localization Client
Localization Clients shall register/push each localization (episode of care) record to the GP-localization-service. Each update in a care episode is also pushed to the GP-localization-service (for example, when a care episode is finished). For the registration of new/updated EpisodeOfCare-records, the TA Notified Pull specification is used (i.e. send a notification of a new/updated EpisodeOfCare resource to the GP). 

A Localization Client can search for other care episodes at the GP-localization-service using a regular `GET [GP-localization-service base url]/EpisodeOfCare?patient=[patient-id]`. Each episode of care points to a care provider (data holder) that may have data relevant for the Localization Client.
In order to get the `[patient-id]`, the [$match operation](https://hl7.org/fhir/R4/patient-operation-match.html) shall be used.


When a patient moves to a different General Practitioner, an extra step is needed by the new GP:
- the new GP has to register the EpisodeOfCare at the old GP-localization-service (like any other care provider)
- *the new GP copies all EpisodeOfCare-records from the old GP-localization-service*
- the old GP ends the active EpisodeOfCare-record using `.status = finished` (like any other care provider)
These steps ensure that every care provider is pointed to the active GP-localization-service and is updated on any new GP relationship.  


### Data models

#### Localization record

Within GF-Localization the [NL-gf-EpisodeOfCare profile](./StructureDefinition-nl-gf-episodeofcare.html) is used to register, search, and validate localization records ([NL-GF-IG, ADR#10](https://github.com/nuts-foundation/nl-generic-functions-ig/issues/10)).
This profile is based on the [NL-Core-EpisodeOfCare](https://simplifier.net/nictiz-r4-zib2020/nlcoreepisodeofcare) profile and adds/requires an author-assigned identifier.
The content of the EpisodeOfCare resource can be used to determine if a care provider (data holder) has relevant data for the data user.

The EpisodeOfCare is used here primarily for Localization, but it may also be used other purposes:
- A consistent overview of care episodes for a specific patient
- Check active treatment relationships (between the patient and a General Practitioner, between the patient and any type of care provider).
- The `EpisodeOfCare.team` element may be used to point to a CareTeam of care providers (from different organizations) collaborating for a specific patient in related episodes (thereby creating groups of related episodes).


### Security and Privacy Considerations

Data registration and retrieval shall follow regular security and privacy considerations for personal health information. Data is stored at and exchanged between care providers. 
Authentication en Authorization measures shall be in place so that parties can only publish and edit Localization/EpisodeOfCare-records concerning themselves. Localization clients can only publish an EpisodeOfCare to the Localization-service when patient has given consent for that.

---

### Example Use Cases

#### Use case: Radiologist registering Imaging Data
**Scenario**: Dr. Carter, a radiologist at a care provider organization, performs an imaging study for a patient. This imaging study is related to an EpisodeOfCare that is created at the start of the imaging study. To enable data discovery by other healthcare professionals, Dr. Carter's organization registers this EpisodeOfCare at the GP-Localization-service. 


{% include localization-gp-internist-registration.svg %}


#### Use Case: Cardiologist searching for Imaging Data

**Scenario**: Dr. Smith, a cardiologist at Hospital A, is treating a patient who was recently referred from another hospital. She needs to know what imaging data (X-rays, CT scans, MRIs) might be available from other healthcare providers to avoid unnecessary duplicate examinations and to get a complete picture of the patient's medical history.


{% include localization-gp-cardiologist-search.svg %}


### Roadmap for GF Localization

#### Localization Service
Potential future enhancements to the Localization Service include:
- Audit logging capabilities (MUST HAVE, TODO)