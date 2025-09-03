Instance: org3-organization1
InstanceOf: NlGfOrganization
Usage: #example
Title: "9.02 Organization Organization 1"
Description: "Existing data in EHR of Organization 2"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthcareProvider-Organization"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[=].value = "33333333"
* name = "Organization 3"
* type[+] = $organization-type#X3 "Verplegings- of verzorgingsinstelling"
* telecom[0].system = #phone
* telecom[=].value = "+31301234567"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "info@organization3.nl"
* telecom[=].use = #work
* address.line = "Smidsstraat 10"
* address.line.extension[0].url = "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-streetName"
* address.line.extension[=].valueString = "Smidsstraat"
* address.line.extension[+].url = "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-houseNumber"
* address.line.extension[=].valueString = "10"
* address.city = "Zelhem"
* address.postalCode = "7021 AC"
* endpoint[+] = Reference(Endpoint/org3-endpoint)

Instance: org3-organization2
InstanceOf: NlGfOrganization
Usage: #example
Title: "9.03 Organization Verpleegafdeling"
Description: "Existing data in EHR of Organization 3"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthcareProvider-Organization"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[=].value = "33333333"
* name = "Organization 3, Verpleegafdeling"
* type[+] = $organization-type#X3 "Verplegings- of verzorgingsinstelling"
* partOf = Reference(Organization/org3-organization1)

Instance: org3-endpoint
InstanceOf: NlGfEndpoint
Usage: #example
Title: "9.01 Endpoint Example GP"
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
* address = $endpoint3


Instance: org3-hcs1
InstanceOf: NlGfHealthcareService
Usage: #example
* active = true
* providedBy = Reference(Organization/org3-organization1)
* active = true
* name = "Geriatrie"
* type = $sct#146521000146103 "Brief comprehensive geriatric assessment"
* type = $sct#107101000146106 "comprehensive geriatric assessment"
* type = $sct#86944008 "Visual field study"
* type = $sct#95661000146101 "Doppler ultrasonography of peripheral vascular system with pulse volume recording"
* specialty[+].coding = $agb-specialismen#0335 "Medisch specialisten, geriatrie"
* specialty[+].coding = $sct#394811001 "Geriatric medicine"

Instance: org3-hcs2
InstanceOf: NlGfHealthcareService
Usage: #example
* active = true
* providedBy = Reference(Organization/org3-organization1)
* name = "Verpleging"
* type = $sct#23044009 "Patient transfer to skilled nursing facility for level 1 care"
* type = $sct#58413007 "Patient transfer to skilled nursing facility for level 2 care"
* type = $sct#43495009 "Patient transfer to skilled nursing facility for level 3 care"
* specialty[+].coding = $agb-specialismen#0100 "Verpleegkundige"
* specialty[+].coding = $sct#223366009 "Nursing department"

Instance: org3-practitioner1
InstanceOf: NlGfPractitioner
Usage: #example
* active = true
* name.family = "Doe"
* name.given = "John"
* telecom[0].system = #phone
* telecom[=].value = "+31301234568"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "john.doe@organization3.nl"
* telecom[=].use = #work
* address.line = "Smidsstraat 11"
* address.city = "Zelhem"
* address.postalCode = "7021 AC"

Instance: org3-practitionerrole1
InstanceOf: NlGfPractitionerRole
Usage: #example
* practitioner = Reference(Practitioner/org3-practitioner1)
* organization = Reference(Organization/org3-organization1)
* active = true
* code.coding = $sct#69280009 "Specialized physician"
* specialty[+].coding = $agb-specialismen#0335 "Medisch specialisten, geriatrie"
* specialty[+].coding = $sct#394811001 "Geriatric medicine"
* telecom[0].system = #phone
* telecom[=].value = "+31301234568"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "john.doe@organization3.nl"
* telecom[=].use = #work

Instance: services-organization3
InstanceOf: Bundle
Usage: #example
Title: "9.01 Bundle of services and personal health information in EHR of Organization 2"
* type = #transaction
* insert BundleEntry(org3-organization1, #PUT, Organization/org3-organization1)
* insert BundleEntry(org3-endpoint, #PUT, Endpoint/org3-endpoint)
* insert BundleEntry(org3-hcs1, #PUT, HealthcareService/org3-hcs1)
* insert BundleEntry(org3-practitioner1, #PUT, Practitioner/org3-practitioner1)
* insert BundleEntry(org3-practitionerrole1, #PUT, PractitionerRole/org3-practitionerrole1)