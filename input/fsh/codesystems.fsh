CodeSystem: NlGfDataExchangeCapabilitiesCS
Id: nl-gf-data-exchange-capabilities
Title: "NL GF Data exchange capabilities"
Description: "Local code system for NL Generic Functions."
* ^url = "http://nuts-foundation.github.io/nl-generic-functions-ig/CodeSystem/nl-gf-data-exchange-capabilities"
* ^status = #active
* ^experimental = true
* #http://nuts-foundation.github.io/nl-generic-functions-ig/CapabilityStatement/nl-gf-admin-directory-update-client "Care Services Directory for Update Client"
* #eOverdracht-notification "Transfer of Care - eOverdracht Notification"
* #Twiin-TA-notification "Twiin - TA Notification"
* #Nuts-OAuth "Nuts OAuth endpoint"
* #http://nictiz.nl/fhir/CapabilityStatement/eOverdracht-servercapabilities "Transfer of Care - eOverdracht Server"
* #http://nictiz.nl/fhir/CapabilityStatement/bgz2017-servercapabilities "BGZ Server"
* #http://nictiz.nl/fhir/CapabilityStatement/mp-MedicationData.RetrieveServe "Minimal requirements for a server to fulfill the 'Serve medication data' transaction (system role: MP-MGB)."
* #http://nictiz.nl/fhir/CapabilityStatement/mp-MedicationData.SendReceive "Minimal requirements for a server to fulfill the 'Receive medication data' transaction (system role: MP-MGO)."
* #http://nictiz.nl/fhir/CapabilityStatement/mp-MedicationOverview.RetrieveServe "Minimal requirements for a server to fulfill the 'Serve medication overview' transaction (system role: MP-MOB)."
* #http://nictiz.nl/fhir/CapabilityStatement/mp-MedicationOverview.SendReceive "Minimal requirements for a server to fulfill the 'Receive medication overview' transaction (system role: MP-MOO)."
* #http://nictiz.nl/fhir/CapabilityStatement/mp-MedicationPrescription "Minimal requirements for a server to fulfill the 'Receive medication prescription' transaction (system role: MP-VOO)."
* #http://nictiz.nl/fhir/CapabilityStatement/mp-MedicationPrescriptionProcessing "Minimal requirements for a server to fulfill the 'Receive medication prescription processing' transaction (system role: MP-VAO)."
* #http://nictiz.nl/fhir/CapabilityStatement/mp-ProposalDispenseRequest "Minimal requirements for a server to fulfill the 'Receive proposal dispense request' transaction (system role: MP-VVO)."
* #http://nictiz.nl/fhir/CapabilityStatement/mp-ReplyProposalDispenseRequest "Minimal requirements for a server to fulfill the 'Receive reply proposal dispense request' transaction (system role: MP-VVS)."
* #http://nictiz.nl/fhir/CapabilityStatement/mp-ProposalMedicationAgreement "Minimal requirements for a server to fulfill the 'Receive proposal medication agreement' transaction (system role: MP-VMO)."
* #http://nictiz.nl/fhir/CapabilityStatement/mp-ReplyProposalMedicationAgreement "Minimal requirements for a server to fulfill the 'Receive reply proposal medication agreement' transaction (system role: MP-VMS)."