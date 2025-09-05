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
* nl-gf-code-system#nl-gf-dicom "DICOM Images"

CodeSystem: NlGfCodeSystem
Id: nl-gf-code-system
Title: "NL GF Code System"
Description: "Local code system for NL Generic Functions."
* #nl-gf-care-services "Care Services Directory"
* #nl-gf-dicom "DICOM Images"

ValueSet: UziAgbSpecialismenVS
Id: uzi-agb-specialismen-vs
Title: "UZI and AGB Specialismen"
Description: "Value set for UZI-roles and AGB specialismen."
* ^status = #active
* include codes from system http://nuts-foundation.github.io/nl-generic-functions-ig/CodeSystem/agb-specialismen
* include codes from system http://nuts-foundation.github.io/nl-generic-functions-ig/CodeSystem/uzi-rolcode

CodeSystem: AgbSpecialismenCS
Id: agb-specialismen
Title: "AGB Specialismen"
Description: """Dit codesysteem is een (gedeeltelijke) kopie van  urn:oid:2.16.840.1.113883.2.4.6.7"""
* ^language = #nl-NL
* ^identifier.system = "urn:ietf:rfc:3986"
* ^identifier.value = "urn:oid:2.16.840.1.113883.2.4.6.7"
* ^url = "http://nuts-foundation.github.io/nl-generic-functions-ig/CodeSystem/agb-specialismen"
* ^status = #active
* ^experimental = false
* #0303 "Chirurgie (Heelkunde)"
* #0305 "Medisch specialisten, orthopedie"
* #0306 "Medisch specialisten, urologie"
* #0308 "Medisch specialisten, neurochirurgie"
* #0313 "Interne geneeskunde"
* #0335 "Medisch specialisten, geriatrie"
* #0100 "Verpleegkundige"


ValueSet: UziRolcodesVS
Id: uzi-rolcode-vs
Title: "RoleCodeNL - zorgverlenertype (personen)"
Description: "Value set for Uzi rolcodes."
* ^status = #active
* include codes from system http://nuts-foundation.github.io/nl-generic-functions-ig/CodeSystem/uzi-rolcode

CodeSystem: UziRolcodesCS
Id: uzi-rolcode
Title: "RoleCodeNL - zorgverlenertype (personen)"
Description: """Dit codesysteem is een kopie http://fhir.nl/fhir/NamingSystem/uzi-rolcode)"""
* ^meta.profile = "http://hl7.org/fhir/StructureDefinition/shareablecodesystem"
* ^meta.source = "https://simplifier.net/nictiz-r4-zib2020/uzi-rolcode/$download?format=json"
* ^language = #nl-NL
* ^identifier.use = #official
* ^identifier.system = "urn:ietf:rfc:3986"
* ^identifier.value = "urn:oid:2.16.840.1.113883.2.4.15.111"
* ^url = "http://nuts-foundation.github.io/nl-generic-functions-ig/CodeSystem/uzi-rolcode"
* ^status = #active
* ^experimental = false
* ^property[0].code = #status
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#status"
* ^property[=].description = "A code that indicates the status of the concept. Values found in this version of the code system are: active, deprecated"
* ^property[=].type = #code
* ^property[+].code = #deprecationDate
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#deprecationDate"
* ^property[=].description = "The date at which a concept was deprecated. Concepts that are deprecated but not inactive can still be used, but their use is discouraged, and they should be expected to be made inactive in a future release. Property type is dateTime. Note that the status property may also be used to indicate that a concept is deprecated"
* ^property[=].type = #dateTime
* ^property[+].code = #effectiveDate
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#effectiveDate"
* ^property[=].description = "The date at which the concept was status was last changed. This is calculated based on the highest of 'creation date', 'expiration date', and 'official release date'"
* ^property[=].type = #dateTime
* ^property[+].code = #inactive
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#inactive"
* ^property[=].description = "True if the concept is not considered active - e.g. not a valid concept any more and not approved for current use. Property type is boolean, default value is false"
* ^property[=].type = #boolean
* ^property[+].code = #notSelectable
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#notSelectable"
* ^property[=].description = "The concept is not intended to be chosen by the user - only intended to be used as a selector for other concepts. Note, though, that the interpretation of this is highly contextual; all concepts are selectable in some context. Property type is boolean"
* ^property[=].type = #boolean
* ^property[+].code = #parent
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#parent"
* ^property[=].description = "The concept identified in this property is a parent of the concept on which it is a property. The property type will be 'code'. The meaning of 'parent' is defined by the hierarchyMeaning attribute"
* ^property[=].type = #code
* ^property[+].code = #child
* ^property[=].uri = "http://hl7.org/fhir/concept-properties#child"
* ^property[=].description = "The concept identified in this property is a child of the concept on which it is a property. The property type will be 'code'. The meaning of 'child' is defined by the hierarchyMeaning attribute"
* ^property[=].type = #code
* #AssignedRoleType "Een roltype wordt gebruikt om een entiteit verder aan te duiden, die een rol speelt met AssignedEntity als modelattribuut RoleClass."
* #AssignedRoleType ^designation.language = #nl-NL
* #AssignedRoleType ^designation.use.system = "http://snomed.info/sct"
* #AssignedRoleType ^designation.use = $sct#900000000000013009 "Synonym"
* #AssignedRoleType ^designation.use.display = "Synonym"
* #AssignedRoleType ^designation.value = "Een roltype wordt gebruikt om een entiteit verder aan te duiden, die een rol speelt met AssignedEntity als modelattribuut RoleClass."
* #AssignedRoleType ^property[0].code = #status
* #AssignedRoleType ^property[=].valueCode = #active
* #AssignedRoleType ^property[+].code = #notSelectable
* #AssignedRoleType ^property[=].valueBoolean = true
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #01.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #02.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #03.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #04.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #16.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #17.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #25.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #30.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #31.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #79.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #80.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #81.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #82.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #83.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #84.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #85.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #86.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #87.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #88.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #89.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #90.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #91.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #92.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #93.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #94.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #95.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #96.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #97.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #98.000
* #AssignedRoleType ^property[+].code = #child
* #AssignedRoleType ^property[=].valueCode = #99.000
* #01.000 "Arts"
* #01.000 ^designation.language = #nl-NL
* #01.000 ^designation.use.system = "http://snomed.info/sct"
* #01.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.000 ^designation.use.display = "Synonym"
* #01.000 ^designation.value = "Arts"
* #01.000 ^property[0].code = #status
* #01.000 ^property[=].valueCode = #active
* #01.000 ^property[+].code = #parent
* #01.000 ^property[=].valueCode = #AssignedRoleType
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.002
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.003
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.004
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.008
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.010
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.011
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.012
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.013
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.014
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.015
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.016
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.018
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.019
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.020
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.021
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.022
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.023
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.024
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.025
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.026
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.030
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.031
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.032
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.033
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.034
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.035
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.039
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.040
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.041
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.042
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.045
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.046
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.047
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.048
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.050
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.062
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.055
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.056
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.070
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.071
* #01.000 ^property[+].code = #child
* #01.000 ^property[=].valueCode = #01.074
* #01.002 "Allergoloog (gesloten register)"
* #01.002 ^designation.language = #nl-NL
* #01.002 ^designation.use.system = "http://snomed.info/sct"
* #01.002 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.002 ^designation.use.display = "Synonym"
* #01.002 ^designation.value = "Allergoloog (gesloten register)"
* #01.002 ^property[0].code = #status
* #01.002 ^property[=].valueCode = #active
* #01.002 ^property[+].code = #parent
* #01.002 ^property[=].valueCode = #01.000
* #01.003 "Anesthesioloog"
* #01.003 ^designation.language = #nl-NL
* #01.003 ^designation.use.system = "http://snomed.info/sct"
* #01.003 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.003 ^designation.use.display = "Synonym"
* #01.003 ^designation.value = "Anesthesioloog"
* #01.003 ^property[0].code = #status
* #01.003 ^property[=].valueCode = #active
* #01.003 ^property[+].code = #parent
* #01.003 ^property[=].valueCode = #01.000
* #01.004 "Apotheekhoudende huisarts"
* #01.004 ^designation.language = #nl-NL
* #01.004 ^designation.use.system = "http://snomed.info/sct"
* #01.004 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.004 ^designation.use.display = "Synonym"
* #01.004 ^designation.value = "Apotheekhoudende huisarts"
* #01.004 ^property[0].code = #status
* #01.004 ^property[=].valueCode = #active
* #01.004 ^property[+].code = #parent
* #01.004 ^property[=].valueCode = #01.000
* #01.008 "Bedrijfsarts"
* #01.008 ^designation.language = #nl-NL
* #01.008 ^designation.use.system = "http://snomed.info/sct"
* #01.008 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.008 ^designation.use.display = "Synonym"
* #01.008 ^designation.value = "Bedrijfsarts"
* #01.008 ^property[0].code = #status
* #01.008 ^property[=].valueCode = #active
* #01.008 ^property[+].code = #parent
* #01.008 ^property[=].valueCode = #01.000
* #01.010 "Cardioloog"
* #01.010 ^designation.language = #nl-NL
* #01.010 ^designation.use.system = "http://snomed.info/sct"
* #01.010 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.010 ^designation.use.display = "Synonym"
* #01.010 ^designation.value = "Cardioloog"
* #01.010 ^property[0].code = #status
* #01.010 ^property[=].valueCode = #active
* #01.010 ^property[+].code = #parent
* #01.010 ^property[=].valueCode = #01.000
* #01.011 "Cardiothoracaal chirurg"
* #01.011 ^designation.language = #nl-NL
* #01.011 ^designation.use.system = "http://snomed.info/sct"
* #01.011 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.011 ^designation.use.display = "Synonym"
* #01.011 ^designation.value = "Cardiothoracaal chirurg"
* #01.011 ^property[0].code = #status
* #01.011 ^property[=].valueCode = #active
* #01.011 ^property[+].code = #parent
* #01.011 ^property[=].valueCode = #01.000
* #01.012 "Dermatoloog"
* #01.012 ^designation.language = #nl-NL
* #01.012 ^designation.use.system = "http://snomed.info/sct"
* #01.012 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.012 ^designation.use.display = "Synonym"
* #01.012 ^designation.value = "Dermatoloog"
* #01.012 ^property[0].code = #status
* #01.012 ^property[=].valueCode = #active
* #01.012 ^property[+].code = #parent
* #01.012 ^property[=].valueCode = #01.000
* #01.013 "Arts v. maag-darm-leverziekten"
* #01.013 ^designation.language = #nl-NL
* #01.013 ^designation.use.system = "http://snomed.info/sct"
* #01.013 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.013 ^designation.use.display = "Synonym"
* #01.013 ^designation.value = "Arts v. maag-darm-leverziekten"
* #01.013 ^property[0].code = #status
* #01.013 ^property[=].valueCode = #active
* #01.013 ^property[+].code = #parent
* #01.013 ^property[=].valueCode = #01.000
* #01.014 "Chirurg"
* #01.014 ^designation.language = #nl-NL
* #01.014 ^designation.use.system = "http://snomed.info/sct"
* #01.014 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.014 ^designation.use.display = "Synonym"
* #01.014 ^designation.value = "Chirurg"
* #01.014 ^property[0].code = #status
* #01.014 ^property[=].valueCode = #active
* #01.014 ^property[+].code = #parent
* #01.014 ^property[=].valueCode = #01.000
* #01.015 "Huisarts"
* #01.015 ^designation.language = #nl-NL
* #01.015 ^designation.use.system = "http://snomed.info/sct"
* #01.015 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.015 ^designation.use.display = "Synonym"
* #01.015 ^designation.value = "Huisarts"
* #01.015 ^property[0].code = #status
* #01.015 ^property[=].valueCode = #active
* #01.015 ^property[+].code = #parent
* #01.015 ^property[=].valueCode = #01.000
* #01.016 "Internist"
* #01.016 ^designation.language = #nl-NL
* #01.016 ^designation.use.system = "http://snomed.info/sct"
* #01.016 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.016 ^designation.use.display = "Synonym"
* #01.016 ^designation.value = "Internist"
* #01.016 ^property[0].code = #status
* #01.016 ^property[=].valueCode = #active
* #01.016 ^property[+].code = #parent
* #01.016 ^property[=].valueCode = #01.000
* #01.018 "Keel- neus- en oorarts"
* #01.018 ^designation.language = #nl-NL
* #01.018 ^designation.use.system = "http://snomed.info/sct"
* #01.018 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.018 ^designation.use.display = "Synonym"
* #01.018 ^designation.value = "Keel- neus- en oorarts"
* #01.018 ^property[0].code = #status
* #01.018 ^property[=].valueCode = #active
* #01.018 ^property[+].code = #parent
* #01.018 ^property[=].valueCode = #01.000
* #01.019 "Kinderarts"
* #01.019 ^designation.language = #nl-NL
* #01.019 ^designation.use.system = "http://snomed.info/sct"
* #01.019 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.019 ^designation.use.display = "Synonym"
* #01.019 ^designation.value = "Kinderarts"
* #01.019 ^property[0].code = #status
* #01.019 ^property[=].valueCode = #active
* #01.019 ^property[+].code = #parent
* #01.019 ^property[=].valueCode = #01.000
* #01.020 "Arts klinische chemie (gesloten register)"
* #01.020 ^designation.language = #nl-NL
* #01.020 ^designation.use.system = "http://snomed.info/sct"
* #01.020 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.020 ^designation.use.display = "Synonym"
* #01.020 ^designation.value = "Arts klinische chemie (gesloten register)"
* #01.020 ^property[0].code = #status
* #01.020 ^property[=].valueCode = #active
* #01.020 ^property[+].code = #parent
* #01.020 ^property[=].valueCode = #01.000
* #01.021 "Klinisch geneticus"
* #01.021 ^designation.language = #nl-NL
* #01.021 ^designation.use.system = "http://snomed.info/sct"
* #01.021 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.021 ^designation.use.display = "Synonym"
* #01.021 ^designation.value = "Klinisch geneticus"
* #01.021 ^property[0].code = #status
* #01.021 ^property[=].valueCode = #active
* #01.021 ^property[+].code = #parent
* #01.021 ^property[=].valueCode = #01.000
* #01.022 "Klinisch geriater"
* #01.022 ^designation.language = #nl-NL
* #01.022 ^designation.use.system = "http://snomed.info/sct"
* #01.022 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.022 ^designation.use.display = "Synonym"
* #01.022 ^designation.value = "Klinisch geriater"
* #01.022 ^property[0].code = #status
* #01.022 ^property[=].valueCode = #active
* #01.022 ^property[+].code = #parent
* #01.022 ^property[=].valueCode = #01.000
* #01.023 "Longarts"
* #01.023 ^designation.language = #nl-NL
* #01.023 ^designation.use.system = "http://snomed.info/sct"
* #01.023 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.023 ^designation.use.display = "Synonym"
* #01.023 ^designation.value = "Longarts"
* #01.023 ^property[0].code = #status
* #01.023 ^property[=].valueCode = #active
* #01.023 ^property[+].code = #parent
* #01.023 ^property[=].valueCode = #01.000
* #01.024 "Arts-microbioloog"
* #01.024 ^designation.language = #nl-NL
* #01.024 ^designation.use.system = "http://snomed.info/sct"
* #01.024 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.024 ^designation.use.display = "Synonym"
* #01.024 ^designation.value = "Arts-microbioloog"
* #01.024 ^property[0].code = #status
* #01.024 ^property[=].valueCode = #active
* #01.024 ^property[+].code = #parent
* #01.024 ^property[=].valueCode = #01.000
* #01.025 "Neurochirurg"
* #01.025 ^designation.language = #nl-NL
* #01.025 ^designation.use.system = "http://snomed.info/sct"
* #01.025 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.025 ^designation.use.display = "Synonym"
* #01.025 ^designation.value = "Neurochirurg"
* #01.025 ^property[0].code = #status
* #01.025 ^property[=].valueCode = #active
* #01.025 ^property[+].code = #parent
* #01.025 ^property[=].valueCode = #01.000
* #01.026 "Neuroloog"
* #01.026 ^designation.language = #nl-NL
* #01.026 ^designation.use.system = "http://snomed.info/sct"
* #01.026 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.026 ^designation.use.display = "Synonym"
* #01.026 ^designation.value = "Neuroloog"
* #01.026 ^property[0].code = #status
* #01.026 ^property[=].valueCode = #active
* #01.026 ^property[+].code = #parent
* #01.026 ^property[=].valueCode = #01.000
* #01.030 "Nucleair geneeskundige"
* #01.030 ^designation.language = #nl-NL
* #01.030 ^designation.use.system = "http://snomed.info/sct"
* #01.030 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.030 ^designation.use.display = "Synonym"
* #01.030 ^designation.value = "Nucleair geneeskundige"
* #01.030 ^property[0].code = #status
* #01.030 ^property[=].valueCode = #active
* #01.030 ^property[+].code = #parent
* #01.030 ^property[=].valueCode = #01.000
* #01.031 "Oogarts"
* #01.031 ^designation.language = #nl-NL
* #01.031 ^designation.use.system = "http://snomed.info/sct"
* #01.031 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.031 ^designation.use.display = "Synonym"
* #01.031 ^designation.value = "Oogarts"
* #01.031 ^property[0].code = #status
* #01.031 ^property[=].valueCode = #active
* #01.031 ^property[+].code = #parent
* #01.031 ^property[=].valueCode = #01.000
* #01.032 "Orthopedisch chirurg"
* #01.032 ^designation.language = #nl-NL
* #01.032 ^designation.use.system = "http://snomed.info/sct"
* #01.032 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.032 ^designation.use.display = "Synonym"
* #01.032 ^designation.value = "Orthopedisch chirurg"
* #01.032 ^property[0].code = #status
* #01.032 ^property[=].valueCode = #active
* #01.032 ^property[+].code = #parent
* #01.032 ^property[=].valueCode = #01.000
* #01.033 "Patholoog"
* #01.033 ^designation.language = #nl-NL
* #01.033 ^designation.use.system = "http://snomed.info/sct"
* #01.033 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.033 ^designation.use.display = "Synonym"
* #01.033 ^designation.value = "Patholoog"
* #01.033 ^property[0].code = #status
* #01.033 ^property[=].valueCode = #active
* #01.033 ^property[+].code = #parent
* #01.033 ^property[=].valueCode = #01.000
* #01.034 "Plastisch chirurg"
* #01.034 ^designation.language = #nl-NL
* #01.034 ^designation.use.system = "http://snomed.info/sct"
* #01.034 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.034 ^designation.use.display = "Synonym"
* #01.034 ^designation.value = "Plastisch chirurg"
* #01.034 ^property[0].code = #status
* #01.034 ^property[=].valueCode = #active
* #01.034 ^property[+].code = #parent
* #01.034 ^property[=].valueCode = #01.000
* #01.035 "Psychiater"
* #01.035 ^designation.language = #nl-NL
* #01.035 ^designation.use.system = "http://snomed.info/sct"
* #01.035 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.035 ^designation.use.display = "Synonym"
* #01.035 ^designation.value = "Psychiater"
* #01.035 ^property[0].code = #status
* #01.035 ^property[=].valueCode = #active
* #01.035 ^property[+].code = #parent
* #01.035 ^property[=].valueCode = #01.000
* #01.039 "Radioloog"
* #01.039 ^designation.language = #nl-NL
* #01.039 ^designation.use.system = "http://snomed.info/sct"
* #01.039 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.039 ^designation.use.display = "Synonym"
* #01.039 ^designation.value = "Radioloog"
* #01.039 ^property[0].code = #status
* #01.039 ^property[=].valueCode = #active
* #01.039 ^property[+].code = #parent
* #01.039 ^property[=].valueCode = #01.000
* #01.040 "Radiotherapeut"
* #01.040 ^designation.language = #nl-NL
* #01.040 ^designation.use.system = "http://snomed.info/sct"
* #01.040 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.040 ^designation.use.display = "Synonym"
* #01.040 ^designation.value = "Radiotherapeut"
* #01.040 ^property[0].code = #status
* #01.040 ^property[=].valueCode = #active
* #01.040 ^property[+].code = #parent
* #01.040 ^property[=].valueCode = #01.000
* #01.041 "Reumatoloog"
* #01.041 ^designation.language = #nl-NL
* #01.041 ^designation.use.system = "http://snomed.info/sct"
* #01.041 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.041 ^designation.use.display = "Synonym"
* #01.041 ^designation.value = "Reumatoloog"
* #01.041 ^property[0].code = #status
* #01.041 ^property[=].valueCode = #active
* #01.041 ^property[+].code = #parent
* #01.041 ^property[=].valueCode = #01.000
* #01.042 "Revalidatiearts"
* #01.042 ^designation.language = #nl-NL
* #01.042 ^designation.use.system = "http://snomed.info/sct"
* #01.042 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.042 ^designation.use.display = "Synonym"
* #01.042 ^designation.value = "Revalidatiearts"
* #01.042 ^property[0].code = #status
* #01.042 ^property[=].valueCode = #active
* #01.042 ^property[+].code = #parent
* #01.042 ^property[=].valueCode = #01.000
* #01.045 "Uroloog"
* #01.045 ^designation.language = #nl-NL
* #01.045 ^designation.use.system = "http://snomed.info/sct"
* #01.045 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.045 ^designation.use.display = "Synonym"
* #01.045 ^designation.value = "Uroloog"
* #01.045 ^property[0].code = #status
* #01.045 ^property[=].valueCode = #active
* #01.045 ^property[+].code = #parent
* #01.045 ^property[=].valueCode = #01.000
* #01.046 "Gynaecoloog"
* #01.046 ^designation.language = #nl-NL
* #01.046 ^designation.use.system = "http://snomed.info/sct"
* #01.046 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.046 ^designation.use.display = "Synonym"
* #01.046 ^designation.value = "Gynaecoloog"
* #01.046 ^property[0].code = #status
* #01.046 ^property[=].valueCode = #active
* #01.046 ^property[+].code = #parent
* #01.046 ^property[=].valueCode = #01.000
* #01.047 "Specialist ouderengeneeskunde"
* #01.047 ^designation.language = #nl-NL
* #01.047 ^designation.use.system = "http://snomed.info/sct"
* #01.047 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.047 ^designation.use.display = "Synonym"
* #01.047 ^designation.value = "Specialist ouderengeneeskunde"
* #01.047 ^property[0].code = #status
* #01.047 ^property[=].valueCode = #active
* #01.047 ^property[+].code = #parent
* #01.047 ^property[=].valueCode = #01.000
* #01.048 "Verzekeringsarts"
* #01.048 ^designation.language = #nl-NL
* #01.048 ^designation.use.system = "http://snomed.info/sct"
* #01.048 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.048 ^designation.use.display = "Synonym"
* #01.048 ^designation.value = "Verzekeringsarts"
* #01.048 ^property[0].code = #status
* #01.048 ^property[=].valueCode = #active
* #01.048 ^property[+].code = #parent
* #01.048 ^property[=].valueCode = #01.000
* #01.050 "Zenuwarts (gesloten register)"
* #01.050 ^designation.language = #nl-NL
* #01.050 ^designation.use.system = "http://snomed.info/sct"
* #01.050 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.050 ^designation.use.display = "Synonym"
* #01.050 ^designation.value = "Zenuwarts (gesloten register)"
* #01.050 ^property[0].code = #status
* #01.050 ^property[=].valueCode = #active
* #01.050 ^property[+].code = #parent
* #01.050 ^property[=].valueCode = #01.000
* #01.062 "Internist-Allergoloog (gesloten register)"
* #01.062 ^designation.language = #nl-NL
* #01.062 ^designation.use.system = "http://snomed.info/sct"
* #01.062 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.062 ^designation.use.display = "Synonym"
* #01.062 ^designation.value = "Internist-Allergoloog (gesloten register)"
* #01.062 ^property[0].code = #status
* #01.062 ^property[=].valueCode = #active
* #01.062 ^property[+].code = #parent
* #01.062 ^property[=].valueCode = #01.000
* #01.055 "Arts maatschappij en gezondheid"
* #01.055 ^designation.language = #nl-NL
* #01.055 ^designation.use.system = "http://snomed.info/sct"
* #01.055 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.055 ^designation.use.display = "Synonym"
* #01.055 ^designation.value = "Arts maatschappij en gezondheid"
* #01.055 ^property[0].code = #status
* #01.055 ^property[=].valueCode = #active
* #01.055 ^property[+].code = #parent
* #01.055 ^property[=].valueCode = #01.000
* #01.056 "Arts voor verstandelijk gehandicapten"
* #01.056 ^designation.language = #nl-NL
* #01.056 ^designation.use.system = "http://snomed.info/sct"
* #01.056 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.056 ^designation.use.display = "Synonym"
* #01.056 ^designation.value = "Arts voor verstandelijk gehandicapten"
* #01.056 ^property[0].code = #status
* #01.056 ^property[=].valueCode = #active
* #01.056 ^property[+].code = #parent
* #01.056 ^property[=].valueCode = #01.000
* #01.070 "Jeugdarts"
* #01.070 ^designation.language = #nl-NL
* #01.070 ^designation.use.system = "http://snomed.info/sct"
* #01.070 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.070 ^designation.use.display = "Synonym"
* #01.070 ^designation.value = "Jeugdarts"
* #01.070 ^property[0].code = #status
* #01.070 ^property[=].valueCode = #active
* #01.070 ^property[+].code = #parent
* #01.070 ^property[=].valueCode = #01.000
* #01.071 "Spoedeisende hulp arts (SEH-arts)"
* #01.071 ^designation.language = #nl-NL
* #01.071 ^designation.use.system = "http://snomed.info/sct"
* #01.071 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.071 ^designation.use.display = "Synonym"
* #01.071 ^designation.value = "Spoedeisende hulp arts (SEH-arts)"
* #01.071 ^property[0].code = #status
* #01.071 ^property[=].valueCode = #active
* #01.071 ^property[+].code = #parent
* #01.071 ^property[=].valueCode = #01.000
* #01.074 "Sportarts"
* #01.074 ^designation.language = #nl-NL
* #01.074 ^designation.use.system = "http://snomed.info/sct"
* #01.074 ^designation.use = $sct#900000000000013009 "Synonym"
* #01.074 ^designation.use.display = "Synonym"
* #01.074 ^designation.value = "Sportarts"
* #01.074 ^property[0].code = #status
* #01.074 ^property[=].valueCode = #active
* #01.074 ^property[+].code = #parent
* #01.074 ^property[=].valueCode = #01.000
* #02.000 "Tandarts"
* #02.000 ^designation.language = #nl-NL
* #02.000 ^designation.use.system = "http://snomed.info/sct"
* #02.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #02.000 ^designation.use.display = "Synonym"
* #02.000 ^designation.value = "Tandarts"
* #02.000 ^property[0].code = #status
* #02.000 ^property[=].valueCode = #active
* #02.000 ^property[+].code = #parent
* #02.000 ^property[=].valueCode = #AssignedRoleType
* #02.000 ^property[+].code = #child
* #02.000 ^property[=].valueCode = #02.053
* #02.000 ^property[+].code = #child
* #02.000 ^property[=].valueCode = #02.054
* #02.053 "Orthodontist"
* #02.053 ^designation.language = #nl-NL
* #02.053 ^designation.use.system = "http://snomed.info/sct"
* #02.053 ^designation.use = $sct#900000000000013009 "Synonym"
* #02.053 ^designation.use.display = "Synonym"
* #02.053 ^designation.value = "Orthodontist"
* #02.053 ^property[0].code = #status
* #02.053 ^property[=].valueCode = #active
* #02.053 ^property[+].code = #parent
* #02.053 ^property[=].valueCode = #02.000
* #02.054 "Kaakchirurg"
* #02.054 ^designation.language = #nl-NL
* #02.054 ^designation.use.system = "http://snomed.info/sct"
* #02.054 ^designation.use = $sct#900000000000013009 "Synonym"
* #02.054 ^designation.use.display = "Synonym"
* #02.054 ^designation.value = "Kaakchirurg"
* #02.054 ^property[0].code = #status
* #02.054 ^property[=].valueCode = #active
* #02.054 ^property[+].code = #parent
* #02.054 ^property[=].valueCode = #02.000
* #03.000 "Verloskundige"
* #03.000 ^designation.language = #nl-NL
* #03.000 ^designation.use.system = "http://snomed.info/sct"
* #03.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #03.000 ^designation.use.display = "Synonym"
* #03.000 ^designation.value = "Verloskundige"
* #03.000 ^property[0].code = #status
* #03.000 ^property[=].valueCode = #active
* #03.000 ^property[+].code = #parent
* #03.000 ^property[=].valueCode = #AssignedRoleType
* #04.000 "Fysiotherapeut"
* #04.000 ^designation.language = #nl-NL
* #04.000 ^designation.use.system = "http://snomed.info/sct"
* #04.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #04.000 ^designation.use.display = "Synonym"
* #04.000 ^designation.value = "Fysiotherapeut"
* #04.000 ^property[0].code = #status
* #04.000 ^property[=].valueCode = #active
* #04.000 ^property[+].code = #parent
* #04.000 ^property[=].valueCode = #AssignedRoleType
* #16.000 "Psychotherapeut"
* #16.000 ^designation.language = #nl-NL
* #16.000 ^designation.use.system = "http://snomed.info/sct"
* #16.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #16.000 ^designation.use.display = "Synonym"
* #16.000 ^designation.value = "Psychotherapeut"
* #16.000 ^property[0].code = #status
* #16.000 ^property[=].valueCode = #active
* #16.000 ^property[+].code = #parent
* #16.000 ^property[=].valueCode = #AssignedRoleType
* #17.000 "Apotheker"
* #17.000 ^designation.language = #nl-NL
* #17.000 ^designation.use.system = "http://snomed.info/sct"
* #17.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #17.000 ^designation.use.display = "Synonym"
* #17.000 ^designation.value = "Apotheker"
* #17.000 ^property[0].code = #status
* #17.000 ^property[=].valueCode = #active
* #17.000 ^property[+].code = #parent
* #17.000 ^property[=].valueCode = #AssignedRoleType
* #17.000 ^property[+].code = #child
* #17.000 ^property[=].valueCode = #17.060
* #17.000 ^property[+].code = #child
* #17.000 ^property[=].valueCode = #17.075
* #17.060 "Ziekenhuisapotheker"
* #17.060 ^designation.language = #nl-NL
* #17.060 ^designation.use.system = "http://snomed.info/sct"
* #17.060 ^designation.use = $sct#900000000000013009 "Synonym"
* #17.060 ^designation.use.display = "Synonym"
* #17.060 ^designation.value = "Ziekenhuisapotheker"
* #17.060 ^property[0].code = #status
* #17.060 ^property[=].valueCode = #active
* #17.060 ^property[+].code = #parent
* #17.060 ^property[=].valueCode = #17.000
* #17.075 "Openbaar apotheker"
* #17.075 ^designation.language = #nl-NL
* #17.075 ^designation.use.system = "http://snomed.info/sct"
* #17.075 ^designation.use = $sct#900000000000013009 "Synonym"
* #17.075 ^designation.use.display = "Synonym"
* #17.075 ^designation.value = "Openbaar apotheker"
* #17.075 ^property[0].code = #status
* #17.075 ^property[=].valueCode = #active
* #17.075 ^property[+].code = #parent
* #17.075 ^property[=].valueCode = #17.000
* #25.000 "Gezondheidszorgpsycholoog"
* #25.000 ^designation.language = #nl-NL
* #25.000 ^designation.use.system = "http://snomed.info/sct"
* #25.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #25.000 ^designation.use.display = "Synonym"
* #25.000 ^designation.value = "Gezondheidszorgpsycholoog"
* #25.000 ^property[0].code = #status
* #25.000 ^property[=].valueCode = #active
* #25.000 ^property[+].code = #parent
* #25.000 ^property[=].valueCode = #AssignedRoleType
* #25.000 ^property[+].code = #child
* #25.000 ^property[=].valueCode = #25.061
* #25.000 ^property[+].code = #child
* #25.000 ^property[=].valueCode = #25.063
* #25.061 "Klinisch psycholoog"
* #25.061 ^designation.language = #nl-NL
* #25.061 ^designation.use.system = "http://snomed.info/sct"
* #25.061 ^designation.use = $sct#900000000000013009 "Synonym"
* #25.061 ^designation.use.display = "Synonym"
* #25.061 ^designation.value = "Klinisch psycholoog"
* #25.061 ^property[0].code = #status
* #25.061 ^property[=].valueCode = #active
* #25.061 ^property[+].code = #parent
* #25.061 ^property[=].valueCode = #25.000
* #25.063 "Klinisch neuropsycholoog"
* #25.063 ^designation.language = #nl-NL
* #25.063 ^designation.use.system = "http://snomed.info/sct"
* #25.063 ^designation.use = $sct#900000000000013009 "Synonym"
* #25.063 ^designation.use.display = "Synonym"
* #25.063 ^designation.value = "Klinisch neuropsycholoog"
* #25.063 ^property[0].code = #status
* #25.063 ^property[=].valueCode = #active
* #25.063 ^property[+].code = #parent
* #25.063 ^property[=].valueCode = #25.000
* #30.000 "Verpleegkundige"
* #30.000 ^designation.language = #nl-NL
* #30.000 ^designation.use.system = "http://snomed.info/sct"
* #30.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #30.000 ^designation.use.display = "Synonym"
* #30.000 ^designation.value = "Verpleegkundige"
* #30.000 ^property[0].code = #status
* #30.000 ^property[=].valueCode = #active
* #30.000 ^property[+].code = #parent
* #30.000 ^property[=].valueCode = #AssignedRoleType
* #30.000 ^property[+].code = #child
* #30.000 ^property[=].valueCode = #30.065
* #30.000 ^property[+].code = #child
* #30.000 ^property[=].valueCode = #30.066
* #30.000 ^property[+].code = #child
* #30.000 ^property[=].valueCode = #30.067
* #30.000 ^property[+].code = #child
* #30.000 ^property[=].valueCode = #30.068
* #30.000 ^property[+].code = #child
* #30.000 ^property[=].valueCode = #30.069
* #30.000 ^property[+].code = #child
* #30.000 ^property[=].valueCode = #30.076
* #30.065 "Verpl. spec. prev. zorg bij som. aandoeningen"
* #30.065 ^designation.language = #nl-NL
* #30.065 ^designation.use.system = "http://snomed.info/sct"
* #30.065 ^designation.use = $sct#900000000000013009 "Synonym"
* #30.065 ^designation.use.display = "Synonym"
* #30.065 ^designation.value = "Verpl. spec. prev. zorg bij som. aandoeningen"
* #30.065 ^property[0].code = #status
* #30.065 ^property[=].valueCode = #deprecated
* #30.065 ^property[+].code = #deprecationDate
* #30.065 ^property[=].valueDateTime = "2023-07-01"
* #30.065 ^property[+].code = #effectiveDate
* #30.065 ^property[=].valueDateTime = "2023-07-01"
* #30.065 ^property[+].code = #inactive
* #30.065 ^property[=].valueBoolean = true
* #30.065 ^property[+].code = #parent
* #30.065 ^property[=].valueCode = #30.000
* #30.066 "Verpl. spec. acute zorg bij som. aandoeningen"
* #30.066 ^designation.language = #nl-NL
* #30.066 ^designation.use.system = "http://snomed.info/sct"
* #30.066 ^designation.use = $sct#900000000000013009 "Synonym"
* #30.066 ^designation.use.display = "Synonym"
* #30.066 ^designation.value = "Verpl. spec. acute zorg bij som. aandoeningen"
* #30.066 ^property[0].code = #status
* #30.066 ^property[=].valueCode = #deprecated
* #30.066 ^property[+].code = #deprecationDate
* #30.066 ^property[=].valueDateTime = "2021-01-01"
* #30.066 ^property[+].code = #effectiveDate
* #30.066 ^property[=].valueDateTime = "2021-01-01"
* #30.066 ^property[+].code = #inactive
* #30.066 ^property[=].valueBoolean = true
* #30.066 ^property[+].code = #parent
* #30.066 ^property[=].valueCode = #30.000
* #30.067 "Verpl. spec. intensieve zorg bij som. aandoeningen"
* #30.067 ^designation.language = #nl-NL
* #30.067 ^designation.use.system = "http://snomed.info/sct"
* #30.067 ^designation.use = $sct#900000000000013009 "Synonym"
* #30.067 ^designation.use.display = "Synonym"
* #30.067 ^designation.value = "Verpl. spec. intensieve zorg bij som. aandoeningen"
* #30.067 ^property[0].code = #status
* #30.067 ^property[=].valueCode = #deprecated
* #30.067 ^property[+].code = #deprecationDate
* #30.067 ^property[=].valueDateTime = "2021-01-01"
* #30.067 ^property[+].code = #effectiveDate
* #30.067 ^property[=].valueDateTime = "2021-01-01"
* #30.067 ^property[+].code = #inactive
* #30.067 ^property[=].valueBoolean = true
* #30.067 ^property[+].code = #parent
* #30.067 ^property[=].valueCode = #30.000
* #30.068 "Verpl. spec. chronische zorg bij som. aandoeningen"
* #30.068 ^designation.language = #nl-NL
* #30.068 ^designation.use.system = "http://snomed.info/sct"
* #30.068 ^designation.use = $sct#900000000000013009 "Synonym"
* #30.068 ^designation.use.display = "Synonym"
* #30.068 ^designation.value = "Verpl. spec. chronische zorg bij som. aandoeningen"
* #30.068 ^property[0].code = #status
* #30.068 ^property[=].valueCode = #deprecated
* #30.068 ^property[+].code = #deprecationDate
* #30.068 ^property[=].valueDateTime = "2023-07-01"
* #30.068 ^property[+].code = #effectiveDate
* #30.068 ^property[=].valueDateTime = "2023-07-01"
* #30.068 ^property[+].code = #inactive
* #30.068 ^property[=].valueBoolean = true
* #30.068 ^property[+].code = #parent
* #30.068 ^property[=].valueCode = #30.000
* #30.069 "Verpl. spec. geestelijke gezondheidszorg"
* #30.069 ^designation.language = #nl-NL
* #30.069 ^designation.use.system = "http://snomed.info/sct"
* #30.069 ^designation.use = $sct#900000000000013009 "Synonym"
* #30.069 ^designation.use.display = "Synonym"
* #30.069 ^designation.value = "Verpl. spec. geestelijke gezondheidszorg"
* #30.069 ^property[0].code = #status
* #30.069 ^property[=].valueCode = #active
* #30.069 ^property[+].code = #parent
* #30.069 ^property[=].valueCode = #30.000
* #30.076 "Verpl. spec. algemene gezondheidszorg"
* #30.076 ^designation.language = #nl-NL
* #30.076 ^designation.use.system = "http://snomed.info/sct"
* #30.076 ^designation.use = $sct#900000000000013009 "Synonym"
* #30.076 ^designation.use.display = "Synonym"
* #30.076 ^designation.value = "Verpl. spec. algemene gezondheidszorg"
* #30.076 ^property[0].code = #status
* #30.076 ^property[=].valueCode = #active
* #30.076 ^property[+].code = #effectiveDate
* #30.076 ^property[=].valueDateTime = "2021-01-01"
* #30.076 ^property[+].code = #parent
* #30.076 ^property[=].valueCode = #30.000
* #31.000 "Orthopedagoog-generalist"
* #31.000 ^designation.language = #nl-NL
* #31.000 ^designation.use.system = "http://snomed.info/sct"
* #31.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #31.000 ^designation.use.display = "Synonym"
* #31.000 ^designation.value = "Orthopedagoog-generalist"
* #31.000 ^property[0].code = #status
* #31.000 ^property[=].valueCode = #active
* #31.000 ^property[+].code = #effectiveDate
* #31.000 ^property[=].valueDateTime = "2020-01-01"
* #31.000 ^property[+].code = #parent
* #31.000 ^property[=].valueCode = #AssignedRoleType
* #79.000 "Geregistreerd-mondhygiënist" "Artikel 36a Wet BIG"
* #79.000 ^designation.language = #nl-NL
* #79.000 ^designation.use.system = "http://snomed.info/sct"
* #79.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #79.000 ^designation.use.display = "Synonym"
* #79.000 ^designation.value = "Geregistreerd-mondhygiënist"
* #79.000 ^property[0].code = #status
* #79.000 ^property[=].valueCode = #active
* #79.000 ^property[+].code = #effectiveDate
* #79.000 ^property[=].valueDateTime = "2020-07-01"
* #79.000 ^property[+].code = #parent
* #79.000 ^property[=].valueCode = #AssignedRoleType
* #80.000 "Bachelor medisch hulpverlener" "Artikel 36a Wet BIG"
* #80.000 ^designation.language = #nl-NL
* #80.000 ^designation.use.system = "http://snomed.info/sct"
* #80.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #80.000 ^designation.use.display = "Synonym"
* #80.000 ^designation.value = "Bachelor medisch hulpverlener"
* #80.000 ^property[0].code = #status
* #80.000 ^property[=].valueCode = #active
* #80.000 ^property[+].code = #parent
* #80.000 ^property[=].valueCode = #AssignedRoleType
* #81.000 "Physician assistant"
* #81.000 ^designation.language = #nl-NL
* #81.000 ^designation.use.system = "http://snomed.info/sct"
* #81.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #81.000 ^designation.use.display = "Synonym"
* #81.000 ^designation.value = "Physician assistant"
* #81.000 ^property[0].code = #status
* #81.000 ^property[=].valueCode = #active
* #81.000 ^property[+].code = #parent
* #81.000 ^property[=].valueCode = #AssignedRoleType
* #82.000 "Klinisch technoloog" "Artikel 36a Wet BIG"
* #82.000 ^designation.language = #nl-NL
* #82.000 ^designation.use.system = "http://snomed.info/sct"
* #82.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #82.000 ^designation.use.display = "Synonym"
* #82.000 ^designation.value = "Klinisch technoloog"
* #82.000 ^property[0].code = #status
* #82.000 ^property[=].valueCode = #active
* #82.000 ^property[+].code = #parent
* #82.000 ^property[=].valueCode = #AssignedRoleType
* #83.000 "Apothekersassistent"
* #83.000 ^designation.language = #nl-NL
* #83.000 ^designation.use.system = "http://snomed.info/sct"
* #83.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #83.000 ^designation.use.display = "Synonym"
* #83.000 ^designation.value = "Apothekersassistent"
* #83.000 ^property[0].code = #status
* #83.000 ^property[=].valueCode = #active
* #83.000 ^property[+].code = #parent
* #83.000 ^property[=].valueCode = #AssignedRoleType
* #84.000 "Klinisch fysicus"
* #84.000 ^designation.language = #nl-NL
* #84.000 ^designation.use.system = "http://snomed.info/sct"
* #84.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #84.000 ^designation.use.display = "Synonym"
* #84.000 ^designation.value = "Klinisch fysicus"
* #84.000 ^property[0].code = #status
* #84.000 ^property[=].valueCode = #active
* #84.000 ^property[+].code = #parent
* #84.000 ^property[=].valueCode = #AssignedRoleType
* #85.000 "Tandprotheticus"
* #85.000 ^designation.language = #nl-NL
* #85.000 ^designation.use.system = "http://snomed.info/sct"
* #85.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #85.000 ^designation.use.display = "Synonym"
* #85.000 ^designation.value = "Tandprotheticus"
* #85.000 ^property[0].code = #status
* #85.000 ^property[=].valueCode = #active
* #85.000 ^property[+].code = #parent
* #85.000 ^property[=].valueCode = #AssignedRoleType
* #86.000 "VIG-er"
* #86.000 ^designation.language = #nl-NL
* #86.000 ^designation.use.system = "http://snomed.info/sct"
* #86.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #86.000 ^designation.use.display = "Synonym"
* #86.000 ^designation.value = "VIG-er"
* #86.000 ^property[0].code = #status
* #86.000 ^property[=].valueCode = #active
* #86.000 ^property[+].code = #parent
* #86.000 ^property[=].valueCode = #AssignedRoleType
* #87.000 "Optometrist"
* #87.000 ^designation.language = #nl-NL
* #87.000 ^designation.use.system = "http://snomed.info/sct"
* #87.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #87.000 ^designation.use.display = "Synonym"
* #87.000 ^designation.value = "Optometrist"
* #87.000 ^property[0].code = #status
* #87.000 ^property[=].valueCode = #active
* #87.000 ^property[+].code = #parent
* #87.000 ^property[=].valueCode = #AssignedRoleType
* #88.000 "Huidtherapeut"
* #88.000 ^designation.language = #nl-NL
* #88.000 ^designation.use.system = "http://snomed.info/sct"
* #88.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #88.000 ^designation.use.display = "Synonym"
* #88.000 ^designation.value = "Huidtherapeut"
* #88.000 ^property[0].code = #status
* #88.000 ^property[=].valueCode = #active
* #88.000 ^property[+].code = #parent
* #88.000 ^property[=].valueCode = #AssignedRoleType
* #89.000 "Diëtist"
* #89.000 ^designation.language = #nl-NL
* #89.000 ^designation.use.system = "http://snomed.info/sct"
* #89.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #89.000 ^designation.use.display = "Synonym"
* #89.000 ^designation.value = "Diëtist"
* #89.000 ^property[0].code = #status
* #89.000 ^property[=].valueCode = #active
* #89.000 ^property[+].code = #parent
* #89.000 ^property[=].valueCode = #AssignedRoleType
* #90.000 "Ergotherapeut"
* #90.000 ^designation.language = #nl-NL
* #90.000 ^designation.use.system = "http://snomed.info/sct"
* #90.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #90.000 ^designation.use.display = "Synonym"
* #90.000 ^designation.value = "Ergotherapeut"
* #90.000 ^property[0].code = #status
* #90.000 ^property[=].valueCode = #active
* #90.000 ^property[+].code = #parent
* #90.000 ^property[=].valueCode = #AssignedRoleType
* #91.000 "Logopedist"
* #91.000 ^designation.language = #nl-NL
* #91.000 ^designation.use.system = "http://snomed.info/sct"
* #91.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #91.000 ^designation.use.display = "Synonym"
* #91.000 ^designation.value = "Logopedist"
* #91.000 ^property[0].code = #status
* #91.000 ^property[=].valueCode = #active
* #91.000 ^property[+].code = #parent
* #91.000 ^property[=].valueCode = #AssignedRoleType
* #92.000 "Mondhygiënist"
* #92.000 ^designation.language = #nl-NL
* #92.000 ^designation.use.system = "http://snomed.info/sct"
* #92.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #92.000 ^designation.use.display = "Synonym"
* #92.000 ^designation.value = "Mondhygiënist"
* #92.000 ^property[0].code = #status
* #92.000 ^property[=].valueCode = #active
* #92.000 ^property[+].code = #parent
* #92.000 ^property[=].valueCode = #AssignedRoleType
* #93.000 "Oefentherapeut Mensendieck"
* #93.000 ^designation.language = #nl-NL
* #93.000 ^designation.use.system = "http://snomed.info/sct"
* #93.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #93.000 ^designation.use.display = "Synonym"
* #93.000 ^designation.value = "Oefentherapeut Mensendieck"
* #93.000 ^property[0].code = #status
* #93.000 ^property[=].valueCode = #active
* #93.000 ^property[+].code = #parent
* #93.000 ^property[=].valueCode = #AssignedRoleType
* #94.000 "Oefentherapeut Cesar"
* #94.000 ^designation.language = #nl-NL
* #94.000 ^designation.use.system = "http://snomed.info/sct"
* #94.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #94.000 ^designation.use.display = "Synonym"
* #94.000 ^designation.value = "Oefentherapeut Cesar"
* #94.000 ^property[0].code = #status
* #94.000 ^property[=].valueCode = #active
* #94.000 ^property[+].code = #parent
* #94.000 ^property[=].valueCode = #AssignedRoleType
* #95.000 "Orthoptist"
* #95.000 ^designation.language = #nl-NL
* #95.000 ^designation.use.system = "http://snomed.info/sct"
* #95.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #95.000 ^designation.use.display = "Synonym"
* #95.000 ^designation.value = "Orthoptist"
* #95.000 ^property[0].code = #status
* #95.000 ^property[=].valueCode = #active
* #95.000 ^property[+].code = #parent
* #95.000 ^property[=].valueCode = #AssignedRoleType
* #96.000 "Podotherapeut"
* #96.000 ^designation.language = #nl-NL
* #96.000 ^designation.use.system = "http://snomed.info/sct"
* #96.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #96.000 ^designation.use.display = "Synonym"
* #96.000 ^designation.value = "Podotherapeut"
* #96.000 ^property[0].code = #status
* #96.000 ^property[=].valueCode = #active
* #96.000 ^property[+].code = #parent
* #96.000 ^property[=].valueCode = #AssignedRoleType
* #97.000 "Radiodiagnostisch laborant"
* #97.000 ^designation.language = #nl-NL
* #97.000 ^designation.use.system = "http://snomed.info/sct"
* #97.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #97.000 ^designation.use.display = "Synonym"
* #97.000 ^designation.value = "Radiodiagnostisch laborant"
* #97.000 ^property[0].code = #status
* #97.000 ^property[=].valueCode = #active
* #97.000 ^property[+].code = #parent
* #97.000 ^property[=].valueCode = #AssignedRoleType
* #98.000 "Radiotherapeutisch laborant"
* #98.000 ^designation.language = #nl-NL
* #98.000 ^designation.use.system = "http://snomed.info/sct"
* #98.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #98.000 ^designation.use.display = "Synonym"
* #98.000 ^designation.value = "Radiotherapeutisch laborant"
* #98.000 ^property[0].code = #status
* #98.000 ^property[=].valueCode = #active
* #98.000 ^property[+].code = #parent
* #98.000 ^property[=].valueCode = #AssignedRoleType
* #99.000 "Zorgverlener andere zorg"
* #99.000 ^designation.language = #nl-NL
* #99.000 ^designation.use = $sct#900000000000013009 "Synonym"
* #99.000 ^designation.value = "Zorgverlener andere zorg"
* #99.000 ^property[0].code = #status
* #99.000 ^property[=].valueCode = #active
* #99.000 ^property[+].code = #parent
* #99.000 ^property[=].valueCode = #AssignedRoleType


ValueSet: ProcedureType
Id: nl-gf-procedure-type
Title: "NL GF Procedure Types"
Description: "Indicates the type of medical procedure."
* ^status = #active
* ^copyright = "This value set includes content from SNOMED CT, which is copyright © 2002+ International Health Terminology Standards Development Organisation (IHTSDO), and distributed by agreement between IHTSDO and HL7. Implementer use of SNOMED CT is not covered by this agreement"
* include codes from system $sct where concept is-a #71388002 "Procedure (procedure)"