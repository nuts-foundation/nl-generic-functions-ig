Profile: GFDLEpisodeOfCare
Parent: EpisodeOfCare
Title: "Generic Functions, Data Localization: EpisodeOfCare Profile"
Description: "A care plan for a patient that is shared between multiple care providers."
Id: GFDLEpisodeOfCare
* ^url = "https://example.org/fhir/StructureDefinition/MyEpisodeOfCare"
* ^status = #draft
* diagnosis 1..1
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