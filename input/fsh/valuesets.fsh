ValueSet: NlGfDataExchangeCapabilitiesVS
Id: nl-gf-data-exchange-capabilities-vs
Title: "NL GF Data exchange capabilities"
Description: "The data exchange capabilities supported by the NL Generic Functions."
* ^status = #active
* ^experimental = true
* include codes from valueset http://hl7.org/fhir/ValueSet/endpoint-payload-type
* include codes from system http://nuts-foundation.github.io/nl-generic-functions-ig/CodeSystem/nl-gf-data-exchange-capabilities

ValueSet: NlGfWlzZorgprofielenVS
Id: nl-gf-wlz-zorgprofielen-vs
Title: "NL GF WLZ Zorgprofielen ValueSet"
Description: "The WLZ Zorgprofielen supported by the NL Generic Functions."
* ^status = #active
* ^experimental = true
* include codes from valueset http://decor.nictiz.nl/fhir/ValueSet/2.16.840.1.113883.2.4.3.11.60.121.11.19--20200901000000
* include codes from system http://nuts-foundation.github.io/nl-generic-functions-ig/CodeSystem/nl-gf-wlz-zorgprofielen-cs