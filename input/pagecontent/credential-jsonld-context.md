<!--
SPDX-FileCopyrightText: 2026 Rein Krul

SPDX-License-Identifier: CC-BY-SA-4.0
-->

### GIS JSON-LD Context

The GIS credentials use the following JSON-LD context, referenced from each credential's `@context`. It maps the terms used across the GIS credentials (`HealthcareProvider`, `ServiceProvider`, `Delegation`, `PatientEnrollment`, identifiers, delegation and enrollment relations) to the `gis:` (`http://gis-nl.example/`) and `schema:` (`http://schema.org/`) namespaces.

<div class="stu-note" markdown="1">

**Editorial note**: The `gis:` namespace URL `http://gis-nl.example/` is a placeholder. The definitive context URL is still to be determined.

</div>

```json
{
  "@context": {
    "gis": "http://gis-nl.example/",
    "schema": "http://schema.org/",

    "HealthcareProvider": "gis:HealthcareProvider",
    "HealthcareProfessional": "gis:HealthcareProfessional",
    "HealthcareWorker": "gis:HealthcareWorker",
    "Patient": "gis:Patient",
    "ServiceProvider": "gis:ServiceProvider",

    "Delegation": "gis:Delegation",
    "DelegationScope": "gis:DelegationScope",
    "PatientEnrollment": "gis:PatientEnrollment",

    "Identifier": "schema:PropertyValue",
    "identifier": {
      "@id": "schema:identifier",
      "@container": "@set"
    },
    "system": "schema:propertyID",
    "value": "schema:value",
    "roleCode": {
      "@id": "gis:roleCode",
      "@type": "http://fhir.nl/fhir/NamingSystem/uzi-rolcode"
    },
    "name": "schema:name",

    "hasDelegation": "gis:hasDelegation",
    "issuedTo": "gis:issuedTo",
    "issuedBy": "gis:issuedBy",
    "delegatedBy": "gis:delegatedBy",
    "scope": "gis:scope",
    "authorizationRule": "gis:authorizationRule",
    "authorizedActions": "gis:authorizedActions",
    "hasEnrollment": "gis:hasEnrollment",
    "patient": "gis:patient",
    "enrolledBy": "gis:enrolledBy",
    "services": "gis:services"
  }
}
```
