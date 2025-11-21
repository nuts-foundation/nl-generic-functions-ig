### Introduction

This FHIR Implementation Guide specifies the technical components of the Generic Function Consent, a national initiative led by the Dutch Ministry of Health, Welfare and Sport (VWS). The GF Consent aims to establish a standardized, interoperable system for using patient consent as a legal basis for processing medical data, enabling reliable and efficient exchange of health data across healthcare systems and organizations.

This guide outlines the technical requirements and architectural principles underlying the GF Consent. Key design principles include:

- The Mitz agreements and specifications are leading for the use of a national catalogue of patient consents.
- International standards: The solution should be based on international standards, lowering the bar for international (European) data exchange and adoption by internationally operating software vendors.
- Explicit and implicit consent: The GF Consent specifies the use of both explicit and implicit consent.
- Specific and categorical consent: The GF Consent specifies the use of consents concerning individual data holder organizations and/or data user organizations and consents concerning categories of data holder organizations and/or data user organizations, where categories are based on Organization Type.
- Stakeholder Responsibility: Healthcare providers are accountable for maintaining the accuracy of consent records.

By adhering to these principles, this Implementation Guide supports consistent and secure use of consent information, fostering improved interoperability within the healthcare ecosystem.

### Solution overview

GF Consent defines the use of 3 different types of consents:
- explicit consents stored in a national catalogue of patient consents
- explicit consents stored locally
- implicit consents

#### OTV: Explicit consents stored in a national catalogue of patient consents

For explicit consents stored in a national catalogue of patient consents, this specification uses/follows the [Mitz afsprakenstelsel](https://vzvz.atlassian.net/wiki/spaces/MA11), commonly referred to as the OTV ("Online ToestemmingsVoorziening").
The consents stored in Mitz can't be queried directly, but Mitz can process input (data requester of organization type X, patient Y and data holder of organization type Z) and return a policy decision (allow/deny) based on the consent stored in Mitz. See the chapters called 'Gesloten Autorisatievraag' in ["Implementatiehandleiding_OpenGesloten"](https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten) for more information.


#### DHTV: Explicit consents stored locally

GF Consent recognizes the possibility of using explicit consents stored decentrally, e.g. in an EHR or other system managed by the data holder organization (commonly referred to as a DHTV, dossierhouderstoestemmingsvoorziening). The GF Consent does not define agreements and specifications for the internal processing and storage of a DHTV. GF Consent does define agreements and specifications to standardize the data models and interfaces for creating, reading and updating consents on the DHTV, because:
- Standardization enables personal health records, client portals and other patient and/or professional facing applications to create, read and update consents in DHTV's.
- Standardization ensures consistency of meaning (syntactical and semantic interoperability?) between consents of various sources (OTV and/or one or more DHTV's). This consistency of meaning is necessary to correctly process combinations of consents of various sources in an authorization/data access policy.

##### DHTV keeping copies of OTV consents
In order to reduce operational dependencies on a central, national catalogue, the DHTV shall have the option to publish/subscribe to changes in the consent at the OTV. These can be used by the data holder organization (DHTV) to store and use theses consents locally:
1. Subscribing to consent choices changes: A data holder organization can choose to subscribe to consent choices changes of a specific patient. See the chapters called 'Toestemmingsabonnement' in ["Implementatiehandleiding_Migreren-Abonneren-Notificeren-Registreren Toestemming"](https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten).
1. Receiving notification about consent choice: Subscribers (see process 1) receive a notification when consent choice changes occur in the Mitz consent catalogue. See the chapters called 'Toestemmingsnotificatie' in ["Implementatiehandleiding_Migreren-Abonneren-Notificeren-Registreren Toestemming"](https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten).

#### Implicit consents

GF Consent recognizes the possibility of using implict consents as a legal basis for the processing of medical data. In the Netherlands, implicit consent is defined as a consent that can be implied/ assumed. For example, in the case of a referral or handoff sent with the patient's knowledge to a specific healthcare provider (see chapter 'Veronderstelde Toestemming' in NEN 7517 for more details). Consent-records are an important input for GF Authorization and need to be explicit in order to evaluate the consents of a patient. Making implicit consent explicit (and storing/updating these consents) is a responsibility of the care provider. 

### Processing multiple consents

In real life, one data request can be linked to multiple explicit consents, stored either in a national catalogue of patient consents or locally. When multiple consents apply to one data request, conflicts can arise. The GF Consent specifies the following about processing multiple consents that apply to the same data request:
1. More specific consents supersede less specific consents
1. Consents concerning an individual data holder organizations are more specific than consents concerning a category of data holder organizations
1. Consents concerning an individual data user organizations are more specific than consents concerning a category of data user organizations
1. Consents concerning a specific context are more specific than consents that do not concern a specific context
1. Consents concerning specific resources are more specific than consents that do not concern specific resources
1. Objections are seen as negative consents
1. In case of an objection and a consent with equal specificness: Objections supersede consents


### Components (actors)

#### Consent recorder
This specification reuses the definition of the [IHE PCF Consent Recorder](https://profiles.ihe.net/ITI/PCF/volume-1.html#153111-consent-recorder). 

#### Consent registry: OTV
This specification reuses the definition of MITZ Consent Registry as described in the [Mitz afsprakenstelsel](https://vzvz.atlassian.net/wiki/spaces/MA11). OTV/MITZ as Consent Registry actor only defines interfaces for subscription and notification of consent changes. See ["Implementatiehandleiding_Migreren-Abonneren-Notificeren-Registreren Toestemming"](https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten). 

#### Consent registry: DHTV
This specification reuses the definition of the [IHE PCF Consent Registry](https://profiles.ihe.net/ITI/PCF/CapabilityStatement-IHE.PCF.consentRegistry.html). A DHTV could implement the [IHE PCF Consent Registry capabilitystatement](https://profiles.ihe.net/ITI/PCF/CapabilityStatement-IHE.PCF.consentRegistry.html) as [GF Authorization](./authorization.html) uses consents in access/authorization policies.

#### Consent Authorization Server: OTV
This specification reuses the definition of the MITZ Authorization Server as described in the [Mitz afsprakenstelsel](https://vzvz.atlassian.net/wiki/spaces/MA11). OTV/MITZ as Consent Authorization Server actor only defines interfaces for the authroization or policy decision also known as ["gesloten vraag"](https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten). 


#### Consent Authorization Server/Enforcement Point: DHTV 
The (enforcement of) authorization or access are part of [GF Authorization](./authorization.html) and not further specified here.



### Data models

GF Consent reuses 2 datamodels to hold consents the OTV/MITZ FHIR Consent profile and IHE PCF FHIR Consent profile.

#### FHIR Consent: OTV

If MITZ/OTV Consents are stored and used locally (at the authorization server or policy decision point of the data holder), the data model SHALL comply to the specification in the [Mitz afsprakenstelsel](https://vzvz.atlassian.net/wiki/spaces/MA11).

#### FHIR Consent: DHTV

GF Consent reuses the [IHE PCF Explicit Intermediate Consent](https://profiles.ihe.net/ITI/PCF/StructureDefinition-IHE.PCF.consentIntermediate.html) profile.
