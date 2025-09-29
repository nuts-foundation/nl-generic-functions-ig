### Care Services Proxy and Policy Decision Point

The Care Services expose an Administration Directory as a FHIR service, as described in:
- [Client CapabilityStatement](CapabilityStatement-nl-gf-admin-directory-update-client.html)
- [Care Services Overview](care-services.html)

This Administration Directory might be the internal FHIR service of the supplier. To prevent leakage of FHIR resources, the internal FHIR service requires protection. This is commonly realized through an AAA (Authentication, Authorization, and Accounting) proxy.

#### Proxy Implementation Options

The proxy can be either:
1. Provisioned by the NUTS software
2. Implemented by the supplier

#### Required API Interactions

To implement this protection mechanism, the NUTS software needs to provide two API requests:

##### 1a. Search Narrowing Request

This API is invoked **before** the request is executed to the internal FHIR service. It:
- Requires the incoming request with the FHIR query parameters
- Applies the query parameters to the returned scope
- Returns a search-narrowed scope that includes the FHIR query parameters

**Example:**
- Incoming request: `Organization`
- Returned scope: `Organization?identifier=ura|24173480`

##### 1b. Scope Request (Alternative)

This API is invoked **before** the request is executed to the internal FHIR service. It:
- Returns FHIR scopes similar to [SMART on FHIR Access Scopes](https://build.fhir.org/ig/HL7/smart-app-launch/scopes-and-launch-context.html)
- Provides access scopes specific to the mCSD (mobile Care Services Discovery) use case
- Returns scopes that define which resources and operations are authorized

**Example:**
- Incoming request: for mCSD resources
- Returned scopes:
  - `system/Organization.rs?identifier=ura|24173480`
  - `system/Location.rs?managingOrganization=Organization/24173480`
  - `system/Practitioner.rs?_has:PractitionerRole:practitioner:organization=Organization/24173480`
  - `system/PractitionerRole.rs?organization=Organization/24173480`
  - `system/HealthcareService.rs?_has:Location:location:managingOrganization=Organization/24173480`

##### 2. Response Authorization (Policy Decision Point)

This API is invoked **when** the proxy is responding to the incoming request. It:
- Uses the [Authorization API 1.0](https://openid.net/specs/authorization-api-1_0-01.html) specification
- Allows the NUTS software to function as a Policy Decision Point (PDP)
- Evaluates the response Bundle against authorization policies

This two-phase approach ensures that:
- Only authorized data is queried from the internal FHIR service
- Response data is validated against policies before being returned to the requester
- The internal FHIR service remains protected from unauthorized access or data leakage

#### API Specification

The complete OpenAPI specification for these endpoints is available here: [Care Services Proxy OpenAPI Specification](care-services-proxy-openapi.json)

#### Example API Calls

##### Search Narrowing Request Example

**Request:**
```http
POST /authorization/search-narrowing
Content-Type: application/json

{
  "use_case": "mCSD",
  "query": "Organization?name=Example&_id=123",
  "method": "GET",
  "requester": {
    "organization_identifier": "ura|24173480"
  }
}
```

**Response:**
```json
{
  "allowed": true,
  "narrowed_scope": "Organization?identifier=ura|24173480",
  "original_scope": "Organization",
  "applied_filters": [
    {
      "parameter": "identifier",
      "value": "ura|24173480"
    }
  ]
}
```

##### Scope Request Example

**Request:**
```http
POST /authorization/scopes
Content-Type: application/json

{
  "use_case": "mCSD",
  "requester": {
    "organization_identifier": "ura|24173480"
  }
}
```

**Response:**
```json
{
  "scopes": [
    "system/Organization.rs?identifier=ura|24173480",
    "system/Location.rs?managingOrganization=Organization/24173480",
    "system/Practitioner.rs?_has:PractitionerRole:practitioner:organization=Organization/24173480",
    "system/PractitionerRole.rs?organization=Organization/24173480",
    "system/HealthcareService.rs?_has:Location:location:managingOrganization=Organization/24173480"
  ],
  "scope_details": [
    {
      "scope": "system/Organization.rs?identifier=ura|24173480",
      "description": "Read and search access to Organization resources",
      "constraints": ["identifier=ura|24173480", "type=prov"]
    }
  ],
  "expiry": "2024-12-31T23:59:59Z"
}
