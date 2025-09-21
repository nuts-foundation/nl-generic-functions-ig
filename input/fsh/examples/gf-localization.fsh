Instance: 52b792ba-11ae-42f3-bcc1-231f333f2317
InstanceOf: NlGfLocalizationDocumentReference
Usage: #example
Title: "Example NL Generic Functions Localization DocumentReference"
Description: "Example instance of the NlGfLocalizationDocumentReference profile."
* status = #current
* type = $loinc#55188-7 "Patient data Document"
* subject.identifier.system = "http://fhir.nl/fhir/NamingSystem/bsn"
* subject.identifier.value = "123456789"
* custodian.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* custodian.identifier.value = "22222222"
* content.attachment.contentType = #text/plain
* content.attachment.data = "IlRoaXMgRG9jdW1lbnRSZWZlcmVuY2UgZG9lcyBub3QgcG9pbnQgdG8gYSBzcGVjaWZpYyBkb2N1bWVudCwgYnV0IHJhdGhlciB0byBkb2N1bWVudHMgb3IgZGF0YSBpbiBnZW5lcmFsIGF0IHRoZSBjdXN0b2RpYW4gcmVmZXJlbmNlZCBpbiB0aGlzIGluc3RhbmNlLiBUaGlzIGNhbiBiZSB1c2VkIGJ5IGRhdGEgbG9jYWxpemF0aW9uIHNlcnZpY2VzIChhbHNvIGtub3duIGFzIG1lZGljYWwgcmVjb3JkIGxvY2FsaXphdGlvbiBzZXJ2aWNlcykuIg=="
// decoded data: "This DocumentReference does not point to a specific document, but rather to documents or data in general at the custodian referenced in this instance. This can be used by localization services (also known as medical record localization services)."
* content.attachment.title = "Generic reference to patient data"

