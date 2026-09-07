Instance: 39b97672-5de0-47b3-acf3-e49a3cb8d13a
InstanceOf: Bundle
Usage: #example
Title: "Notification bundle with Task for Care provider 33333333 as owner"
* meta.profile = "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-subscription-notification-r4"
* type = #history
* timestamp = "2020-05-29T11:44:13.1882432-05:00"
* entry.fullUrl = "urn:uuid:292d3c72-edc1-4d8a-afaa-d85e19c7f562a"
* entry.resource = 292d3c72-edc1-4d8a-afaa-d85e19c7f562a
* entry.request.method = #GET
* entry.request.url = "https://cp2-test.example.org/fhirr4/Subscription/614899b2-5132-488b-8cb8-12a821fceb06/$status"
* entry.response.status = "200"

Instance: 292d3c72-edc1-4d8a-afaa-d85e19c7f562a
InstanceOf: Parameters
Usage: #example
Title: "Notification bundle parameter for Care provider 33333333"
* meta.profile = "http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-subscription-status-r4"
* parameter[0].name = "subscription"
* parameter[=].valueReference = Reference(https://cp2-test.example.org/fhirr4/Subscription/614899b2-5132-488b-8cb8-12a821fceb06)
* parameter[+].name = "status"
* parameter[=].valueCode = #active
* parameter[+].name = "type"
* parameter[=].valueCode = #event-notification
* parameter[+].name = "notification-event"
* parameter[=].part[0].name = "event-number"
* parameter[=].part[=].valueString = "1"
* parameter[=].part[+].name = "timestamp"
* parameter[=].part[=].valueInstant = "2024-05-29T11:44:13.1882432-05:00"
* parameter[=].part[+].name = "focus"
* parameter[=].part[=].valueReference = Reference(https://cp2-test.example.org/fhirstu3/Task/a0fc5221-bcd9-46f1-922f-c2913dae5d63)