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
Description: "The Request resource describing what is ordered: a patient referral. instantiatesCanonical points at the BgZ dataset PlanDefinition; supportingInfo carries the trigger Observation for this specific case."
* status = #active
* intent = #order
* code = $sct#3457005 "Patient referral"
* instantiatesCanonical = "http://nictiz.nl/fhir/PlanDefinition/bgz|1.2.0"
* subject.identifier.system = $bsn
* subject.identifier.value = "999911120"
* authoredOn = "2026-04-17T10:25:00+02:00"
* requester.identifier.system = $ura
* requester.identifier.value = "11111111"
* requester.display = "Placer Hospital"
* performer.identifier.system = $ura
* performer.identifier.value = "22222222"
* performer.display = "Fulfiller Hospital"
* supportingInfo.reference = "Observation/trigger-hba1c"
* supportingInfo.display = "Trigger lab result that motivated the referral"


Instance:    np-referral-coordination-task
InstanceOf:  NlCowCoordinationTask
Usage:       #example
Title:       "Referral — Coordination Task"
Description: "Per-case workflow Task at the Placer. Task.for.identifier carries the BSN; Task.input carries one Placer-supplied supplemental query in addition to the BgZ dataset."
* status = #requested
* intent = #order
* code = $sct#3457005 "Patient referral"
* focus = Reference(ServiceRequest/np-referral-servicerequest)
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
* input[supplementalQuery].type = $taskparam#supplemental-query
* input[supplementalQuery].valueString = "Observation?category=http://snomed.info/sct|118228005&date=ge2026-01-01"