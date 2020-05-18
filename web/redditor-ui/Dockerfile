FROM node:10

# Create app directory
WORKDIR /usr/src/app

COPY ./public public
COPY ./src src
COPY ./yarn.lock .
COPY ./package.json .

RUN yarn

EXPOSE 3000

CMD [ "yarn", "run", "start" ]
