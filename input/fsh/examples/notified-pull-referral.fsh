// Example: patient referral from a Placer hospital (URA 11111111) to a
// Fulfiller hospital (URA 22222222). The referral carries the BgZ dataset.
// Illustrates all four layers of the Notified Pull profile: Subscription
// (transport), Notification Bundle, Coordination Task (workflow),
// ServiceRequest + PlanDefinition (data).

Instance:    np-referral-subscription
InstanceOf:  NlCowSubscription
Usage:       #example
Title:       "Referral — Subscription (Placer → Fulfiller)"
Description: "Broad Subscription covering all referral events between the two partners. Criteria carries the SubscriptionTopic canonical; a filter extension narrows to referral-coded Tasks."
* status = #active
* reason = "Notify Fulfiller of referrals ready for pull"
* criteria = "http://twiin.nl/fhir/SubscriptionTopic/referral"
* criteria.extension[+].url = "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-filter-criteria"
* criteria.extension[=].valueString = "Task?code=http://snomed.info/sct|3457005"
* channel.type = #rest-hook
* channel.endpoint = "https://fulfiller.example.nl/fhir/notification"
* channel.payload = #application/fhir+json
* extension[+].url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-Subscription.managingEntity"
* extension[=].valueReference.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* extension[=].valueReference.identifier.value = "11111111"
* extension[=].valueReference.display = "Placer Hospital"


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


Instance:    np-referral-subscription-status
InstanceOf:  Parameters
Usage:       #example
Title:       "Referral — SubscriptionStatus (notification event)"
Description: "Parameters resource carried as the first entry of the notification Bundle, following the Subscription Backport IG shape. notification-event.focus points at the Coordination Task; authorization-hint carries the opaque legal-basis token."
* parameter[+].name = "subscription"
* parameter[=].valueReference = Reference(Subscription/np-referral-subscription)
* parameter[+].name = "type"
* parameter[=].valueCode = #event-notification
* parameter[+].name = "status"
* parameter[=].valueCode = #active
* parameter[+].name = "topic"
* parameter[=].valueCanonical = "http://twiin.nl/fhir/SubscriptionTopic/referral"
* parameter[+].name = "notification-event"
* parameter[=].part[+].name = "event-number"
* parameter[=].part[=].valueString = "1"
* parameter[=].part[+].name = "timestamp"
* parameter[=].part[=].valueInstant = "2026-04-17T10:30:05+02:00"
* parameter[=].part[+].name = "focus"
* parameter[=].part[=].valueReference = Reference(Task/np-referral-coordination-task)
* parameter[=].part[+].name = "authorization-hint"
* parameter[=].part[=].part[+].name = "type"
* parameter[=].part[=].part[=].valueCoding = http://fhir.nl/fhir/CodeSystem/AuthorizationType#authorization-base
* parameter[=].part[=].part[+].name = "value"
* parameter[=].part[=].part[=].valueString = "ZGFhNDFjY2MtZGFmMi00YjZkLThiNDYtN2JlZDk1MWEyYzk2"


Instance:    np-referral-notification-bundle
InstanceOf:  Bundle
Usage:       #example
Title:       "Referral — Notification Bundle"
Description: "The POST payload from Placer to Fulfiller. Contains only the SubscriptionStatus; no clinical content. The Fulfiller then pulls the Coordination Task, ServiceRequest and PlanDefinition separately."
* meta.profile = "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-subscription-notification"
* type = #history
* timestamp = "2026-04-17T10:30:05+02:00"
* entry[+].fullUrl = "urn:uuid:np-referral-subscription-status"
* entry[=].resource = np-referral-subscription-status
* entry[=].request.method = #GET
* entry[=].request.url = "https://placer.example.nl/fhir/Subscription/np-referral-subscription/$status"
* entry[=].response.status = "200"
