Instance: 52b792ba-11ae-42f3-bcc1-231f333f2317
InstanceOf: NlGfLocalizationDocumentReference
Usage: #example
Title: "Example NL Generic Functions Localization DocumentReference"
Description: "Example instance of the NlGfLocalizationDocumentReference profile."
* status = #current
* type = $loinc#55188-7 "Patient data Document"
* subject.identifier.system = "http://fhir.nl/fhir/NamingSystem/pseudo-bsn"
* subject.identifier.value = "123456789"
* custodian.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* custodian.identifier.value = "22222222"
* content.attachment.contentType = #application/json+fhir
* content.attachment.url = "https://cp2-test.example.org/fhirr4/Patient/27e58ece-409e-44f9-8cc1-b33495a0ef9d"