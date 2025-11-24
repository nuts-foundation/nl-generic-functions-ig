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

# Note: ig.ini and sushi-config.yaml should be mounted as volumes when running the container
# This allows for configuration changes without rebuilding the image

CMD ["bash", "_genonce.sh"]
