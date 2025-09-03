Instance: org2-nursing-request
InstanceOf: ServiceRequest
Usage: #example
Title: "ServiceRequest Nursing"
* meta.profile = "http://nictiz.nl/fhir/StructureDefinition/nl-core-Procedure-request"
* meta.versionId = "1"
* status = #active
* intent = #order
* subject = Reference(Patient/org2-jaantje) "Patient Jaantje Merkens"
* requester = Reference(PractitionerRole/org2-cardiologist-carolinevandijk) "Caroline van Dijk at Organization 2"
* code = $sct#43495009 "Patient transfer to skilled nursing facility for level 3 care"