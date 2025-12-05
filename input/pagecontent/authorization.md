### Introduction

This FHIR Implementation Guide specifies the technical components of the Generic Function Authorization, a national initiative led by the Dutch Ministry of Health, Welfare and Sport (VWS). The GF Authorization aims to establish a standardized, interoperable system for authorizing access to data and services of healthcare organizations, enabling reliable and efficient exchange of health data across healthcare systems and organizations.

This guide outlines the data requirements and principles underlying the GF Authorization. Key design principles include:

- International standards: The solution should be based on international standards, lowering the bar for international (European) data exchange and adoption by internationally operating software vendors.
- Policy Based Access Control (PBAC) is used to control access to data. PBAC can be used for Role-Based, Attribute-Based and more complex business logic to determine access control. This enables patient-level, operation-level and/or resource-level permissions for various healthcare processes or secondary (e.g. research) use-cases.
- Stakeholder Responsibility: Healthcare providers are accountable for implementing correct authorization

By adhering to these principles, this Implementation Guide supports consistent and secure authorization, fostering improved interoperability within the healthcare ecosystem.


### Solution overview

On a high level, a data access/operation authorization starts with a request from the requesting party, for example: a practitioner requesting data. This request, along with information of the requesting party and e.g. patient consent records form the *input data* for the process. This input is *evaluated by a policy* by a responding party; this could be a data holder. The outcome is a *decision* (allow or deny). Basically: Input --> policy evaluation --> Output

Just below this top level abstraction, there's a lot more to discuss:

<img src="authorization-overview-transactions.png" width="100%" style="float: none" alt="Overview of authorization process"/>

1. Authorization policy makers create policies based on input data (data models) specified in Healthcare Information models and standards


#### Scope
GF Authorization only specifies the input-variables, policy evaluation, output-variables of the authorization decision. ***How to obtain and verify the inputs, is out-of-scope***; other pages in this IG specify the use of authoritative sources, certificates and/or verifiable credentials.


### Components (actors)

Reuse actor specification in [XACML](https://www.oasis-open.org/committees/xacml/repository/cs-xacml-specification-1.1.pdf)



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
- input:
Authorization policies SHALL be expressed in the [Rego policy language](https://www.openpolicyagent.org/docs/policy-language) to avoid semantic ambiguity and support automated testing.


#### Data user


#### Data holder
- May have recorded resource-level access for data user while sending notification (TA Notified Pull mechanism)
Implementers are not required to use the Rego-policy-language (nor the OpenID AuthZen API) in production systems, but the outcome of their authorization decisions SHALL match the outcome using the original, specified authorization policy. 


### Data models
GF Authorization uses the information model specification of [OpenID AuthZen](https://openid.net/specs/authorization-api-1_0.html). The information model for requests and responses include the following entities: Subject, Action, Resource, Context, and Decision. These are all defined below.


### Security and privacy considerations

??

### Example use cases

#### Lokalization-service authorization

example inputs

include Rego-policy

show/explain output

#### EPS request authorization

example inputs

include Rego-policy

show/explain output

### Roadmap

??
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


{
  "subject": {
    "type": "organization",
    "id": "URA|123"
    "properties": {
      "subject_id": "DEZI|002"
      "subject_organization_id": "URA|123"
      "subject_organization": "Harry Helpt"
      "subject_role": "uzirole|01.015 (huisarts)"
      "purpose_of_use": "treatment"
    }
  },
  "resource": {
    "type": "MedicationRequest",
    "properties": {
      "status": "active"
    }
  },
  "action": {
    "name": "search",
    "properties": {
      "method": "GET"
    }
  },
  "context": {
    "consent-decision": false
    "consents": [{"resourceType": "Consent", "id"...etc}]
    "time": "2025-10-26T01:22-07:00"
  }
}



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
