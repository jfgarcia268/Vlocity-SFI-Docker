FROM ubuntu:16.04

#Create .sfdx folders to resolve Jenkins bug
RUN mkdir /.cache /.sf /.sfdx &&\
    chmod 757 /.cache /.sf /.sfdx -R

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
    npm install --global --global sfdx-cli@7.163.0 &&\
    sfdx plugins:install @salesforce/sfdx-scanner

#Install acu-pack
RUN --mount=type=secret,id=SF_GITHUB_PASS,dst=/run/secrets/SF_GITHUB_PASS \
    export SF_GITHUB_PASS=$(cat /run/secrets/SF_GITHUB_PASS) \ 
 && echo "y" | sfdx plugins:install "https://jgarciagonzalezSFDC:${SF_GITHUB_PASS}@github.com/forcedotcom/acu-pack.git"

RUN chmod -R go+rwx ${HOME} &&\
    chmod -R go+rwx /root &&\
    chmod 600 /root/.sfdx/key.json 2>&1 >dev/null
