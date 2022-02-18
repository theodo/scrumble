FROM node:14 AS front-builder

# Create app directory
RUN mkdir -p /app
WORKDIR /app

# Install app dependencies
COPY ./client/package.json /app/
COPY ./client/package-lock.json /app/

RUN npm ci --ignore-scripts --loglevel verbose

ARG API_URL='"/api"'
ARG GOOGLE_CLIENT_ID='"846194931476-lnslq69phmckpsul3ttjrcqk7msqmlqf.apps.googleusercontent.com"'
ARG TRELLO_KEY='"62bfdf783665fa1f28e1d3e324974106"'

ENV API_URL=$API_URL
ENV GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID
ENV TRELLO_KEY=$TRELLO_KEY

# Bundle app source
COPY ./client /app
RUN npm run build


## API Stage
FROM node:14 AS api

# Create app directory
RUN mkdir -p /app
WORKDIR /app

# Install app dependencies
COPY ./api/package.json /app/
COPY ./api/package-lock.json /app/
RUN npm ci --loglevel verbose

# Bundle app source
COPY ./api /app
COPY --from=front-builder /app/public /app/public

EXPOSE 8000

CMD [ "npm", "start" ]

