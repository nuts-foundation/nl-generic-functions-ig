Instance: nl-gf-localization-repository
InstanceOf: CapabilityStatement
Usage: #definition
* version = "20250828"
* title = "Localization Service"
* status = #active
* experimental = false
* date = "2025-08-28"
* description = """Dutch profile of the CapabilityStatement for a Localization Service."""
* kind = #requirements
* fhirVersion = #4.0.1
* format[+] = #application/fhir+xml
* format[+] = #application/fhir+json
* rest
  * mode = #server
  * resource[+]
    * insert Expectation(SHALL)
    * type = #DocumentReference
    * supportedProfile = Canonical(NlGfLocalizationDocumentReference)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #create
    * interaction[+]
      * insert Expectation(MAY)
      * code = #update
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #read
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #search-type
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "_id"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "custodian.identifier"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "patient.identifier"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "type"
      * type = #token