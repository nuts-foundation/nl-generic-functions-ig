Instance: fhir-resource-url
InstanceOf: NamingSystem
Usage: #definition
* name = "FHIR resource URL"
* status = #active
* kind = #identifier
* date = "2025-11-05T00:00:00-00:00"
* description = "This identifier represents an URI and URL that is SHOULD resolve/redirect to a FHIR resource for a long term (10+ years); just like 'permalinks' or 'persistent URLs' are used in scientific literature. \r\n\r\nOnly authoritative sources, i.e. the (legal) custodian/data holder should assign these URLs. \r\n\r\nThe custodian is responsible for forwarding/redirecting the URL-host/domain to a specific software system or platform, ensuring long term persistence of the identifier or (external) reference that's pointing to this resource."
* uniqueId[0].type = #uri
* uniqueId[=].value = "http://fhir.nl/fhir/NamingSystem/url/fhir"
* uniqueId[=].preferred = true
* uniqueId[=].comment = "The client system may use the Accept header to request a specific FHIR version, e.g. `Accept: application/fhir+json; fhirVersion=4.0`. See ['Managing Multiple FHIR Versions'](http://hl7.org/fhir/R4/versioning.html#mt-version) for more information. \r\nHowever, a specific FHIR version may not be supported for the intended +10 years, a server MAY ignore this header. \r\nIf no version is specified, the server returns the default version."

Instance: pseudo-bsn
InstanceOf: NamingSystem
Usage: #definition
* name = "Pseudonymized BSN"
* status = #active
* kind = #identifier
* date = "2025-11-05T00:00:00-00:00"
* description = "This Patient identifier represents a pseudonymized BSN."
* uniqueId[0].type = #uri
* uniqueId[=].value = "http://fhir.nl/fhir/NamingSystem/pseudo-bsn"
* uniqueId[=].preferred = true
