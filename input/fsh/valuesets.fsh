ValueSet: NlGfDataExchangeCapabilitiesVS
Id: nl-gf-data-exchange-capabilities-vs
Title: "NL GF Data exchange capabilities"
Description: "The data exchange capabilities supported by the NL Generic Functions."
* ^status = #active
* ^experimental = true
* include codes from valueset http://hl7.org/fhir/ValueSet/endpoint-payload-type
* include codes from system http://nuts-foundation.github.io/nl-generic-functions-ig/CodeSystem/nl-gf-data-exchange-capabilities