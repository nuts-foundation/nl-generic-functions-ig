Instance: nl-gf-data-localization-repository
InstanceOf: CapabilityStatement
Usage: #definition
* version = "20250828"
* title = "Data Localization Service"
* status = #active
* experimental = false
* date = "2025-08-28"
* description = """Dutch profile of the CapabilityStatement for a data localization service. Based on the IHE BALP Audit Record Repository
https://profiles.ihe.net/ITI/BALP/CapabilityStatement/IHE.BALP.ATNA.AuditRecordRepository version 1.1.3"""
* kind = #requirements
* fhirVersion = #4.0.1
* format[+] = #application/fhir+xml
* format[+] = #application/fhir+json
* rest
  * mode = #server
  * documentation = "Dutch profile of the IHE Basic Audit Logging Profile ITI-20 endpoint"
  * resource[+]
    * insert Expectation(SHALL)
    * type = #AuditEvent
    * supportedProfile = Canonical(NlGfDataLocalizationAuditEvent)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #create
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
      * name = "_lastUpdated"
      * type = #date
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "date"
      * type = #date
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "address"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "agent.identifier"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "patient.identifier"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "entity.identifier"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "entity-type"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "entity-role"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "source.identifier"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "type"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "subtype"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "outcome"
      * type = #token


