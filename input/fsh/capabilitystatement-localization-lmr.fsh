Instance: nl-gf-localization-repository-lmr
InstanceOf: CapabilityStatement
Usage: #definition
* version = "20250828"
* title = "Localization Service - Local Metadata Register"
* status = #active
* experimental = false
* date = "2025-08-28"
* description = """Dutch profile of the CapabilityStatement for a Localization Service - Local Metadata Register"""
* kind = #requirements
* fhirVersion = #4.0.1
* format[+] = #application/fhir+xml
* format[+] = #application/fhir+json
* rest
  * mode = #server
  * resource[+]
    * insert Expectation(SHALL)
    * type = #Patient
    * documentation = "HTTP Method HEAD SHALL be supported to check for the existence of -and access to- a Patient resource, without returning the actual resource."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #read

  // // More resources types can be added here to support/represent other data categories in the Localization service (DocumentReference.type values):

  // * resource[+]
  //   * insert Expectation(SHALL)
  //   * type = #MedicationRequest
  //   * documentation = "HTTP Method HEAD SHALL be supported to check for the existence of -and access to- a MedicationRequest resource, without returning the actual resource."
  //   * interaction[+]
  //     * insert Expectation(SHALL)
  //     * code = #read