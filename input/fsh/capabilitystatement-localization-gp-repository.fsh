Instance: nl-gf-localization-gp-repository
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
    * type = #EpisodeOfCare
    * supportedProfile = Canonical(NlGfEpisodeOfCare)
    * documentation = "."
    * interaction[+]
      * insert Expectation(MAY)
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
      * name = "care-manager"
      * type = #reference
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "date"
      * type = #date
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "identifier"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "organization"
      * type = #reference
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "patient"
      * type = #reference
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "status"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "type"
      * type = #token
  * resource[+]
    * insert Expectation(SHALL)
    * type = #Patient
    * documentation = "."
    * operation[+]
      * name = "match"
      * definition = Canonical(http://hl7.org/fhir/OperationDefinition/Patient-match)