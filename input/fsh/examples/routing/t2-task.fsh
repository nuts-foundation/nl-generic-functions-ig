Instance: a0fc5221-bcd9-46f1-922f-c2913dae5d63
InstanceOf: Task
Usage: #example
Title: "Organization 2 - Task for ServiceRequest Nursing"
Description: "Task created by Organization 2 to fulfill the ServiceRequest for nursing care at Nursing department at Organization 3"
* insert AuthorAssignedIdentifier("https://cp2-test.example.org/tasks","a0fc5221-bcd9-46f1-922f-c2913dae5d63","http://fhir.nl/fhir/NamingSystem/ura", "22222222")
* status = #requested
* intent = #order
* code = $task-code#fulfill
* focus = Reference(ServiceRequest/53a41e63-e826-45fa-9076-9be4b18399c8) "ServiceRequest Nursing"
* for = Reference(Patient/27e58ece-409e-44f9-8cc1-b33495a0ef9d)
* requester = Reference(PractitionerRole/f051d3bd-26ff-4030-a5b6-fc4ef2be83ba) "Caroline van Dijk at Organization 2"
* owner = Reference(HealthcareService/b48826dc-2d58-479a-bfd3-80b7a9d69757) "Organization 3 - HealthcareService Verpleging"
* location = Reference(Location/9a2b8f1c-4e7d-42a1-b3c9-2d5e8f7a6c1b) "Organization 3 - Location Nursing Department"