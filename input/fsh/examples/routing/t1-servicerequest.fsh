Instance: 53a41e63-e826-45fa-9076-9be4b18399c8
InstanceOf: ServiceRequest
Usage: #example
Title: "Organisation 2 - ServiceRequest Nursing"
Description: "Request from Organization 2 for nursing care"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Procedure-request"
* meta.versionId = "1"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/ServiceRequest","53a41e63-e826-45fa-9076-9be4b18399c8","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* status = #active
* intent = #order
* subject = Reference(Patient/27e58ece-409e-44f9-8cc1-b33495a0ef9d) "Patient Jaantje Merkens"
* requester = Reference(PractitionerRole/f051d3bd-26ff-4030-a5b6-fc4ef2be83ba) "Caroline van Dijk at Organization 2"
* code = NlGfWlzZorgprofielenCS#6VV "VV Beschermd wonen met intensieve verzorging en verpleging"
