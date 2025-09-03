Instance: org4-organization1
InstanceOf: NlGfOrganization
Usage: #example
Title: "9.02 Organization Organization 1"
Description: "Existing data in EHR of Organization 2"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthcareProvider-Organization"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[=].value = "44444444"
* name = "Organization 1"
* type[+] = $organization-type#V6 "Algemeen ziekenhuis"
* type[+] = $sct#22232009 "Hospital"
* telecom[0].system = #phone
* telecom[=].value = "+31301234567"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "info@organization1.nl"
* telecom[=].use = #work
* address.line[+].value = "Brouwersplein 23"
* address.line[+].extension.url = "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-streetName"
* address.line[=].extension.valueString = "Brouwersplein"
* address.line[+].extension.url = "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-houseNumber"
* address.line[=].extension.valueString = "23"
* address.city = "Arnhem"
* address.postalCode = "6811 BL"
* endpoint[+] = Reference(Endpoint/org4-endpoint)

Instance: org4-endpoint
InstanceOf: NlGfEndpoint
Usage: #example
Title: "9.01 Endpoint Example GP"
* status = #active
* payloadType[+].coding.system = "http://terminology.hl7.org/CodeSystem/endpoint-payload-type"
* payloadType[=].coding.code = #Any
* payloadMimeType[+] = #application/fhir+json
* connectionType.system = "http://terminology.hl7.org/CodeSystem/endpoint-connection-type"
* connectionType.code = #hl7-fhir-rest
* name = "Example GP FHIR Endpoint"
* managingOrganization.identifier.system = "http://fhir.nl/fhir/NamingSystem/kvk"
* managingOrganization.identifier.value = "34270859" //Gerimedica
* contact[0].system = #phone
* contact[=].value = "+3131599991"
* contact[=].use = #work
* contact[+].system = #email
* contact[=].value = "info@example.com"
* contact[=].use = #work
* address = $endpoint4

Instance: services-organization4
InstanceOf: Bundle
Usage: #example
Title: "9.01 Bundle of services and personal health information in EHR of Organization 2"
* type = #transaction
* insert BundleEntry(org4-organization1, #PUT, Organization/org4-organization1)
* insert BundleEntry(org4-endpoint, #PUT, Endpoint/org4-endpoint)
