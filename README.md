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

# Generating FSH-FHIR-resources on your desktop

If you want to generate FSH FHIR-resources based on Simplifier-FHIR-profiles (like the Dutch 'nl-core' profiles) on your local desktop, you have to [install Dotnet & Firely Terminal](https://docs.fire.ly/projects/Firely-Terminal/getting_started/InstallingFirelyTerminal.html):
```
sudo apt-get install -y dotnet-sdk-8.0
echo 'export PATH=$PATH:~/.dotnet/tools' >> ~/.bashrc
echo "-----reload bash configuration file"
source ~/.bashrc
```
create a snapshot of the Dutch profiles using 
```
fhir install nictiz.fhir.nl.r4.nl-core 0.12.0-beta.1
````
[Install NodeJS & Sushi](https://fshschool.org/docs/sushi/installation/) to generate FHIR-resource from FSH-files (it will need the snapshots you've just created):
```
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
sudo npm install -g npm@latest 
sudo npm install -g fsh-sushi
```
now you should be able to generate fhir resources from fsh-files using
```
sushi .
```
