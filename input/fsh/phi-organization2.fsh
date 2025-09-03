Instance: org2-jaantje
InstanceOf: Patient //TODO: dependency on $nl-core-Patient if dependency-bug-nictiz is fixed
Title: "9.01 Patient Jaantje Merkens"
* meta.profile = $nl-core-Patient
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
* managingOrganization = Reference(Organization/org2-organization1) "Organization 2"

//8jr geleden: Aortadissectie
Instance: org2-aortadissectie
InstanceOf: Condition
Usage: #example
Title: "Condition Aortadissectie"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Problem"
* onsetDateTime = "2017-09-03T12:00:00Z"
* code = $sct#308546005 "aortadissectie"
* subject = Reference(Patient/org2-jaantje) 


//Start antihypertensiva bij cardioloog
Instance: org2-methyldopa
InstanceOf: MedicationRequest
Usage: #example
Title: "MedicationRequest Cisplatine"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-MedicationRequest"
* status = #active
* intent = #order
* medicationCodeableConcept = $atc#L01BC05 "Cisplatine (pyrimidine-antagonisten)"
* subject = Reference(Patient/org2-jaantje) 
* authoredOn = "2017-09-03"
* requester = Reference(PractitionerRole/org2-cardiologist-carolinevandijk) // Organization 2
* dosageInstruction[0].text = "Take one tablet by mouth twice daily"
* dosageInstruction[0].timing.repeat.frequency = 2
* dosageInstruction[0].timing.repeat.period = 1
* dosageInstruction[0].timing.repeat.periodUnit = #d
* dosageInstruction[0].doseAndRate[0].doseQuantity.value = 250
* dosageInstruction[0].doseAndRate[0].doseQuantity.unit = "mg"

Instance: org2-ms1
InstanceOf: MedicationStatement
Usage: #example
Title: "MedicationStatement Cisplatine"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-MedicationStatement"
* status = #active
* medicationCodeableConcept = $atc#L01BC05 "Cisplatine (pyrimidine-antagonisten)"
* subject = Reference(Patient/org2-jaantje)
* effectiveDateTime = "2017-09-03"
* dateAsserted = "2017-09-03"
* informationSource = Reference(PractitionerRole/org2-cardiologist-carolinevandijk)
* dosage[0].text = "Take one tablet by mouth twice daily"
* dosage[0].timing.repeat.frequency = 2
* dosage[0].timing.repeat.period = 1
* dosage[0].timing.repeat.periodUnit = #d
* dosage[0].doseAndRate[0].doseQuantity.value = 250
* dosage[0].doseAndRate[0].doseQuantity.unit = "mg"

Instance: org2-report-vascular-medicine
InstanceOf: DiagnosticReport
Usage: #example
* status = #final
* basedOn = Reference(https://fhir-org1.test.dataverloskunde.nl/fhir/ServiceRequest/org1-vascular-medicine)
* code = $sct#371530004 " klinisch consultverslag"
* code.text = "Negative result, no abnormalities detected"
* subject = Reference(Patient/org2-jaantje)
* effectiveDateTime = "2025-02-19T10:00:00Z"
* issued = "2025-02-19T10:05:00Z"
* conclusionCode.coding = $sct#281900007 "geen afwijkingen gevonden"
* conclusion = "No significant findings. The test is negative."

Instance: org2-report-neurology
InstanceOf: DiagnosticReport
Usage: #example
* status = #final
* basedOn = Reference(https://fhir-org1.test.dataverloskunde.nl/fhir/ServiceRequest/org1-neurology)
* code = $sct#10241000146105 "verslag van neurologische beoordeling"
* code.text = "Negative result, no abnormalities detected"
* subject = Reference(Patient/org2-jaantje)
* effectiveDateTime = "2025-02-19T10:00:00Z"
* issued = "2025-02-19T10:05:00Z"
* conclusionCode.coding = $sct#281900007 "geen afwijkingen gevonden"
* conclusion = "No significant findings. The test is negative."


Instance: org2-report-orthopedic-specialty
InstanceOf: DiagnosticReport
Usage: #example
* status = #final
* basedOn = Reference(https://fhir-org1.test.dataverloskunde.nl/fhir/ServiceRequest/org1-orthopedic-specialty)
* code = $sct#10301000146102 "hematologieverslag"
* code.text = "Negative result, no abnormalities detected"
* subject = Reference(Patient/org2-jaantje)
* effectiveDateTime = "2025-02-19T10:00:00Z"
* issued = "2025-02-19T10:05:00Z"
* conclusionCode.coding = $sct#281900007 "geen afwijkingen gevonden"
* conclusion = "No significant findings. The test is negative."

Instance: org2-report-internal-medicine
InstanceOf: DiagnosticReport
Usage: #example
* status = #final
* basedOn = Reference(https://fhir-org1.test.dataverloskunde.nl/fhir/ServiceRequest/org1-internal-medicine)
* code = $sct#10301000146102 "hematologieverslag"
* code.text = "Negative result, no abnormalities detected"
* subject = Reference(Patient/org2-jaantje)
* effectiveDateTime = "2025-02-19T10:00:00Z"
* issued = "2025-02-19T10:05:00Z"
* conclusionCode.coding = $sct#281900007 "geen afwijkingen gevonden"
* conclusion = "No significant findings. The test is negative."


//4jr geleden: Vermindering energie en krachtsverlies in benen
Instance: org2-hypercalciemie
InstanceOf: Condition
Usage: #example
Title: "Condition hypercalciëmie"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Problem"
* onsetDateTime = "2021-09-03T12:00:00Z"
* code = $sct#66931009 "hypercalciëmie"
* subject = Reference(Patient/org2-jaantje) 

Instance: org2-thyroidectomy
InstanceOf: Procedure
Usage: #example
Title: "Procedure Thyroidectomy"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Procedure"
* status = #completed
* code = $sct#13619001 "Thyroidectomy"
* subject = Reference(Patient/org2-jaantje) 
* performedDateTime = "2022-05-15T08:00:00Z"
* performer[0].actor = Reference(PractitionerRole/org2-cardiologist-carolinevandijk)
* reasonReference = Reference(Condition/org2-hypercalciemie)

Instance: phi-organization2
InstanceOf: Bundle
Usage: #example
Title: "9.01 Bundle of services and personal health information in EHR of Organization 2"
* type = #transaction
* insert BundleEntry(org2-jaantje, #PUT, Patient/org2-jaantje)
* insert BundleEntry(org2-aortadissectie, #PUT, Condition/org2-aortadissectie)
* insert BundleEntry(org2-hypercalciemie, #PUT, Condition/org2-hypercalciemie)
* insert BundleEntry(org2-thyroidectomy, #PUT, Procedure/org2-thyroidectomy)
* insert BundleEntry(org2-methyldopa, #PUT, MedicationRequest/org2-methyldopa)
* insert BundleEntry(org2-report-vascular-medicine, #PUT, DiagnosticReport/org2-report-vascular-medicine)
* insert BundleEntry(org2-report-neurology, #PUT, DiagnosticReport/org2-report-neurology)
* insert BundleEntry(org2-report-orthopedic-specialty, #PUT, DiagnosticReport/org2-report-orthopedic-specialty)
* insert BundleEntry(org2-report-internal-medicine, #PUT, DiagnosticReport/org2-report-internal-medicine)
* insert BundleEntry(org2-ms1, #PUT, MedicationStatement/org2-ms1)