ValueSet: NlGfDataExchangeCapabilitiesVS
Id: nl-gf-data-exchange-capabilities-vs
Title: "NL GF Data exchange capabilities"
Description: "The data exchange capabilities supported by the NL Generic Functions."
* ^status = #active
* ^experimental = true
* include codes from valueset http://hl7.org/fhir/ValueSet/endpoint-payload-type
* include codes from system http://nuts-foundation.github.io/nl-generic-functions-ig/CodeSystem/nl-gf-data-exchange-capabilities

ValueSet: NlGfDataLocalizationContextVS
Id: nl-gf-data-localization-context-vs
Title: "NL GF Data localization context"
Description: "Data localization context supported by NL Generic Functions."
* ^status = #active
* ^experimental = true
* ^copyright = "This value set includes content from SNOMED CT, which is copyright © 2002+ International Health Terminology Standards Development Organisation (IHTSDO), and distributed by agreement between IHTSDO and HL7. Implementer use of SNOMED CT is not covered by this agreement"
* $sct#721912009  "Medication summary section"
* $sct#371530004  "Imaging report"
* $sct#77465005  "Patient summary document"
* $sct#721963009  "Immunization summary document"
* $sct#782671000000103  "Multidisciplinary care management"
* $sct#308292007  "Transfer of care"

ValueSet: OrganisatieTypeCodelijstVS
Id: 2.16.840.1.113883.2.4.3.11.60.40.2.17.2.3--20200901000000
Title: "OrganisatieType Valueset"
Description: "Deze valueset is een kopie van http://decor.nictiz.nl/fhir/ValueSet/2.16.840.1.113883.2.4.3.11.60.40.2.17.2.3--20200901000000 en bevat de Nederlandse organisatie types zoals gedefinieerd in de ZIB Organisatie. Het is een subset van de oorspronkelijke lijst, met alleen de relevante organisatie types voor zorginstellingen."
* ^identifier.use = #official
* ^identifier.system = "urn:ietf:rfc:3986"
* ^identifier.value = "urn:oid:2.16.840.1.113883.2.4.3.11.60.40.2.17.2.3"
* ^version = "2020-09-01T00:00:00"
* ^status = #active
* ^experimental = false
* $organization-type#V4 "Ziekenhuis"
* $organization-type#V4 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
* $organization-type#V4 ^extension.valueString = "Ziekenhuis"
// * $organization-type#V5 "Universitair Medisch Centrum"
// * $organization-type#V5 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#V5 ^extension.valueString = "Universitair Medisch Centrum"
// * $organization-type#V6 "Algemeen ziekenhuis"
// * $organization-type#V6 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#V6 ^extension.valueString = "Algemeen ziekenhuis"
// * $organization-type#BRA "Brandwondencentrum"
// * $organization-type#BRA ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#BRA ^extension.valueString = "Brandwondencentrum"
// * $organization-type#Z4 "Zelfstandig behandelcentrum"
// * $organization-type#Z4 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#Z4 ^extension.valueString = "Zelfstandig behandelcentrum"
// * $organization-type#Z5 "Diagnostisch centrum"
// * $organization-type#Z5 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#Z5 ^extension.valueString = "Diagnostisch centrum"
// * $organization-type#B2 "Echocentrum"
// * $organization-type#B2 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#B2 ^extension.valueString = "Echocentrum"
* $organization-type#X3 "Verplegings- of verzorgingsinstelling"
* $organization-type#X3 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
* $organization-type#X3 ^extension.valueString = "Verplegings- of verzorgingsinstelling"
// * $organization-type#R5 "Verpleeghuis"
// * $organization-type#R5 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#R5 ^extension.valueString = "Verpleeghuis"
// * $organization-type#M1 "Verzorgingstehuis"
// * $organization-type#M1 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#M1 ^extension.valueString = "Verzorgingstehuis"
* $organization-type#A1 "Apotheekinstelling"
* $organization-type#A1 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
* $organization-type#A1 ^extension.valueString = "Apotheekinstelling"
// * $organization-type#J8 "Openbare apotheek"
// * $organization-type#J8 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#J8 ^extension.valueString = "Openbare apotheek"
// * $organization-type#K9 "Zelfstandig opererende ziekenhuisapotheek"
// * $organization-type#K9 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#K9 ^extension.valueString = "Zelfstandig opererende ziekenhuisapotheek"
* $organization-type#H1 "Huisartsinstelling"
* $organization-type#H1 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
* $organization-type#H1 ^extension.valueString = "Huisartsinstelling"
// * $organization-type#Z3 "Huisartspraktijk (zelfstandig of groepspraktijk)"
// * $organization-type#Z3 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#Z3 ^extension.valueString = "Huisartspraktijk (zelfstandig of groepspraktijk)"
// * $organization-type#K3 "Apotheekhoudende huisartspraktijk"
// * $organization-type#K3 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#K3 ^extension.valueString = "Apotheekhoudende huisartspraktijk"
// * $organization-type#N6 "Huisartsenpost (t.b.v. dienstwaarneming)"
// * $organization-type#N6 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#N6 ^extension.valueString = "Huisartsenpost (t.b.v. dienstwaarneming)"
* $organization-type#L1 "Laboratorium"
* $organization-type#L1 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
* $organization-type#L1 ^extension.valueString = "Laboratorium"
// * $organization-type#P4 "Polikliniek (als onderdeel van een ziekenhuis)"
// * $organization-type#P4 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#P4 ^extension.valueString = "Polikliniek (als onderdeel van een ziekenhuis)"
// * $organization-type#R8 "Revalidatiecentrum"
// * $organization-type#R8 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#R8 ^extension.valueString = "Revalidatiecentrum"
// * $organization-type#P6 "Preventieve gezondheidszorg"
// * $organization-type#P6 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#P6 ^extension.valueString = "Preventieve gezondheidszorg"
* $organization-type#G5 "Geestelijke Gezondheidszorg"
* $organization-type#G5 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
* $organization-type#G5 ^extension.valueString = "Geestelijke Gezondheidszorg"
// * $organization-type#G6 "Verstandelijk gehandicaptenzorg"
// * $organization-type#G6 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#G6 ^extension.valueString = "Verstandelijk gehandicaptenzorg"
// * $organization-type#T2 "Thuiszorg"
// * $organization-type#T2 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#T2 ^extension.valueString = "Thuiszorg"
// * $organization-type#K4 "Kraamzorg"
// * $organization-type#K4 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#K4 ^extension.valueString = "Kraamzorg"
// * $organization-type#H2 "Hospice"
// * $organization-type#H2 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#H2 ^extension.valueString = "Hospice"
// * $organization-type#JGZ "Jeugdgezondheidszorg"
// * $organization-type#JGZ ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#JGZ ^extension.valueString = "Jeugdgezondheidszorg"
// * $organization-type#G3 "Verloskundigenpraktijk"
// * $organization-type#G3 ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#G3 ^extension.valueString = "Verloskundigenpraktijk"
// * $organization-type#DIA "Dialysecentrum"
// * $organization-type#DIA ^extension.url = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"
// * $organization-type#DIA ^extension.valueString = "Dialysecentrum"
* $v3-NullFlavor#OTH "Overige"

ValueSet: ProcedureType
Id: nl-gf-procedure-type-vs
Title: "NL GF Procedure Types"
Description: "Indicates the type of medical procedure."
* ^status = #active
* ^copyright = "This value set includes content from SNOMED CT, which is copyright © 2002+ International Health Terminology Standards Development Organisation (IHTSDO), and distributed by agreement between IHTSDO and HL7. Implementer use of SNOMED CT is not covered by this agreement"
* include codes from system $sct where concept is-a #71388002 "Procedure (procedure)"

ValueSet: UziRolcodesVS
Id: uzi-rolcode-vs
Title: "RoleCodeNL - zorgverlenertype (personen)"
Description: "Value set for Uzi rolcodes."
* ^status = #active
* include codes from system http://nuts-foundation.github.io/nl-generic-functions-ig/CodeSystem/uzi-rolcode

ValueSet: UziAgbSpecialismenVS
Id: uzi-agb-specialismen-vs
Title: "UZI and AGB Specialismen"
Description: "Value set for UZI-roles and AGB specialismen."
* ^status = #active
* include codes from system http://nuts-foundation.github.io/nl-generic-functions-ig/CodeSystem/agb-specialismen
* include codes from system http://nuts-foundation.github.io/nl-generic-functions-ig/CodeSystem/uzi-rolcode



