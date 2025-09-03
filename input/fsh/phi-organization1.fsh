Instance: org1-jaantje
InstanceOf: Patient //TODO: dependency on $nl-core-Patient if dependency-bug-nictiz is fixed
Title: "9.01 Patient Jaantje Merkens"
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
* managingOrganization = Reference(Organization/org1-organization1) "Organization 1"

Instance: org1-general-weakness
InstanceOf: Condition
Usage: #example
Title: "9.01 Condition General Weakness"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Condition"
* meta.versionId = "1"
* meta.lastUpdated = "2024-09-03T12:00:00Z"
* clinicalStatus = #active
* verificationStatus = #provisional
* code = $sct#13791008 "krachtsvermindering"
* bodySite[+] = $sct#421480009 "been of beide benen"
* subject = Reference(Patient/org1-jaantje) "Patient Jaantje Merkens"
* onsetDateTime = "2021-08-01T00:00:00Z"
* recorder = Reference(PractitionerRole/org1-generalpractitioner-harryarts) "Caroline van Dijk at Organization 1"
* note.text = "Patient reports general weakness and loss of energy in legs."

Instance: org1-vascular-medicine
InstanceOf: ServiceRequest
Usage: #example
Title: "9.01 ServiceRequest Vascular medicine"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Procedure-request"
* meta.versionId = "1"
* status = #active
* intent = #order
* subject = Reference(Patient/org1-jaantje) "Patient Jaantje Merkens"
* requester = Reference(PractitionerRole/org1-generalpractitioner-harryarts) "Caroline van Dijk at Organization 1"
* code = $sct#105251000146109 "eerste polikliniekbezoek"
* reasonReference = Reference(Condition/org1-general-weakness) "General Weakness"
* performerType = $sct#722414000 "Vascular medicine"


Instance: org1-neurology
InstanceOf: ServiceRequest
Usage: #example
Title: "9.01 ServiceRequest Neurological  Diagnostics"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Procedure-request"
* meta.versionId = "1"
* status = #active
* intent = #order
* subject = Reference(Patient/org1-jaantje) "Patient Jaantje Merkens"
* requester = Reference(PractitionerRole/org1-generalpractitioner-harryarts) "Caroline van Dijk at Organization 1"
* code = $sct#105251000146109 "eerste polikliniekbezoek"
* reasonReference = Reference(Condition/org1-general-weakness) "General Weakness"
* performerType = $sct#394591006 "Neurology"

Instance: org1-orthopedic-specialty
InstanceOf: ServiceRequest
Usage: #example
Title: "9.01 ServiceRequest Orthoptic Diagnostics"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Procedure-request"
* meta.versionId = "1"
* status = #active
* intent = #order
* subject = Reference(Patient/org1-jaantje) "Patient Jaantje Merkens"
* requester = Reference(PractitionerRole/org1-generalpractitioner-harryarts) "Caroline van Dijk at Organization 1"
* code = $sct#105251000146109 "eerste polikliniekbezoek"
* reasonReference = Reference(Condition/org1-general-weakness) "General Weakness"
* performerType = $sct#1345026002 "Orthopedic specialty"

Instance: org1-internal-medicine
InstanceOf: ServiceRequest
Usage: #example
Title: "9.01 ServiceRequest Internal medicine"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Procedure-request"
* meta.versionId = "1"
* status = #active
* intent = #order
* subject = Reference(Patient/org1-jaantje) "Patient Jaantje Merkens"
* requester = Reference(PractitionerRole/org1-generalpractitioner-harryarts) "Caroline van Dijk at Organization 1"
* code = $sct#105251000146109 "eerste polikliniekbezoek"
* reasonReference = Reference(Condition/org1-general-weakness) "General Weakness"
* performerType = $sct#419192003 "Internal medicine"

Instance: org1-ms1
InstanceOf: MedicationStatement
Usage: #example
Title: "MedicationStatement Urokinase"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-MedicationStatement"
* status = #active
* medicationCodeableConcept = $atc#B01AD04 "Urokinase (trombolytica)"
* subject = Reference(Patient/org1-jaantje)
* effectiveDateTime = "2017-09-03"
* dateAsserted = "2017-09-03"
* informationSource = Reference(PractitionerRole/org1-generalpractitioner-harryarts)
* dosage[0].text = "Take one tablet by mouth twice daily"
* dosage[0].timing.repeat.frequency = 2
* dosage[0].timing.repeat.period = 1
* dosage[0].timing.repeat.periodUnit = #d
* dosage[0].doseAndRate[0].doseQuantity.value = 500
* dosage[0].doseAndRate[0].doseQuantity.unit = "mg"



Instance: cps-careteam-01-02
InstanceOf: CareTeam
Usage: #example
Title: "1.43.2 CareTeam update"
Description: "Add participant to CareTeam"
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(Patient/org1-jaantje)
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(PractitionerRole/org1-generalpractitioner-harryarts)
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(https://fhir-org2.test.dataverloskunde.nl/fhir/PractitionerRole/org2-cardiologist-carolinevandijk)
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(https://fhir-org3.test.dataverloskunde.nl/fhir/PractitionerRole/org3-practitionerrole1)
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(Organization/org1-organization1)
* participant[=].member.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* participant[=].member.identifier.value = "11111111"
* participant[+].period.start = "2024-08-27"
* participant[=].member = Reference(https://fhir-org2.test.dataverloskunde.nl/fhir/Organization/org2-organization1)
* participant[=].member.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* participant[=].member.identifier.value = "22222222"
// * participant[+].period.start = "2024-08-27"
// * participant[=].member = Reference(https://fhir-org3.test.dataverloskunde.nl/fhir/Organization/org3-organization1)
// * participant[=].member.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
// * participant[=].member.identifier.value = "33333333"



Instance: phi-organization1
InstanceOf: Bundle
Usage: #example
Title: "9.01 Bundle of services and personal health information in EHR of Organization 1"
* type = #transaction
* insert BundleEntry(org1-jaantje, #PUT, Patient/org1-jaantje)
* insert BundleEntry(org1-general-weakness, #PUT, Condition/org1-general-weakness)
* insert BundleEntry(org1-vascular-medicine, #PUT, ServiceRequest/org1-vascular-medicine)
* insert BundleEntry(org1-neurology, #PUT, ServiceRequest/org1-neurology)
* insert BundleEntry(org1-orthopedic-specialty, #PUT, ServiceRequest/org1-orthopedic-specialty)
* insert BundleEntry(org1-internal-medicine, #PUT, ServiceRequest/org1-internal-medicine)
* insert BundleEntry(org1-ms1, #PUT, MedicationStatement/org1-ms1)
* insert BundleEntry(cps-careteam-01-02, #PUT, CareTeam/cps-careteam-01-02)
