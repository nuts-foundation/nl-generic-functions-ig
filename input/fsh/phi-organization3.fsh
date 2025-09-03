Instance: org3-jaantje
InstanceOf: Patient //TODO: dependency on $nl-core-Patient if dependency-bug-nictiz is fixed
Title: "9.01 Patient Jaantje Merkens"
* meta.profile = $nl-core-Patient
* identifier[0].system = "http://organization3.example.org/EHR/patients"
* identifier[=].value = "126"
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
* managingOrganization = Reference(Organization/org3-organization1) "Organization 1"

Instance: org3-ms1
InstanceOf: MedicationStatement
Title: "9.01 MedicationStatement for Apremilast"
* status = #active
* medicationCodeableConcept = $atc#L04AA32 "Apremilast (immunosuppressiva)"
* subject = Reference(Patient/org3-jaantje)
* dateAsserted = "2024-10-03"
* informationSource = Reference(PractitionerRole/org3-practitionerrole1)
* dosage[0].text = "10 mg orally every 4 hours"
* dosage[0].timing.repeat.frequency = 6
* dosage[0].timing.repeat.period = 1
* dosage[0].timing.repeat.periodUnit = #d
* dosage[0].doseAndRate[0].doseQuantity.value = 10
* dosage[0].doseAndRate[0].doseQuantity.unit = "mg"



Instance: org3-ct1
InstanceOf: CareTeam
Usage: #example
Title: "1.43.2 CareTeam update"
Description: "Add participant to CareTeam"
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(Patient/org3-jaantje)
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(PractitionerRole/org3-practitionerrole1)
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(Organization/org3-organization1)
* participant[=].member.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* participant[=].member.identifier.value = "33333333"

Instance: phi-organization3
InstanceOf: Bundle
Usage: #example
Title: "9.01 Bundle of services and personal health information in EHR of Organization 3"
* type = #transaction
* insert BundleEntry(org3-jaantje, #PUT, Patient/org3-jaantje)
* insert BundleEntry(org3-ms1, #PUT, MedicationStatement/org3-ms1)
* insert BundleEntry(org3-ct1, #PUT, CareTeam/org3-ct1)