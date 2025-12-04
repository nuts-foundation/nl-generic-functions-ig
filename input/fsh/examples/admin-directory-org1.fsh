Instance: 4cb35b96-f021-4e15-bf71-d67a6d4bebec
InstanceOf: NlGfOrganization
Usage: #example
Title: "Organization 1 - Organization"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[=].value = "11111111"
* insert AuthorAssignedIdentifier("https://cp1-test.example.org/departments","4cb35b96-f021-4e15-bf71-d67a6d4bebec","http://fhir.nl/fhir/NamingSystem/ura", "11111111")
* name = "example General Practice"
* type[+] = $organization-type#Z3 "Huisartspraktijk (zelfstandig of groepspraktijk)"
* telecom[0].system = #phone
* telecom[=].value = "+3131599991"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "info@cp1.example.org"
* telecom[=].use = #work
* address.line = "Vogelenzangweg 31"
* address.line[+].extension[0].url = "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-streetName"
* address.line[=].extension[0].valueString = "Vogelenzangweg"
* address.line[+].extension[0].url = "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-houseNumber"
* address.line[=].extension[0].valueString = "31"
* address.city = "Ulft"
* address.postalCode = "7071 PT"
* endpoint[+] = Reference(Endpoint/59654248-477c-4694-b156-e0042f0765a6)

Instance: 59654248-477c-4694-b156-e0042f0765a6
InstanceOf: NlGfEndpoint
Usage: #example
Title: "Organization 1 - Endpoint"
* insert AuthorAssignedIdentifier("https://cp1-test.example.org/api","59654248-477c-4694-b156-e0042f0765a6","http://fhir.nl/fhir/NamingSystem/ura", "11111111")
* status = #active
* payloadType[+].coding = nl-gf-data-exchange-capabilities#http://nuts-foundation.github.io/nl-generic-functions-ig/CapabilityStatement/nl-gf-admin-directory-update-client "Care Services Directory for Update Client"
* payloadMimeType[+] = #application/fhir+json
* connectionType = $endpoint-connection-type#hl7-fhir-rest
* name = "FHIR Endpoint 1"
* managingOrganization.identifier.system = "http://fhir.nl/fhir/NamingSystem/kvk"
* managingOrganization.identifier.value = "51494752" //Pharmapartners B.V.
* contact[0].system = #phone
* contact[=].value = "+3131599991"
* contact[=].use = #work
* contact[+].system = #email
* contact[=].value = "info@cp1.example.org"
* contact[=].use = #work
* address = "https://cp1-test.example.org/fhirr4"


Instance: 5fa4c91a-a12f-48ae-a4c7-92971dc7ab53
InstanceOf: NlGfPractitionerRole
Usage: #example
Title: "Organization 1 - PractitionerRole Harry Arts"
* insert AuthorAssignedIdentifier("https://cp1-test.example.org/employees","5fa4c91a-a12f-48ae-a4c7-92971dc7ab53","http://fhir.nl/fhir/NamingSystem/ura", "11111111")
* practitioner = Reference(Practitioner/9a63e407-34af-4ae4-ad3c-f7107fbbc0cd)
* organization = Reference(Organization/4cb35b96-f021-4e15-bf71-d67a6d4bebec)
* code.coding = $uzi-rolcode#01.015 "Huisarts"
* telecom[+].system = #email
* telecom[=].value = "h.arts@cp1.example.org"

Instance: 9a63e407-34af-4ae4-ad3c-f7107fbbc0cd
InstanceOf: NlGfPractitioner
Usage: #example
Title: "Organization 1 - Practitioner Harry Arts"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/uzi"
* identifier[=].value = "UZI-2"
* insert AuthorAssignedIdentifier("https://cp1-test.example.org/employees","5678","http://fhir.nl/fhir/NamingSystem/ura", "11111111")
* name.use = #official
* name.text = "Hary Arts"
* name.family = "Arts"
* name.given = "Harry"

Instance: admin-directory-org1
InstanceOf: Bundle
Usage: #example
Title: "Bundle of care services in HIS of Organization 1"
Description: "This bundle contains all care services for the Organization 1 Administration Directory example"
* type = #transaction
* insert BundleEntryPUT(Organization, 4cb35b96-f021-4e15-bf71-d67a6d4bebec)
* insert BundleEntryPUT(Endpoint, 59654248-477c-4694-b156-e0042f0765a6)
* insert BundleEntryPUT(PractitionerRole, 5fa4c91a-a12f-48ae-a4c7-92971dc7ab53)
* insert BundleEntryPUT(Practitioner, 9a63e407-34af-4ae4-ad3c-f7107fbbc0cd)

