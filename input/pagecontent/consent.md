### Introduction

This FHIR Implementation Guide specifies the technical components of the Generic Function Consent, a national initiative led by the Dutch Ministry of Health, Welfare and Sport (VWS). The GF Consent aims to establish a standardized, interoperable system for using patient consent as a legal basis for processing medical data, enabling reliable and efficient exchange of health data across healthcare systems and organizations.

This guide outlines the technical requirements and architectural principles underlying the GF Consent, with a focus on x, y and z. Key design principles include:

- The Mitz agreements and specifications are leading for the use of a national catalogue of patient consents.
- International standards: The solution should be based on international standards, lowering the bar for international (European) data exchange and adoption by internationally operating software vendors.
- Explicit and implicit consent: The GF Consent specifies the use of both explicit and implicit consent.
- Specific and categorical consent: The GF Consent specificies the use of consents concerning individual data holder organizations and/or data user organizations and consents concerning categories of data holder organizations and/or data user organizations, where categories are based on Organization Type.
- Stakeholder Responsibility: Healthcare providers are accountable for maintaining the accuracy of consent records.

By adhering to these principles, this Implementation Guide supports consistent and secure use of consent information, fostering improved interoperability within the healthcare ecosystem.

### Solution overview

GF Consent defines the use of 3 different types of consents:
- explicit consents stored in a national catalogue of patient consents
- explicit consents stored locally
- implicit consents

#### OTV: Explicit consents stored in a national catalogue of patient consents

GF Consent follows the agreements and specifications in the [Mitz afsprakenstelsel](https://vzvz.atlassian.net/wiki/spaces/MA11) for the use of consents stored in a national catalogue of patient consents, commonly referred to as an OTV ("Online toestemmingsvoorziening").

Here is a brief overview of the GF Consent processes concerning the use of consents registered in Mitz consent catalogue:
1. Subscribing to consent choices changes: A data holder organization can choose to subscribe to consent choices changes of a specific patient. See the chapters called 'Toestemmingsabonnement' in ["Implementatiehandleiding_Migreren-Abonneren-Notificeren-Registreren Toestemming"](https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten).
2. Mitz closed authorization question: A data holder organization can send a request to Mitz to check whether a consent is registered in the Mitz consent catalogue that applies to the URA and/or an Organization Type of the data holder organization and the Organization Type of the data user organization. See the chapters called 'Gesloten Autorisatievraag' in ["Implementatiehandleiding_OpenGesloten"](https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten).
3. Receiving notification about consent choice: Subscribers (see process 1) receive a notification when consent choice changes occur in the Mitz consent catalogue. See the chapters called 'Toestemmingsnotificatie' in ["Implementatiehandleiding_Migreren-Abonneren-Notificeren-Registreren Toestemming"](https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten).

#### DHTV: Explicit consents stored locally

GF Consent recognizes the possibility of using explicit consents stored decentrally, e.g. in an EHR or other system managed by the data holder organization (commonly referred to as a DHTV, dossierhouderstoestemmingsvoorziening). The GF Consent does not define agreements and specifications for the internal functionality of a DHTV. The GF Consent does define agreements and specifications to standardize the data models and interfaces for creating, reading and updating consents on the DHTV. The rationale for this is twofold:
-  Standardization enables personal health records, client portals and other patient and/or professional facing applications to create, read and update consents in DHTV's.
- Standardization ensures consistency of meaning (syntactical and semantic interoperability?) between consents of various sources (OTV and/or one or more DHTV's). This consistency of meaning is necessary to correctly process combinations of consents of various sources.

#### Implicit consents

GF Consent recognizes the possibility of using implict consents as a legal basis for the processing of medical data. In the Netherlands, implict consent is defined as a consent that can be implied/ assumed. For example, in the case of a referral or handoff sent with the patient's knowledge to a specific healthcare provider (see chapter 'Veronderstelde Toestemming' in NEN 7517 for more details). GF Consent does not define agreements and specifications for the implementation of implicit consents. It is up to the data holder organizations and/or its data processors to make choices about this.

### Processing multiple consents

In real life, one data request can be linked to multiple explicit consents, stored either in a national catalogue of patient consents or locally. When multiple consents apply to one data request, conflicts can arise. The GF Consent specifies the following about processing multiple consents that apply to the same data request:
- More specific consents supersede less specific consents
- Consents concerning an individual data holder organizations are more specific than consents concerning a category of data holder organizations
- Consents concerning an individual data user organizations are more specific than consents concerning a category of data user organizations
- Consents concerning a specific context are more specific than consents that do not concern a specific context
- Consents concerning specific resources are more specific than consents that do not concern specific resources
- Objections are seen as negative consents
- In case of an objection and a consent with equal specificness: Objections supersede consents


### Components (actors)

#### OTV

See the [Mitz afsprakenstelsel](https://vzvz.atlassian.net/wiki/spaces/MA11).

#### DHTV

Reuse the following actors defined in IHE-PCF:
- Consent Recorder: some text. See [IHE PCF Consent Recorder](https://build.fhir.org/ig/IHE/ITI.PCF/branches/master/volume-1.html#153111-consent-recorder).
- Consent Registry: This is the DHTV itself. See [IHE PCF Consent Registry](https://build.fhir.org/ig/IHE/ITI.PCF/branches/master/volume-1.html#153112-consent-registry).
- Consent Authorization Server: The PDP. See [IHE PCF Consent Authorization Server](https://build.fhir.org/ig/IHE/ITI.PCF/branches/master/volume-1.html#153113-consent-authorization-server).

### Data models

GF Consent ensures (semantic?) interoperability between OTV and DHTV by combining the reuse of Mitz-specifications for OTV and the reuse of data models defined in [IHE-PCF](https://build.fhir.org/ig/IHE/ITI.PCF/branches/master/index.html).

#### OTV

GF Consent complies to the data model specifications in the [Mitz afsprakenstelsel](https://vzvz.atlassian.net/wiki/spaces/MA11).

#### DHTV

GF Consent complies to the [IHE PCF Explicit Intermediate Consent](https://build.fhir.org/ig/IHE/ITI.PCF/branches/master/StructureDefinition-IHE.PCF.consentIntermediate.html) Resource Profile that is specified in IHE-PCF.

#### Mapping OTV-DHTV Consent

!!Please insert a table here that maps the Mitz Consent data model to the IHE PCF Explicit Intermediate Consent!!

### Security

#### OTV

GF Consent complies to the security specfications in the [Mitz afsprakenstelsel](https://vzvz.atlassian.net/wiki/spaces/MA11).

#### DHTV

Security requirements for interacting with the standardized CRU-interface of DHTV:

Network-later-encryption:
- Use TLS with PKIo

Authentication: 
- client authentication of DHTV-consumer vendor using mTLS with PKIo
- The DHTV-consumer must act on behalf of either a data holder organization OR a patient  
- Authenticating data holder organization, see IG Authentication
- Authenticating patient see IG Authentication/DigID?

Logic:
- If DHTV-consumer acts on behalf of a patient, it can only CRU Consents with Consent.patient == that patient
- If DHTV-consumer acts on behalf of a data holder organization, it can only CRU Consents with Consent.organization == that data holder organization
