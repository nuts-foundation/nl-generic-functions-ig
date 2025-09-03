Instance: org2-nursing-task
InstanceOf: Task
Usage: #example
Title: "Task for ServiceRequest Nursing"
* status = #requested
* intent = #order
* code = $task-code#fullfill
* for = Reference(Patient/org3-jaantje)
* requester = Reference(PractitionerRole/org2-cardiologist-carolinevandijk) "Caroline van Dijk at Organization 2"
* owner = Reference(Organization/org3-organization2)