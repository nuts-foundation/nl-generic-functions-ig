// preferably this shouldn't be needed at all, but unfortunately :identifier modifier isn't widely supported
// among fhir servers (https://hl7.org/fhir/R4/search.html#reference)

Instance: EpisodeOfCare-patient-identifier
InstanceOf: SearchParameter
Usage: #definition
* url = "http://nuts-foundation.github.io/nl-generic-functions-ig/gfdl-searchparameter-episodeofcare-patient-identifier.json"
* name = "patient-identifier"
* status = #active
* description = "Search EpisodeOfCare by patient identifier"
* code = #patient-identifier
* base = #EpisodeOfCare
* type = #token
* expression = "EpisodeOfCare.patient.identifier"
* xpathUsage = #normal
* xpath = "f:EpisodeOfCare/f:patient/f:identifier"
