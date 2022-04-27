FROM node:14-alpine AS base
RUN mkdir -p /usr/app
WORKDIR /usr/app

FROM base AS build-frontend
ARG SSH_PRIVATE_KEY
RUN mkdir /p ~/.ssh/
RUN echo "$SSH_PRIVATE_KEY" | base64 -d > ~/.ssh/id_rsa
RUN chmod 600 ~/.ssh/id_rsa
RUN apk add --no-cache git openssh
RUN ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN git config --global user.email "cd-heroku@master.com"
RUN git config --global user.name "cd-heroku"
ARG FRONT_REPOSITORY_URL
RUN git clone $FRONT_REPOSITORY_URL ./
RUN npm install
RUN npm run build

FROM base AS build-backend
COPY ./ ./
RUN npm i
RUN npm run build

FROM base AS release
COPY --from=build-backend /usr/app/dist ./
COPY --from=build-frontend /usr/app/dist ./public
COPY ./package.json ./
RUN npm i --only=production

ENTRYPOINT [ "node", "index" ]
