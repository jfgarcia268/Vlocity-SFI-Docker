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
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_18.x  | bash
RUN node -v
RUN npm -v
#RUN apt-get -y install nodejs
RUN apt-get -y install default-jdk

#Install puppeteer Dep
RUN apt-get -y install libpangocairo-1.0-0 libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxi6 libxtst6 libnss3 libcups2 libxss1 libxrandr2 libgconf2-4 libasound2 libatk1.0-0 libgtk-3-0

#Install NodeJS Packages
RUN npm config set unsafe-perm=true &&\
    npm install --global sfdx-cli vlocity puppeteer &&\
    #npm install --global sfdx-cli@7.162.0 vlocity puppeteer &&\
    npm install puppeteer --save

#Install SFDX-CLI Plugins
RUN echo "y" | sfdx plugins:install vlocityestools &&\
    sfdx plugins:install @salesforce/sfdx-scanner &&\
    echo "y" | sfdx plugins:install sfdx-git-delta

RUN --mount=type=secret,id=SF_GITHUB_PASS,dst=/run/secrets/SF_GITHUB_PASS \
    export SF_GITHUB_PASS=$(cat /run/secrets/SF_GITHUB_PASS) \ 
 && echo "y" | sfdx plugins:install "https://jgarciagonzalezSFDC:${SF_GITHUB_PASS}@github.com/forcedotcom/acu-pack.git"

RUN chmod -R go+rwx /root &&\
    rm -rf  /root/.sfdx/key.json 2>&1 >dev/null

# Version Summary
#RUN git --version &&\
#    node --version &&\
#    npm --version &&\
#    vlocity help &&\
#    sfdx vlocityestools &&\
#    sfdx force &&\
#   sfdx plugins --core &&\
#    sfdx --version --verbose
