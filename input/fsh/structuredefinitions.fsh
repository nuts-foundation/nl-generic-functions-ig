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