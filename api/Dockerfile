FROM node:wheezy

# Create app directory
RUN mkdir -p /app
WORKDIR /app

# Install app dependencies
COPY package.json /app/
RUN npm install -g npm@latest
RUN npm install --quiet

# Bundle app source
COPY . /app

EXPOSE 8000

CMD [ "npm", "start" ]
