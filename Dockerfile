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
    curl -sL https://deb.nodesource.com/setup_14.x  | bash - &&\
    apt-get -y install nodejs default-jdk

#Install NodeJS Packages
RUN npm config set unsafe-perm=true &&\
    npm install --global sfdx-cli vlocity

#Install SFDX-CLI Plugins
RUN echo "y" | sfdx plugins:install vlocityestools &&\
    sfdx plugins:install @salesforce/sfdx-scanner 
RUN --mount=type=secret,id=SF_GITHUB_PASS,dst=/run/secrets/SF_GITHUB_PASS \
    export SF_GITHUB_PASS=$(cat /run/secrets/SF_GITHUB_PASS) \ 
 && echo "y" | sfdx plugins:install "https://jgarciagonzalezSFDC:${SF_GITHUB_PASS}@github.com/CSGAMERSServices/acu-pack.git"

RUN chmod -R go+rwx ${HOME} &&\
    chmod -R go+rwx /root &&\
    chmod 600 /root/.sfdx/key.json 2>&1 >dev/null

# Version Summary
RUN git --version &&\
    node --version &&\
    npm --version &&\
    vlocity help &&\
    sfdx vlocityestools &&\
    sfdx force &&\
    sfdx plugins --core &&\
    sfdx --version --verbose
