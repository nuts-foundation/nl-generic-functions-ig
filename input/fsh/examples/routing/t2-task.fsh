Instance: a0fc5221-bcd9-46f1-922f-c2913dae5d63
InstanceOf: Task
Usage: #example
Title: "Organization 2 - Task for ServiceRequest Nursing"
Description: "Task created by Organization 2 to fulfill the ServiceRequest for nursing care at Nursing department at Organization 3"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/url/fhir"
* identifier[=].value = "https://cp2-test.example.org/fhirr4/Task/a0fc5221-bcd9-46f1-922f-c2913dae5d63"
* status = #requested
* intent = #order
* code = $task-code#fulfill
* basedOn = Reference(ServiceRequest/53a41e63-e826-45fa-9076-9be4b18399c8) "ServiceRequest Nursing"
* for = Reference(Patient/27e58ece-409e-44f9-8cc1-b33495a0ef9d)
* requester = Reference(PractitionerRole/f051d3bd-26ff-4030-a5b6-fc4ef2be83ba) "Caroline van Dijk at Organization 2"
* insert RefIdentifierFHIRUrl(owner, "https://cp3-test.example.org/fhirr4/Organization/631cf10e-42d6-4165-9907-11e2333d4a85", "Nursing department at Organization 3")
