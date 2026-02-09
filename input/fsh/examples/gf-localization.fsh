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

Instance: a1b2c3d4-e5f6-7890-abcd-ef1234567890
InstanceOf: NlGfLocalizationList
Usage: #example
Title: "Example NL Generic Functions Localization List"
Description: "Example instance of the NlGfLocalizationList profile. It expresses an Organization with identifier (URA) 22222222 having a Medicatieafspraak of a patient with a pseudonymised identifier (BSN)"
* insert AuthorAssignedIdentifier("https://cp1-test.example.org/nvi","f8141dc0-4c1f-4395-9d62-cf175324e92a","http://fhir.nl/fhir/NamingSystem/ura", "11111111")
* status = #current
* mode = #working
* code = $aorta-bouwsteentype-cs#MEDAFSPRAAK "Medicatieafspraak"
* subject.identifier.system = "http://fhir.nl/fhir/NamingSystem/pseudo-bsn"
* subject.identifier.value = "UHN1ZWRvYnNuOiA5OTk5NDAwMw=="
* source.identifier.system = "tbd"
* source.identifier.value = "an-identifier"
* source.type = $resource-types#Device
* emptyReason = http://terminology.hl7.org/CodeSystem/list-empty-reason#withheld
