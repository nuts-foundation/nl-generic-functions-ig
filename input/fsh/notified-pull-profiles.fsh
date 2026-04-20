Alias: $taskparam                = http://fhir.nl/fhir/NamingSystem/TaskParameter
Alias: $task-code-cs             = http://hl7.org/fhir/CodeSystem/task-code
Alias: $backport-topic           = http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-topic-canonical
Alias: $backport-filter          = http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-filter-criteria
Alias: $sub-managingEntity       = http://hl7.org/fhir/5.0/StructureDefinition/extension-Subscription.managingEntity


Profile:     NlCowSubscription
Parent:      Subscription
Id:          nl-cow-subscription
Title:       "NL COW Subscription"
Description: """
Broad, long-lived Subscription from a Placer to a Fulfiller for Notified Pull. One Subscription
covers all Coordination Tasks for a single use-case topic between the two partners. Creation of
the Subscription (in-band or out-of-band) is use-case defined; the Placer MUST check that a
Subscription exists for the Fulfiller before notifying.
"""
// Backport-IG pattern: Subscription.criteria carries the SubscriptionTopic canonical URL.
// A filter (Backport extension) refines which events fire. The R5 cross-version
// Subscription.managingEntity identifies the sending organization.
// The Backport IG is not yet a hard dependency of this IG; instances set these extensions
// by raw URL until it is.
* status 1..1
* reason 1..1
* criteria 1..1
* channel 1..1
* channel.type = #rest-hook
* channel.endpoint 1..1
* channel.payload = #application/fhir+json


Profile:     NlCowCoordinationTask
Parent:      Task
Id:          nl-cow-coordination-task
Title:       "NL COW Coordination Task"
Description: """
Per-case Task hosted at the Placer that tracks the lifecycle of one Notified Pull order.
Task.focus references the Request resource describing what is ordered (ServiceRequest,
MedicationRequest, …). Task.for.identifier carries the patient's BSN so the Fulfiller can
match the patient before pulling any clinical data.
"""
* status 1..1
* intent = #order
* code 1..1
* focus 1..1
* focus only Reference(ServiceRequest or MedicationRequest or DeviceRequest)
* for 1..1
* for.identifier 1..1
* for.identifier.system = "http://fhir.nl/fhir/NamingSystem/bsn"
* for.identifier.value 1..1
* requester 1..1
* owner 1..1
* restriction.period 0..1

// Task.input slot for per-case Placer-supplied supplemental FHIR queries.
// No other per-case parameters are standardised in this draft.
* input ^slicing.discriminator.type = #pattern
* input ^slicing.discriminator.path = "type"
* input ^slicing.rules = #open
* input contains supplementalQuery 0..*
* input[supplementalQuery].type = $taskparam#supplemental-query
* input[supplementalQuery].value[x] only string


Profile:     NlCowCancellationRequestTask
Parent:      Task
Id:          nl-cow-cancellationrequest-task
Title:       "NL COW CancellationRequest Task"
Description: """
Sub-Task created by the Placer to request cancellation of a Coordination Task that has reached
'in-progress'. Until then the Placer may cancel directly by setting the Coordination Task
status to 'cancelled'. The Fulfiller accepts or rejects the CancellationRequest Task;
on acceptance the Placer sets the Coordination Task to 'cancelled'.
"""
* status 1..1
* intent = #order
* code = $task-code-cs#abort
* focus 1..1
* focus only Reference(NlCowCoordinationTask)
* for 1..1
* requester 1..1
* owner 1..1
