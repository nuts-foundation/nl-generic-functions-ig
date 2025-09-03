ValueSet: NLGfPayloadTypes
Id: nl-gf-payload-types
Title: "NL GF Payload Types"
Description: "The payload types supported by the NL Generic Functions."
* ^status = #active
* ^experimental = true
// * include codes from valueset http://hl7.org/fhir/ValueSet/endpoint-payload-type
* ^copyright = "This value set includes content from SNOMED CT, which is copyright © 2002+ International Health Terminology Standards Development Organisation (IHTSDO), and distributed by agreement between IHTSDO and HL7. Implementer use of SNOMED CT is not covered by this agreement"
* $sct#721912009  "Medication summary section"
* $sct#371530004  "Imaging report"
* $sct#77465005  "Patient summary document"
* $sct#721963009  "Immunization summary document"
* $sct#782671000000103  "Multidisciplinary care management"
* $sct#308292007  "Transfer of care"
* nl-gf-code-system#nl-gf-care-services "Care Services Directory"

CodeSystem: NlGfCodeSystem
Id: nl-gf-code-system
Title: "NL GF Code System"
Description: "Local code system for NL Generic Functions."
* #nl-gf-care-services "Care Services Directory"


// ValueSet: ProcedureType
// Id: nl-gf-procedure-type
// Title: "NL GF Procedure Types"
// * ^status = #active
// * include codes from valueset http://decor.nictiz.nl/fhir/ValueSet/2.16.840.1.113883.2.4.3.11.60.121.11.19--20200901000000


// ValueSet: SpecialtyType
// Id: nl-gf-specialty-type
// Title: "NL GF Specialty Types"
// * ^status = #active
// * include codes from valueset SpecialismeUZICodelijst
// * include codes from valueset http://decor.nictiz.nl/fhir/ValueSet/2.16.840.1.113883.2.4.3.11.60.40.2.17.1.7--20200901000000

// Alias: $uzi-rolcode = http://fhir.nl/fhir/NamingSystem/uzi-rolcode
// Alias: $FHIR-version = http://hl7.org/fhir/FHIR-version
// Alias: $sct = http://snomed.info/sct

// ValueSet: SpecialismeUZICodelijst
// Id: SpecialismeUZICodelijst
// Title: "SpecialismeUZICodelijst"
// Description: "RoleCodeNL (Zorgverlenertype (personen)) - Alle waarden"
// * ^meta.source = "http://decor.nictiz.nl/fhir/4.0/zib2020bbr-"
// * ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
// * ^meta.tag = $FHIR-version#4.0.1
// * ^extension.url = "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod"
// * ^extension.valuePeriod.start = "2020-09-01T00:00:00Z"
// * ^identifier.use = #official
// * ^identifier.system = "urn:ietf:rfc:3986"
// * ^identifier.value = "urn:oid:2.16.840.1.113883.2.4.3.11.60.40.2.17.1.6"
// * ^version = "2020-09-01T00:00:00"
// * ^status = #active
// * ^experimental = false
// * ^publisher = "Registratie aan de bron"
// * ^contact.name = "Registratie aan de bron"
// * ^contact.telecom[0].system = #url
// * ^contact.telecom[=].value = "https://www.registratieaandebron.nl"
// * ^contact.telecom[+].system = #url
// * ^contact.telecom[=].value = "https://www.zibs.nl"
// * ^immutable = false
// * ^expansion.identifier = "urn:uuid:433e6cab-20d0-40c9-be6c-ab20d0b0c938"
// * ^expansion.timestamp = "2025-08-29T15:29:47.827Z"
// * ^expansion.total = 84
// * ^expansion.contains[0].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].abstract = true
// * ^expansion.contains[=].code = #AssignedRoleType
// * ^expansion.contains[=].display = "Een roltype wordt gebruikt om een entiteit verder aan te duiden, die een rol speelt met AssignedEntity als modelattribuut RoleClass."
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Een roltype wordt gebruikt om een entiteit verder aan te duiden, die een rol speelt met AssignedEntity als modelattribuut RoleClass."
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.000
// * ^expansion.contains[=].display = "Arts"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Arts"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.002
// * ^expansion.contains[=].display = "Allergoloog (gesloten register)"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Allergoloog (gesloten register)"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.003
// * ^expansion.contains[=].display = "Anesthesioloog"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Anesthesioloog"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.004
// * ^expansion.contains[=].display = "Apotheekhoudende huisarts"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Apotheekhoudende huisarts"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.008
// * ^expansion.contains[=].display = "Bedrijfsarts"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Bedrijfsarts"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.010
// * ^expansion.contains[=].display = "Cardioloog"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Cardioloog"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.011
// * ^expansion.contains[=].display = "Cardiothoracaal chirurg"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Cardiothoracaal chirurg"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.012
// * ^expansion.contains[=].display = "Dermatoloog"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Dermatoloog"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.013
// * ^expansion.contains[=].display = "Arts v. maag-darm-leverziekten"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Arts v. maag-darm-leverziekten"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.014
// * ^expansion.contains[=].display = "Chirurg"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Chirurg"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.015
// * ^expansion.contains[=].display = "Huisarts"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Huisarts"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.016
// * ^expansion.contains[=].display = "Internist"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Internist"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.018
// * ^expansion.contains[=].display = "Keel- neus- en oorarts"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Keel- neus- en oorarts"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.019
// * ^expansion.contains[=].display = "Kinderarts"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Kinderarts"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.020
// * ^expansion.contains[=].display = "Arts klinische chemie (gesloten register)"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Arts klinische chemie (gesloten register)"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.021
// * ^expansion.contains[=].display = "Klinisch geneticus"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Klinisch geneticus"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.022
// * ^expansion.contains[=].display = "Klinisch geriater"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Klinisch geriater"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.023
// * ^expansion.contains[=].display = "Longarts"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Longarts"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.024
// * ^expansion.contains[=].display = "Arts-microbioloog"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Arts-microbioloog"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.025
// * ^expansion.contains[=].display = "Neurochirurg"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Neurochirurg"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.026
// * ^expansion.contains[=].display = "Neuroloog"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Neuroloog"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.030
// * ^expansion.contains[=].display = "Nucleair geneeskundige"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Nucleair geneeskundige"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.031
// * ^expansion.contains[=].display = "Oogarts"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Oogarts"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.032
// * ^expansion.contains[=].display = "Orthopedisch chirurg"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Orthopedisch chirurg"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.033
// * ^expansion.contains[=].display = "Patholoog"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Patholoog"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.034
// * ^expansion.contains[=].display = "Plastisch chirurg"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Plastisch chirurg"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.035
// * ^expansion.contains[=].display = "Psychiater"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Psychiater"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.039
// * ^expansion.contains[=].display = "Radioloog"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Radioloog"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.040
// * ^expansion.contains[=].display = "Radiotherapeut"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Radiotherapeut"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.041
// * ^expansion.contains[=].display = "Reumatoloog"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Reumatoloog"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.042
// * ^expansion.contains[=].display = "Revalidatiearts"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Revalidatiearts"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.045
// * ^expansion.contains[=].display = "Uroloog"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Uroloog"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.046
// * ^expansion.contains[=].display = "Gynaecoloog"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Gynaecoloog"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.047
// * ^expansion.contains[=].display = "Specialist ouderengeneeskunde"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Specialist ouderengeneeskunde"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.048
// * ^expansion.contains[=].display = "Verzekeringsarts"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Verzekeringsarts"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.050
// * ^expansion.contains[=].display = "Zenuwarts (gesloten register)"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Zenuwarts (gesloten register)"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.062
// * ^expansion.contains[=].display = "Internist-Allergoloog (gesloten register)"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Internist-Allergoloog (gesloten register)"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.055
// * ^expansion.contains[=].display = "Arts maatschappij en gezondheid"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Arts maatschappij en gezondheid"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.056
// * ^expansion.contains[=].display = "Arts voor verstandelijk gehandicapten"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Arts voor verstandelijk gehandicapten"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.070
// * ^expansion.contains[=].display = "Jeugdarts"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Jeugdarts"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.071
// * ^expansion.contains[=].display = "Spoedeisende hulp arts (SEH-arts)"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Spoedeisende hulp arts (SEH-arts)"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #01.074
// * ^expansion.contains[=].display = "Sportarts"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Sportarts"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #02.000
// * ^expansion.contains[=].display = "Tandarts"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Tandarts"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #02.053
// * ^expansion.contains[=].display = "Orthodontist"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Orthodontist"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #02.054
// * ^expansion.contains[=].display = "Kaakchirurg"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Kaakchirurg"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #03.000
// * ^expansion.contains[=].display = "Verloskundige"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Verloskundige"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #04.000
// * ^expansion.contains[=].display = "Fysiotherapeut"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Fysiotherapeut"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #16.000
// * ^expansion.contains[=].display = "Psychotherapeut"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Psychotherapeut"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #17.000
// * ^expansion.contains[=].display = "Apotheker"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Apotheker"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #17.060
// * ^expansion.contains[=].display = "Ziekenhuisapotheker"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Ziekenhuisapotheker"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #17.075
// * ^expansion.contains[=].display = "Openbaar apotheker"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Openbaar apotheker"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #25.000
// * ^expansion.contains[=].display = "Gezondheidszorgpsycholoog"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Gezondheidszorgpsycholoog"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #25.061
// * ^expansion.contains[=].display = "Klinisch psycholoog"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Klinisch psycholoog"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #25.063
// * ^expansion.contains[=].display = "Klinisch neuropsycholoog"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Klinisch neuropsycholoog"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #30.000
// * ^expansion.contains[=].display = "Verpleegkundige"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Verpleegkundige"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].inactive = true
// * ^expansion.contains[=].code = #30.065
// * ^expansion.contains[=].display = "Verpl. spec. prev. zorg bij som. aandoeningen"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Verpl. spec. prev. zorg bij som. aandoeningen"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].inactive = true
// * ^expansion.contains[=].code = #30.066
// * ^expansion.contains[=].display = "Verpl. spec. acute zorg bij som. aandoeningen"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Verpl. spec. acute zorg bij som. aandoeningen"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].inactive = true
// * ^expansion.contains[=].code = #30.067
// * ^expansion.contains[=].display = "Verpl. spec. intensieve zorg bij som. aandoeningen"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Verpl. spec. intensieve zorg bij som. aandoeningen"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].inactive = true
// * ^expansion.contains[=].code = #30.068
// * ^expansion.contains[=].display = "Verpl. spec. chronische zorg bij som. aandoeningen"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Verpl. spec. chronische zorg bij som. aandoeningen"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #30.069
// * ^expansion.contains[=].display = "Verpl. spec. geestelijke gezondheidszorg"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Verpl. spec. geestelijke gezondheidszorg"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #30.076
// * ^expansion.contains[=].display = "Verpl. spec. algemene gezondheidszorg"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Verpl. spec. algemene gezondheidszorg"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #31.000
// * ^expansion.contains[=].display = "Orthopedagoog-generalist"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Orthopedagoog-generalist"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #79.000
// * ^expansion.contains[=].display = "Geregistreerd-mondhygiënist"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Geregistreerd-mondhygiënist"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #80.000
// * ^expansion.contains[=].display = "Bachelor medisch hulpverlener"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Bachelor medisch hulpverlener"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #81.000
// * ^expansion.contains[=].display = "Physician assistant"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Physician assistant"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #82.000
// * ^expansion.contains[=].display = "Klinisch technoloog"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Klinisch technoloog"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #83.000
// * ^expansion.contains[=].display = "Apothekersassistent"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Apothekersassistent"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #84.000
// * ^expansion.contains[=].display = "Klinisch fysicus"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Klinisch fysicus"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #85.000
// * ^expansion.contains[=].display = "Tandprotheticus"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Tandprotheticus"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #86.000
// * ^expansion.contains[=].display = "VIG-er"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "VIG-er"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #87.000
// * ^expansion.contains[=].display = "Optometrist"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Optometrist"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #88.000
// * ^expansion.contains[=].display = "Huidtherapeut"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Huidtherapeut"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #89.000
// * ^expansion.contains[=].display = "Diëtist"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Diëtist"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #90.000
// * ^expansion.contains[=].display = "Ergotherapeut"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Ergotherapeut"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #91.000
// * ^expansion.contains[=].display = "Logopedist"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Logopedist"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #92.000
// * ^expansion.contains[=].display = "Mondhygiënist"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Mondhygiënist"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #93.000
// * ^expansion.contains[=].display = "Oefentherapeut Mensendieck"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Oefentherapeut Mensendieck"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #94.000
// * ^expansion.contains[=].display = "Oefentherapeut Cesar"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Oefentherapeut Cesar"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #95.000
// * ^expansion.contains[=].display = "Orthoptist"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Orthoptist"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #96.000
// * ^expansion.contains[=].display = "Podotherapeut"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Podotherapeut"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #97.000
// * ^expansion.contains[=].display = "Radiodiagnostisch laborant"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Radiodiagnostisch laborant"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #98.000
// * ^expansion.contains[=].display = "Radiotherapeutisch laborant"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Radiotherapeutisch laborant"
// * ^expansion.contains[+].system = "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
// * ^expansion.contains[=].code = #99.000
// * ^expansion.contains[=].display = "Zorgverlener andere zorg"
// * ^expansion.contains[=].designation.language = #nl-NL
// * ^expansion.contains[=].designation.use = $sct#900000000000013009 "Synonym"
// * ^expansion.contains[=].designation.value = "Zorgverlener andere zorg"
