Instance: nl-gf-query-directory-query-client
InstanceOf: CapabilityStatement
Usage: #definition
* version = "20250828"
* title = "Query Directory for Query Client"
* status = #active
* experimental = false
* date = "2025-08-28"
* description = "Dutch profile of the CapabilityStatement for Query Directory Actor that should be able to work with an Query Client."
* kind = #requirements
* fhirVersion = #4.0.1
* format[+] = #application/fhir+xml
* format[+] = #application/fhir+json
* rest
  * mode = #server
  * documentation = "Dutch profile of the IHE ITI mCSD ITI-90 endpoint"
  * resource[+]
    * insert Expectation(MAY)
    * type = #HealthcareService
    * supportedProfile = Canonical(NlGfHealthcareService)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #read
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #search-type
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "active"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "identifier"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "location"
      * type = #reference
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "name"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "name:contains"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "name:exact"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "organization"
      * type = #reference
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "service-type"
      * type = #token
  * resource[+]
    * insert Expectation(MAY)
    * type = #Location
    * supportedProfile[+] = Canonical(NlGfLocation)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #read
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #search-type
    * searchInclude = "Location:organization"
      * insert Expectation(SHALL)
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "identifier"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "name"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "name:contains"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "name:exact"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "organization"
      * type = #reference
    * searchParam[+]
      * insert Expectation(SHOULD)
      * name = "partof"
      * type = #reference
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "type"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "status"
      * type = #token
  * resource[+]
    * insert Expectation(MAY)
    * type = #Organization
    * supportedProfile[+] = Canonical(NlGfOrganization)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #read
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #search-type
    * searchInclude = "Organization:endpoint"
      * insert Expectation(SHALL)
    * searchRevInclude[+] = "Location:organization"
    * searchRevInclude[+] = "OrganizationAffiliation:participating-organization"
    * searchRevInclude[+] = "OrganizationAffiliation:primary-organization"
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "active"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "identifier"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "name"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "name:contains"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "name:exact"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHOULD)
      * name = "partof"
      * type = #reference
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "type"
      * type = #token
  * resource[+]
    * insert Expectation(MAY)
    * type = #Practitioner
    * supportedProfile = Canonical(NlGfPractitioner)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #read
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #search-type
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "active"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "identifier"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "name"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "name:contains"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "name:exact"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "given"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "given:contains"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "given:exact"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "family"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "family:contains"
      * type = #string
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "family:exact"
      * type = #string
  * resource[+]
    * insert Expectation(MAY)
    * type = #PractitionerRole
    * supportedProfile = Canonical(NlGfPractitionerRole)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #read
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #search-type
    * searchInclude = "PractitionerRole:practitioner"
      * insert Expectation(SHALL)
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "active"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "location"
      * type = #reference
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "organization"
      * type = #reference
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "role"
      * type = #token
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "service"
      * type = #reference
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "specialty"
      * type = #token
  * resource[+]
    * insert Expectation(MAY)
    * type = #Endpoint
    * supportedProfile[+] = Canonical(NlGfEndpoint)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #read
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #search-type
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
      * name = "status"
      * type = #token
  * resource[+]
    * insert Expectation(MAY)
    * type = #OrganizationAffiliation
    * supportedProfile[+] = Canonical(NlGfOrganizationAffiliation)
    * documentation = "."
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #read
    * interaction[+]
      * insert Expectation(SHALL)
      * code = #search-type
    * searchInclude = "OrganizationAffiliation:endpoint"
      * insert Expectation(SHALL)
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "active"
      * type = #token
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
      * name = "participating-organization"
      * type = #reference
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "primary-organization"
      * type = #reference
    * searchParam[+]
      * insert Expectation(SHALL)
      * name = "role"
      * type = #token
  * searchParam[+]
    * insert Expectation(SHALL)
    * name = "_id"
    * type = #token
  * searchParam[+]
    * insert Expectation(SHALL)
    * name = "_lastUpdated"
    * type = #token
    * documentation = "The values for this shall support these prefixes: gt, lt, ge, le, sa, and eb"