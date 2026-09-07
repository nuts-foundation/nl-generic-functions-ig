Instance: 614899b2-5132-488b-8cb8-12a821fceb06
InstanceOf: Subscription
Usage: #example
Title: "Subscription at URA 22222222 for Task.owner URA 33333333"
Description: "Subscription to receive notifications of Task-instance-id's where Care provider 33333333 is the (proposed) owner."

* meta.profile = "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-subscription"
* status = #active
* reason = "Subscription to receive notifications of Task-instance-id's where Care provider 33333333 is the (proposed) owner."
* criteria = "http://nuts-foundation.github.io/nl-generic-functions-ig/SubscriptionTopic/subscriberIsTaskOwner"
* criteria.extension.url = "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-filter-criteria"
* criteria.extension.valueString = "Task?owner.identifier=http://fhir.nl/fhir/NamingSystem/ura|33333333"
* channel.extension[0].url = "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-heartbeat-period"
* channel.extension[=].valueUnsignedInt = 86400
* channel.extension[+].url = "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-timeout"
* channel.extension[=].valueUnsignedInt = 60
* channel.extension[+].url = "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-max-count"
* channel.extension[=].valuePositiveInt = 20
* channel.type = #rest-hook
* channel.endpoint = "https://cp3-test.example.org/fhirr4"
* channel.payload = #application/fhir+json
* channel.payload.extension.url = "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-payload-content"
* channel.payload.extension.valueCode = #id-only