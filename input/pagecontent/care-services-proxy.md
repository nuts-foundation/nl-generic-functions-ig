### Care Services Proxy and Policy Enforcement Point

The Care Services expose an Administration Directory as a FHIR service, as described in:
- [Client CapabilityStatement](CapabilityStatement-nl-gf-admin-directory-update-client.html)
- [Care Services Overview](care-services.html)

This Administration Directory might be the internal FHIR service of the supplier. To prevent leakage of FHIR resources, the internal FHIR service requires protection. This is commonly realized through an AAA (Authentication, Authorization, and Accounting) proxy acting as a Policy Enforcement Point (PEP).

#### Proxy Implementation Options

The proxy can be implemented using:
1. A generic reverse proxy solution (e.g., **HAProxy**, NGINX, Envoy)
2. Custom supplier implementation

The design is specifically intended for implementation in generic proxies like **HAProxy** through a two-call API pattern that separates authentication from authorization logic. NUTS provides the Policy Decision Point (PDP) APIs but does not provide proxy software.

#### Two-Phase Authorization Approach

The Policy Enforcement Point (PEP) implements a two-phase authorization mechanism to protect FHIR APIs. This approach ensures that:
- Only authenticated and authorized requests reach the internal FHIR service
- FHIR queries are automatically narrowed based on authorization policies
- The solution can be implemented in generic proxy software

##### Phase 1: Token Introspection

The proxy first performs OAuth 2.0 token introspection to validate the access token and retrieve the Verifiable Presentations that were used during authentication.

**Endpoint:** `POST /internal/auth/v2/accesstoken/introspect_extended` (NUTS API)

This call:
- Validates the OAuth 2.0 access token (RFC 7662)
- Returns standard introspection fields (`active`, `iss`, `client_id`, `exp`, `scope`, etc.)
- Returns the Presentation Definitions that were requested
- Returns the Verifiable Presentations (VPs) that were submitted
- Returns the Presentation Submissions showing how VPs fulfill the definitions
- Provides the PDP with full access to Verifiable Credentials for authorization decisions

**Example extended introspection response:**
```json
{
  "active": true,
  "iss": "https://example.com/oauth2/authorizer",
  "client_id": "https://requester.example.com",
  "exp": 1735689599,
  "iat": 1735603199,
  "scope": "patient/*.read",
  "presentation_definitions": {
    "user_wallet": {
      "id": "healthcare-professional-access-pd",
      "input_descriptors": [
        {
          "id": "dezi_login_credential",
          "constraints": {
            "fields": [
              {
                "path": ["$.credentialSubject.type"],
                "filter": {
                  "type": "string",
                  "const": "Practitioner"
                }
              }
            ]
          }
        }
      ]
    }
  },
  "presentation_submissions": {
    "healthcare-professional-access-pd": {
      "id": "submission-123",
      "definition_id": "healthcare-professional-access-pd",
      "descriptor_map": [
        {
          "id": "dezi_login_credential",
          "format": "jwt_vc",
          "path": "$.verifiableCredential[0]"
        }
      ]
    }
  },
  "vps": [
    {
      "@context": ["https://www.w3.org/2018/credentials/v1"],
      "type": ["VerifiablePresentation"],
      "verifiableCredential": [
        {
          "@context": [
            "https://www.w3.org/2018/credentials/v1",
            "https://dezi.nl/contexts/v1"
          ],
          "type": ["VerifiableCredential", "DeziLoginCredential"],
          "issuer": "did:web:dezi.nl",
          "issuanceDate": "2024-01-01T00:00:00Z",
          "credentialSubject": {
            "id": "did:web:practitioner.example.com",
            "type": "Practitioner",
            "identifier": "urn:oid:2.16.528.1.1007.3.1:123456789",
            "name": "Dr. Jane Smith",
            "qualification": "Medical Doctor",
            "organization": {
              "identifier": "ura|24173480",
              "name": "Example Hospital"
            }
          },
          "proof": { "..." }
        }
      ],
      "proof": { "..." }
    }
  ]
}
```

**Rationale:** The extended endpoint provides the PDP with complete Verifiable Presentations, enabling:
- Extraction of any claims from the VCs as needed
- Verification of credential schemas and types
- Access to relationships between entities (e.g., Practitioner → Organization, Practitioner → Patient)
- Complex authorization decisions based on full credential context
- Integration with DEZI (Digitale Eenduidige Zorgverlener Identificatie) for healthcare professional authentication via OIDC

##### Phase 2: Search Narrowing / Query Rewriting

After successful introspection, the proxy calls the Policy Decision Point (PDP) to obtain a rewritten FHIR query that applies search-narrowing based on authorization policies.

**Endpoint:** `POST /authorization/search-narrowing`

This call provides:
- The introspection result (user identity and claims)
- The HTTP request details (method, path, query parameters, headers)
- Client certificate properties (if applicable for mTLS)

The PDP returns:
- A rewritten FHIR query with search-narrowing parameters
- Authorization decision (allow/deny)
- Applied filters for auditability

#### Authorization Matrix

The authorization policies are defined in a comprehensive authorization matrix that covers all use cases and resource types. This matrix defines which actors can access which resources under what conditions.

The authorization matrix follows a similar approach to the [OZO Authorization Matrix for Practitioner](https://ozo-implementation-guide.headease.nl/ozo-authorization-practitioner.html), defining:
- Actor types (Practitioner with DEZI credentials, Organization, RelatedPerson, etc.)
- Resource types (Patient, Observation, Organization, Location, etc.)
- Allowed operations (read, search, create, update, delete)
- Search narrowing rules for each combination
- Contextual constraints (organization membership, care team membership, consent status, etc.)

The Policy Decision Point (PDP) enforces these rules by rewriting FHIR queries to automatically apply the appropriate search parameters.

#### Use Case Examples

##### Use Case 1: Healthcare Professional Reading Patient Resources

**Scenario:** A healthcare professional authenticated via DEZI wants to read Patient resources.

**Phase 1 - Token Introspection:**
```http
POST /internal/auth/v2/accesstoken/introspect_extended HTTP/1.1
Content-Type: application/x-www-form-urlencoded

token=<access_token>
```

**Introspection Response (truncated for brevity):**
```json
{
  "active": true,
  "iss": "https://example.com/oauth2/authorizer",
  "client_id": "https://requester.example.com",
  "exp": 1735689599,
  "iat": 1735603199,
  "scope": "patient/*.read",
  "vps": [
    {
      "type": ["VerifiablePresentation"],
      "verifiableCredential": [
        {
          "type": ["VerifiableCredential", "DeziLoginCredential"],
          "issuer": "did:web:dezi.nl",
          "credentialSubject": {
            "type": "Practitioner",
            "identifier": "urn:oid:2.16.528.1.1007.3.1:123456789",
            "name": "Dr. Jane Smith",
            "qualification": "Medical Doctor",
            "organization": {
              "identifier": "ura|24173480",
              "name": "Example Hospital"
            }
          }
        }
      ]
    }
  ]
}
```

**Phase 2 - Search Narrowing:**

Incoming FHIR request:
```http
GET /Patient HTTP/1.1
```

PDP call:
```http
POST /authorization/search-narrowing HTTP/1.1
Content-Type: application/json

{
  "introspection_result": {
    "active": true,
    "vps": [
      {
        "verifiableCredential": [
          {
            "type": ["VerifiableCredential", "DeziLoginCredential"],
            "credentialSubject": {
              "type": "Practitioner",
              "identifier": "urn:oid:2.16.528.1.1007.3.1:123456789",
              "organization": {
                "identifier": "ura|24173480"
              }
            }
          }
        ]
      }
    ]
  },
  "http_request": {
    "method": "GET",
    "path": "/Patient",
    "query_params": {}
  }
}
```

**PDP Response (Narrowed Query):**
```json
{
  "allowed": true,
  "rewritten_query": "/Patient?_has:CareTeam:patient:participant:Practitioner.identifier=urn:oid:2.16.528.1.1007.3.1:123456789",
  "original_query": "/Patient",
  "applied_filters": [
    {
      "parameter": "_has:CareTeam:patient:participant:Practitioner.identifier",
      "value": "urn:oid:2.16.528.1.1007.3.1:123456789",
      "reason": "Practitioner can only access patients where they are a CareTeam participant"
    }
  ]
}
```

The proxy then executes:
```http
GET /Patient?_has:CareTeam:patient:participant:Practitioner.identifier=urn:oid:2.16.528.1.1007.3.1:123456789 HTTP/1.1
```

##### Use Case 2: Shared mCSD Administration Directory

**Scenario:** An organization queries an mCSD Administration Directory that contains more than just mCSD resources.

**Requirements:**
- Search narrowing to only mCSD Administration Directory resources using the `mcsd-profile` extension
- The extension `http://nuts.nl/fhir/StructureDefinition/mcsd-profile` with value `admin` indicates mCSD conformance
- A custom SearchParameter makes this extension searchable via `mcsd-profile=admin`
- Restrict to specific resource types (Organization, Location, PractitionerRole, Endpoint)
- Only allow specific operations (GET, POST /_search, GET /_history)

**Phase 1 - Token Introspection (truncated):**
```json
{
  "active": true,
  "iss": "https://example.com/oauth2/authorizer",
  "client_id": "https://organization.example.com",
  "exp": 1735689599,
  "scope": "organization/*.read",
  "vps": [
    {
      "type": ["VerifiablePresentation"],
      "verifiableCredential": [
        {
          "type": ["VerifiableCredential", "OrganizationCredential"],
          "credentialSubject": {
            "type": "Organization",
            "identifier": "ura|24173480",
            "name": "Example Hospital"
          }
        }
      ]
    }
  ]
}
```

**Phase 2 - Search Narrowing:**

Incoming request:
```http
GET /Organization HTTP/1.1
```

**PDP Response:**
```json
{
  "allowed": true,
  "rewritten_query": "/Organization?mcsd-profile=admin",
  "applied_filters": [
    {
      "parameter": "mcsd-profile",
      "value": "admin",
      "reason": "Restrict to organizations with mCSD admin profile"
    }
  ],
  "allowed_operations": ["GET", "POST"],
  "resource_constraints": {
    "required_extension": "http://nuts.nl/fhir/StructureDefinition/mcsd-profile"
  }
}
```

**Note:** Use a custom SearchParameter that makes extensions searchable:
- Define a SearchParameter named `mcsd-profile` that searches on the extension `http://nuts.nl/fhir/StructureDefinition/mcsd-profile`
- Filter using the extension value: `mcsd-profile=admin`
- The extension value explicitly indicates business meaning (e.g., "admin" means the resource participates in mCSD Administration Directory)

##### Use Case 3: Separate FHIR Server for mCSD

**Scenario:** Dedicated FHIR server containing only mCSD resources.

In this case, search narrowing may be minimal since the server only contains authorized resource types:

```http
GET /Organization HTTP/1.1
```

May be narrowed to:
```http
GET /Organization?mcsd-profile=admin&active=true
```

**SearchParameter Definition Example:**

To make the `mcsd-profile` extension searchable, define a SearchParameter:

```json
{
  "resourceType": "SearchParameter",
  "id": "Organization-mcsd-profile",
  "url": "http://nuts.nl/fhir/SearchParameter/Organization-mcsd-profile",
  "name": "McsdProfile",
  "status": "active",
  "code": "mcsd-profile",
  "base": ["Organization"],
  "type": "token",
  "description": "Search Organizations by mCSD profile extension value",
  "expression": "Organization.extension('http://nuts.nl/fhir/StructureDefinition/mcsd-profile').value",
  "xpath": "f:Organization/f:extension[@url='http://nuts.nl/fhir/StructureDefinition/mcsd-profile']/f:valueCode",
  "xpathUsage": "normal"
}
```

This allows querying: `GET /Organization?mcsd-profile=admin`

#### Best Practices for Search Narrowing

##### Extension-Based Filtering with SearchParameters

**Recommended approach:**

1. **Define an extension** to indicate profile conformance:
   - Extension URL: `http://nuts.nl/fhir/StructureDefinition/mcsd-profile`
   - Value type: `code` or `Coding`
   - Example values: `admin` (Administration Directory), `care-services-updates`, etc.

2. **Create a SearchParameter** to make the extension searchable:
   - SearchParameter code: `mcsd-profile`
   - Type: `token`
   - Expression: `Organization.extension('http://nuts.nl/fhir/StructureDefinition/mcsd-profile').value`

3. **Use in queries**:
   - Query: `GET /Organization?mcsd-profile=admin`
   - Can be combined with other parameters: `GET /Organization?mcsd-profile=admin&active=true`

**Benefits:**
- **Explicit business meaning:** Extension values represent actual business decisions
- **Better performance:** Can be indexed by FHIR servers
- **Reliable:** Standard SearchParameter mechanism
- **Clear intent:** Extension values explicitly state business purpose (e.g., "admin" participation)
- **Portable:** Works across all FHIR servers that support custom SearchParameters

#### Implementation in Generic Proxies

The two-phase authorization approach is specifically designed to be implementable in generic reverse proxies like **HAProxy**, **NGINX**, or **Envoy**.

##### HAProxy Example Configuration

```haproxy
frontend fhir_frontend
    bind *:443 ssl crt /path/to/cert.pem

    # Extract access token from Authorization header
    http-request set-var(txn.token) req.hdr(Authorization),regsub(^Bearer[[:space:]]+,)

    # Phase 1: Token Introspection
    http-request lua.introspect_token

    # Phase 2: Search Narrowing
    http-request lua.narrow_search

    # Forward to backend with rewritten query
    use_backend fhir_backend

backend fhir_backend
    server fhir1 127.0.0.1:8080
```

**Lua Script for HAProxy:**
```lua
-- Phase 1: Introspect token (extended to get VPs)
core.register_action("introspect_token", {"http-req"}, function(txn)
    local token = txn.get_var(txn, "txn.token")

    -- Call NUTS extended introspection endpoint to get Verifiable Presentations
    local response = http_post("http://nuts:8080/internal/auth/v2/accesstoken/introspect_extended",
                               "token=" .. token,
                               {["Content-Type"] = "application/x-www-form-urlencoded"})

    -- Store introspection result (includes VPs)
    txn.set_var(txn, "txn.introspection", response)
end)

-- Phase 2: Get narrowed query
core.register_action("narrow_search", {"http-req"}, function(txn)
    local introspection = txn.get_var(txn, "txn.introspection")
    local method = txn.sf:method()
    local path = txn.sf:path()
    local query = txn.sf:query()

    -- Call NUTS search narrowing endpoint
    local request_body = json.encode({
        introspection_result = json.decode(introspection),
        http_request = {
            method = method,
            path = path,
            query_params = parse_query(query)
        }
    })

    local response = http_post("http://nuts:8080/authorization/search-narrowing",
                              request_body,
                              {["Content-Type"] = "application/json"})

    local narrowed = json.decode(response)

    if narrowed.allowed then
        -- Rewrite the request path with narrowed query
        txn.sf:req_set_uri(narrowed.rewritten_query)
    else
        -- Deny access
        txn.set_var(txn, "txn.auth_failed", "true")
        txn:done(403)
    end
end)
```

##### Benefits of Generic Proxy Implementation

1. **Separation of Concerns:** Authorization logic is centralized in the NUTS PDP
2. **Technology Agnostic:** Works with any proxy that can make HTTP calls
3. **Performance:** Caching of introspection results possible at proxy level
4. **Flexibility:** Easy to switch or upgrade proxy software
5. **Standard Protocols:** Uses OAuth 2.0 token introspection (RFC 7662)

#### API Specification

The complete OpenAPI specification for these endpoints is available here: [Care Services Proxy OpenAPI Specification](care-services-proxy-openapi.json)

#### Sequence Diagram

```
┌─────────┐         ┌───────┐         ┌──────────┐         ┌──────────┐
│ Client  │         │ Proxy │         │NUTS (PDP)│         │FHIR API  │
│         │         │ (PEP) │         │          │         │          │
└────┬────┘         └───┬───┘         └────┬─────┘         └────┬─────┘
     │                  │                  │                    │
     │ GET /Patient     │                  │                    │
     ├─────────────────>│                  │                    │
     │                  │                  │                    │
     │                  │ POST /internal/auth/v2/accesstoken/introspect_extended
     │                  ├─────────────────>│                    │
     │                  │                  │                    │
     │                  │ {active: true,   │                    │
     │                  │  vps: [...]}     │                    │
     │                  │<─────────────────┤                    │
     │                  │                  │                    │
     │                  │ POST /authorization/search-narrowing  │
     │                  ├─────────────────>│                    │
     │                  │                  │                    │
     │                  │ {allowed: true,  │                    │
     │                  │  rewritten_query}│                    │
     │                  │<─────────────────┤                    │
     │                  │                  │                    │
     │                  │ GET /Patient?_has:CareTeam:patient:participant:Practitioner.identifier=...
     │                  ├──────────────────────────────────────>│
     │                  │                  │                    │
     │                  │                  │     FHIR Bundle    │
     │                  │<──────────────────────────────────────┤
     │                  │                  │                    │
     │  FHIR Bundle     │                  │                    │
     │<─────────────────┤                  │                    │
     │                  │                  │                    │
```

#### Security Considerations

1. **mTLS Support:** The proxy should support mutual TLS when client certificates are required
2. **Token Caching:** Introspection results may be cached (respecting token expiry)
3. **Rate Limiting:** Apply rate limits to prevent abuse
4. **Audit Logging:** Log all authorization decisions and applied filters
5. **Certificate Validation:** Validate and extract properties from client certificates when present
