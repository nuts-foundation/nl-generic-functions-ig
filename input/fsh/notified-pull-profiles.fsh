Alias: $taskparam                = http://fhir.nl/fhir/NamingSystem/TaskParameter
Alias: $task-code-cs             = http://hl7.org/fhir/CodeSystem/task-code
Alias: $backport-topic           = http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-topic-canonical
Alias: $backport-filter         = http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-filter-criteria
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
Parent:      http://hl7.org/fhir/uv/cow/StructureDefinition/coordination-task
Id:          nl-cow-coordination-task
Title:       "NL COW Coordination Task"
Description: """
Per-case Task hosted at the Placer that tracks the lifecycle of one Notified Pull order.
Derived from the COW Coordination Task (identifier 1..*, businessStatus, code, focus on one of
six order types are inherited). Task.for references the Patient at the Placer; Task.for.identifier
carries the BSN once the Fulfiller may know it (per Fulfiller, per phase, as the use case defines).
"""
// Rules below are what this profile adds or narrows relative to COW.
* status 1..1
* intent = #order
* for 1..1
* for.reference 1..1
* for.identifier 0..1
* for.identifier.system = "http://fhir.nl/fhir/NamingSystem/bsn"
* for.identifier.value 1..1
* requester 1..1
* owner 1..1
* restriction.period 0..1

// Task.input slots for per-order Placer-supplied additions (kept on the Task, not the Request,
// so that adding one notifies the Fulfiller and candidates can get different sets).
* input ^slicing.discriminator.type = #pattern
* input ^slicing.discriminator.path = "type"
* input ^slicing.rules = #open
* input contains supplementalResource 0..* and supplementalQuery 0..*
* input[supplementalResource].type = $taskparam#supplemental-resource
* input[supplementalResource].value[x] only Reference
* input[supplementalQuery].type = $taskparam#supplemental-query
* input[supplementalQuery].value[x] only string


Profile:     NlCowCancellationRequestTask
Parent:      http://hl7.org/fhir/uv/cow/StructureDefinition/cancellation-request-task
Id:          nl-cow-cancellationrequest-task
Title:       "NL COW CancellationRequest Task"
Description: """
Sub-Task created by the Placer to request cancellation of a Coordination Task that has reached
'in-progress'. Until then the Placer may cancel directly by setting the Coordination Task
status to 'cancelled'. The Fulfiller accepts or rejects the CancellationRequest Task;
on acceptance the Placer sets the Coordination Task to 'cancelled'.
"""
// code = abort and focus 1..1 are inherited from COW. This profile narrows focus to the
// Coordination Task (Placer-initiated cancellation only); COW also allows a Request as focus.
* status 1..1
* intent = #order
* focus only Reference(NlCowCoordinationTask)
* for 1..1
* requester 1..1
* owner 1..1


CodeSystem:  NlCowBusinessStatusCS
Id:          nl-cow-business-status
Title:       "NL COW Business Status"
Description: "Business-status codes used by this profile that the COW business-status value set does not define. COW's workflow state overview uses selected without defining it."
* ^url = "http://fhir.nl/CodeSystem/nl-cow-business-status"
* ^caseSensitive = true
* ^content = #complete
* #selected "Selected" "Among several candidate Fulfillers offered the same order, this Task's owner was selected by the Placer."
