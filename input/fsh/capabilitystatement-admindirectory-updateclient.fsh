Instance: nl-gf-admin-directory-update-client
InstanceOf: CapabilityStatement
Usage: #definition
* version = "20250828"
* title = "Administration Directory for Update Client"
* status = #active
* experimental = false
* date = "2025-08-28"
* description = "Dutch profile of the CapabilityStatement for Administration Directory Actor that should be able to work with an Update Client."
* kind = #requirements
* fhirVersion = #4.0.1
* format[+] = #application/fhir+xml
* format[+] = #application/fhir+json
* rest
  * mode = #server
  * documentation = "Dutch profile of the IHE ITI mCSD ITI-91 endpoint. Note that this CapabilityStatement includes the search-interaction without any specific search-parameter (the `_since` is added to allow for history-type interactions). This search interaction can be used to retrieve the latest state of all resources of a specific type."
  * resource[+]
    * insert Expectation(MAY)
    * type = #Organization
    * supportedProfile[+] = Canonical(NlGfOrganization)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #history-type
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #search-type
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "_since"
      * type = #date
  * resource[+]
    * insert Expectation(MAY)
    * type = #Location
    * supportedProfile[+] = Canonical(NlGfLocation)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #history-type
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #search-type
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "_since"
      * type = #date
  * resource[+]
    * insert Expectation(MAY)
    * type = #Practitioner
    * supportedProfile = Canonical(NlGfPractitioner)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #history-type
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #search-type
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "_since"
      * type = #date
  * resource[+]
    * insert Expectation(MAY)
    * type = #PractitionerRole
    * supportedProfile = Canonical(NlGfPractitionerRole)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #history-type
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #search-type
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "_since"
      * type = #date
  * resource[+]
    * insert Expectation(MAY)
    * type = #HealthcareService
    * supportedProfile = Canonical(NlGfHealthcareService)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #history-type
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #search-type
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "_since"
      * type = #date
  * resource[+]
    * insert Expectation(MAY)
    * type = #Endpoint
    * supportedProfile[+] = Canonical(NlGfEndpoint)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #history-type
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #search-type
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "_since"
      * type = #date
  * resource[+]
    * insert Expectation(MAY)
    * type = #OrganizationAffiliation
    * supportedProfile[+] = Canonical(NlGfOrganizationAffiliation)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #history-type
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #search-type
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "_since"
      * type = #date