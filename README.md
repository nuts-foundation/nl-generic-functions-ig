# nuts-knooppunt-specs
Specifications of the Nuts Knooppunt


# FHIR Implementation Guide Auto-Builder

This FHIR IG is setup to auto-build to https://build.fhir.org/ig/nuts-foundation/nl-generic-functions-ig or https://build.fhir.org/ig/nuts-foundation/nl-generic-functions-ig/branches/<your-branch>

The build-logs of this auto-build ae published on https://chat.fhir.org/#narrow/stream/179297-committers.2Fnotification/topic/ig-build (could take 2-3 minutes after a commit to the repo)
In the ./build.log you can find the build log. Validation tests are in ./output/qa.html

This IG can also be triggerred manually using the FHIR Implementation Guide Auto-Builder. To trigger a build, use this curl statement (change to branchname 'main' to whatever branch you're trying to build):

curl -X POST  "https://us-central1-fhir-org-starter-project.cloudfunctions.net/ig-commit-trigger" \
-H "Content-Type:application/json" \
--data '{"ref": "refs/heads/main", "repository": {"full_name": "nuts-foundation/nl-generic-functions-ig"}}'


