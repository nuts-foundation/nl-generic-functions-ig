Instance: org4-jaantje
InstanceOf: Patient //TODO: dependency on $nl-core-Patient if dependency-bug-nictiz is fixed
Title: "9.01 Patient Jaantje Merkens"
* meta.profile = $nl-core-Patient
* identifier[0].system = "http://organization4.example.org/EHR/patients"
* identifier[=].value = "126fvdsezv"
* identifier[+].system = "http://fhir.nl/fhir/NamingSystem/bsn"
* identifier[=].value = "111222333"
* name
  * given[0] = "Jaantje"
  * family = "Merkens"
* telecom[+].system = #phone
* telecom[=].value = "+31612345678"
* telecom[+].system = #email
* telecom[=].value = "j.merkens@bigtech.com"
* gender = #female
* birthDate = "1950-02-26"
* address.line = "Kerkstraat 18"
* address.postalCode = "7071 WZ"
* address.city = "Ulft"
* managingOrganization = Reference(Organization/org4-organization1) "Organization 1"

Instance: phi-organization4
InstanceOf: Bundle
Usage: #example
Title: "9.01 Bundle of services and personal health information in EHR of Organization 3"
* type = #transaction
* insert BundleEntry(org4-jaantje, #PUT, Patient/org4-jaantje)