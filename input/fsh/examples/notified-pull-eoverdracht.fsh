// Example: nursing transfer of care from a discharging hospital (Placer,
// URA 11111111) to two candidate home-care organizations in parallel (Fulfillers,
// URA 33333333 and 44444444). Whichever accepts first is selected; the others
// are cancelled. Same four-layer structure as the referral example;
// ServiceRequest.performer is absent until a candidate is selected.
//
// One notification Bundle is shown (for the first Task). In production every
// Task triggers its own notification via the Placer's Subscription to that
// candidate.


Instance:    np-eov-plandefinition
InstanceOf:  PlanDefinition
Usage:       #example
Title:       "eOverdracht dataset — PlanDefinition (stub)"
Description: "Nictiz-hosted canonical dataset definition for eOverdracht. Shown as a stub."
* url = "http://nictiz.nl/fhir/PlanDefinition/eoverdracht"
* version = "4.0.0"
* name = "EOverdrachtDataset"
* title = "eOverdracht — transfer of care dataset"
* status = #active
* date = "2026-01-01"
* publisher = "Nictiz"
* action[+].title = "Patient demographics"
* action[=].input.type = #Patient
* action[+].title = "Nursing handoff composition"
* action[=].input.type = #Composition
* action[=].input.extension[+].url = "http://example.org/fhir/StructureDefinition/fhir-query-string"
* action[=].input.extension[=].valueString = "Composition?type=http://snomed.info/sct|371535009&status=final"
* action[+].title = "Care plan"
* action[=].input.type = #CarePlan
* action[+].title = "Current nursing observations"
* action[=].input.type = #Observation
* action[=].input.extension[+].url = "http://example.org/fhir/StructureDefinition/fhir-query-string"
* action[=].input.extension[=].valueString = "Observation?category=http://terminology.hl7.org/CodeSystem/observation-category|activity&date=ge2026-01-01"


Instance:    np-eov-servicerequest
InstanceOf:  ServiceRequest
Usage:       #example
Title:       "eOverdracht — ServiceRequest"
Description: "The transfer-of-care order. performer is intentionally absent: during solicitation the candidates are known via the Coordination Tasks (Task.owner), not via the ServiceRequest. performer MAY be set once a candidate is selected."
* status = #active
* intent = #order
* code = $sct#308292007 "Transfer of care"
* instantiatesCanonical = "http://nictiz.nl/fhir/PlanDefinition/eoverdracht|4.0.0"
* subject.identifier.system = $bsn
* subject.identifier.value = "999900450"
* authoredOn = "2026-04-17T09:10:00+02:00"
* requester.identifier.system = $ura
* requester.identifier.value = "11111111"
* requester.display = "Placer Hospital"


Instance:    np-eov-coordination-task-a
InstanceOf:  NlCowCoordinationTask
Usage:       #example
Title:       "eOverdracht — Coordination Task (candidate A)"
Description: "Coordination Task offering the transfer to Fulfiller A. Shares groupIdentifier with the task offered to Fulfiller B."
* status = #requested
* intent = #order
* code = $sct#308292007 "Transfer of care"
* focus = Reference(ServiceRequest/np-eov-servicerequest)
* groupIdentifier.system = $uuid
* groupIdentifier.value = "urn:uuid:4a7a0c9c-9d51-4b14-9d21-0bd0eeb57f10"
* for.identifier.system = $bsn
* for.identifier.value = "999900450"
* authoredOn = "2026-04-17T09:15:00+02:00"
* requester.identifier.system = $ura
* requester.identifier.value = "11111111"
* requester.display = "Placer Hospital"
* owner.identifier.system = $ura
* owner.identifier.value = "33333333"
* owner.display = "Fulfiller Home-care A"
* restriction.period.end = "2026-05-17T00:00:00+02:00"


Instance:    np-eov-coordination-task-b
InstanceOf:  NlCowCoordinationTask
Usage:       #example
Title:       "eOverdracht — Coordination Task (candidate B)"
Description: "Parallel Coordination Task offering the same ServiceRequest to Fulfiller B. Same groupIdentifier as candidate A. The Placer will select the first to accept, cancelling the other with statusReason 'not selected'."
* status = #requested
* intent = #order
* code = $sct#308292007 "Transfer of care"
* focus = Reference(ServiceRequest/np-eov-servicerequest)
* groupIdentifier.system = $uuid
* groupIdentifier.value = "urn:uuid:4a7a0c9c-9d51-4b14-9d21-0bd0eeb57f10"
* for.identifier.system = $bsn
* for.identifier.value = "999900450"
* authoredOn = "2026-04-17T09:15:00+02:00"
* requester.identifier.system = $ura
* requester.identifier.value = "11111111"
* requester.display = "Placer Hospital"
* owner.identifier.system = $ura
* owner.identifier.value = "44444444"
* owner.display = "Fulfiller Home-care B"
* restriction.period.end = "2026-05-17T00:00:00+02:00"