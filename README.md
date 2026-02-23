<!--
SPDX-FileCopyrightText: 2025 Bram Wesselo
SPDX-FileCopyrightText: 2025 Rein Krul
SPDX-FileCopyrightText: 2025 Roland Groen

SPDX-License-Identifier: CC-BY-SA-4.0
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
make builder
```

#### Make Targets

| Command | Description |
|---|---|
| `make builder` | Build the Docker image with all dependencies |
| `make check-syntax` | Run SUSHI only to validate FSH syntax (fast, seconds) |
| `make ig-novalidate` | Full IG build, skipping terminology validation (faster) |
| `make ig` | Full IG build with terminology validation |

FHIR packages and build artifacts are cached in `build-cache/` to speed up subsequent builds.

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

curl -X POST "https://us-central1-fhir-org-starter-project.cloudfunctions.net/ig-commit-trigger" \
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

## Licensing

This project uses two licenses depending on the nature of the file:

Code and logic is licensed under the EUPL-1.2. This applies to files that are executed, compiled, or processed as code, including FHIR Shorthand (`.fsh`) and PlantUML (`.plantuml`) files.

Content and knowledge is licensed under CC-BY-SA-4.0. This applies to files that primarily carry documentation or informational content, including Markdown (`.md`) and image (`.png`) files.

Each file contains an SPDX header indicating its applicable license. When in doubt, consider whether the file contains logic (EUPL-1.2) or content (CC-BY-SA-4.0).
