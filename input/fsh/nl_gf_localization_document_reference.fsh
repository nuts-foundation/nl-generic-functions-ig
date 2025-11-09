Profile: NlGfLocalizationDocumentReference
Parent: DocumentReference
Id: nl-gf-localization-documentreference
Title: "NL Generic Functions Localization DocumentReference Profile"
Description: """A DocumentReference profile for registering the availability of patient data at healthcare organizations for localization services. This profile is used to indicate that certain patient data is available at a specific organization and can be accessed for localization purposes."""
* type 1..1
* subject 1..1
* subject.identifier.system = "http://fhir.nl/fhir/NamingSystem/pseudo-bsn"
* subject.reference 0..0
* custodian 1..1
* custodian.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* custodian.reference 0..0
* content.attachment.url 1..1
* content.attachment.contentType 1..1