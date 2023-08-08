FROM ubuntu:20.04

# Install
RUN apt-get update && \
    apt-get install -y xvfb wget && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN apt-get update && \
    apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && \
    apt-get install -y libsdl1.2-dev && \
    rm -rf /var/lib/apt/lists/*

# Install MongoDB
RUN apt-get update && \
    apt-get install -y gnupg && \
    wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list && \
    apt-get update && \
    apt-get install -y mongodb-org && \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g pm2

RUN mkdir /data/db -p

# Create app directory
WORKDIR /app


# Install app dependencies
COPY caasComplete/package*.json ./caasComplete/
RUN cd caasComplete && npm install

# Bundle app source
COPY caasComplete/LICENSE ./caasComplete
COPY caasComplete/proxyAll.js ./caasComplete
COPY caasComplete/config/docker.json ./caasComplete/config/local.json
COPY caasComplete/hc-demoapp-frontend ./caasComplete/hc-demoapp-frontend

COPY communicatorLicenseEmpty.txt ./communicatorLicense.txt
COPY startAll.sh .

COPY updateHC.sh .
RUN chmod +x updateHC.sh && ./updateHC.sh

EXPOSE 80

CMD ["./startAll.sh"]