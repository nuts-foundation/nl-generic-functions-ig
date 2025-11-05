### Introduction

This FHIR Implementation Guide specifies the technical components of the Generic Function Consent (GFC), a national initiative led by the Dutch Ministry of Health, Welfare and Sport (VWS). GFC aims to establish a standardized, interoperable system for using patient consent as a legal basis for processing medical data, enabling reliable and efficient exchange of health data across healthcare systems and organizations.

This guide outlines the technical requirements and architectural principles underlying GFC, with a focus on x, y and z. Key design principles include:

- Mitz: The Mitz agreements and specifications are leading for the use of a national catalogue of patient consents.
- International standards: The solution should be based on international standards, lowering the bar for international (European) data exchange and adoption by internationally operating software vendors.
- Explicit and implicit consent: GFC specifies the use of both explicit and implicit consent.
- Specific and categorical consent: GFC specificies the use of consents concerning individual data holder organizations and/or data user organizations and consents concerning categories of data holder organizations and/or data user organizations, where categories are based on Organization Type.
- Stakeholder Responsibility: Healthcare providers are accountable for maintaining the accuracy of consent records.

By adhering to these principles, this Implementation Guide supports consistent and secure use of consent information, fostering improved interoperability within the healthcare ecosystem.

### Solution overview

GFC defines the use of 3 different types of consents:
a. explicit consents stored in a national catalogue of patient consents
b. explicit consents stored locally
c. implicit consents (HOW TO )

#### a. explicit consents stored in a national catalogue of patient consents

GFC follows the agreements and specifications in the [Mitz afsprakenstelsel](https://vzvz.atlassian.net/wiki/spaces/MA11) for the use of consents stored in a national catalogue of patient consents.

Here is a brief overview of the GFC processes concerning the use of consents registered in Mitz consent catalogue:
1. Subscribing to consent choices changes: A data holder organization can choose to subscribe to consent choices changes of a specific patient. See the chapters called 'Toestemmingsabonnement' in  "Implementatiehandleiding_Migreren-Abonneren-Notificeren-Registreren Toestemming"(https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten).
2. Mitz closed authorization question: A data holder organization can send a request to Mitz to check whether a consent is registered in the Mitz consent catalogue that applies to the URA and/or an Organization Type of the data holder organization and the Organization Type of the data user organization. See the chapters called 'Gesloten Autorisatievraag' in  "Implementatiehandleiding_OpenGesloten"(https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten).
3. Receiving notification about consent choice: Subscribers (see process 1) receive a notification when consent choice changes occur in the Mitz consent catalogue. See the chapters called 'Toestemmingsnotificatie' in "Implementatiehandleiding_Migreren-Abonneren-Notificeren-Registreren Toestemming"(https://vzvz.atlassian.net/wiki/spaces/MA11/pages/828314367/Bijlage+Architectuurdocumenten).

#### b. explicit consents stored locally
GFC also defines agreements and specifications for the use of explicit consents stored decentrally, e.g. in an EHR or other system managed by the data holder organization. These agreements and specifications will be added later, see section 'Roadmap for Consent'.

#### c. implicit consents
GFC also defines agreements and specifications for the use of implicit consents.




### Roadmap for Consent

#### Use of local consent
to do

#### Use of implicit consent
to do
