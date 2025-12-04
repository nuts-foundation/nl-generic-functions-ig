Instance: 96e7aa36-6d66-4a9e-bf6b-245d97d8ec1d
InstanceOf: Patient //TODO: dependency on $nl-core-Patient if dependency-bug-nictiz is fixed
Usage: #inline
Title: "Patient Jaantje Merkens"
* meta.profile = $nl-core-Patient
* identifier[0].system = "http://organization3.example.org/EHR/patients"
* identifier[=].value = "126"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/bsn"
* identifier[=].value = "111222333"
* insert AuthorAssignedIdentifier("https://cp3-test.example.org/Patient","96e7aa36-6d66-4a9e-bf6b-245d97d8ec1d","http://fhir.nl/fhir/NamingSystem/ura", "33333333")
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
* managingOrganization = Reference(Organization/3e799075-63a2-4a4c-913d-a91b8198463d) "Organization 1"

Instance: 8732d369-7759-447b-af01-f3e0c601b452
InstanceOf: MedicationStatement
Usage: #inline
Title: "MedicationStatement for Apremilast"
* insert AuthorAssignedIdentifier("https://cp3-test.example.org/MedicationStatement","8732d369-7759-447b-af01-f3e0c601b452","http://fhir.nl/fhir/NamingSystem/ura", "33333333")
* status = #active
* medicationCodeableConcept = $atc#L04AA32 "apremilast"
* subject = Reference(Patient/96e7aa36-6d66-4a9e-bf6b-245d97d8ec1d)
* dateAsserted = "2024-10-03"
* informationSource = Reference(PractitionerRole/d60525bd-5caf-4437-8f4b-4156300a27de)
* dosage[0].text = "10 mg orally every 4 hours"
* dosage[0].timing.repeat.frequency = 6
* dosage[0].timing.repeat.period = 1
* dosage[0].timing.repeat.periodUnit = #d
* dosage[0].doseAndRate[0].doseQuantity.value = 10
* dosage[0].doseAndRate[0].doseQuantity.unit = "mg"



Instance: bd8f360a-7bf2-4b65-9202-f3c092525492
InstanceOf: CareTeam
Usage: #inline
Title: "CareTeam of Patient Jaantje Merkens"
* insert AuthorAssignedIdentifier("https://cp3-test.example.org/CareTeam","bd8f360a-7bf2-4b65-9202-f3c092525492","http://fhir.nl/fhir/NamingSystem/ura", "33333333")
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(Patient/96e7aa36-6d66-4a9e-bf6b-245d97d8ec1d)
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(PractitionerRole/d60525bd-5caf-4437-8f4b-4156300a27de)
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(Organization/3e799075-63a2-4a4c-913d-a91b8198463d)
* participant[=].member.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* participant[=].member.identifier.value = "33333333"

Instance: phi-org3
InstanceOf: Bundle
Usage: #example
Title: "Bundle of personal health information in ECD of Organization 3"
Description: "This bundle contains all personal health information for Patient Jaantje Merkens in Organization 3"
* type = #transaction
* insert BundleEntryPUT(Patient, 96e7aa36-6d66-4a9e-bf6b-245d97d8ec1d)
* insert BundleEntryPUT(MedicationStatement, 8732d369-7759-447b-af01-f3e0c601b452)
* insert BundleEntryPUT(CareTeam, bd8f360a-7bf2-4b65-9202-f3c092525492)
