FROM ubuntu:24.04

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
    curl -sL https://deb.nodesource.com/setup_22.x  | bash - &&\
    apt-get -y install nodejs default-jdk

# 1. SET THE ENVIRONMENT FIRST
# This tells sf to use a global, shared location for everything
ENV SF_ALLOW_IT_ANYWAY=true
ENV SF_DATA_DIR=/usr/local/share/sf
ENV SF_CONFIG_DIR=/usr/local/share/sf
ENV SF_CACHE_DIR=/usr/local/share/sf

# 2. Prepare the global directory with open permissions
RUN mkdir -p /usr/local/share/sf && chmod -R 777 /usr/local/share/sf

# 3. Install CLI and Plugin
RUN npm install @salesforce/cli sfdx-git-delta --global

# 4. Link using the dynamic NPM root path
# Using $(npm root -g) is safer than hardcoding /usr/lib
RUN sf plugins link $(npm root -g)/sfdx-git-delta --no-install

# 5. VERIFICATION (This should now pass)
RUN sf sgd source delta --help


#Install acu-pack
#RUN --mount=type=secret,id=SF_GITHUB_PASS,dst=/run/secrets/SF_GITHUB_PASS \
#    export SF_GITHUB_PASS=$(cat /run/secrets/SF_GITHUB_PASS) \ 
# && echo "y" | sfdx plugins:install "https://jgarciagonzalezSFDC:${SF_GITHUB_PASS}@github.com/forcedotcom/acu-pack.git"

#RUN chmod -R go+rwx ${HOME} &&\
#    chmod -R go+rwx /root &&\
#    chmod 600 /root/.sfdx/key.json 2>&1 >dev/null
