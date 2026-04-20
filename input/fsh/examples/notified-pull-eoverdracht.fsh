// Example: nursing transfer of care from a discharging hospital (Placer,
// URA 11111111) to two candidate home-care organizations in parallel (Fulfillers,
// URA 33333333 and 44444444). Whichever accepts first is selected; the others
// are cancelled. Same four-layer structure as the referral example;
// ServiceRequest.performer is absent until a candidate is selected.
//
// One notification Bundle is shown (for the first Task). In production every
// Task triggers its own notification via the Placer's Subscription to that
// candidate.

Instance:    np-eov-subscription
InstanceOf:  NlCowSubscription
Usage:       #example
Title:       "eOverdracht — Subscription (Placer → Fulfiller A)"
Description: "Broad Subscription covering all transfer-of-care events between Placer and Fulfiller A. Placer holds an analogous Subscription for each other candidate Fulfiller."
* status = #active
* reason = "Notify Fulfiller of eOverdracht transfers ready for pull"
* criteria = "http://twiin.nl/fhir/SubscriptionTopic/transfer-of-care"
* criteria.extension[+].url = "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-filter-criteria"
* criteria.extension[=].valueString = "Task?code=http://snomed.info/sct|308292007"
* channel.type = #rest-hook
* channel.endpoint = "https://fulfiller-a.example.nl/fhir/notification"
* channel.payload = #application/fhir+json
* extension[+].url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-Subscription.managingEntity"
* extension[=].valueReference.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* extension[=].valueReference.identifier.value = "11111111"
* extension[=].valueReference.display = "Placer Hospital"


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


Instance:    np-eov-subscription-status
InstanceOf:  Parameters
Usage:       #example
Title:       "eOverdracht — SubscriptionStatus (notification event to Fulfiller A)"
Description: "First and only entry of the notification Bundle sent to Fulfiller A. An analogous SubscriptionStatus is sent to Fulfiller B, referencing their Coordination Task."
* parameter[+].name = "subscription"
* parameter[=].valueReference = Reference(Subscription/np-eov-subscription)
* parameter[+].name = "type"
* parameter[=].valueCode = #event-notification
* parameter[+].name = "status"
* parameter[=].valueCode = #active
* parameter[+].name = "topic"
* parameter[=].valueCanonical = "http://twiin.nl/fhir/SubscriptionTopic/transfer-of-care"
* parameter[+].name = "notification-event"
* parameter[=].part[+].name = "event-number"
* parameter[=].part[=].valueString = "1"
* parameter[=].part[+].name = "timestamp"
* parameter[=].part[=].valueInstant = "2026-04-17T09:15:02+02:00"
* parameter[=].part[+].name = "focus"
* parameter[=].part[=].valueReference = Reference(Task/np-eov-coordination-task-a)
* parameter[=].part[+].name = "authorization-hint"
* parameter[=].part[=].part[+].name = "type"
* parameter[=].part[=].part[=].valueCoding = http://fhir.nl/fhir/CodeSystem/AuthorizationType#authorization-base
* parameter[=].part[=].part[+].name = "value"
* parameter[=].part[=].part[=].valueString = "NzRlOTBlYjAtNTFjMy00NjU3LWJkYjUtYzM0N2UwOTk5OTk5"


Instance:    np-eov-notification-bundle
InstanceOf:  Bundle
Usage:       #example
Title:       "eOverdracht — Notification Bundle (to Fulfiller A)"
Description: "POST payload from the Placer to Fulfiller A. An analogous Bundle is POSTed to Fulfiller B for the parallel Task. Whichever Fulfiller accepts first will be selected."
* meta.profile = "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-subscription-notification"
* type = #history
* timestamp = "2026-04-17T09:15:02+02:00"
* entry[+].fullUrl = "urn:uuid:np-eov-subscription-status"
* entry[=].resource = np-eov-subscription-status
* entry[=].request.method = #GET
* entry[=].request.url = "https://placer.example.nl/fhir/Subscription/np-eov-subscription/$status"
* entry[=].response.status = "200"
