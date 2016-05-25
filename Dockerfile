FROM node:wheezy

# Create app directory
RUN mkdir -p /app
WORKDIR /app

# Install app dependencies
COPY package.json /app/
RUN npm install

# Bundle app source
COPY server /app

EXPOSE 8000
# required for jwilder/nginx-proxy to work
EXPOSE 8082
CMD [ "npm", "start" ]
