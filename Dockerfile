FROM ubuntu:16.04

#Install JQ & unzip
RUN apt-get update -y &&\
    apt-get install software-properties-common -y &&\
    apt-get -y install jq unzip

#Install GIT
RUN add-apt-repository ppa:git-core/ppa &&\
    apt update -y &&\
    apt install -y git

#Install NodeJS and Java
RUN apt-get -y install curl gnupg &&\
    curl -sL https://deb.nodesource.com/setup_18.x  | bash - &&\
    apt-get -y install nodejs default-jdk

#Install SF-CLI and plugins
RUN npm config set unsafe-perm=true &&\
    npm install @salesforce/cli --global