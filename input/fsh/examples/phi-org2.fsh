Instance: 27e58ece-409e-44f9-8cc1-b33495a0ef9d
InstanceOf: Patient //TODO: dependency on $nl-core-Patient if dependency-bug-nictiz is fixed
Usage: #example
Title: "Patient Jaantje Merkens"
Description: "Patient Jaantje Merkens in EHR of Organization 2"
* meta.profile = $nl-core-Patient
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/Patient","27e58ece-409e-44f9-8cc1-b33495a0ef9d","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* identifier[0].system = "http://organization2.example.org/EHR/patients"
* identifier[=].value = "vdfesz"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/bsn"
* identifier[=].value = "111222333"
* name
  * given[0] = "Jaantje"
  * family = "Merkens"
* telecom[+].system = #phone
* telecom[=].value = "+31612345678"
* telecom[+].system = #email
* telecom[=].value = "j.merkens@bigtech.com"
* gender = #female
* birthDate = "1950-02-26"
* address.line = "Kerkstraat 18"
* address.postalCode = "7071 WZ"
* address.city = "Ulft"
* managingOrganization = Reference(Organization/cff921f3-c1c1-4a4c-8f0f-cafd0aa25067) "Organization 2"

//8jr geleden: Aortadissectie
Instance: 8f26c2c2-9a7b-4a2f-84ac-264f1177964c
InstanceOf: Condition
Usage: #inline
Title: "Condition Aortadissectie"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Problem"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/Condition","8f26c2c2-9a7b-4a2f-84ac-264f1177964c","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* onsetDateTime = "2017-09-03T12:00:00Z"
* code = $sct#308546005 "Dissection of aorta"
* subject = Reference(Patient/27e58ece-409e-44f9-8cc1-b33495a0ef9d) 


//Start antihypertensiva bij cardioloog
Instance: 8c2d4009-4322-4d4a-8e29-3e70cd67d286
InstanceOf: MedicationRequest
Usage: #inline
Title: "MedicationRequest Cisplatine"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-MedicationRequest"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/MedicationRequest","8c2d4009-4322-4d4a-8e29-3e70cd67d286","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* status = #active
* intent = #order
* medicationCodeableConcept = $atc#L01BC05 "gemcitabine"
* subject = Reference(Patient/27e58ece-409e-44f9-8cc1-b33495a0ef9d) 
* authoredOn = "2017-09-03"
* requester = Reference(PractitionerRole/f051d3bd-26ff-4030-a5b6-fc4ef2be83ba) // Organization 2
* dosageInstruction[0].text = "Take one tablet by mouth twice daily"
* dosageInstruction[0].timing.repeat.frequency = 2
* dosageInstruction[0].timing.repeat.period = 1
* dosageInstruction[0].timing.repeat.periodUnit = #d
* dosageInstruction[0].doseAndRate[0].doseQuantity.value = 250
* dosageInstruction[0].doseAndRate[0].doseQuantity.unit = "mg"

Instance: e00a59fa-7d7e-422d-8505-ef3e645404e9
InstanceOf: MedicationStatement
Usage: #inline
Title: "MedicationStatement Cisplatine"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-MedicationStatement"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/MedicationStatement","e00a59fa-7d7e-422d-8505-ef3e645404e9","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* status = #active
* medicationCodeableConcept = $atc#L01BC05 "gemcitabine"
* subject = Reference(Patient/27e58ece-409e-44f9-8cc1-b33495a0ef9d)
* effectiveDateTime = "2017-09-03"
* dateAsserted = "2017-09-03"
* informationSource = Reference(PractitionerRole/f051d3bd-26ff-4030-a5b6-fc4ef2be83ba)
* dosage[0].text = "Take one tablet by mouth twice daily"
* dosage[0].timing.repeat.frequency = 2
* dosage[0].timing.repeat.period = 1
* dosage[0].timing.repeat.periodUnit = #d
* dosage[0].doseAndRate[0].doseQuantity.value = 250
* dosage[0].doseAndRate[0].doseQuantity.unit = "mg"


//4jr geleden: Vermindering energie en krachtsverlies in benen
Instance: 5a7f34e7-9b7b-4e5c-ba7c-890edbc4d757
InstanceOf: Condition
Usage: #example
Title: "Condition hypercalciëmie"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Problem"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/Condition","5a7f34e7-9b7b-4e5c-ba7c-890edbc4d757","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* onsetDateTime = "2021-09-03T12:00:00Z"
* code = $sct#66931009 "Hypercalcemia"
* subject = Reference(Patient/27e58ece-409e-44f9-8cc1-b33495a0ef9d) 

Instance: 6bc0f95c-f281-475e-a279-4ed6beb59024
InstanceOf: Procedure
Usage: #inline
Title: "Procedure Thyroidectomy"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Procedure"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/Procedure","6bc0f95c-f281-475e-a279-4ed6beb59024","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* status = #completed
* code = $sct#13619001 "Thyroidectomy"
* subject = Reference(Patient/27e58ece-409e-44f9-8cc1-b33495a0ef9d) 
* performedDateTime = "2022-05-15T08:00:00Z"
* performer[0].actor = Reference(PractitionerRole/f051d3bd-26ff-4030-a5b6-fc4ef2be83ba)
* reasonReference = Reference(Condition/5a7f34e7-9b7b-4e5c-ba7c-890edbc4d757)

Instance: phi-org2
InstanceOf: Bundle
Usage: #example
Title: "Bundle of personal health information in EHR of Organization 2"
Description: "This bundle contains all personal health information for Patient Jaantje Merkens in Organization 2"
* type = #transaction
* insert BundleEntryPUT(Patient, 27e58ece-409e-44f9-8cc1-b33495a0ef9d)
* insert BundleEntryPUT(Condition, 8f26c2c2-9a7b-4a2f-84ac-264f1177964c)
* insert BundleEntryPUT(Condition, 5a7f34e7-9b7b-4e5c-ba7c-890edbc4d757)
* insert BundleEntryPUT(Procedure, 6bc0f95c-f281-475e-a279-4ed6beb59024)
* insert BundleEntryPUT(MedicationRequest, 8c2d4009-4322-4d4a-8e29-3e70cd67d286)
* insert BundleEntryPUT(MedicationStatement, e00a59fa-7d7e-422d-8505-ef3e645404e9)
