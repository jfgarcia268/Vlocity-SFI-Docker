FROM ubuntu:16.04

#Install JQ
RUN apt-get update -y
RUN apt-get install software-properties-common -y
RUN apt-get -y install jq

#Install GIT
RUN add-apt-repository ppa:git-core/ppa
RUN apt update -y
RUN apt install -y git

#Install unzip
RUN apt-get install -y unzip

#Install Java
RUN apt-get --assume-yes install default-jdk

#Install NodeJS
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_14.x  | bash -
RUN apt-get -y install nodejs

#Install puppeteer Dep
RUN apt-get -y install libpangocairo-1.0-0 libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxi6 libxtst6 libnss3 libcups2 libxss1 libxrandr2 libgconf2-4 libasound2 libatk1.0-0 libgtk-3-0

#Install NodeJS Packages
RUN npm config set unsafe-perm=true
RUN npm install --global sfdx-cli
RUN npm install --global vlocity
RUN npm install puppeteer --save
RUN npm install --global puppeteer
#--unsafe-perm=true

#Install SFDX-CLI Plugins
RUN echo "y" | sfdx plugins:install vlocityestools
RUN sfdx plugins:install @salesforce/sfdx-scanner

RUN --mount=type=secret,id=SF_GITHUB_PASS,dst=/run/secrets/SF_GITHUB_PASS \
    export SF_GITHUB_PASS=$(cat /run/secrets/SF_GITHUB_PASS) \ 
 && echo "y" | sfdx plugins:install "https://jgarciagonzalezSFDC:${SF_GITHUB_PASS}@github.com/CSGAMERSServices/acu-pack.git"

RUN chmod -R go+rwx ${HOME}
RUN chmod -R go+rwx /root

# Version Summary
RUN git --version
RUN node --version
RUN npm --version
RUN vlocity help
RUN sfdx vlocityestools
RUN sfdx force
RUN sfdx plugins --core
RUN sfdx --version --verbose
