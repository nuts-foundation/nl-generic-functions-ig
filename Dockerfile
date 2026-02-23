# SPDX-FileCopyrightText: 2025 Bram Wesselo
# SPDX-FileCopyrightText: 2025 Roland Groen
#
# SPDX-License-Identifier: EUPL-1.2

FROM eclipse-temurin:21-jdk-jammy
LABEL maintainer="roland@headease.nl"

# Install native compilation dependencies.
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y gcc g++ make apt-utils

# Install Node from NodeSource.
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get install -y nodejs

# Install Jekyll for Ubuntu/Debian: https://jekyllrb.com/docs/installation/ubuntu/
RUN apt-get install -y ruby-full build-essential zlib1g-dev
RUN gem install -N jekyll bundler

# Build argument for IG Publisher version compatible with Nictiz/Simplifier profiles 
# ARG PUBLISHER_VERSION=2.0.13
# RUN curl -L https://github.com/HL7/fhir-ig-publisher/releases/download/${PUBLISHER_VERSION}/publisher.jar -o /usr/local/publisher.jar


RUN mkdir /app
WORKDIR /app

# Install the FHIR Shorthand transfiler:
RUN npm i -g fsh-sushi

# Download the IG publisher.
COPY ./_updatePublisher.sh .
RUN bash ./_updatePublisher.sh -y
RUN chmod +x *.sh *.bat

# Allow the JVM to use more memory for the IG Publisher
ENV JAVA_TOOL_OPTIONS="-Xmx2g -Dfile.encoding=UTF-8"

# Keep a copy of publisher.jar outside input-cache so it survives volume mounts
RUN cp /app/input-cache/publisher.jar /app/publisher.jar

# Note: ig.ini and sushi-config.yaml should be mounted as volumes when running the container
# This allows for configuration changes without rebuilding the image

# Copy publisher.jar into input-cache if missing (e.g. when volume is mounted over it), then run
CMD ["bash", "-c", "cp -n /app/publisher.jar /app/input-cache/publisher.jar 2>/dev/null; bash _genonce.sh"]
