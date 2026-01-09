### Introduction

This FHIR Implementation Guide specifies the technical components of the Generic Function Consent, a national initiative led by the Dutch Ministry of Health, Welfare and Sport (VWS). The GF Consent aims to establish a standardized, interoperable system for using patient consent as a legal basis for processing medical data, enabling reliable and efficient exchange of health data across healthcare systems and organizations.

This guide outlines the technical requirements and architectural principles underlying the GF Consent. Key design principles include:

- The Mitz agreements and specifications are leading for the use of a national catalogue of patient consent preferences.
- International standards: The solution should be based on international standards, lowering the bar for international (European) data exchange and adoption by internationally operating software vendors.
- Explicit and implicit consent: The GF Consent specifies the use of both explicit and implicit consent.
- Specific and categorical consent: Consents may refer to individual organizations or categories of organizations (based on the Organization Type). I.e. consents can have a very narrow or very broad scope.
- Stakeholder Responsibility: Healthcare providers are accountable for maintaining the accuracy of consent records.

By adhering to these principles, this Implementation Guide supports consistent and secure use of consent information, fostering improved interoperability within the healthcare ecosystem.

### Solution overview

GF Consent defines the use of 3 different types of consents:
- explicit consents stored in a national catalogue of patient consent preferences
- explicit consents stored locally
- implicit consents

#### OTV: Explicit consents stored in a national catalogue of patient consents

For explicit consents stored in a national catalogue of patient consent preferences, this specification uses/follows the [Mitz afsprakenstelsel](https://vzvz.atlassian.net/wiki/spaces/MA11), commonly referred to as the OTV ("Online ToestemmingsVoorziening").
The consents stored in Mitz can't be queried directly, but Mitz can process input (data user organization of type X, patient Y and data holder organization of type Z) and return a policy decision (allow/deny) based on the consent preferences stored in Mitz. See the chapters called 'Gesloten Autorisatievraag' in ["Implementatiehandleiding_OpenGesloten"](https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten) for more information.


#### DHTV: Explicit consents stored locally

GF Consent recognizes the possibility of using explicit consents stored decentrally, e.g. in an EHR or other system managed by the data holder organization (commonly referred to as a DHTV, dossierhouderstoestemmingsvoorziening). The GF Consent does not define agreements and specifications for the internal processing and storage of a DHTV. GF Consent does define agreements and specifications to standardize the data models and interfaces for creating, reading and updating consents on the DHTV, because:
- Standardization enables personal health records, client portals and other patient and/or professional facing applications to create, read and update consents in DHTV's.
- Standardization ensures consistency of meaning (syntactical and semantic interoperability) between Consents records of various sources.

##### DHTV keeping copies of OTV consents
The DHTV can have the option to publish/subscribe to changes in consent preferences registered in the OTV. The following actions can be used by the DHTV of a data holder organization:
1. Subscribing to Consent changes: A data holder organization can choose to subscribe to Consent record changes of a specific patient. See the chapters called 'Toestemmingsabonnement' in ["Implementatiehandleiding_Migreren-Abonneren-Notificeren-Registreren Toestemming"](https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten).
2. Receiving notification about Consent: Subscribers (see process 1) receive a notification when Consent changes occur in the Mitz consent preference catalogue. See the chapters called 'Toestemmingsnotificatie' in ["Implementatiehandleiding_Migreren-Abonneren-Notificeren-Registreren Toestemming"](https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten).

#### Implicit consents

GF Consent recognizes the possibility of using implict consents as a legal basis for the processing of medical data. In the Netherlands, implicit consent is defined as a consent that can be implied/ assumed. For example, in the case of a referral or handoff sent with the patient's knowledge (and approval) to a specific healthcare provider (see chapter 'Veronderstelde Toestemming' in NEN 7517 for more details). Consent-records are an important input for GF Authorization and need to be explicit in order to evaluate the consents of a patient. Making implicit consent explicit (and storing/updating these consents) is a responsibility of the care provider. 

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
This specification reuses the definition of Mitz Consent Registry as described in the [Mitz afsprakenstelsel](https://vzvz.atlassian.net/wiki/spaces/MA11). OTV/Mitz as Consent Registry actor only defines interfaces for subscription and notification of consent changes. See ["Implementatiehandleiding_Migreren-Abonneren-Notificeren-Registreren Toestemming"](https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten). 

#### Consent registry: DHTV
This specification reuses the definition of the [IHE PCF Consent Registry](https://profiles.ihe.net/ITI/PCF/CapabilityStatement-IHE.PCF.consentRegistry.html). A DHTV could implement the [IHE PCF Consent Registry capabilitystatement](https://profiles.ihe.net/ITI/PCF/CapabilityStatement-IHE.PCF.consentRegistry.html) as [GF Authorization](./authorization.html) uses consents in access/authorization policies.

#### Consent Authorization Server: OTV
This specification reuses the definition of the Mitz Authorization Server as described in the [Mitz afsprakenstelsel](https://vzvz.atlassian.net/wiki/spaces/MA11). OTV/Mitz as Consent Authorization Server actor only defines interfaces for the authroization or policy decision also known as ["gesloten vraag"](https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten). 


#### Consent Authorization Server/Enforcement Point: DHTV 
The (enforcement of) authorization or access are part of [GF Authorization](./authorization.html) and not further specified here.



### Data models

GF Consent reuses 2 datamodels to hold consents the OTV/Mitz FHIR Consent profile and IHE PCF FHIR Consent profile.

#### FHIR Consent: OTV

If Mitz/OTV Consents are stored and used locally (at the authorization server or policy decision point of the data holder), the data model SHALL comply to the specification in the [Mitz afsprakenstelsel](https://vzvz.atlassian.net/wiki/spaces/MA11).

#### FHIR Consent: DHTV

GF Consent reuses the [IHE PCF Explicit Intermediate Consent](https://profiles.ihe.net/ITI/PCF/StructureDefinition-IHE.PCF.consentIntermediate.html) profile.

<div markdown="1" class="w-100 bg-danger">
> The IHE PCF Consent profile is evaluated in the Proof of concept phase, but it does not align with the profile in Mitz. Further analysis and (implementer) feedback is needed. This analysis/decision is discussed [here](https://github.com/nuts-foundation/nl-generic-functions-ig/issues/47)
</div>
