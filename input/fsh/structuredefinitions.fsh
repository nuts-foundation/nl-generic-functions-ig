Profile: SCPCareplan
Parent: CarePlan
Title: "Shared Care Planning: CarePlan Profile"
Description: "A care plan for a patient that is shared between multiple care providers."
* category = $sct#135411000146103 // Multidisciplinary care regime
* subject only Reference(Patient)
* subject 1..1
* careTeam only Reference(CareTeam)
* careTeam 1..1
* author only Reference(PractitionerRole)
* author 1..1
* contained only CareTeam
* contained 1..1


// Profile: SCPCareTeam
// Parent: CareTeam
// Title: "Shared Care Planning: CareTeam Profile"
// Description: "A care team for a patient that is shared between multiple care providers."
// * subject only Reference(Patient)
// * subject 1..1
// * participant.member 1..1
// * participant.period.start 1..1
// * participant.period.end 0..1


Profile: SCPTask
Parent: Task
Title: "Shared Care Planning: Task Profile"
Description: "A task for a patient that is shared between multiple care providers."
* ^status = #draft
* ^experimental = true
* basedOn only Reference(SCPCareplan)
* basedOn MS
* status from SCPTaskStatus (required)
//rule: only if focal-resource is of type Questionnaire, state-transistion request->completed is allowed
* focus MS
* for only Reference(Patient)
* for 1..1
* requester.identifier.system 1..1
* requester.identifier.value 1..1
* owner.identifier.system 1..1
* owner.identifier.value 1..1


Instance: ActivityDefinition-SCPTask
InstanceOf: ActivityDefinition
Usage: #definition
* meta.tag = $FHIR-version#4.0.1
* url = "http://santeonnl.github.io/shared-care-planning/ActivityDefinition/SCPTask.json"
* name = "activitydefinition-scp-task"
* status = #active
* version = "0.1"
* title = "Shared Care Planning: Task ActivityDefinition"
* description = "An ActivityDefinition for a task for a patient that is shared between multiple care providers."
* kind = #Task
* profile = "http://santeonnl.github.io/shared-care-planning/StructureDefinition/SCPTask"


ValueSet: SCPTaskStatus
Id: scp-task-status
Title: "Shared Care Planning: Task Status"
* ^status = #active
* include codes from valueset http://hl7.org/fhir/ValueSet/task-status
* exclude $task-status#draft

// Invariant: SCPTask-state-change
// Severity: #error
// Description: "Only the 'requester' can create an SCPTask in state 'ready' or 'requested'.
// Only the 'owner' can update an SCPTask for state transitions requested->received, requested->accepted, requested->rejected, received->accepted, received->rejected, accepted->in-progress, in-progress->completed, in-progress->failed, ready->completed and ready->failed.
// Both the 'requester' and 'owner' can update an SCPTask for state transitions requested->cancelled, received->cancelled, accepted->cancelled, in-progress->on-hold and on-hold->in-progress"


Profile: GFDLEpisodeOfCare
Parent: EpisodeOfCare
Title: "Generic Functions, Data Localization: EpisodeOfCare Profile"
Description: "An episode of care for tracking the involvement of healthcare organizations in patient care, categorized by medical specialty or department."
Id: GFDLEpisodeOfCare
* ^url = "https://example.org/fhir/StructureDefinition/MyEpisodeOfCare"
* ^status = #draft
* type 1..1
* type from GFDLMedicalSpecialtyVS (required)
* type ^short = "Medical specialty or department"
* type ^definition = "The medical specialty or department providing care during this episode"
* patient.identifier 1..
* patient.identifier.system 1..
* patient.identifier.system = "http://fhir.nl/fhir/NamingSystem/bsn" (exactly)
* patient.identifier.system ^short = "PatientIdentificationNumber"
* patient.identifier.system ^definition = "The patient’s identification number. In transfer situations, use of the social security number (BSN) must comply with the Use of Social Security Numbers in Healthcare Act (Wbsn-z). In other situations, other number systems can be used, such as internal hospital patient numbers for example."
* patient.identifier.value 1..
* managingOrganization 1..
* period 1..

ValueSet: GFDLTaskStatus
Id: gfdl-episodeofcare-status
Title: "Generic Functions, Data Localization: EpisodeOfCare Status"
* ^compose.include.valueSet = "http://hl7.org/fhir/ValueSet/episode-of-care-status"
// Exclude the specific code "planned" from EpisodeOfCareStatus
* ^compose.exclude[+].system = "http://hl7.org/fhir/episode-of-care-status"
* ^compose.exclude.concept[+].code = #planned
* ^compose.exclude.concept[+].code = #waitlist
* ^compose.exclude.concept[+].code = #onhold

CodeSystem: GFDLMedicalSpecialtyCS
Id: gfdl-medical-specialty
Title: "Generic Functions, Data Localization: Medical Specialty CodeSystem"
Description: "Code system for medical specialties and departments used in NVI"
* ^status = #draft
* ^caseSensitive = true
* #cardiology "Cardiology" "Department of Cardiology"
* #internal-medicine "Internal Medicine" "Department of Internal Medicine"
* #surgery "Surgery" "Department of Surgery"
* #orthopedics "Orthopedics" "Department of Orthopedics"
* #psychiatry "Psychiatry" "Department of Psychiatry"
* #neurology "Neurology" "Department of Neurology"
* #pediatrics "Pediatrics" "Department of Pediatrics"
* #obstetrics-gynecology "Obstetrics & Gynecology" "Department of Obstetrics and Gynecology"
* #radiology "Radiology" "Department of Radiology"
* #anesthesiology "Anesthesiology" "Department of Anesthesiology"
* #emergency-medicine "Emergency Medicine" "Department of Emergency Medicine"
* #family-medicine "Family Medicine" "Department of Family Medicine"
* #ophthalmology "Ophthalmology" "Department of Ophthalmology"
* #dermatology "Dermatology" "Department of Dermatology"
* #oncology "Oncology" "Department of Oncology"
* #geriatrics "Geriatrics" "Department of Geriatrics"
* #rehabilitation "Rehabilitation Medicine" "Department of Rehabilitation Medicine"
* #intensive-care "Intensive Care" "Intensive Care Unit"
* #general-practice "General Practice" "General Practitioner"

ValueSet: GFDLMedicalSpecialtyVS
Id: gfdl-medical-specialty-vs
Title: "Generic Functions, Data Localization: Medical Specialty ValueSet"
Description: "Value set for medical specialties and departments used in NVI"
* ^status = #active
* include codes from system GFDLMedicalSpecialtyCS