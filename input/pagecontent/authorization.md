### Introduction

This FHIR Implementation Guide specifies the technical components of the Generic Function Authorization, a national initiative led by the Dutch Ministry of Health, Welfare and Sport (VWS). The GF Authorization aims to establish a standardized, interoperable system for authorizing access to data and services of healthcare organizations, enabling reliable and efficient exchange of health data across healthcare systems and organizations.

This guide outlines the data requirements and principles underlying the GF Authorization. Key design principles include:

- International standards: The solution should be based on international standards, lowering the bar for international (European) data exchange and adoption by internationally operating software vendors.
- Policy Based Access Control (PBAC) is used to control access to data. PBAC can be used for Role-Based, Attribute-Based and more complex business logic to determine access control. This enables patient-level, operation-level and/or resource-level permissions for various healthcare processes or secondary (e.g. research) use-cases.
- Stakeholder Responsibility: Healthcare providers are accountable for implementing correct authorization

By adhering to these principles, this Implementation Guide supports consistent and secure authorization, fostering improved interoperability within the healthcare ecosystem.
<!--  pfor policy makers -->

### Solution overview

On a high level, a data access/operation authorization starts with a request from the requesting party, for example: a practitioner requesting data. This request, along with information of the requesting party and e.g. patient consent records form the *input data* for the process. This input is *evaluated by a policy* by a responding party; this could be a data holder. The outcome is a *decision* (allow or deny). Basically: Input --> policy evaluation --> Output

Just below this top level abstraction, there's a lot more to discuss:

<img src="authorization-overview-transactions.png" width="100%" style="float: none" alt="Overview of authorization process"/>

1. Authorization policy makers create authorization policies based on attributes specified in Healthcare Information models and standards. These attributes can be certain identifiers (BSN, URA, etc.), entity characteristics (organization type, practitioner role), permission records (qualifications, consent) and/or specified operations or capability statements for requesting and responding party
2. Requesting and responding parties need to acquire attributes (data) from authoritative data sources. When to get this data is not specified here. A (PKIoverheid) certificate from a Trust Service Provider may be fetched one a year, a CiBG-DeZI-token may be fetched when a practitioner starts his/her shift and a VZVZ Mitz patient consent may be fetched, by the responding party, just after receiving a data request.
3. The requesting party can now create a request and send it to the responding party along with 'claims'; statement on the e.g. identity or characteristics of the requesting party. The responding party may add additional claims or attributes, for example, a local patient consent and/or the VZVZ Mitz consent preference.
4. The request and all claims/attributes are input for the authorization policy. The input is evaluated against the policy. The outcome is a decisions if the request is allowed or denied.  


#### Scope
GF Authorization only specifies the input-variables, policy evaluation and output-variables of the authorization decision. ***How to obtain and verify the inputs, is out-of-scope***; other pages in this IG specify the use of authoritative sources, certificates and/or verifiable credentials. Execution of the request and architectural design (e.g. Policy Enforcement Point or AAA-proxies) are also out of scope. 


### Components (actors)

This IG distinguishes 4 categories of actors:
1. Authoritative data sources
1. Autorization policy makers
1. Requesting party (Data user)
1. Responding party (Data holder)

The role of these actors can be explained in [XACML](https://www.oasis-open.org/committees/xacml/repository/cs-xacml-specification-1.1.pdf) terms. We'll not go into this here, but XACML-roles are added in the [solution overview](#solution-overview) figure.


#### Authoritative data sources

**Trust Service Provider Certificates**: 
PKIoverheid certificates. Used to identify the organization operating the client or server of data user or data holder. 

**CiBG-DeZI**: 
- Used to identify the practitioner and care provider
- Role of the Practitioner. Uses (indirectly) the BIG-register as data source

**CiBG-LRZa**:
- Registry of care providers and their care service directory endpoint-urls

**Care service directories**:
- Can data holder handle my request? 
- Endpoint-url of data holder

**SBV-Z**:
- Used to check the identity (BSN) of the patient

**Vektis Organization type**:
- Vektis is the source of the care provider type. A care provider can be one or more types. For example: a pharmacy, hospital, general practitioner, care at home, etc.

**VZVZ Mitz**:
- Patient Consent preference registry

**NictiZ Qualifications**:
- Is data user (care provider and software) qualified for the request? This source claims the data user to be abled to use some CapabilityStatements from NictiZ Healthcare Information standards. The request should be in scope of the CapabilityStatements.

**NictiZ Healthcare Information standards**:
Healthcare Information standards define which operations a data user or data holder should use/support. These standards also define HealthCare Information Models (HCIM's) and therefore which data labels, codes or categories can be used in policies. 

#### Autorization policy makers
Authorization policies SHALL be expressed in the [Rego policy language](https://www.openpolicyagent.org/docs/policy-language) to avoid semantic ambiguity and support automated testing.
<!-- publishing policies, policies should be merged without negotiation... Legislation is always input-->

#### Requesting party (Data user)
Creates a request, adds necessary attributes/claims about itself and sends it to the responding party 

#### Responding party (Data holder)
Acquires attributes/claims about requesting party and e.g. the patient consent. Evaluates the request.
May have recorded resource-level access for data user while sending notification (TA Notified Pull mechanism)
Implementers are not required to use the Rego-policy-language (nor the OpenID AuthZen API) in production systems, but the outcome of their authorization decisions SHALL match the outcome using the original, specified authorization policy. 


### Data models
GF Authorization uses the information model specification of [OpenID AuthZen](https://openid.net/specs/authorization-api-1_0.html). The information model for requests and responses include the following entities: Subject, Action, Resource, Context, and Decision. The use of this information model is illustrated by an example of a data user searching for active MedicationRequests for a patient.

#### Subject
This is the principle requesting the data. Attributes may come from Identity Providers (CiBG DeZI) and or (client-)certificates. Attributes:

- `type`: **NOTE TO REVIEWER/EDITOR: to be specified (required by Authorization API spec). Currently not used by Knooppunt PDP.**
- `id`: **NOTE TO REVIEWER/EDITOR: to be specified (required by Authorization API spec). Currently not used by Knooppunt PDP.**
- `properties`: this map contains at least the following attributes, but may be extended with other attributes required by the policy:
    - `client_id`: value identifying the application of the requester, e.g. `client_id` of the OAuth2-client.
    - `client_qualifications`: array of strings of data exchanges the client is qualified for.
    - `subject_id`: identifier of the practitioner (CiBG Dezi-nummer/UZI)
    - `subject_organization_id`: identifier of the organization of the practitioner (URA)
    - `subject_organization`: name of the organization of the practitioner
    - `subject_role`: array of strings indicating the roles of the practitioner (from CiBG Dezi / BIG-register)
    - `subject_facility_type`: type of the organization of the practitioner (Vektis)

#### Resource
This is the requested data. Attributes are typically from the request URL and request parameters (e.g. FHIR search parameters).

**NOTE TO REVIEWER/EDITOR: `action.fhir_rest` communicates similar information, should these 2 converge? Knooppunt PDP currently only uses `resource.type`**

- `type`: the type of the resource, for example 'MedicationRequest'
- `id`: the identifier of the resource, for example the FHIR Patient resource ID from the request URL.
- `properties`: **NOTE TO REVIEWER/EDITOR: to be specified**

#### Action
The action performed by the request. For example 'GET' (read/search), 'POST' (create) , 'PUT' (update).

It contains information about the request, and a parsed representation of the request if supported by this IG.
Policy writers are encouraged to use the connection type-specific properties, e.g. `fhir_rest.search_params` over `request.query_params`.

- `name`: the name of the action, for example 'search'. **NOTE TO REVIEWER/EDITOR: Currently not used by Knooppunt PDP.**
- `connection_type_code` (required): indicates the type of the connection. Policy writers are encouraged to use the [HL7 EndpointConnectionType](http://terminology.hl7.org/CodeSystem/endpoint-connection-type) code system whenever applicable. 
  The informs the policy engine on how to interpret the request.
- `request`:
  - `protocol` (required): the protocol of the request, for `HTTP/1.1`.
  - `method` (required): the HTTP method of the request, for example 'GET', 'POST', 'PUT', etc.
  - `path` (required): the path of the request, for example `/MedicationRequest`.
  - `query_params`: a map of string arrays containing the query parameters of the request.
  - `header`: a map of string arrays containing the header parameters of the request.
  - `body`: base64 encoded body of the request, for example for a FHIR resource creation or update.
- `fhir_rest`: if the request is a HL7 FHIR REST request, the following properties apply:
  - `capability_checked`: a boolean indicating whether the interaction is allowed by the associated FHIR CapabilityStatement. **NOTE TO REVIEWER/EDITOR: Move CapabilityStatement to actual policy, instead of being policy input?**
  - `interaction_type`: a string indicating the type of FHIR interaction, for example `read`, `search-type`, `create`, `update`, etc.
  - `operation`: a string indicating the FHIR operation, for example `Patient-everything`. Only applicable if `interaction_type` is `operation`.
  - `search_params`: a map of string arrays containing the FHIR search parameters of the request, for example `{"status": ["active"], "patient": ["Patient/90546b0d-e323-47f3-909b-fb9504859f7b"]}`.
  - `include`: an array of strings containing the FHIR `_include` parameters of the request, for example `["MedicationRequest:medication"]`.
  - `revinclude`: an array of strings containing the FHIR `_revinclude` parameters of the request, for example `["Provenance:target"]`.

For requests that are scoped to a patient, `patient_bsn` and/or `patient_id` MUST be provided.
They are typically derived from the request (e.g. FHIR search parameter `patient` or `identifier`).
They could also be sourced from the authentication token, or be looked up in the EHR if only `patient_id` was provided in the request, and the policy requires the `patient_bsn` for the Mitz consent check.

#### Context
Other input for the policy evaluation is added to the context.

- `context`:
  - `data_holder_facility_type`: a string indicating the type of the organization of the data holder (Vektis), e.g. `Z3`.
  - `data_holder_organization_id`: a string indicating the identifier of the organization of the data holder (URA), e.g. `123`.
  - `patient_bsn`: a string indicating the BSN (identifier) of the patient.
  - `patient_id`: a string uniquely identifying the patient in the system of the data holder, for example the FHIR Patient resource ID.
  - `mitz_consent` a boolean indicating whether the Mitz consent check allows sharing the data.
  - `purpose_of_use`: a string indicating the purpose of use of the request. **NOTE TO REVIEWER/EDITOR: Currently not used by Knooppunt PDP.**

#### Example of a HL7 FHIR search request

```
{
  "subject": {
    "type": "organization",
    "id": "URA|123",
    "properties": {
      "client_id": "cee473c4-d9be-487b-b719-f552189d5891",
      "client_qualifications": ["http://nictiz.nl/fhir/CapabilityStatement/mp-MedicationData.RetrieveServe","http://nictiz.nl/fhir/CapabilityStatement/bgz2017-servercapabilities","Twiin-TA-notification"],
      "subject_id": "900000009",
      "subject_organization_id": "87654321",
      "subject_organization": "Harry Helpt",
      "subject_role": ["01.041", "30.000", "01.010", "01.011"],
      "subject_facility_type": "Z3"
    }
  },
  "resource": {
    "type": "MedicationRequest",
    "properties": {
      "status": "active",
    }
  },
  "action": {
    "name": "search",
    "connection_type_code": "hl7-fhir-rest",
    "request": {
      "protocol": "HTTP/1.1",
      "method": "GET",
      "path": "/MedicationRequest",
      "query_params": {
        "status": ["active"],
        "patient": ["Patient/90546b0d-e323-47f3-909b-fb9504859f7b"]
      },
      "header": {
        "Accept": ["application/fhir+json"]
      }
    },
    "fhir_rest": {
      "capability_checked": true,
      "interaction_type": "search-type",
      "search_params": {
        "status": ["active"],
        "patient": ["Patient/90546b0d-e323-47f3-909b-fb9504859f7b"]
      }
    },
    "properties": {
      "method": "GET"
    }
  },
  "context": {
    "data_holder_facility_type": "Z3",
    "data_holder_organization_id": "URA|123",
    "patient_bsn": "123456789",
    "patient_id": "90546b0d-e323-47f3-909b-fb9504859f7b",
    "mitz_consent": true,
    "purpose_of_use": "treatment"
  }
}
```

**NOTE TO REVIEWER/EDITOR: Add more examples**

### Security and privacy considerations
--TODO

### Example use cases

### Advanced Care Planning (ACP) / Proactieve ZorgPlanning (PZP)

The following policy allows the following FHIR requests, if the patient gave consent in Mitz:
- `GET [base]/Patient?identifier=http://fhir.nl/fhir/NamingSystem/bsn|{context.patient_bsn}`
- `GET [base]/Consent?patient=Patient/{context.patient_id}&scope=http://terminology.hl7.org/CodeSystem/consentscope|treatment&category=http://snomed.info/sct|129125009`

```
package pzp_gf

import rego.v1

#
# This file implements the FHIR queries for PZP/ACP (Proactieve ZorgPlanning)
# as specified by https://wiki.nuts.nl/books/pzp/page/pzp-volume-3-content
#

default allow := false
allow if {
    patient_gave_mitz_consent
    is_allowed_query
}

default patient_gave_mitz_consent := false
patient_gave_mitz_consent if {
    input.context.mitz_consent == true
}

# GET [base]/Patient?identifier=http://fhir.nl/fhir/NamingSystem/bsn|{value}
default is_allowed_query := false
is_allowed_query if {
    input.resource.type == "Patient"
    input.action.fhir_rest.interaction_type == "search-type"
    # identifier: exactly 1 identifier of type BSN
    is_string(input.action.fhir_rest.search_params.identifier)
    startswith(input.action.fhir_rest.search_params.identifier, "http://fhir.nl/fhir/NamingSystem/bsn|")
}

# GET [base]/Consent?patient={reference}&scope=http://terminology.hl7.org/CodeSystem/consentscope|treatment&category=http://snomed.info/sct|129125009
is_allowed_query if {
    input.resource.type == "Consent"
    input.action.fhir_rest.interaction_type == "search-type"
    # patient: reference Patient resource
    startswith(input.action.fhir_rest.search_params.patient, "Patient/")
    input.action.fhir_rest.search_params.scope == "http://terminology.hl7.org/CodeSystem/consentscope|treatment"
    input.action.fhir_rest.search_params.category == "http://snomed.info/sct|129125009"
}
```

--TODO
<!-- #### Lokalization-service authorization

example inputs

include Rego-policy

show/explain output

#### EPS request authorization

example inputs

include Rego-policy

show/explain output -->

### Roadmap
--TODO

<!-- 
comments meeting 24-nov 14:00:

Aandachtspunten

- Policy maker must use REGO
- how does TANP fit in?
- geen architectuurkeuzes voorschrijven: b.v. term PDP niet noemen

Houd rekening met verschillende lezers:
- policy makers
- PEP -implementers
- vendors (die integratiewerk moeten verrichten om extra inputs op te halen en te verifieren)

- beschrijf: waar verwachten we welke input?
Welke inputs zijn er mogelijk?
Waar kan je die inputs in de request verwachten? -->




<!-- The Shared Care Planning (SCP) authorization model is based on the authority of the Care Plan Service (CPS). This service maintains the Care Plan and is responsible for all the due diligence that is required to build up the required trust for all Care Plan Contributors (CPC) in the network.

### Scope of the care plan

#### Bound to the patient
A Care Plan is bound to a patient, and no more than one patient. A Care Plan (CP)  has one single Care Team (CT). Therefore, in CSP the terms Care Plan and Care Team are somewhat interchangeable. 

#### Owned by the Plan Service (CPS)
A Care Plan is created by the Care Plan Service as the owner of a CarePlan. As the care network of the Patient grows, more organization become part of the Care Team
```asciidoc
     ┌───────┐                          
     │Patient│                          
     └───┬───┘                          
         │                              
         │                              
     ┌───┴────┐                         
     │CarePlan┼───────────┬────────┐    
     └───┬────┘           │        │    
         │CPS             │CPC     │CPC 
         │                │        │    
┌────────┴─────────┐ ┌────┴───┐ ┌──┴───┐
│General Practioner│ │Hospital│ │Physio│
└──────────────────┘ └────────┘ └──────┘
```
### A single context of care
A Care Plan is bound to one single context, in the sense that, CSP assumes that all members of the CT are always allowed to access all relevant data. In the case they are not allowed to access all relevant data, they should not be part of the CT. This that case, a different CP should be created. If a patient is referred to another organization that should not have access to all relevant data of the patient, another (nested) CP should be created.

```AsciiDoc
        ┌───────┐                          
┌───────┼Patient│                          
│       └───┬───┘                          
│           │                              
│           │                              
│       ┌───┴────┐                         
│       │CarePlan┼───────────┬────────┐    
│       └───┬────┘           │        │    
│           │CPS             │CPC     │CPC 
│           │                │        │    
│  ┌────────┴─────────┐ ┌────┴───┐ ┌──┴───┐
│  │General Practioner│ │Hospital│ │Physio│
│  └──────────────────┘ └────┬───┘ └──────┘
│                            │             
│                            │CPS          
│                            │             
│                    ┌───────┴───────┐     
└────────────────────┼Nested CarePlan│     
                     └───────┬───────┘     
                             │             
                             │CPC          
                      ┌──────┴──────┐      
                      │Mental health│      
                      │care provider│      
                      └─────────────┘      
```

### Model of Patients' consent
New members can only be added to the Care Team of the Care Plan by with explicit consent of the Patient. This responsibility lies with the Care Plan Service. The CPS must be able to contact the Patient and handle the proces of requesting consent. The same goes for Care Plan Contributors that enter a Care Team with existing data; those must verify with the Patient that the existing data is being shared within the context of the Care Plan and Care Team.

### Methods of Patients' consent
The methods of consent must be either in physical interaction with the Patient (at the desk), by physical channels such as mail or with digital methods such as e-mail or SMS notifications to digital consent forms protected by contemporary authentication methods that are already in place.     

#### (Lack of) cryptographic consent
In the current authentication landscape of the Netherlands, cryptographic proof of end-user consent is not in sight on the short term. The solution we propose is based on a) consent of the user and b) the due-diligence of the CPS and the CPC in some cases. We choose not to put the emphasis on capturing proof of consent with cryptographic methods, knowing that such technology will eventually become part of the EU Digital Identity Wallet infrastructure signing function. 

### Authentication of Organizations
Organizations are authenticated by their X509 Certificate, that is used to sign a X509Credential. This ensures the identity of the health care organizations in Shared Care Planning.


### CPS Responsibilities
The Care Plan Service (SCP) has the role of maintaining the Care Plan and acts as gatekeeper for the Care Plan and Care Team for the Patient. The SCP may only add members to the Care Team with the explicit consent of the user. The CPS may keep track of the consent using the FHIR Consent resources, but is not required to do so.

### CPC Responsibilities
The Care Plan Contributor (CPC) only needs to get consent of the Patient when it links pre-existing data of the Patient to the context of the CarePlan. In that case, the CPC must contact the Patient and is required to get consent for sharing the data.

### The CPS expansion and consent flow

The core flow of consent works a follows:
* A Task is created for a new CPC and that CPC is notified about the Task. Both the CPS or CPC roles can do this. The CPC can either be the initiator of recipient of the Task.
* The CPC either accepts or rejects the Task without knowing the patient.
* The CPS is notified about the accepted Task.
* The CPS contacts the Patient about the new CPC and gets consent on expanding the Care Team.
* The CPS expands the Care Team and notifies the new CPC about the updated CareTeam.
* The new CPC now can fetch the details of the Patient.
* (optional) The CPC can determine the pre-existing data about the patient exists in the system and that this data will be shared within the context of the Care Team. In that case, consent of the patient must be acquired.

#### A more complicated example
{::nomarkdown}
{% include authorization.svg %}
{:/}

The provided **sequence diagram** illustrates the process of adding three external systems (*OLVG*, *Geboortezorg*, and *Fysio*) to a patient's care team. The interactions are handled by the control system (*Huisarts*) and involve patient approval at various stages.

---

## Key Components in the Diagram:

1. **Actors and Entities:**
   - **Patient:** The individual whose care team is being managed.
   - **Huisarts (CPS):** A CPS responsible for the care team management.
   - **OLVG (CPC):** An CPC being added to the care team.
   - **Geboortezorg (CPC):** Another CPC being added.
   - **Fysio (CPC):** A third CPC being added to the care team.

2. **Groups:**  
Each step in the process is organized into groups that represent the task of adding a organization to the care team (*OLVG*, *Geboortezorg*, and *Fysio*).

---

## Process Steps:

### Step 1: Adding **"OLVG"** to the CareTeam
- **Huisarts (CPS) initiates a task** with the *OLVG* system (**CPC**).
- *OLVG* accepts the task and **notifies the Huisarts (CPS)**.
- **The Huisarts (CPS) consults the patient** for approval by sending an consent request.
- Upon patient consent:
  - **The Huisarts (CPS) updates the care team** to include *OLVG*.
  - **The Huisarts (CPS) notifies the OLVG system** of the update.
- *OLVG* then **fetches the patient's details**.

---

### Step 2: Adding **"Geboortezorg"** to the CareTeam
- A new addition starts from *OLVG* (**CPC**), which triggers a task for *Geboortezorg* (**CPC**).
- *Geboortezorg* accepts the task, notifies *OLVG*, and *OLVG* subsequently **notifies the Huisarts (CPS)**.
- **The Huisarts (CPS) consults the patient** for their consent.
- Upon patient consent:
  - **Huisarts (CPS) updates the care team** to include *Geboortezorg*.
  - Notifications are sent to both *OLVG* and *Geboortezorg*.
- *Geboortezorg* **fetches the patient's details** at the Huisarts (CPS).
- If the patient has **existing data**, an additional **consent is required** from the patient. Upon consent, the existing data is handled accordingly.

---

### Step 3: The patient goes to the **Fysio** and names **OLVG**
- *Fysio* (**CPC**) triggers a task for *OLVG* (**CPC**).
- *OLVG* accepts the task, sets the `basedOn` value of the Task to the Care Plan of the CPS and **notifies the Huisarts (CPS)**.
- **The Huisarts (CPS) consults the patient** for consent.
- Upon patient consent:
  - **The Huisarts (CPS) updates the care team** to include *Fysio*.
  - The Huisarts (CPS) sends **notifications to all involved systems** (*OLVG*, *Geboortezorg*, and *Fysio*).
- *Fysio* fetches **the patient's details** from the Huisarts (CPS).
- Additionally:
  - *Fysio* requests **data from *OLVG***.
  - *OLVG* performs an **internal check (CareTeam)** and shares the required **data back to *Fysio***.


### Main advantages of this approach
#### Distributed
As soon as an organization gets assigned a task that is part of SCP, the task refers to the Care Plan with the `basedOn` value. The Care Plan becomes discoverable and the roles in the SCP are implicitly determined by the ownership of the Care Plan. The CPS is the organization hosting the FHIR resource, all the other members are CPC in the Care Plan.

#### Specific
Consent is acquired on adding an organization or existing data to a care plan, and not at forehand. -->
