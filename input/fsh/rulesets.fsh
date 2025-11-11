
RuleSet: Expectation( conformance )
* extension[+]
  * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * valueCode = #{conformance}

RuleSet: SupportResource (resource)
* rest.resource[+].type = #{resource}
// * rest.resource[=].extension[0].url = $exp
// * rest.resource[=].extension[0].valueCode = {expectation}

RuleSet: SupportProfile (profile)
* rest.resource[=].supportedProfile[+] = "{profile}"
// * rest.resource[=].supportedProfile[=].extension[0].url = $exp
// * rest.resource[=].supportedProfile[=].extension[0].valueCode = {expectation}

RuleSet: SupportInteraction (interaction)
* rest.resource[=].interaction[+].code = {interaction}
// * rest.resource[=].interaction[=].extension[0].url = $exp
// * rest.resource[=].interaction[=].extension[0].valueCode = {expectation}

RuleSet: SupportSearchParam (name, type)
* rest.resource[=].searchParam[+].name = "{name}"
* rest.resource[=].searchParam[=].type = {type}
// * rest.resource[=].searchParam[=].extension[0].url = $exp
// * rest.resource[=].searchParam[=].extension[0].valueCode = {expectation}

RuleSet: SupportCustomSearchParam (name, canonical, type)
* rest.resource[=].searchParam[+].name = "{name}"
* rest.resource[=].searchParam[=].definition = "{canonical}"
* rest.resource[=].searchParam[=].type = {type}

RuleSet: BundleEntryPUT (type, resource)
* entry[+].fullUrl = "urn:uuid:{resource}"
* entry[=].resource = {resource}
* entry[=].request.method = #PUT
* entry[=].request.url = "{type}/{resource}"

RuleSet: BundleEntryPUTetag (resource, type, uuid, etag)
* entry[+].resource = {resource}
* entry[=].request.method = #PUT
* entry[=].request.url = "{type}/{uuid}"
* entry[=].request.ifMatch = "W/\"{etag}\""

RuleSet: BundleEntryWithFullurl (fullUrl, resource, method, url)
* entry[+].fullUrl = "{fullUrl}"
* entry[=].resource = {resource}
* entry[=].request.method = {method}
* entry[=].request.url = "{url}"

RuleSet: RefIdentifierFHIRUrl (resource-element, url, display)
* {resource-element}.identifier.system = "http://fhir.nl/fhir/NamingSystem/url/fhir"
* {resource-element}.identifier.value = {url}
* {resource-element}.display = {display}

RuleSet: RefIdentifier (resource-element, resource-type, instance-number, identifier-system, identifier-value, assigner-system, assigner-value, source)
* {resource-element} = Reference({{{source}-fhir-url}}{resource-type}/{{{resource-type}{instance-number}}})
* {resource-element}.type = "{resource-type}"
* {resource-element}.identifier.system = {identifier-system}
* {resource-element}.identifier.value = "{identifier-value}"
* {resource-element}.identifier.assigner.identifier.system = {assigner-system}
* {resource-element}.identifier.assigner.identifier.value = "{assigner-value}"

RuleSet: RefIdentifierContained (resource-element, resource-type, id, identifier-system, identifier-value, assigner-system, assigner-value)
* {resource-element} = Reference({id})
* {resource-element}.type = "{resource-type}"
* {resource-element}.identifier.system = {identifier-system}
* {resource-element}.identifier.value = "{identifier-value}"
* {resource-element}.identifier.assigner.identifier.system = {assigner-system}
* {resource-element}.identifier.assigner.identifier.value = "{assigner-value}"

RuleSet: FatReference (resource-type, instance-number, identifier-system, identifier-value, assigner-system, assigner-value, source)
* {resource-element} = Reference({{{source}-fhir-url}}{resource-type}/{{{resource-type}{instance-number}}})
* {resource-element}.type = "{resource-type}"
* {resource-element}.identifier.system = {identifier-system}
* {resource-element}.identifier.value = "{identifier-value}"
* {resource-element}.identifier.assigner.identifier.system = {assigner-system}
* {resource-element}.identifier.assigner.identifier.value = "{assigner-value}"