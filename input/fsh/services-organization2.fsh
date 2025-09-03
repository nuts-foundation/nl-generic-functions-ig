Instance: org2-organization1
InstanceOf: NlGfOrganization
Usage: #example
Title: "9.02 Organization Organization 2"
Description: "9.01 Organization Example Hospital"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthcareProvider-Organization"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[=].value = "22222222"
* name = "example Hospital"
* type[+] = $organization-type#V4 "Ziekenhuis"
* type[+] = $sct#22232009 "Hospital"
* telecom[0].system = #phone
* telecom[=].value = "+31301234567"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "info@examplehospital.nl"
* telecom[=].use = #work
* address.line = "Catharinastraat 21"
* address.line.extension[0].url = "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-streetName"
* address.line.extension[=].valueString = "Catharinastraat"
* address.line.extension[+].url = "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-houseNumber"
* address.line.extension[=].valueString = "21"
* address.city = "Doetinchem"
* address.postalCode = "7001 BZ"
* endpoint[+] = Reference(Endpoint/org2-endpoint)

Instance: org2-endpoint
InstanceOf: NlGfEndpoint
Usage: #example
* status = #active
* payloadType[+].coding = $sct#308292007  "Transfer of care"
* payloadType[+].coding = nl-gf-code-system#nl-gf-care-services "Care Services Directory"
* payloadMimeType[+] = #application/fhir+json
* connectionType.system = "http://terminology.hl7.org/CodeSystem/endpoint-connection-type"
* connectionType.code = #hl7-fhir-rest
* name = "Example GP FHIR Endpoint"
* managingOrganization.identifier.system = "http://fhir.nl/fhir/NamingSystem/kvk"
* managingOrganization.identifier.value = "08013836" //Nedap N.V.
* contact[0].system = #phone
* contact[=].value = "+3131599991"
* contact[=].use = #work
* contact[+].system = #email
* contact[=].value = "info@example.com"
* contact[=].use = #work
* address = $endpoint2


Instance: org2-hcs1
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "9.02 HealthcareService Telemonitoring at Organization 2"
Description: "Existing data in EHR of Organization 2"
* active = true
* providedBy = Reference(Organization/org2-organization1)
* active = true
* name = "Polikliniek 't Vaatje"
* type = $sct#105251000146109 "First consultation with outpatient"
* specialty[+].coding = $agb-specialismen#0303 "Chirurgie (Heelkunde)"
* specialty[+].coding = $sct#408463005 "Vascular surgery"
* specialty[+].coding = $sct#722414000 "Vascular medicine"

Instance: org2-hcs2
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "9.02 HealthcareService Telemonitoring at Organization 2"
Description: "Existing data in EHR of Organization 2"
* active = true
* providedBy = Reference(Organization/org2-organization1)
* active = true
* name = "Neurochirurgie"
* type = $sct#105251000146109 "First consultation with outpatient"
* specialty[+].coding = $agb-specialismen#0308 "Medisch specialisten, neurochirurgie"
* specialty[+].coding = $sct#394591006 "Neurology"

Instance: org2-hcs3
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "9.02 HealthcareService Telemonitoring at Organization 2"
Description: "Existing data in EHR of Organization 2"
* active = true
* providedBy = Reference(Organization/org2-organization1)
* active = true
* name = "Orthopedie"
* type = $sct#105251000146109 "First consultation with outpatient"
* specialty[+].coding = $agb-specialismen#0305 "Medisch specialisten, orthopedie"
* specialty[+].coding = $sct#1345026002 "Orthopedic specialty"

Instance: org2-hcs4
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "9.02 HealthcareService Telemonitoring at Organization 2"
Description: "Existing data in EHR of Organization 2"
* active = true
* providedBy = Reference(Organization/org2-organization1)
* active = true
* name = "Interne Geneeskunde"
* type = $sct#105251000146109 "First consultation with outpatient"
* specialty[+].coding = $agb-specialismen#0313 "Interne geneeskunde"
* specialty[+].coding = $sct#419192003 "Internal medicine"


Instance: org2-hcs5
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "9.02 HealthcareService Telemonitoring at Organization 2"
Description: "Existing data in EHR of Organization 2"
* active = true
* providedBy = Reference(Organization/org2-organization1)
* active = true
* name = "Geriatrie"
* type = $sct#105251000146109 "First consultation with outpatient"
* specialty[+].coding = $agb-specialismen#0335 "Medisch specialisten, geriatrie"
* specialty[+].coding = $sct#394811001 "Geriatric medicine"

Instance: org2-hcs6
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "9.02 HealthcareService Telemonitoring at Organization 2"
Description: "Existing data in EHR of Organization 2"
* active = true
* providedBy = Reference(Organization/org2-organization1)
* active = true
* name = "Urologie"
* type = $sct#105251000146109 "First consultation with outpatient"
* specialty[+].coding = $agb-specialismen#0306 "Medisch specialisten, urologie"
* specialty[+].coding = $sct#394612005 "Urology"
* specialty[+].coding = $sct#419043006 "Urological oncology"


Instance: org2-cardiologist-carolinevandijk
InstanceOf: NlGfPractitionerRole
Usage: #example
Title: "9.01 PractitionerRole Caroline van Dijk at Organization 1"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthProfessional-PractitionerRole"
* identifier[+].system = "http://organization1.example.org/HRM/assignments"
* identifier[=].value = "123456"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/uzi"
* identifier[=].value = "UZI-1"
* practitioner = Reference(Practitioner/org2-carolinevandijk)
* organization = Reference(Organization/org2-organization1)
* code.coding = $sct#17561000 "Cardiologist"
* specialty.coding = $sct#394579002 "Cardiology"
* telecom[+].system = #email
* telecom[=].value = "c.vandijk@organization1.nl"


Instance: org2-carolinevandijk
InstanceOf: NlGfPractitioner
Usage: #example
Title: "9.01 Practitioner Caroline van Dijk"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthProfessional-Practitioner"
* identifier[+].system = "http://organization1.example.org/HRM/employees"
* identifier[=].value = "1234"
* name.use = #official
* name.text = "Caroline van Dijk"
* name.family = "van Dijk"
* name.given = "Caroline"
* telecom[+].system = #phone
* telecom[=].value = "+31688888888"
* telecom[+].system = #email
* telecom[=].value = "caroline@vandijk.nl"



Instance: services-organization2
InstanceOf: Bundle
Usage: #example
Title: "9.01 Bundle of services and personal health information in EHR of Organization 2"
* type = #transaction
* insert BundleEntry(org2-organization1, #PUT, Organization/org2-organization1)
* insert BundleEntry(org2-endpoint, #PUT, Endpoint/org2-endpoint)
* insert BundleEntry(org2-hcs1, #PUT, HealthcareService/org2-hcs1)
* insert BundleEntry(org2-hcs2, #PUT, HealthcareService/org2-hcs2)
* insert BundleEntry(org2-hcs3, #PUT, HealthcareService/org2-hcs3)
* insert BundleEntry(org2-hcs4, #PUT, HealthcareService/org2-hcs4)
* insert BundleEntry(org2-hcs5, #PUT, HealthcareService/org2-hcs5)
* insert BundleEntry(org2-hcs6, #PUT, HealthcareService/org2-hcs6)
* insert BundleEntry(org2-cardiologist-carolinevandijk, #PUT, PractitionerRole/org2-cardiologist-carolinevandijk)
* insert BundleEntry(org2-carolinevandijk, #PUT, Practitioner/org2-carolinevandijk)

