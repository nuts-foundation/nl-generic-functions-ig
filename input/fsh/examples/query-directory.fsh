// // ----------------------------------------------------------------
// // Resource of LRZa Admin Directory

Instance: lrza-o1
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
* endpoint[+] = Reference(Endpoint/lrza-e1)

Instance: lrza-e1
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

Instance: lrza-o2
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
* endpoint[+] = Reference(Endpoint/lrza-e2)


Instance: lrza-e2
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

Instance: lrza-o3
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
* endpoint[+] = Reference(Endpoint/lrza-e3)

Instance: lrza-e3
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

// // ----------------------------------------------------------------
// // Resource from Admin Directory Organization 1

Instance: ad1-o1
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
* endpoint[+] = Reference(Endpoint/ad1-e1)

Instance: ad1-e1
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


Instance: ad1-pr1
InstanceOf: NlGfPractitionerRole
Usage: #example
Title: "Organization 1 - PractitionerRole Harry Arts"
* insert AuthorAssignedIdentifier("https://cp1-test.example.org/employees","5fa4c91a-a12f-48ae-a4c7-92971dc7ab53","http://fhir.nl/fhir/NamingSystem/ura", "11111111")
* practitioner = Reference(Practitioner/ad1-p1)
* organization = Reference(Organization/ad1-o1)
* code.coding = $uzi-rolcode#01.015 "Huisarts"
* telecom[+].system = #email
* telecom[=].value = "h.arts@cp1.example.org"

Instance: ad1-p1
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

// // ----------------------------------------------------------------
// // Resource from Admin Directory Organization 2

Instance: ad2-o1
InstanceOf: NlGfOrganization
Usage: #example
Title: "Organization 2 - Organization"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[=].value = "22222222"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/departments","cff921f3-c1c1-4a4c-8f0f-cafd0aa25067","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
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
* endpoint[+] = Reference(Endpoint/ad2-e1)
* endpoint[+] = Reference(Endpoint/ad2-e2)
* endpoint[+] = Reference(Endpoint/ad2-e3)

Instance: ad2-e1
InstanceOf: NlGfEndpoint
Usage: #example
Title: "Organization 2 - Endpoint FHIR R4"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/api","430f7379-8ec2-4e55-b096-919995da61e2","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
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

Instance: ad2-e2
InstanceOf: NlGfEndpoint
Usage: #example
Title: "Organization 2 - Endpoint DICOM-WADO-RS"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/api","d4c1d657-67a9-471c-9732-9c042e9a6d43","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* status = #active
* payloadType[+].coding = $endpoint-payload-type#any "Any"
* connectionType = $endpoint-connection-type#dicom-wado-rs
* name = "DICOM-WADO-RS Endpoint"
* managingOrganization.identifier.system = "http://fhir.nl/fhir/NamingSystem/kvk"
* managingOrganization.identifier.value = "08013836"
* contact[0].system = #phone
* contact[=].value = "+3131599991"
* contact[=].use = #work
* contact[+].system = #email
* contact[=].value = "info@nedap.example.org"
* contact[=].use = #work
* address = "https://cp2-test.example.org/dicom-wado-rs"

Instance: ad2-e3
InstanceOf: NlGfEndpoint
Usage: #example
Title: "Organization 2 - Endpoint FHIR STU3"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/api","2427ca0c-8a29-4a6a-aabd-50cf02f587a7","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* status = #active
* payloadType[+].coding = nl-gf-data-exchange-capabilities#http://nictiz.nl/fhir/CapabilityStatement/eOverdracht-servercapabilities "Transfer of Care - eOverdracht Server"
* payloadMimeType[+] = #application/fhir+json
* connectionType = $endpoint-connection-type#hl7-fhir-rest
* name = "FHIR STU3 Endpoint"
* managingOrganization.identifier.system = "http://fhir.nl/fhir/NamingSystem/kvk"
* managingOrganization.identifier.value = "08013836" //Nedap N.V.
* contact[0].system = #phone
* contact[=].value = "+3131599991"
* contact[=].use = #work
* contact[+].system = #email
* contact[=].value = "info@nedap.example.org"
* contact[=].use = #work
* address = "https://cp2-test.example.org/fhirstu3"

Instance: ad2-hs1
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 2 - HealthcareService Cardiology"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/services","5cb05355-474b-4d30-8b0e-a9ca574b8274","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* active = true
* providedBy = Reference(Organization/ad2-o1)
* active = true
* name = "Polikliniek 't Vaatje"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = urn:oid:2.16.840.1.113883.2.4.6.7#0303 "Chirurgie (Heelkunde)"
* specialty[+].coding = $uzi-rolcode#01.014 "Chirurg"

Instance: ad2-hs2
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 2 - HealthcareService Neurochirurgie"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/services","c79125e5-739f-4238-959c-cd5872518c1f","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* active = true
* providedBy = Reference(Organization/ad2-o1)
* active = true
* name = "Neurochirurgie"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = urn:oid:2.16.840.1.113883.2.4.6.7#0308 "Medisch specialisten, neurochirurgie"
* specialty[+].coding = $uzi-rolcode#01.025 "Neurochirurg"

Instance: ad2-hs3
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 2 - HealthcareService Orthopedie"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/services","9d47ca45-4166-4531-a23d-ef5fa613ece4","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* active = true
* providedBy = Reference(Organization/ad2-o1)
* active = true
* name = "Orthopedie"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = urn:oid:2.16.840.1.113883.2.4.6.7#0305 "Medisch specialisten, orthopedie"
* specialty[+].coding = $uzi-rolcode#01.032 "Orthopedisch chirurg"

Instance: ad2-hs4
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 2 - HealthcareService Interne Geneeskunde"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/services","f6a508bd-9455-4afa-aad0-baec0833602d","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* active = true
* providedBy = Reference(Organization/ad2-o1)
* active = true
* name = "Interne Geneeskunde"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = urn:oid:2.16.840.1.113883.2.4.6.7#0313 "Interne geneeskunde"
* specialty[+].coding = $uzi-rolcode#01.016 "Internist"


Instance: ad2-hs5
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 2 - HealthcareService Geriatrie"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/services","120325af-083c-40ee-b16e-01230fe65655","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* active = true
* providedBy = Reference(Organization/ad2-o1)
* active = true
* name = "Geriatrie"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = urn:oid:2.16.840.1.113883.2.4.6.7#0335 "Medisch specialisten, geriatrie"
* specialty[+].coding = $uzi-rolcode#01.022 "Klinisch geriater"

Instance: ad2-hs6
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 2 - HealthcareService Urologie"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/services","08013141-16b2-42a0-8c9a-af57cee5511b","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* active = true
* providedBy = Reference(Organization/ad2-o1)
* active = true
* name = "Urologie"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = urn:oid:2.16.840.1.113883.2.4.6.7#0306 "Medisch specialisten, urologie"
* specialty[+].coding = $uzi-rolcode#01.045 "Uroloog"



Instance: ad2-pr1
InstanceOf: NlGfPractitionerRole
Usage: #example
Title: "Organization 2 - PractitionerRole Cardioloog Caroline van Dijk at Organization 2"
* identifier[+].system = "http://cp2.example.org/HRM/assignments"
* identifier[=].value = "123456"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/employees","f051d3bd-26ff-4030-a5b6-fc4ef2be83ba","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* practitioner = Reference(Practitioner/ad2-p1)
* organization = Reference(Organization/ad2-o1)
* code.coding = $uzi-rolcode#01.010 "Cardioloog"
* specialty.coding = $uzi-rolcode#01.010 "Cardioloog"
* telecom[+].system = #email
* telecom[=].value = "c.vandijk@cp2.example.org"


Instance: ad2-p1
InstanceOf: NlGfPractitioner
Usage: #example
Title: "Organization 2 - Practitioner Cardioloog Caroline van Dijk"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthProfessional-Practitioner"
* identifier[+].system = "http://cp2.example.org/HRM/employees"
* identifier[=].value = "1234"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/uzi"
* identifier[=].value = "UZI-1"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/physicians","040b160a-6072-4244-adc0-2b786c4ef052","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* name.use = #official
* name.text = "Caroline van Dijk"
* name.family = "van Dijk"
* name.given = "Caroline"




// // ----------------------------------------------------------------
// // Resource from Admin Directory Organization 3

Instance: ad3-o1
InstanceOf: NlGfOrganization
Usage: #example
Title: "Organization 3- Organization"

* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[=].value = "33333333"
* insert AuthorAssignedIdentifier("https://cp3-test.example.org/departments","3e799075-63a2-4a4c-913d-a91b8198463d","http://fhir.nl/fhir/NamingSystem/ura", "33333333")
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
* endpoint[+] = Reference(Endpoint/ad3-e1)
* endpoint[+] = Reference(Endpoint/ad3-e2)

Instance: ad3-o2
InstanceOf: NlGfOrganization
Usage: #example
Title: "Organization 3 - Organization Nursing department"
Description: "Nursing department at Organization 3"
* insert AuthorAssignedIdentifier("https://cp3-test.example.org/departments","631cf10e-42d6-4165-9907-11e2333d4a85","http://fhir.nl/fhir/NamingSystem/ura", "33333333")
* name = "Nursing department at Organization 3"
* type[+] = $organization-type#X3 "Verplegings- of verzorgingsinstelling"
* partOf = Reference(Organization/ad3-o1)

Instance: ad3-l1
InstanceOf: NlGfLocation
Usage: #example
Title: "Organization 3 - Location Main Building"
* insert AuthorAssignedIdentifier("https://cp3-test.example.org/locations","7c5e3d2a-1f9e-4b8c-9d6a-8e2f5c3b1a4d","http://fhir.nl/fhir/NamingSystem/ura", "33333333")
* status = #active
* name = "Main Building"
* type = $v3-RoleCode#SNF "Skilled nursing facility"
* managingOrganization = Reference(Organization/3e799075-63a2-4a4c-913d-a91b8198463d)
* address.line = "Smidsstraat 10"
* address.city = "Zelhem"
* address.postalCode = "7021 AC"
* address.country = "NL"

Instance: ad3-l2
InstanceOf: NlGfLocation
Usage: #example
Title: "Organization 3 - Location Nursing Department"
* insert AuthorAssignedIdentifier("https://cp3-test.example.org/locations","9a2b8f1c-4e7d-42a1-b3c9-2d5e8f7a6c1b","http://fhir.nl/fhir/NamingSystem/ura", "33333333")
* status = #active
* name = "Verpleeghuis Weltevree"
* type = $v3-RoleCode#SNF "Skilled nursing facility"
* managingOrganization = Reference(Organization/631cf10e-42d6-4165-9907-11e2333d4a85)
* address.city = "Doetinchem"
* address.country = "NL"

Instance: ad3-e1
InstanceOf: NlGfEndpoint
Usage: #example
Title: "Organization 3 - Endpoint FHIR R4"
* insert AuthorAssignedIdentifier("https://cp3-test.example.org/api","8f224548-6d50-44b6-82c5-75826ee0900f","http://fhir.nl/fhir/NamingSystem/ura", "33333333")
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

Instance: ad3-e2
InstanceOf: NlGfEndpoint
Usage: #example
Title: "Organization 3 - Endpoint FHIR STU3"
* insert AuthorAssignedIdentifier("https://cp3-test.example.org/api","72a349cc-7336-4a91-873d-fc9349769e1a","http://fhir.nl/fhir/NamingSystem/ura", "33333333")
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


Instance: ad3-hs1
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 3 - HealthcareService Geriatrie"
* insert AuthorAssignedIdentifier("https://cp3-test.example.org/services","4fcf98c7-b198-4d61-8b3e-5ea39e33c405","http://fhir.nl/fhir/NamingSystem/ura", "33333333")
* active = true
* providedBy = Reference(Organization/ad3-o1)
* active = true
* name = "Geriatrie"
* type[+] = $sct#146521000146103 "Brief comprehensive geriatric assessment"
* type[+] = $sct#107101000146106 "comprehensive geriatric assessment"
* type[+] = $sct#86944008 "Visual field study"
* specialty[+].coding = urn:oid:2.16.840.1.113883.2.4.6.7#0335 "Medisch specialisten, geriatrie"


Instance: ad3-hs2
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 3 - HealthcareService Verpleging"
* insert AuthorAssignedIdentifier("https://cp3-test.example.org/services","b48826dc-2d58-479a-bfd3-80b7a9d69757","http://fhir.nl/fhir/NamingSystem/ura", "33333333")
* active = true
* providedBy = Reference(Organization/631cf10e-42d6-4165-9907-11e2333d4a85)
* name = "Verpleging"
* location[+] = Reference(Location/9a2b8f1c-4e7d-42a1-b3c9-2d5e8f7a6c1b)
* location[+] = Reference(Location/7c5e3d2a-1f9e-4b8c-9d6a-8e2f5c3b1a4d)
* type[+] = NlGfWlzZorgprofielenCS#5VV "VV Beschermd wonen met intensieve dementiezorg"
* type[+] = NlGfWlzZorgprofielenCS#6VV "VV Beschermd wonen met intensieve verzorging en verpleging"
* type[+] = NlGfWlzZorgprofielenCS#7VV "VV Beschermd wonen met zeer intensieve zorg, vanwege specifieke aandoeningen, met de nadruk op begeleiding"
* type[+] = NlGfWlzZorgprofielenCS#8VV "VV Beschermd wonen met zeer intensieve zorg, vanwege specifieke aandoeningen, met de nadruk op verzorging/verpleging"
* specialty[+].coding = urn:oid:2.16.840.1.113883.2.4.6.7#0100 "Verpleegkundige"


Instance: ad3-p1
InstanceOf: NlGfPractitioner
Usage: #example
Title: "Organization 3 - Practitioner John Doe"
* insert AuthorAssignedIdentifier("https://cp3-test.example.org/physicians","08630c28-5e2a-4b0c-b8ce-f08f533246b9","http://fhir.nl/fhir/NamingSystem/ura", "33333333")
* active = true
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/uzi"
* identifier[=].value = "UZI-3"
* name.family = "Doe"
* name.given = "John"
* telecom[0].system = #phone
* telecom[=].value = "+31301234568"
* telecom[=].use = #work
* telecom[+].system = #email
* address.line = "Smidsstraat 11"
* address.city = "Zelhem"
* address.postalCode = "7021 AC"

Instance: ad3-pr1
InstanceOf: NlGfPractitionerRole
Usage: #example
Title: "Organization 3 - PractitionerRole Klinisch Geriater John Doe"
* insert AuthorAssignedIdentifier("https://cp3-test.example.org/employees","d60525bd-5caf-4437-8f4b-4156300a27de","http://fhir.nl/fhir/NamingSystem/ura", "33333333")
* practitioner = Reference(Practitioner/ad3-p1)
* organization = Reference(Organization/ad3-o1)
* active = true
* code.coding = $uzi-rolcode#01.022 "Klinisch geriater"
* specialty[+].coding = urn:oid:2.16.840.1.113883.2.4.6.7#0335 "Medisch specialisten, geriatrie"
* specialty[+].coding = $uzi-rolcode#01.022 "Klinisch geriater"
* telecom[0].system = #phone
* telecom[=].value = "+31301234568"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "john.doe@cp3.example.org"
* telecom[=].use = #work
* telecom[+].system = #url
* telecom[=].value = "https://matrix.to/#doctorno:cp3.example.org"
* telecom[=].use = #work


// // ----------------------------------------------------------------
// // Resulting Bundle for Query Directory

Instance: query-directory
InstanceOf: Bundle
Usage: #example
Title: "Bundle of care services in Query Directory"
Description: "This bundle contains all care services from each Administration Directory for the Query Directory example"
* type = #transaction
* insert BundleEntryPUT(Organization, lrza-o1)
* insert BundleEntryPUT(Endpoint, lrza-e1)
* insert BundleEntryPUT(Organization, lrza-o2)
* insert BundleEntryPUT(Endpoint, lrza-e2)
* insert BundleEntryPUT(Organization, lrza-o3)
* insert BundleEntryPUT(Endpoint, lrza-e3)

* insert BundleEntryPUT(Organization, ad1-o1)
* insert BundleEntryPUT(Endpoint, ad1-e1)
* insert BundleEntryPUT(PractitionerRole, ad1-pr1)
* insert BundleEntryPUT(Practitioner, ad1-p1)

* insert BundleEntryPUT(Organization, ad2-o1)
* insert BundleEntryPUT(Endpoint, ad2-e1)
* insert BundleEntryPUT(Endpoint, ad2-e2)
* insert BundleEntryPUT(Endpoint, ad2-e3)
* insert BundleEntryPUT(HealthcareService, ad2-hs1)
* insert BundleEntryPUT(HealthcareService, ad2-hs2)
* insert BundleEntryPUT(HealthcareService, ad2-hs3)
* insert BundleEntryPUT(HealthcareService, ad2-hs4)
* insert BundleEntryPUT(HealthcareService, ad2-hs5)
* insert BundleEntryPUT(HealthcareService, ad2-hs6)
* insert BundleEntryPUT(PractitionerRole, ad2-pr1)
* insert BundleEntryPUT(Practitioner, ad2-p1)

* insert BundleEntryPUT(Organization, ad3-o1)
* insert BundleEntryPUT(Organization, ad3-o2)
* insert BundleEntryPUT(Organization, ad3-l1)
* insert BundleEntryPUT(Organization, ad3-l2)
* insert BundleEntryPUT(Endpoint, ad3-e1)
* insert BundleEntryPUT(Endpoint, ad3-e2)
* insert BundleEntryPUT(HealthcareService, ad3-hs1)
* insert BundleEntryPUT(HealthcareService, ad3-hs2)
* insert BundleEntryPUT(Practitioner, ad3-p1)
* insert BundleEntryPUT(PractitionerRole, ad3-pr1)
