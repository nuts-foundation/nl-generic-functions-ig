// Example: patient referral from a Placer hospital (URA 11111111) to a
// Fulfiller hospital (URA 22222222). The referral carries the BgZ dataset.
// Illustrates all four layers of the Notified Pull profile: Subscription
// (transport), Notification Bundle, Coordination Task (workflow),
// ServiceRequest + PlanDefinition (data).



Instance:    np-bgz-plandefinition
InstanceOf:  PlanDefinition
Usage:       #example
Title:       "BgZ dataset — PlanDefinition (stub)"
Description: "Nictiz-hosted canonical dataset definition for BgZ. Referenced from a referral's ServiceRequest via instantiatesCanonical. Shown as a stub; the production version enumerates ~30 queries."
* url = "http://nictiz.nl/fhir/PlanDefinition/bgz"
* version = "1.2.0"
* name = "BgZDataset"
* title = "BgZ — Basisgegevensset Zorg"
* status = #active
* date = "2026-01-01"
* publisher = "Nictiz"
* action[+].title = "Patient demographics"
* action[=].input.type = #Patient
* action[+].title = "Problem list"
* action[=].input.type = #Condition
* action[+].title = "Laboratory results (last known per type)"
* action[=].input.type = #Observation
// Raw FHIR search URL carried as an extension until DataRequirement supports $lastn and _include.
* action[=].input.extension[+].url = "http://example.org/fhir/StructureDefinition/fhir-query-string"
* action[=].input.extension[=].valueString = "Observation/$lastn?category=http://snomed.info/sct|275711006&_include=Observation:specimen"


Instance:    np-referral-servicerequest
InstanceOf:  ServiceRequest
Usage:       #example
Title:       "Referral — ServiceRequest"
Description: "The Request resource describing what is ordered: a patient referral. instantiatesCanonical points at the BgZ dataset PlanDefinition. Per-order additions are on the Coordination Task."
* status = #active
* intent = #order
* code = $sct#3457005 "Patient referral"
* instantiatesCanonical = "http://nictiz.nl/fhir/PlanDefinition/bgz|1.2.0"
* subject = Reference(Patient/7b2e5c1a-4d9f-4a83-b6e2-0c5f8d3a9e17) "Patient at the Placer"
* authoredOn = "2026-04-17T10:25:00+02:00"
* requester.identifier.system = $ura
* requester.identifier.value = "11111111"
* requester.display = "Placer Hospital"
* performer.identifier.system = $ura
* performer.identifier.value = "22222222"
* performer.display = "Fulfiller Hospital"


Instance:    np-referral-coordination-task
InstanceOf:  NlCowCoordinationTask
Usage:       #example
Title:       "Referral — Coordination Task"
Description: "Per-order workflow Task at the Placer. Task.for.identifier carries the BSN (the Placer chose to disclose it at creation); Task.input carries the trigger Observation and one supplemental query in addition to the BgZ dataset."
* identifier.system = $uuid
* identifier.value = "urn:uuid:3c9f2b7e-6d41-4a8e-9b25-1f7c0e5d8a63"
* status = #requested
* intent = #order
* code.coding[0] = $task-code#fulfill
* code.coding[+] = $sct#3457005 "Patient referral"
* focus = Reference(ServiceRequest/np-referral-servicerequest)
* for = Reference(Patient/7b2e5c1a-4d9f-4a83-b6e2-0c5f8d3a9e17)
* for.identifier.system = $bsn
* for.identifier.value = "999911120"
* authoredOn = "2026-04-17T10:30:00+02:00"
* requester.identifier.system = $ura
* requester.identifier.value = "11111111"
* requester.display = "Placer Hospital"
* owner.identifier.system = $ura
* owner.identifier.value = "22222222"
* owner.display = "Fulfiller Hospital"
* restriction.period.end = "2026-07-17T00:00:00+02:00"
* input[supplementalResource].type = $taskparam#supplemental-resource
* input[supplementalResource].valueReference.reference = "Observation/trigger-hba1c"
* input[supplementalResource].valueReference.display = "Trigger lab result that motivated the referral"
* input[supplementalQuery].type = $taskparam#supplemental-query
* input[supplementalQuery].valueString = "Observation?category=http://snomed.info/sct|118228005&date=ge2026-01-01"