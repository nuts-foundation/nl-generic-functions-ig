Instance: 128447d2-e153-4c93-8ac6-6c357555f3db
InstanceOf: Patient //TODO: dependency on $nl-core-Patient if dependency-bug-nictiz is fixed
Usage: #inline
Title: "Patient Jaantje Merkens"
* meta.profile = $nl-core-Patient
* identifier[0].system = "http://organization1.example.org/EHR/patients"
* identifier[=].value = "123456"
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
* managingOrganization = Reference(Organization/4cb35b96-f021-4e15-bf71-d67a6d4bebec) "Organization 1"

Instance: 8cdd8f8d-f75b-4285-851e-ff302dad46fb
InstanceOf: Condition
Usage: #inline
Title: "Condition General Weakness"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Condition"
* meta.versionId = "1"
* meta.lastUpdated = "2024-09-03T12:00:00Z"
* clinicalStatus = $condition-clinical#active
* verificationStatus = $condition-ver-status#provisional
* code = $sct#13791008 "General weakness"
* bodySite[+] = $sct#421480009 "Lower extremity or both lower extremities"
* subject = Reference(Patient/128447d2-e153-4c93-8ac6-6c357555f3db) "Patient Jaantje Merkens"
* onsetDateTime = "2021-08-01T00:00:00Z"
* recorder = Reference(PractitionerRole/5fa4c91a-a12f-48ae-a4c7-92971dc7ab53) "Caroline van Dijk at Organization 1"
* note.text = "Patient reports general weakness and loss of energy in legs."

Instance: 73f4bffe-eac4-4863-8e4a-852c578f95dd
InstanceOf: ServiceRequest
Usage: #inline
Title: "ServiceRequest Vascular medicine"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Procedure-request"
* meta.versionId = "1"
* status = #active
* intent = #order
* subject = Reference(Patient/128447d2-e153-4c93-8ac6-6c357555f3db) "Patient Jaantje Merkens"
* requester = Reference(PractitionerRole/5fa4c91a-a12f-48ae-a4c7-92971dc7ab53) "Caroline van Dijk at Organization 1"
* code = $sct#11429006 "Consultation"
* reasonReference = Reference(Condition/8cdd8f8d-f75b-4285-851e-ff302dad46fb) "General Weakness"
* performerType = $sct#722414000 "Vascular medicine"


Instance: d2f1d123-9bfb-485f-8b6f-2db411c4884e
InstanceOf: ServiceRequest
Usage: #inline
Title: "ServiceRequest Neurological Diagnostics"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Procedure-request"
* meta.versionId = "1"
* status = #active
* intent = #order
* subject = Reference(Patient/128447d2-e153-4c93-8ac6-6c357555f3db) "Patient Jaantje Merkens"
* requester = Reference(PractitionerRole/5fa4c91a-a12f-48ae-a4c7-92971dc7ab53) "Caroline van Dijk at Organization 1"
* code = $sct#11429006 "Consultation"
* reasonReference = Reference(Condition/8cdd8f8d-f75b-4285-851e-ff302dad46fb) "General Weakness"
* performerType = $sct#394591006 "Neurology"

Instance: 4e4215a2-d6ff-4e53-8737-d9810a4cc3eb
InstanceOf: ServiceRequest
Usage: #inline
Title: "ServiceRequest Orthoptic Diagnostics"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Procedure-request"
* meta.versionId = "1"
* status = #active
* intent = #order
* subject = Reference(Patient/128447d2-e153-4c93-8ac6-6c357555f3db) "Patient Jaantje Merkens"
* requester = Reference(PractitionerRole/5fa4c91a-a12f-48ae-a4c7-92971dc7ab53) "Caroline van Dijk at Organization 1"
* code = $sct#11429006 "Consultation"
* reasonReference = Reference(Condition/8cdd8f8d-f75b-4285-851e-ff302dad46fb) "General Weakness"
* performerType = $sct#1345026002 "Orthopedic specialty"

Instance: 3cb7873f-c222-4196-b441-02b3790ec97e
InstanceOf: ServiceRequest
Usage: #inline
Title: "ServiceRequest Internal medicine"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Procedure-request"
* meta.versionId = "1"
* status = #active
* intent = #order
* subject = Reference(Patient/128447d2-e153-4c93-8ac6-6c357555f3db) "Patient Jaantje Merkens"
* requester = Reference(PractitionerRole/5fa4c91a-a12f-48ae-a4c7-92971dc7ab53) "Caroline van Dijk at Organization 1"
* code = $sct#11429006 "Consultation"
* reasonReference = Reference(Condition/8cdd8f8d-f75b-4285-851e-ff302dad46fb) "General Weakness"
* performerType = $sct#419192003 "Internal medicine"

Instance: 98f9d4a7-d58d-4889-8e63-0cb2d4e35144
InstanceOf: MedicationStatement
Usage: #inline
Title: "MedicationStatement Urokinase"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-MedicationStatement"
* status = #active
* medicationCodeableConcept = $atc#B01AD04 "urokinase"
* subject = Reference(Patient/128447d2-e153-4c93-8ac6-6c357555f3db)
* effectiveDateTime = "2017-09-03"
* dateAsserted = "2017-09-03"
* informationSource = Reference(PractitionerRole/5fa4c91a-a12f-48ae-a4c7-92971dc7ab53)
* dosage[0].text = "Take one tablet by mouth twice daily"
* dosage[0].timing.repeat.frequency = 2
* dosage[0].timing.repeat.period = 1
* dosage[0].timing.repeat.periodUnit = #d
* dosage[0].doseAndRate[0].doseQuantity.value = 500
* dosage[0].doseAndRate[0].doseQuantity.unit = "mg"



Instance: f304c628-c19f-4207-adfb-ad34447ab044
InstanceOf: CareTeam
Usage: #inline
Title: "CareTeam of Patient Jaantje Merkens"
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(Patient/128447d2-e153-4c93-8ac6-6c357555f3db)
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(PractitionerRole/5fa4c91a-a12f-48ae-a4c7-92971dc7ab53)
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(https://cp2-test.example.org/fhirr4/PractitionerRole/f051d3bd-26ff-4030-a5b6-fc4ef2be83ba)
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(https://cp3-test.example.org/fhirr4/PractitionerRole/d60525bd-5caf-4437-8f4b-4156300a27de)

* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(Organization/4cb35b96-f021-4e15-bf71-d67a6d4bebec)
* participant[=].member.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* participant[=].member.identifier.value = "11111111"
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(https://cp2-test.example.org/fhirr4/Organization/cff921f3-c1c1-4a4c-8f0f-cafd0aa25067)
* participant[=].member.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* participant[=].member.identifier.value = "22222222"

// * participant[+].period.start = "2024-08-27"
// * participant[=].member = Reference(https://fhir-org3.test.dataverloskunde.nl/fhir/Organization/3e799075-63a2-4a4c-913d-a91b8198463d)
// * participant[=].member.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
// * participant[=].member.identifier.value = "33333333"



Instance: phi-org1
InstanceOf: Bundle
Usage: #example
Title: "Bundle of personal health information in HIS of Organization 1"
Description: "This bundle contains all personal health information for Patient Jaantje Merkens in Organization 1"
* type = #transaction
* insert BundleEntryPUT(Patient, 128447d2-e153-4c93-8ac6-6c357555f3db)
* insert BundleEntryPUT(Condition, 8cdd8f8d-f75b-4285-851e-ff302dad46fb)
* insert BundleEntryPUT(ServiceRequest, 73f4bffe-eac4-4863-8e4a-852c578f95dd)
* insert BundleEntryPUT(ServiceRequest, d2f1d123-9bfb-485f-8b6f-2db411c4884e)
* insert BundleEntryPUT(ServiceRequest, 4e4215a2-d6ff-4e53-8737-d9810a4cc3eb)
* insert BundleEntryPUT(ServiceRequest, 3cb7873f-c222-4196-b441-02b3790ec97e)
* insert BundleEntryPUT(MedicationStatement, 98f9d4a7-d58d-4889-8e63-0cb2d4e35144)
* insert BundleEntryPUT(CareTeam, f304c628-c19f-4207-adfb-ad34447ab044)
