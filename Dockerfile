FROM ubuntu:16.04

#Create .sfdx folders to resolve Jenkins bug
RUN mkdir /.cache /.sf /.sfdx /.local &&\
    chmod 757 /.cache /.sf /.sfdx /.local -R

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
    curl -sL https://deb.nodesource.com/setup_14.x  | bash - &&\
    apt-get -y install nodejs default-jdk

#Install SFDX and plugins
RUN npm config set unsafe-perm=true &&\
    npm install --global sfdx-cli@7.170.0

RUN chmod -R go+rwx ${HOME} &&\
    chmod -R go+rwx /root
