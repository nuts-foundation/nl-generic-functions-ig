Instance: 3f39dca9-a392-4eb3-8366-0c7ff53ab3a9
InstanceOf: NlGfOrganizationLRZA
Usage: #example
Title: "LRZa - Organization 1 - Organization"
* insert AuthorAssignedIdentifier("http://fhir.nl/fhir/NamingSystem/ura","11111111","http://fhir.nl/fhir/NamingSystem/kvk", "50000535")
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
* endpoint[+] = Reference(Endpoint/ffa3e969-3dfd-45d3-9d2c-f4e3795e1bf4)

Instance: ffa3e969-3dfd-45d3-9d2c-f4e3795e1bf4
InstanceOf: NlGfEndpoint
Usage: #example
Title: "LRZa - Organization 1 - Endpoint"
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

Instance: 4815bbe6-9fea-4875-a16c-a168d63054d4
InstanceOf: NlGfOrganizationLRZA
Usage: #example
Title: "LRZa - Organization 2 - Organization"
* insert AuthorAssignedIdentifier("http://fhir.nl/fhir/NamingSystem/ura", "22222222", "http://fhir.nl/fhir/NamingSystem/kvk", "50000535")
* name = "example Hospital"
* type[+] = $organization-type#V4 "Ziekenhuis"
* type[+] = $sct#22232009 "Hospital"
* telecom[0].system = #phone
* telecom[=].value = "+31301234567"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "info@cp2.example.org"
* telecom[=].use = #work
* address.line = "Catharinastraat 21"
* address.line.extension[0].url = "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-streetName"
* address.line.extension[=].valueString = "Catharinastraat"
* address.line.extension[+].url = "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-houseNumber"
* address.line.extension[=].valueString = "21"
* address.city = "Doetinchem"
* address.postalCode = "7001 BZ"
* endpoint[+] = Reference(Endpoint/960a4f8c-74d8-482c-97ab-e2a025869fee)


Instance: 960a4f8c-74d8-482c-97ab-e2a025869fee
InstanceOf: NlGfEndpoint
Usage: #example
Title: "LRZa - Organization 2 - Endpoint"
* status = #active
* payloadType[+].coding = nl-gf-data-exchange-capabilities#http://nuts-foundation.github.io/nl-generic-functions-ig/CapabilityStatement/nl-gf-admin-directory-update-client "Care Services Directory for Update Client"
* payloadMimeType[+] = #application/fhir+json
* connectionType = $endpoint-connection-type#hl7-fhir-rest
* name = "FHIR Endpoint 2"
* managingOrganization.identifier.system = "http://fhir.nl/fhir/NamingSystem/kvk"
* managingOrganization.identifier.value = "08013836" //Nedap N.V.
* contact[0].system = #phone
* contact[=].value = "+3131599991"
* contact[=].use = #work
* contact[+].system = #email
* contact[=].value = "info@nedap.example.org"
* contact[=].use = #work
* address = "https://cp2-test.example.org/fhirr4"

Instance: fcf55b06-f22c-4058-9051-b77368bdd26b
InstanceOf: NlGfOrganizationLRZA
Usage: #example
Title: "LRZa - Organization 3 - Organization"
* insert AuthorAssignedIdentifier("http://fhir.nl/fhir/NamingSystem/ura", "33333333", "http://fhir.nl/fhir/NamingSystem/kvk", "50000535")
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
* endpoint[+] = Reference(Endpoint/553416dd-da12-40f7-a9bd-eb3e193177bd)

Instance: 553416dd-da12-40f7-a9bd-eb3e193177bd
InstanceOf: NlGfEndpoint
Usage: #example
Title: "LRZa - Organization 3 - Endpoint"
* status = #active
* payloadType[+].coding = nl-gf-data-exchange-capabilities#http://nuts-foundation.github.io/nl-generic-functions-ig/CapabilityStatement/nl-gf-admin-directory-update-client "Care Services Directory for Update Client"
* payloadMimeType[+] = #application/fhir+json
* connectionType = $endpoint-connection-type#hl7-fhir-rest
* name = "FHIR Endpoint 3"
* managingOrganization.identifier.system = "http://fhir.nl/fhir/NamingSystem/kvk"
* managingOrganization.identifier.value = "34270859" //Gerimedica
* contact[0].system = #phone
* contact[=].value = "+3131599991"
* contact[=].use = #work
* contact[+].system = #email
* contact[=].value = "info@example.org"
* contact[=].use = #work
* address = "https://cp3-test.example.org/fhirr4"


Instance: admin-directory-lrza
InstanceOf: Bundle
Usage: #example
Title: "Bundle of care services in LRZa"
Description: "This bundle contains all care services for the LRZa Administration Directory example"
* type = #transaction
* insert BundleEntryPUT(Organization, 3f39dca9-a392-4eb3-8366-0c7ff53ab3a9)
* insert BundleEntryPUT(Endpoint, ffa3e969-3dfd-45d3-9d2c-f4e3795e1bf4)
* insert BundleEntryPUT(Organization, 4815bbe6-9fea-4875-a16c-a168d63054d4)
* insert BundleEntryPUT(Endpoint, 960a4f8c-74d8-482c-97ab-e2a025869fee)
* insert BundleEntryPUT(Organization, fcf55b06-f22c-4058-9051-b77368bdd26b)
* insert BundleEntryPUT(Endpoint, 553416dd-da12-40f7-a9bd-eb3e193177bd)
