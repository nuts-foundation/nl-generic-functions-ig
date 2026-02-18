<!--
SPDX-FileCopyrightText: 2025 Bram Wesselo
SPDX-FileCopyrightText: 2025 Rein Krul
SPDX-FileCopyrightText: 2025 Roland Groen

SPDX-License-Identifier: EUPL-1.2
-->

# nuts-knooppunt-specs
Specifications of the Nuts Knooppunt

## Local Development

### Building the IG Locally with Docker

You can build and test the Implementation Guide locally using Docker. This is useful for development and testing before pushing changes.

#### Prerequisites
- Docker installed on your system
- All source files in the `input/` directory

#### Build the Docker Image

First, build the Docker image that contains all necessary tools (FHIR IG Publisher, Sushi, etc.):

```bash
docker build . -t ig-builder
```

This creates a Docker image named `ig-builder` with all the required dependencies.

#### Run the Build

To build the Implementation Guide, run the following command from the project root:

```bash
docker run --rm --name=ig-builder \
  -v ./input:/app/input \
  -v ./output:/app/output \
  -v ./ig.ini:/app/ig.ini \
  -v ./sushi-config.yaml:/app/sushi-config.yaml \
  ig-builder
```

This command:
- Mounts the `input/` directory containing your FHIR resources
- Mounts the `output/` directory where the built IG will be placed
- Mounts the `ig.ini` and `sushi-config.yaml` configuration files
- Runs the IG publisher to generate the output

#### View the Results

After the build completes:
- The generated IG will be in the `output/` directory
- Open `output/index.html` in a web browser to view the IG
- Check `output/qa.html` for validation results and quality checks
- Review `build.log` for detailed build information

#### Clean Output Directory

Before rebuilding, you may want to clean the output directory:

```bash
rm -rf ./output/*
```

## FHIR Implementation Guide Auto-Builder

This FHIR IG is setup to auto-build to https://build.fhir.org/ig/nuts-foundation/nl-generic-functions-ig or https://build.fhir.org/ig/nuts-foundation/nl-generic-functions-ig/branches/<your-branch>

The build-logs of this auto-build ae published on https://chat.fhir.org/#narrow/stream/179297-committers.2Fnotification/topic/ig-build (could take 2-3 minutes after a commit to the repo)
In the ./build.log you can find the build log. Validation tests are in ./output/qa.html

This IG can also be triggered manually using the FHIR Implementation Guide Auto-Builder. To trigger a build, use this curl statement (change to branchname 'main' to whatever branch you're trying to build):

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
```

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
