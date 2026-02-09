# Profile keuze Localisatie

Requirements vanuit localisatie (functionaliteit voor gebuiker); 
- zoeken op patient (pseudoniem)
- zoeken op datacategorien
- zoeken op organisatiecategorien
- zoeken op organisatie (of liever (ook) op applicatie om registratie te kunnen controleren??)

Hier worden enkele varianten van een datamodel om Localisatie-records uit te wisselen met de NVI besproken. Als uitgangspunt is het [IHE-MHD Minimal.SubmissionSet profile gekozen binnen IHE MHD. Keuze voor IHE MHD als uitganspunt; zie elders (internationale standaarden/FHIR-besluit; IHE-MHD. Huidig gebruik binnen Medmij en AORTA-stelsel)

## IHE-MHD Minimal.SubmissionSet

Het profile [Minimal.SubmissionSet](https://profiles.ihe.net/ITI/MHD/StructureDefinition-IHE.MHD.Minimal.SubmissionSet.html) definieert basisgegevens en zoekparameters:
- subject (gepseudonimiseerde patient identifier)
- sourceId (URA-identifier van publicerende origanisatie)
- designationType (Expresses contentType)
The profile has some required/mustSupport attributes:
- mode (fixed code: 'working')
- status (fixed code: 'current')
- code (fixed code: 'submissionset')
- source (the patient, practitioner(-role) or device which defined the content)
- entryUUID (uniqueId Identifier holding a OID)
- uniqueId (entryUUID Identifier holding a UUID)

## IHE-MHD UnContained.Comprehensive.SubmissionSet

Het profile [UnContained.Comprehensive.SubmissionSet](https://profiles.ihe.net/ITI/MHD/StructureDefinition-IHE.MHD.UnContained.Comprehensive.SubmissionSet.html) adds a requirement (1..1 cardinality) for attributes:
- designationType (Expresses contentType)
- subject (gepseudonimiseerde patient identifier)
 For the NVI, a contentType and subject will be required to register, so this profile probably has the best fit for NVI requirements

## IHE-MHD Minimal Folder

Het profile [Minimal Folder](https://profiles.ihe.net/ITI/MHD/StructureDefinition-IHE.MHD.Minimal.Folder.html) is used to categorize entries. It does not have a source or sourceId attribute; therefore it does not meet the requirements

## AORTA DataReference

When comparing the [AORTA DataReference profile](https://simplifier.net/vzvz/aorta-datareference) to the [IHE-MHD UnContained.Comprehensive.SubmissionSet profile](https://profiles.ihe.net/ITI/MHD/StructureDefinition-IHE.MHD.UnContained.Comprehensive.SubmissionSet.html), it has these differences:
- tag: an updateReason is added for the notification-functionalty in AORTA (to avoid certain notifications)
- contained: all referenced entities are expected to be contained in the resourced. This doesn't meet the NVI-privacy-requirements
- code: the 'content type' is in attribute (extension) 'designationType' in the MHD-profile. So both profile have a contentType-attribute, but under a different attribute name.
- source: the AORTA profile is restricted to a Device or NLVZVZDevice (no Patient or Practitioner(Role) as source)
- the AORTA profile does have an `emptyReason` attribute with a fixed code ('withheld')
- the AORTA profile does not have an `entry` attribute
- the AORTA profile does not have an `sourceId` attribute
- the AORTA profile does not have an `entryUUID` attribute
- the AORTA profile does not have an `uniqueId` attribute


## Medmij Images List
When comparing the [Medmij Images List](https://simplifier.net/packages/nictiz.fhir.nl.stu3.images/1.0.3/files/714353) to the [IHE-MHD UnContained.Comprehensive.SubmissionSet profile](https://profiles.ihe.net/ITI/MHD/StructureDefinition-IHE.MHD.UnContained.Comprehensive.SubmissionSet.html), it has these differences:
- recipient: optional practitioner(role) that is the recipient of the Images List
- identifier: at least 1 identifier (mapping to entryUUID and uniqueId)
- mode: (fixed code: 'snapshot' in stead of 'working')
- entry: at least 1 and max 3 items


## Conclusie
https://build.fhir.org/ig/nuts-foundation/nl-generic-functions-ig/branches/localization-using-FHIR-list/StructureDefinition-nl-gf-localization-list.html 


## Achtergrond keuzes AORTA m.b.t. FHIR List

De naam van het profiel is AortaDataReference om aan te geven waar het in essentie voor gebruikt wordt (een verwijzing naar een gegevensverzameling binnen een op AORTA aangesloten systeem). De onderliggende FHIR-resource is List, omdat IHE deze ook heeft gekozen bij het FHIR-koppelvlak voor XDS. Oorspronkelijk zijn binnen FHIR de resource types DocumentManifest en DocumentReference bedacht om een XDS-registry te ondersteunen. Op een later moment heeft IHE er binnen het MHD-profiel echter voor gekozen om DocumentManifest niet meer te gebruiken en in plaats daarvan resource type List toe te passen voor het folder concept binnen XDS (zie de MHD-specificatie: https://profiles.ihe.net/ITI/MHD/ITI-66.html). Voor referenties naar afzonderlijke documenten gebruikt MHD nog wel DocumentReference. Aangezien het lokalisatieregister van AORTA (evenals de beoogde NVI) werkt op het niveau van gegevensverzamelingen (en niet aparte documenten of objecten) sluit dit aan op het folderconcept van XDS. Om toekomstige integratie te bevorderen hebben we dus deze keuze bij AORTA gevolgd.

 

Van ons FHIR-profiel AortaDataReference licht ik de afwijkingen op het core FHIR-profiel voor List toe (hieronder een afbeelding van de diff uit Simplifier).



In List.meta.tag nemen we een updateReason op. Deze wordt alleen in bijzonder gevallen gevuld door het aanmeldende systeem, nl. als er een bijzondere context is voor de aanmelding bij het lokalisatieregister. Momenteel onderkennen we waarden ‘BEHEER’ (als de aanmelding bij ons lokalisatieregister om administratieve redenen plaatsvindt, zoals de migratie naar een andere applicatie of het fuseren van zorgaanbieders) en ‘OPNAME’ (als de aanmelding getriggerd wordt door een gegevensmutatie tijdens de opname van de patiënt). In beide gevallen willen we nl. dat het LSP de mogelijkheid heeft om het sturen van notificaties aan geabonneerde systemen te onderdrukken. Bij beheeracties is nl. geen sprake van een relevante mutatie voor raadplegende systemen en bij opgenomen patiënten wil men ook vaak dat notificaties gedempt worden.

 

Als contained resources nemen we een Device en een Patient resource instance op. De Device resource hangt samen met List.source en de Patient resource met List.subject (zie verder hieronder).

 

List.status en List.mode zetten we vast op ‘current’ en ‘working’, aansluitend bij de semantiek van records in ons lokalisatieregister.

 

List.code verwijst naar de ‘gegevenscategorie’ van de achterliggende gegevens bij het bronsysteem. Zoals aangegeven werken we daarbij met ‘bouwsteentypen’ die conceptueel aansluiten bij de ZIB’s van Nictiz (waarbij onze bouwsteentypes soms minder granulair zijn omdat verdere verfijning geen meerwaarde biedt qua lokalisatie). In de toelichting zien jullie ook de optie om ‘gegevenssoorten’ aan te duiden. Dat was de methode die we vóór AORTA 8 hanteerden om gegevens te typeren. Die wordt nog ondersteund voor het raadplegen van legacy aanmeldingen, maar wordt niet meer toegepast bij nieuwe aanmeldingen o.b.v. FHIR. Zoals beloofd zal ik nog een lijstje opleveren met de gebruikte bouwsteentypes. Om er zeker van te zijn dat dit een compleet en actueel overzicht is, heb ik nog een check uitstaan bij de AORTA-architecten.

 

List.subject bevat een referentie naar een contained Patient resource. Hierin zit als Patient.identifier het BSN van de patiënt (dit zou ook een pseudoniem kunnen zijn indien dit een landelijke ontwerpkeuze wordt). Daarnaast geven we in Patient.birthDate de geboortedatum door. Deze wordt NIET opgeslagen, maar alleen doorgegeven aan Mitz, omdat daar bekend moet zijn of de patiënt zelf toestemmingen mag beheren.

 

List.date bevat een timestamp die aangeeft wanneer de achterliggende gegevens in het bronsysteem zijn gewijzigd (de zogenaamde ‘actualiteit’). Dit attribuut is momenteel verplicht, maar is niet randvoorwaardelijk voor onze implementatie (als zou blijken dat dit een te hoog privacy-risico zou opleveren bij pseudonimisering). Bij aanmelden zouden we ook de LSP-kloktijd kunnen gebruiken en bij opleveren is het niet essentieel.

 

List.source bevat een referentie naar een contained Device resource. Hierin zit als Device.identifier het zogenaamde ‘applicatie ID’ binnen AORTA. Vanzelfsprekend zou bij een infrastructuur-overstijgende oplossing een meer universele identificatie van systemen gebruikt moeten worden. Waarom wordt als bron een systeem aangeduid en niet alleen de zorgaanbieder waarbij dat systeem operationeel is? Binnen een zorgaanbieder kunnen meerdere applicaties actief zijn, zelfs voor het beheer van hetzelfde type gegevens. Binnen AORTA doet de applicatie waarin de gegevens worden beheerd ook de aanmelding in het lokalisatieregister. Het ligt dan voor de hand om bij raadpleging van het register (of raadpleging van gegevens op basis daarvan) ook de betrokken applicatie te kennen, zodat geen aparte bevraging van een adresseringsfunctie nodig is (met mogelijk ambigu resultaat). Belangrijk is dat in Device.owner de zorgaanbieder wordt aangegeven waarbinnen het systeem actief is. Dit gebeurt door het URA-nummer als logische referentie te gebruiken (dus is er geen contained Organization resource).

 

List.entry wordt nadrukkelijk niet gebruikt. Dit is compatible met core FHIR omdat het attribuut daar 0..* is (in tegenstelling tot DocumentReference.content, die 1..* is). Bij de toepassing in IHE XDS wordt List.entry gebruikt om te verwijzen naar DocumentReference resource instances, die weer verwijzen naar afzonderlijke documenten). Aangezien we binnen AORTA (en de beoogde NVI) echter geen afzonderlijke documenten (of andere data-objecten) lokaliseren, is het semantisch goed verdedigbaar om List te gebruiken als ‘lege lijst’. Daardoor kunnen wel de betreffende patiënt en zorgaanbieder(systeem) worden aangeduid, zonder specifieke data-objecten te benoemen.

 

List.emptyReason is vast gevuld met ‘withheld’ omdat referenties naar de achterliggende data-objecten bewust niet aangemeld worden en niet raadpleegbaar zijn in de context van lokalisatie (zie de toelichting bij List.entry).