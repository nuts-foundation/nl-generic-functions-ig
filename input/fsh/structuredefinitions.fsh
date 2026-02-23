Profile: NlGfEndpoint
Parent: Endpoint
Id: nl-gf-endpoint
Title: "NL Generic Functions Endpoint Profile"
Description: "The technical details of an endpoint that can be used for electronic services, such as for web services providing access to FHIR resources."
* implicitRules ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Endpoint
* modifierExtension ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Endpoint
* managingOrganization 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Endpoint
* payloadType from NlGfDataExchangeCapabilitiesVS (extensible)

Extension: SupportedActivityDefinitions
Id:        supported-activity-definitions
Title:    "Supported ActivityDefinitions and PlanDefinitions by HealthcareServices"
Description: "ActivityDefinitions or PlanDefinitions to specify the codeable concepts in HealthcareService.type."
Context: HealthcareService
* value[x] only Canonical(ActivityDefinition or PlanDefinition)

Profile: NlGfHealthcareService
Parent: HealthcareService
Id: nl-gf-healthcareservice
Title: "NL Generic Functions HealthcareService Profile"
Description: "The technical details of a healthcare service that can be used in referrals, requests and orders"
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "$this"
* identifier ^slicing.rules = #open
* identifier contains
    AssignedId 1..1
* identifier[AssignedId].system 1..1
* identifier[AssignedId].value 1..1
* identifier[AssignedId].assigner 1..1
* identifier[AssignedId].assigner.identifier 1..1
* identifier[AssignedId].assigner.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[AssignedId].assigner.identifier.value 1..1
* identifier[AssignedId].assigner.identifier.type 1..1
* identifier[AssignedId].assigner.identifier.type.coding 1..1
* identifier[AssignedId].assigner.identifier.type.coding.system = $provenance-participant-type
* identifier[AssignedId].assigner.identifier.type.coding.code = #author
* implicitRules ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.HealthcareService
* modifierExtension ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.HealthcareService
* name 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.HealthcareService
* type 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.HealthcareService
* providedBy 1.. 
* specialty from http://decor.nictiz.nl/fhir/ValueSet/2.16.840.1.113883.2.4.3.11.60.121.11.22--20200901000000 (required)
* type from NlGfWlzZorgprofielenVS (required)
* type.extension contains SupportedActivityDefinitions named supportedActivityDefinitions 0..*


Profile: NlGfLocation
Parent: $NlLocation
Id: nl-gf-location
Title: "NL Generic Functions Location Profile"
Description: "Physical location details for healthcare services, organizations, and practitioners."
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "$this"
* identifier ^slicing.rules = #open
* identifier contains
    AssignedId 1..1
* identifier[AssignedId].system 1..1
* identifier[AssignedId].value 1..1
* identifier[AssignedId].assigner 1..1
* identifier[AssignedId].assigner.identifier 1..1
* identifier[AssignedId].assigner.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[AssignedId].assigner.identifier.value 1..1
* identifier[AssignedId].assigner.identifier.type 1..1
* identifier[AssignedId].assigner.identifier.type.coding 1..1
* identifier[AssignedId].assigner.identifier.type.coding.system = $provenance-participant-type
* identifier[AssignedId].assigner.identifier.type.coding.code = #author

* implicitRules ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Location
* modifierExtension ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Location
* name 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Location
* type 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Location
* status 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Location
* managingOrganization 1..


Invariant:   ura-identifier-or-partof
Description: "an Organization instance must either have an URA-identifier or must be 'partOf' some other instance that is an nl-gf-organization instance."
Expression:  "identifier.where(system='http://fhir.nl/fhir/NamingSystem/ura').exists() or partOf.exists()"
Severity:    #error

Profile: NlGfOrganization
Parent: $NlOrganization
Id: nl-gf-organization
Title: "NL Generic Functions Organization Profile"
Description: "The organizational hierarchy and details for healthcare organizations."
* obeys ura-identifier-or-partof
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "$this"
* identifier ^slicing.rules = #open
* identifier contains
    AssignedId 1..1
* identifier[AssignedId].system 1..1
* identifier[AssignedId].value 1..1
* identifier[AssignedId].assigner 1..1
* identifier[AssignedId].assigner.identifier 1..1
* identifier[AssignedId].assigner.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[AssignedId].assigner.identifier.value 1..1
* identifier[AssignedId].assigner.identifier.type 1..1
* identifier[AssignedId].assigner.identifier.type.coding 1..1
* identifier[AssignedId].assigner.identifier.type.coding.system = $provenance-participant-type
* identifier[AssignedId].assigner.identifier.type.coding.code = #author
* implicitRules ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Organization
* modifierExtension ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Organization
* name 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Organization
* type 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Organization

Profile: NlGfOrganizationLRZA
Parent: $NlOrganization
Id: nl-gf-organization-lrza
Title: "NL Generic Functions Organization Profile"
Description: "The organizational hierarchy and details for healthcare organizations."
* obeys ura-identifier-or-partof
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "$this"
* identifier ^slicing.rules = #open
* identifier contains
    AssignedId 1..1
* identifier[AssignedId].system 1..1
* identifier[AssignedId].value 1..1
* identifier[AssignedId].assigner 1..1
* identifier[AssignedId].assigner.identifier 1..1
* identifier[AssignedId].assigner.identifier.system = "http://fhir.nl/fhir/NamingSystem/kvk"
* identifier[AssignedId].assigner.identifier.value 1..1
* identifier[AssignedId].assigner.identifier.type 1..1
* identifier[AssignedId].assigner.identifier.type.coding 1..1
* identifier[AssignedId].assigner.identifier.type.coding.system = $provenance-participant-type
* identifier[AssignedId].assigner.identifier.type.coding.code = #author
* implicitRules ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Organization
* modifierExtension ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Organization
* name 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Organization
* type 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Organization


Profile: NlGfOrganizationAffiliation
Parent: OrganizationAffiliation
Id: nl-gf-organizationaffiliation
Title: "NL Generic Functions OrganizationAffiliation Profile"
Description: "The details of an affiliation/relationship between two organizations, such as a healthcare provider and a software vendor."
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "$this"
* identifier ^slicing.rules = #open
* identifier contains
    AssignedId 1..1
* identifier[AssignedId].system 1..1
* identifier[AssignedId].value 1..1
* identifier[AssignedId].assigner 1..1
* identifier[AssignedId].assigner.identifier 1..1
* identifier[AssignedId].assigner.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[AssignedId].assigner.identifier.value 1..1
* identifier[AssignedId].assigner.identifier.type 1..1
* identifier[AssignedId].assigner.identifier.type.coding 1..1
* identifier[AssignedId].assigner.identifier.type.coding.system = $provenance-participant-type
* identifier[AssignedId].assigner.identifier.type.coding.code = #author
* implicitRules ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.OrganizationAffiliation
* modifierExtension ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.OrganizationAffiliation
* active 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.OrganizationAffiliation
* organization 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.OrganizationAffiliation
* participatingOrganization 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.OrganizationAffiliation
* network 0.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.OrganizationAffiliation
* code 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.OrganizationAffiliation




Profile: NlGfPractitioner
Parent: $NlPractitioner
Id: nl-gf-practitioner
Title: "NL Generic Functions Practitioner Profile"
Description: "The details of a healthcare practitioner, such as a doctor or nurse, who is directly or indirectly involved in the provisioning of healthcare."
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "$this"
* identifier ^slicing.rules = #open
* identifier contains
    AssignedId 1..1
* identifier[AssignedId].system 1..1
* identifier[AssignedId].value 1..1
* identifier[AssignedId].assigner 1..1
* identifier[AssignedId].assigner.identifier 1..1
* identifier[AssignedId].assigner.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[AssignedId].assigner.identifier.value 1..1
* identifier[AssignedId].assigner.identifier.type 1..1
* identifier[AssignedId].assigner.identifier.type.coding 1..1
* identifier[AssignedId].assigner.identifier.type.coding.system = $provenance-participant-type
* identifier[AssignedId].assigner.identifier.type.coding.code = #author
* implicitRules ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Practitioner
* modifierExtension ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Practitioner
* name 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Practitioner


Profile: NlGfPractitionerRole
Parent: $NlPractitionerRole
Id: nl-gf-practitionerrole
Title: "NL Generic Functions PractitionerRole Profile"
Description: "The details of a healthcare practitioner's role within an organization."
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "$this"
* identifier ^slicing.rules = #open
* identifier contains
    AssignedId 1..1
* identifier[AssignedId].system 1..1
* identifier[AssignedId].value 1..1
* identifier[AssignedId].assigner 1..1
* identifier[AssignedId].assigner.identifier 1..1
* identifier[AssignedId].assigner.identifier.system = "http://fhir.nl/fhir/NamingSystem/ura"
* identifier[AssignedId].assigner.identifier.value 1..1
* identifier[AssignedId].assigner.identifier.type 1..1
* identifier[AssignedId].assigner.identifier.type.coding 1..1
* identifier[AssignedId].assigner.identifier.type.coding.system = $provenance-participant-type
* identifier[AssignedId].assigner.identifier.type.coding.code = #author
* implicitRules ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.PractitionerRole
* modifierExtension ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.PractitionerRole
* practitioner 1..
* organization 1..
* code 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.PractitionerRole


Extension: TaskSTU3Location
Id:        task-stu3-location
Title:    "Location for Task in STU3"
Description: "The location where the task is performed."
* value[x] only Reference(NlGfLocation)

Extension: TaskSTU3HealthcareService
Id:        task-stu3-healthcareservice
Title:    "HealthcareService for Task in STU3"
Description: "The healthcare service where the task is performed."
* value[x] only Reference(NlGfHealthcareService)

Profile: NlGfTaskSTU3
Parent: Task
Id: nl-gf-task-stu3
Title: "NL Generic Functions Task Profile for FHIR STU3"
Description: "A task to be performed, such as a referral or order, with additional details specific to FHIR STU3."
* extension contains TaskSTU3Location named taskLocation 0..1
* extension contains TaskSTU3HealthcareService named healthcareservice 0..1