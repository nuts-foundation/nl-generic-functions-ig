Extension: NlGfLocalizationCustodian
Id: nl-gf-localization-custodian
Title: "NL Generic Functions Localization Custodian"
Description: "The organization responsible for the localization record, identified by URA number."
Context: List
* value[x] only Reference(Organization)
* valueReference.identifier 1..1
* valueReference.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* valueReference.reference 0..0

Profile: NlGfLocalizationList
Parent: List
Id: nl-gf-localization-list
Title: "NL Generic Functions Localization List Profile"
Description: """A List profile for registering the availability of patient data
at healthcare organizations for localization services. This profile is used to
indicate that certain patient data is available at a specific organization and
can be accessed for localization purposes."""
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "$this"
* identifier ^slicing.rules = #open
* identifier contains
    AssignedId 1..1
* identifier[AssignedId].system 1..1
* identifier[AssignedId].value 1..1
* identifier[AssignedId].assigner 1..1
* identifier[AssignedId].assigner.identifier 1..1
* identifier[AssignedId].assigner.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[AssignedId].assigner.identifier.value 1..1
* identifier[AssignedId].assigner.identifier.type 1..1
* identifier[AssignedId].assigner.identifier.type.coding 1..1
* identifier[AssignedId].assigner.identifier.type.coding.system = $provenance-participant-type
* identifier[AssignedId].assigner.identifier.type.coding.code = #author
* status 1..1
* status ^comment = "All records are always current"
* status = #current
* mode 1..1
* mode = #working
* code 1..1
* code from $aorta-bouwsteentype-vs (required)
* subject 1..1
* subject only Reference(Patient)
* subject.identifier 1..1
* subject.identifier.system = "http://fhir.nl/fhir/NamingSystem/pseudo-bsn"
* subject.reference 0..0
* source 1..1
* source only Reference(Device)
* source.reference ..0
* source.type = $resource-types#Device
* entry 0..0
* emptyReason 1..1
* emptyReason = http://terminology.hl7.org/CodeSystem/list-empty-reason#withheld
