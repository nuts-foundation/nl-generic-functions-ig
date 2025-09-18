Instance: 3e799075-63a2-4a4c-913d-a91b8198463d
InstanceOf: NlGfOrganization
Usage: #example
Title: "Organization 3- Organization"

* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[=].value = "33333333"
* name = "example Care Institution"
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
* endpoint[+] = Reference(Endpoint/8f224548-6d50-44b6-82c5-75826ee0900f)
* endpoint[+] = Reference(Endpoint/72a349cc-7336-4a91-873d-fc9349769e1a)

Instance: 631cf10e-42d6-4165-9907-11e2333d4a85
InstanceOf: NlGfOrganization
Usage: #example
Title: "Organization 3 - Organization Nursing department"
Description: "Nursing department at Organization 3"

* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[=].value = "33333333"
* name = "Nursing department at Organization 3"
* type[+] = $organization-type#X3 "Verplegings- of verzorgingsinstelling"
* partOf = Reference(Organization/3e799075-63a2-4a4c-913d-a91b8198463d)

Instance: 8f224548-6d50-44b6-82c5-75826ee0900f
InstanceOf: NlGfEndpoint
Usage: #example
Title: "Organization 3 - Endpoint FHIR R4"
* status = #active
* payloadType[+].coding = nl-gf-data-exchange-capabilities#http://nuts-foundation.github.io/nl-generic-functions-ig/CapabilityStatement/nl-gf-admin-directory-update-client "Care Services Directory for Update Client"
* payloadMimeType[+] = #application/fhir+json
* connectionType = $endpoint-connection-type#hl7-fhir-rest
* name = "FHIR R4 Endpoint"
* managingOrganization.identifier.system = "http://fhir.nl/fhir/NamingSystem/kvk"
* managingOrganization.identifier.value = "34270859" //Gerimedica
* contact[0].system = #phone
* contact[=].value = "+3131599991"
* contact[=].use = #work
* contact[+].system = #email
* contact[=].value = "info@example.org"
* contact[=].use = #work
* address = "https://cp3-test.example.org/fhirr4"

Instance: 72a349cc-7336-4a91-873d-fc9349769e1a
InstanceOf: NlGfEndpoint
Usage: #example
Title: "Organization 3 - Endpoint FHIR STU3"
* status = #active
* payloadType[+].coding = nl-gf-data-exchange-capabilities#http://nictiz.nl/fhir/CapabilityStatement/eOverdracht-servercapabilities "Transfer of Care - eOverdracht Server"
* payloadMimeType[+] = #application/fhir+json
* connectionType = $endpoint-connection-type#hl7-fhir-rest
* name = "FHIR STU3 Endpoint"
* managingOrganization.identifier.system = "http://fhir.nl/fhir/NamingSystem/kvk"
* managingOrganization.identifier.value = "34270859" //Gerimedica
* contact[0].system = #phone
* contact[=].value = "+3131599991"
* contact[=].use = #work
* contact[+].system = #email
* contact[=].value = "info@example.org"
* contact[=].use = #work
* address = "https://cp3-test.example.org/fhirstu3"


Instance: 4fcf98c7-b198-4d61-8b3e-5ea39e33c405
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 3 - HealthcareService Geriatrie"
* active = true
* providedBy = Reference(Organization/3e799075-63a2-4a4c-913d-a91b8198463d)
* active = true
* name = "Geriatrie"
* type[+] = $sct#146521000146103 "Brief comprehensive geriatric assessment"
* type[+] = $sct#107101000146106 "comprehensive geriatric assessment"
* type[+] = $sct#86944008 "Visual field study"
* specialty[+].coding = AgbSpecialismenCS#0335 "Medisch specialisten, geriatrie"


Instance: b48826dc-2d58-479a-bfd3-80b7a9d69757
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 3 - HealthcareService Verpleging"
* active = true
* providedBy = Reference(Organization/631cf10e-42d6-4165-9907-11e2333d4a85)
* name = "Verpleging"
* type[+] = $sct#23044009 "Patient transfer to skilled nursing facility for level 1 care"
* type[+] = $sct#58413007 "Patient transfer to skilled nursing facility for level 2 care"
* type[+] = $sct#43495009 "Patient transfer to skilled nursing facility for level 3 care"
* specialty[+].coding = AgbSpecialismenCS#0100 "Verpleegkundige"


Instance: 08630c28-5e2a-4b0c-b8ce-f08f533246b9
InstanceOf: NlGfPractitioner
Usage: #example
Title: "Organization 3 - Practitioner John Doe"
* active = true
* name.family = "Doe"
* name.given = "John"
* telecom[0].system = #phone
* telecom[=].value = "+31301234568"
* telecom[=].use = #work
* telecom[+].system = #email
* address.line = "Smidsstraat 11"
* address.city = "Zelhem"
* address.postalCode = "7021 AC"

Instance: d60525bd-5caf-4437-8f4b-4156300a27de
InstanceOf: NlGfPractitionerRole
Usage: #example
Title: "Organization 3 - PractitionerRole Klinisch Geriater John Doe"
* practitioner = Reference(Practitioner/08630c28-5e2a-4b0c-b8ce-f08f533246b9)
* organization = Reference(Organization/3e799075-63a2-4a4c-913d-a91b8198463d)
* active = true
* code.coding = UziRolcodesCS#01.022 "Klinisch geriater"
* specialty[+].coding = AgbSpecialismenCS#0335 "Medisch specialisten, geriatrie"
* specialty[+].coding = UziRolcodesCS#01.022 "Klinisch geriater"
* telecom[0].system = #phone
* telecom[=].value = "+31301234568"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "john.doe@cp3.example.org"
* telecom[=].use = #work
* telecom[+].system = #url
* telecom[=].value = "https://matrix.to/#doctorno:cp3.example.org"
* telecom[=].use = #work

Instance: admin-directory-org3
InstanceOf: Bundle
Usage: #example
Title: "Bundle of care services in ECD of Organization 3"
Description: "This bundle contains all care services for the Organization 3 Administration Directory example"
* type = #transaction
* insert BundleEntryPUT(Organization, 3e799075-63a2-4a4c-913d-a91b8198463d)
* insert BundleEntryPUT(Organization, 631cf10e-42d6-4165-9907-11e2333d4a85)
* insert BundleEntryPUT(Endpoint, 8f224548-6d50-44b6-82c5-75826ee0900f)
* insert BundleEntryPUT(Endpoint, 72a349cc-7336-4a91-873d-fc9349769e1a)
* insert BundleEntryPUT(HealthcareService, 4fcf98c7-b198-4d61-8b3e-5ea39e33c405)
* insert BundleEntryPUT(HealthcareService, b48826dc-2d58-479a-bfd3-80b7a9d69757)
* insert BundleEntryPUT(Practitioner, 08630c28-5e2a-4b0c-b8ce-f08f533246b9)
* insert BundleEntryPUT(PractitionerRole, d60525bd-5caf-4437-8f4b-4156300a27de)