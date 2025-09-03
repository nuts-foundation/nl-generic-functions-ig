Instance: org1-organization1
InstanceOf: NlGfOrganization
Usage: #example
Title: "9.01 Organization Example GP"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthcareProvider-Organization"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[=].value = "11111111"
* name = "example General Practice"
* type[+] = $organization-type#Z3 "Huisartspraktijk (zelfstandig of groepspraktijk)"
* telecom[0].system = #phone
* telecom[=].value = "+3131599991"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "info@examplegp.nl"
* telecom[=].use = #work
* address.line = "Vogelenzangweg 31"
* address.line[+].extension[0].url = "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-streetName"
* address.line[=].extension[0].valueString = "Vogelenzangweg"
* address.line[+].extension[0].url = "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-houseNumber"
* address.line[=].extension[0].valueString = "31"
* address.city = "Ulft"
* address.postalCode = "7071 PT"
* endpoint[+] = Reference(Endpoint/org1-endpoint)

Instance: org1-endpoint
InstanceOf: NlGfEndpoint
Usage: #example
Title: "9.01 Endpoint Example GP"
* status = #active
* payloadType[+].coding = nl-gf-code-system#nl-gf-care-services "Care Services Directory"
* payloadMimeType[+] = #application/fhir+json
* connectionType.system = "http://terminology.hl7.org/CodeSystem/endpoint-connection-type"
* connectionType.code = #hl7-fhir-rest
* name = "Example GP FHIR Endpoint"
* managingOrganization.identifier.system = "http://fhir.nl/fhir/NamingSystem/kvk"
* managingOrganization.identifier.value = "51494752" //Pharmapartners B.V.
* contact[0].system = #phone
* contact[=].value = "+3131599991"
* contact[=].use = #work
* contact[+].system = #email
* contact[=].value = "info@example.com"
* contact[=].use = #work
* address = $endpoint1


Instance: org1-generalpractitioner-harryarts
InstanceOf: NlGfPractitionerRole
Usage: #example
Title: "9.01 PractitionerRole Harry Arts at Example GP"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthProfessional-PractitionerRole"
* identifier[+].system = "http://organization1.example.org/HRM/assignments"
* identifier[=].value = "654321"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/uzi"
* identifier[=].value = "UZI-2"
* practitioner = Reference(Practitioner/org1-harryarts)
* organization = Reference(Organization/org1-organization1)
* code.coding = $sct#158965000 "General Practitioner"
* specialty.coding = $sct#394814009 "General practice"
* telecom[+].system = #email
* telecom[=].value = "h.arts@organization1.nl"

Instance: org1-harryarts
InstanceOf: NlGfPractitioner
Usage: #example
Title: "9.01 Practitioner Harry Arts"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthProfessional-Practitioner"
* identifier[+].system = "http://organization1.example.org/HRM/employees"
* identifier[=].value = "5678"
* name.use = #official
* name.text = "Hary Arts"
* name.family = "Arts"
* name.given = "Harry"

Instance: services-organization1
InstanceOf: Bundle
Usage: #example
Title: "9.01 Bundle of services and personal health information in EHR of Organization 1"
* type = #transaction
* insert BundleEntry(org1-organization1, #PUT, Organization/org1-organization1)
* insert BundleEntry(org1-endpoint, #PUT, Endpoint/org1-endpoint)
* insert BundleEntry(org1-generalpractitioner-harryarts, #PUT, PractitionerRole/org1-generalpractitioner-harryarts)
* insert BundleEntry(org1-harryarts, #PUT, Practitioner/org1-harryarts)

