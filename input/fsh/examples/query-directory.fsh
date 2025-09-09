// ----------------------------------------------------------------
// Resource of LRZa Admin Directory

Instance: lrza-o1
InstanceOf: NlGfOrganization
Usage: #inline
* meta.source = "https://www.cibg.nl/lrza/fhirr4/3f39dca9-a392-4eb3-8366-0c7ff53ab3a9"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthcareProvider-Organization"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[=].value = "11111111"
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
Usage: #inline
* meta.source = "https://www.cibg.nl/lrza/fhirr4/ffa3e969-3dfd-45d3-9d2c-f4e3795e1bf4"
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
InstanceOf: NlGfOrganization
Usage: #inline
* meta.source = "https://www.cibg.nl/lrza/fhirr4/4815bbe6-9fea-4875-a16c-a168d63054d4"
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
Usage: #inline
* meta.source = "https://www.cibg.nl/lrza/fhirr4/960a4f8c-74d8-482c-97ab-e2a025869fee"
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
InstanceOf: NlGfOrganization
Usage: #inline
* meta.source = "https://www.cibg.nl/lrza/fhirr4/fcf55b06-f22c-4058-9051-b77368bdd26b"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthcareProvider-Organization"
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
* endpoint[+] = Reference(Endpoint/lrza-e3)

Instance: lrza-e3
InstanceOf: NlGfEndpoint
Usage: #inline
* meta.source = "https://www.cibg.nl/lrza/fhirr4/553416dd-da12-40f7-a9bd-eb3e193177bd"
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

// ----------------------------------------------------------------
// Resource from Admin Directory Organization 1

Instance: ad1-o1
InstanceOf: NlGfOrganization
Usage: #inline
* meta.source = "https://cp1-test.example.org/fhirr4/4cb35b96-f021-4e15-bf71-d67a6d4bebec"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthcareProvider-Organization"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[=].value = "11111111"
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
Usage: #inline
* meta.source = "https://cp1-test.example.org/fhirr4/59654248-477c-4694-b156-e0042f0765a6"
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
Usage: #inline
* meta.source = "https://cp1-test.example.org/fhirr4/5fa4c91a-a12f-48ae-a4c7-92971dc7ab53"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthProfessional-PractitionerRole"
* identifier[+].system = "http://cp1.example.org/HRM/assignments"
* identifier[=].value = "654321"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/uzi"
* identifier[=].value = "UZI-2"
* practitioner = Reference(Practitioner/ad1-p1)
* organization = Reference(Organization/ad1-o1)
* code.coding = UziRolcodesCS#01.015 "Huisarts"
* telecom[+].system = #email
* telecom[=].value = "h.arts@cp1.example.org"

Instance: ad1-p1
InstanceOf: NlGfPractitioner
Usage: #inline
* meta.source = "https://cp1-test.example.org/fhirr4/9a63e407-34af-4ae4-ad3c-f7107fbbc0cd"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthProfessional-Practitioner"
* identifier[+].system = "http://cp1.example.org/HRM/employees"
* identifier[=].value = "5678"
* name.use = #official
* name.text = "Hary Arts"
* name.family = "Arts"
* name.given = "Harry"

// ----------------------------------------------------------------
// Resource from Admin Directory Organization 2

Instance: ad2-o1
InstanceOf: NlGfOrganization
Usage: #inline
* meta.source = "https://cp2-test.example.org/fhirr4/cff921f3-c1c1-4a4c-8f0f-cafd0aa25067"
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

Instance: ad2-e1
InstanceOf: NlGfEndpoint
Usage: #inline
* meta.source = "https://cp2-test.example.org/fhirr4/430f7379-8ec2-4e55-b096-919995da61e2"
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
Usage: #inline
* meta.source = "https://cp2-test.example.org/fhirr4/d4c1d657-67a9-471c-9732-9c042e9a6d43"
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
Usage: #inline
* meta.source = "https://cp2-test.example.org/fhirr4/2427ca0c-8a29-4a6a-aabd-50cf02f587a7"
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
Usage: #inline
* meta.source = "https://cp2-test.example.org/fhirr4/5cb05355-474b-4d30-8b0e-a9ca574b8274"
* active = true
* providedBy = Reference(Organization/ad2-o1)
* active = true
* name = "Polikliniek 't Vaatje"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = AgbSpecialismenCS#0303 "Chirurgie (Heelkunde)"
* specialty[+].coding = UziRolcodesCS#01.014 "Chirurg"

Instance: ad2-hs2
InstanceOf: NlGfHealthcareService
Usage: #inline
* meta.source = "https://cp2-test.example.org/fhirr4/c79125e5-739f-4238-959c-cd5872518c1f"
* active = true
* providedBy = Reference(Organization/ad2-o1)
* active = true
* name = "Neurochirurgie"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = AgbSpecialismenCS#0308 "Medisch specialisten, neurochirurgie"
* specialty[+].coding = UziRolcodesCS#01.025 "Neurochirurg"

Instance: ad2-hs3
InstanceOf: NlGfHealthcareService
Usage: #inline
* meta.source = "https://cp2-test.example.org/fhirr4/9d47ca45-4166-4531-a23d-ef5fa613ece4"
* active = true
* providedBy = Reference(Organization/ad2-o1)
* active = true
* name = "Orthopedie"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = AgbSpecialismenCS#0305 "Medisch specialisten, orthopedie"
* specialty[+].coding = UziRolcodesCS#01.032 "Orthopedisch chirurg"

Instance: ad2-hs4
InstanceOf: NlGfHealthcareService
Usage: #inline
* meta.source = "https://cp2-test.example.org/fhirr4/f6a508bd-9455-4afa-aad0-baec0833602d"
* active = true
* providedBy = Reference(Organization/ad2-o1)
* active = true
* name = "Interne Geneeskunde"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = AgbSpecialismenCS#0313 "Interne geneeskunde"
* specialty[+].coding = UziRolcodesCS#01.016 "Internist"


Instance: ad2-hs5
InstanceOf: NlGfHealthcareService
Usage: #inline
* meta.source = "https://cp2-test.example.org/fhirr4/120325af-083c-40ee-b16e-01230fe65655"
* active = true
* providedBy = Reference(Organization/ad2-o1)
* active = true
* name = "Geriatrie"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = AgbSpecialismenCS#0335 "Medisch specialisten, geriatrie"
* specialty[+].coding = UziRolcodesCS#01.022 "Klinisch geriater"

Instance: ad2-hs6
InstanceOf: NlGfHealthcareService
Usage: #inline
* meta.source = "https://cp2-test.example.org/fhirr4/08013141-16b2-42a0-8c9a-af57cee5511b"
* active = true
* providedBy = Reference(Organization/ad2-o1)
* active = true
* name = "Urologie"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = AgbSpecialismenCS#0306 "Medisch specialisten, urologie"
* specialty[+].coding = UziRolcodesCS#01.045 "Uroloog"



Instance: ad2-pr1
InstanceOf: NlGfPractitionerRole
Usage: #inline
* meta.source = "https://cp2-test.example.org/fhirr4/f051d3bd-26ff-4030-a5b6-fc4ef2be83ba"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthProfessional-PractitionerRole"
* identifier[+].system = "http://cp2.example.org/HRM/assignments"
* identifier[=].value = "123456"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/uzi"
* identifier[=].value = "UZI-1"
* practitioner = Reference(Practitioner/ad2-p1)
* organization = Reference(Organization/ad2-o1)
* code.coding = UziRolcodesCS#01.010 "Cardioloog"
* specialty.coding = UziRolcodesCS#01.010 "Cardioloog"
* telecom[+].system = #email
* telecom[=].value = "c.vandijk@cp2.example.org"


Instance: ad2-p1
InstanceOf: NlGfPractitioner
Usage: #inline
* meta.source = "https://cp2-test.example.org/fhirr4/040b160a-6072-4244-adc0-2b786c4ef052"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthProfessional-Practitioner"
* identifier[+].system = "http://cp2.example.org/HRM/employees"
* identifier[=].value = "1234"
* name.use = #official
* name.text = "Caroline van Dijk"
* name.family = "van Dijk"
* name.given = "Caroline"




// ----------------------------------------------------------------
// Resource from Admin Directory Organization 3

Instance: ad3-o1
InstanceOf: NlGfOrganization
Usage: #inline
* meta.source = "https://cp3-test.example.org/fhirr4/3e799075-63a2-4a4c-913d-a91b8198463d"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthcareProvider-Organization"
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
* endpoint[+] = Reference(Endpoint/ad3-e1)

Instance: ad3-o2
InstanceOf: NlGfOrganization
Usage: #inline
* meta.source = "https://cp3-test.example.org/fhirr4/631cf10e-42d6-4165-9907-11e2333d4a85"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthcareProvider-Organization"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[=].value = "33333333"
* name = "Nursing department at Organization 3"
* type[+] = $organization-type#X3 "Verplegings- of verzorgingsinstelling"
* partOf = Reference(Organization/ad3-o1)

Instance: ad3-e1
InstanceOf: NlGfEndpoint
Usage: #inline
* meta.source = "https://cp3-test.example.org/fhirr4/8f224548-6d50-44b6-82c5-75826ee0900f"
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
Usage: #inline
* meta.source = "https://cp3-test.example.org/fhirr4/72a349cc-7336-4a91-873d-fc9349769e1a"
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
Usage: #inline
* meta.source = "https://cp3-test.example.org/fhirr4/4fcf98c7-b198-4d61-8b3e-5ea39e33c405"
* active = true
* providedBy = Reference(Organization/ad3-o1)
* active = true
* name = "Geriatrie"
* type[+] = $sct#146521000146103 "Brief comprehensive geriatric assessment"
* type[+] = $sct#107101000146106 "comprehensive geriatric assessment"
* type[+] = $sct#86944008 "Visual field study"
* specialty[+].coding = AgbSpecialismenCS#0335 "Medisch specialisten, geriatrie"


Instance: ad3-hs2
InstanceOf: NlGfHealthcareService
Usage: #inline
* meta.source = "https://cp3-test.example.org/fhirr4/b48826dc-2d58-479a-bfd3-80b7a9d69757"
* active = true
* providedBy = Reference(Organization/ad3-o2)
* name = "Verpleging"
* type[+] = $sct#23044009 "Patient transfer to skilled nursing facility for level 1 care"
* type[+] = $sct#58413007 "Patient transfer to skilled nursing facility for level 2 care"
* type[+] = $sct#43495009 "Patient transfer to skilled nursing facility for level 3 care"
* specialty[+].coding = AgbSpecialismenCS#0100 "Verpleegkundige"


Instance: ad3-p1
InstanceOf: NlGfPractitioner
Usage: #inline
* meta.source = "https://cp3-test.example.org/fhirr4/08630c28-5e2a-4b0c-b8ce-f08f533246b9"
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

Instance: ad3-pr1
InstanceOf: NlGfPractitionerRole
Usage: #inline
* meta.source = "https://cp3-test.example.org/fhirr4/d60525bd-5caf-4437-8f4b-4156300a27de"
* practitioner = Reference(Practitioner/ad3-p1)
* organization = Reference(Organization/ad3-o1)
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


// ----------------------------------------------------------------
// Resulting Bundle for Query Directory

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
* insert BundleEntryPUT(Endpoint, ad3-e1)
* insert BundleEntryPUT(Endpoint, ad3-e2)
* insert BundleEntryPUT(HealthcareService, ad3-hs1)
* insert BundleEntryPUT(HealthcareService, ad3-hs2)
* insert BundleEntryPUT(Practitioner, ad3-p1)
* insert BundleEntryPUT(PractitionerRole, ad3-pr1)
