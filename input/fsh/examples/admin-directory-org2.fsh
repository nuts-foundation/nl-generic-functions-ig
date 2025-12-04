Instance: cff921f3-c1c1-4a4c-8f0f-cafd0aa25067
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
* endpoint[+] = Reference(Endpoint/430f7379-8ec2-4e55-b096-919995da61e2)
* endpoint[+] = Reference(Endpoint/d4c1d657-67a9-471c-9732-9c042e9a6d43)
* endpoint[+] = Reference(Endpoint/2427ca0c-8a29-4a6a-aabd-50cf02f587a7)

Instance: 430f7379-8ec2-4e55-b096-919995da61e2
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

Instance: d4c1d657-67a9-471c-9732-9c042e9a6d43
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

Instance: 2427ca0c-8a29-4a6a-aabd-50cf02f587a7
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

Instance: 5cb05355-474b-4d30-8b0e-a9ca574b8274
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 2 - HealthcareService Cardiology"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/services","5cb05355-474b-4d30-8b0e-a9ca574b8274","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* active = true
* providedBy = Reference(Organization/cff921f3-c1c1-4a4c-8f0f-cafd0aa25067)
* active = true
* name = "Polikliniek 't Vaatje"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = urn:oid:2.16.840.1.113883.2.4.6.7#0303 "Chirurgie (Heelkunde)"
* specialty[+].coding = $uzi-rolcode#01.014 "Chirurg"

Instance: c79125e5-739f-4238-959c-cd5872518c1f
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 2 - HealthcareService Neurochirurgie"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/services","c79125e5-739f-4238-959c-cd5872518c1f","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* active = true
* providedBy = Reference(Organization/cff921f3-c1c1-4a4c-8f0f-cafd0aa25067)
* active = true
* name = "Neurochirurgie"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = urn:oid:2.16.840.1.113883.2.4.6.7#0308 "Medisch specialisten, neurochirurgie"
* specialty[+].coding = $uzi-rolcode#01.025 "Neurochirurg"

Instance: 9d47ca45-4166-4531-a23d-ef5fa613ece4
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 2 - HealthcareService Orthopedie"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/services","9d47ca45-4166-4531-a23d-ef5fa613ece4","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* active = true
* providedBy = Reference(Organization/cff921f3-c1c1-4a4c-8f0f-cafd0aa25067)
* active = true
* name = "Orthopedie"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = urn:oid:2.16.840.1.113883.2.4.6.7#0305 "Medisch specialisten, orthopedie"
* specialty[+].coding = $uzi-rolcode#01.032 "Orthopedisch chirurg"

Instance: f6a508bd-9455-4afa-aad0-baec0833602d
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 2 - HealthcareService Interne Geneeskunde"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/services","f6a508bd-9455-4afa-aad0-baec0833602d","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* active = true
* providedBy = Reference(Organization/cff921f3-c1c1-4a4c-8f0f-cafd0aa25067)
* active = true
* name = "Interne Geneeskunde"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = urn:oid:2.16.840.1.113883.2.4.6.7#0313 "Interne geneeskunde"
* specialty[+].coding = $uzi-rolcode#01.016 "Internist"


Instance: 120325af-083c-40ee-b16e-01230fe65655
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 2 - HealthcareService Geriatrie"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/services","120325af-083c-40ee-b16e-01230fe65655","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* active = true
* providedBy = Reference(Organization/cff921f3-c1c1-4a4c-8f0f-cafd0aa25067)
* active = true
* name = "Geriatrie"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = urn:oid:2.16.840.1.113883.2.4.6.7#0335 "Medisch specialisten, geriatrie"
* specialty[+].coding = $uzi-rolcode#01.022 "Klinisch geriater"

Instance: 08013141-16b2-42a0-8c9a-af57cee5511b
InstanceOf: NlGfHealthcareService
Usage: #example
Title: "Organization 2 - HealthcareService Urologie"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/services","08013141-16b2-42a0-8c9a-af57cee5511b","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* active = true
* providedBy = Reference(Organization/cff921f3-c1c1-4a4c-8f0f-cafd0aa25067)
* active = true
* name = "Urologie"
* type = $sct#11429006 "Consultation"
* specialty[+].coding = urn:oid:2.16.840.1.113883.2.4.6.7#0306 "Medisch specialisten, urologie"
* specialty[+].coding = $uzi-rolcode#01.045 "Uroloog"



Instance: f051d3bd-26ff-4030-a5b6-fc4ef2be83ba
InstanceOf: NlGfPractitionerRole
Usage: #example
Title: "Organization 2 - PractitionerRole Cardioloog Caroline van Dijk at Organization 2"
* identifier[+].system = "http://cp2.example.org/HRM/assignments"
* identifier[=].value = "123456"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/employees","f051d3bd-26ff-4030-a5b6-fc4ef2be83ba","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* practitioner = Reference(Practitioner/040b160a-6072-4244-adc0-2b786c4ef052)
* organization = Reference(Organization/cff921f3-c1c1-4a4c-8f0f-cafd0aa25067)
* code.coding = $uzi-rolcode#01.010 "Cardioloog"
* specialty.coding = $uzi-rolcode#01.010 "Cardioloog"
* telecom[+].system = #email
* telecom[=].value = "c.vandijk@cp2.example.org"


Instance: 040b160a-6072-4244-adc0-2b786c4ef052
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



Instance: admin-directory-org2
InstanceOf: Bundle
Usage: #example
Title: "Bundle of care services in EHR of Organization 2"
Description: "This bundle contains all care services for the Organization 2 Administration Directory example"
* type = #transaction
* insert BundleEntryPUT(Organization, cff921f3-c1c1-4a4c-8f0f-cafd0aa25067)
* insert BundleEntryPUT(Endpoint, 430f7379-8ec2-4e55-b096-919995da61e2)
* insert BundleEntryPUT(Endpoint, d4c1d657-67a9-471c-9732-9c042e9a6d43)
* insert BundleEntryPUT(Endpoint, 2427ca0c-8a29-4a6a-aabd-50cf02f587a7)
* insert BundleEntryPUT(HealthcareService, 5cb05355-474b-4d30-8b0e-a9ca574b8274)
* insert BundleEntryPUT(HealthcareService, c79125e5-739f-4238-959c-cd5872518c1f)
* insert BundleEntryPUT(HealthcareService, 9d47ca45-4166-4531-a23d-ef5fa613ece4)
* insert BundleEntryPUT(HealthcareService, f6a508bd-9455-4afa-aad0-baec0833602d)
* insert BundleEntryPUT(HealthcareService, 120325af-083c-40ee-b16e-01230fe65655)
* insert BundleEntryPUT(HealthcareService, 08013141-16b2-42a0-8c9a-af57cee5511b)
* insert BundleEntryPUT(PractitionerRole, f051d3bd-26ff-4030-a5b6-fc4ef2be83ba)
* insert BundleEntryPUT(Practitioner, 040b160a-6072-4244-adc0-2b786c4ef052)
