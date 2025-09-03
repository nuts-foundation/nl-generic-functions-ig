Extension: ReplacedByEndpoint
Id:        replaced-by-endpoint
Title:    "Replaced By Endpoint"
Description: "Points to a new (updated) Endpoint. This can be used if this endpoint.address is (partially) replaced by a new one"
Context: Endpoint
* value[x] only Reference(Endpoint)

Invariant:   address-immutable
Description: "This address field must not be updated after creation of the Endpoint instance"
// Expression:  "address = %previous.address"
Severity:    #error

Profile: NlGfEndpoint
Parent: Endpoint
Id: nl-gf-endpoint
Title: "NL Generic Functions Endpoint Profile"
Description: "The technical details of an endpoint that can be used for electronic services, such as for web services providing access to FHIR resources."
* ^experimental = true
* extension contains ReplacedByEndpoint named replacedBy 0..*
* implicitRules ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Endpoint
* modifierExtension ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Endpoint
* managingOrganization 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Endpoint
* payloadType from NLGfPayloadTypes
* address obeys address-immutable



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
* implicitRules ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.HealthcareService
* modifierExtension ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.HealthcareService
* name 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.HealthcareService
* type 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.HealthcareService
* providedBy 1.. 
* specialty from http://decor.nictiz.nl/fhir/ValueSet/2.16.840.1.113883.2.4.3.11.60.121.11.22--20200901000000 (required)
// * specialty from SpecialtyType
* type from http://decor.nictiz.nl/fhir/ValueSet/2.16.840.1.113883.2.4.3.11.60.121.11.19--20200901000000 (required)
* type.extension contains SupportedActivityDefinitions named supportedActivityDefinitions 0..*




Profile: NlGfLocation
Parent: Location
Id: nl-gf-location
Title: "NL Generic Functions Location Profile"
Description: "Physical location details for healthcare services, organizations, and practitioners."
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
Parent: Organization
Id: nl-gf-organization
Title: "NL Generic Functions Organization Profile"
Description: "The organizational hierarchy and details for healthcare organizations."
* obeys ura-identifier-or-partof
* implicitRules ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Organization
* modifierExtension ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Organization
* name 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Organization
* type 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Organization
* partOf only Reference(NlGfOrganization)




Profile: NlGfOrganizationAffiliation
Parent: OrganizationAffiliation
Id: nl-gf-organizationaffiliation
Title: "NL Generic Functions OrganizationAffiliation Profile"
Description: "The details of an affiliation/relationship between two organizations, such as a healthcare provider and a software vendor."
* implicitRules ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.OrganizationAffiliation
* modifierExtension ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.OrganizationAffiliation
* active 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.OrganizationAffiliation
* organization 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.OrganizationAffiliation
* participatingOrganization 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.OrganizationAffiliation
* network 0.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.OrganizationAffiliation
* code 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.OrganizationAffiliation




Profile: NlGfPractitioner
Parent: Practitioner
Id: nl-gf-practitioner
Title: "NL Generic Functions Practitioner Profile"
Description: "The details of a healthcare practitioner, such as a doctor or nurse, who is directly or indirectly involved in the provisioning of healthcare."
* implicitRules ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Practitioner
* modifierExtension ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Practitioner
* name 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.Practitioner




Profile: NlGfPractitionerRole
Parent: PractitionerRole
Id: nl-gf-practitionerrole
Title: "NL Generic Functions PractitionerRole Profile"
Description: "The details of a healthcare practitioner's role within an organization."
* implicitRules ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.PractitionerRole
* modifierExtension ..0 //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.PractitionerRole
* practitioner 1..
* organization 1..
* code 1.. //compliance to https://profiles.ihe.net/ITI/mCSD/StructureDefinition/IHE.mCSD.PractitionerRole





Profile: NlGfPatientCareTeam
Parent: CareTeam
Id: nl-gf-patient-careteam
Title: "NL Generic Functions CareTeam Profile for Patient Care Team"
Description: "A care team for a (single)patient with multiple care providers and/or care givers."
* subject only Reference(Patient)
* subject 1..1
* participant.period.start 1..1
* participant.period.end 0..1


// Profile: GFDLEpisodeOfCare
// Parent: EpisodeOfCare
// Title: "Generic Functions, Data Localization: EpisodeOfCare Profile"
// Description: "An episode of care for tracking the involvement of healthcare organizations in patient care, categorized by medical specialty or department."
// Id: GFDLEpisodeOfCare
// * ^url = "https://example.org/fhir/StructureDefinition/MyEpisodeOfCare"
// * ^status = #draft
// * type 1..1
// * type from GFDLMedicalSpecialtyVS (required)
// * type ^short = "Medical specialty or department"
// * type ^definition = "The medical specialty or department providing care during this episode"
// * patient.identifier 1..
// * patient.identifier.system 1..
// * patient.identifier.system = "http://fhir.nl/fhir/NamingSystem/bsn" (exactly)
// * patient.identifier.system ^short = "PatientIdentificationNumber"
// * patient.identifier.system ^definition = "The patient’s identification number. In transfer situations, use of the social security number (BSN) must comply with the Use of Social Security Numbers in Healthcare Act (Wbsn-z). In other situations, other number systems can be used, such as internal hospital patient numbers for example."
// * patient.identifier.value 1..
// * managingOrganization 1..
// * period 1..

// ValueSet: GFDLTaskStatus
// Id: gfdl-episodeofcare-status
// Title: "Generic Functions, Data Localization: EpisodeOfCare Status"
// * ^compose.include.valueSet = "http://hl7.org/fhir/ValueSet/episode-of-care-status"
// // Exclude the specific code "planned" from EpisodeOfCareStatus
// * ^compose.exclude[+].system = "http://hl7.org/fhir/episode-of-care-status"
// * ^compose.exclude.concept[+].code = #planned
// * ^compose.exclude.concept[+].code = #waitlist
// * ^compose.exclude.concept[+].code = #onhold

// CodeSystem: GFDLMedicalSpecialtyCS
// Id: gfdl-medical-specialty
// Title: "Generic Functions, Data Localization: Medical Specialty CodeSystem"
// Description: "Code system for medical specialties and departments used in NVI"
// * ^status = #draft
// * ^caseSensitive = true
// * #cardiology "Cardiology" "Department of Cardiology"
// * #internal-medicine "Internal Medicine" "Department of Internal Medicine"
// * #surgery "Surgery" "Department of Surgery"
// * #orthopedics "Orthopedics" "Department of Orthopedics"
// * #psychiatry "Psychiatry" "Department of Psychiatry"
// * #neurology "Neurology" "Department of Neurology"
// * #pediatrics "Pediatrics" "Department of Pediatrics"
// * #obstetrics-gynecology "Obstetrics & Gynecology" "Department of Obstetrics and Gynecology"
// * #radiology "Radiology" "Department of Radiology"
// * #anesthesiology "Anesthesiology" "Department of Anesthesiology"
// * #emergency-medicine "Emergency Medicine" "Department of Emergency Medicine"
// * #family-medicine "Family Medicine" "Department of Family Medicine"
// * #ophthalmology "Ophthalmology" "Department of Ophthalmology"
// * #dermatology "Dermatology" "Department of Dermatology"
// * #oncology "Oncology" "Department of Oncology"
// * #geriatrics "Geriatrics" "Department of Geriatrics"
// * #rehabilitation "Rehabilitation Medicine" "Department of Rehabilitation Medicine"
// * #intensive-care "Intensive Care" "Intensive Care Unit"
// * #general-practice "General Practice" "General Practitioner"

// ValueSet: GFDLMedicalSpecialtyVS
// Id: gfdl-medical-specialty-vs
// Title: "Generic Functions, Data Localization: Medical Specialty ValueSet"
// Description: "Value set for medical specialties and departments used in NVI"
// * ^status = #active
// * include codes from system GFDLMedicalSpecialtyCS

