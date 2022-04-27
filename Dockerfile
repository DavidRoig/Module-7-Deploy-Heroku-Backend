FROM node:14-alpine AS base
RUN mkdir -p /usr/app
WORKDIR /usr/app

FROM base AS build-backend
COPY ./ ./
RUN npm i
RUN npm run build

FROM base AS release
COPY --from=build-backend /usr/app/dist ./
COPY ./package.json ./
RUN npm i --only=production

ENTRYPOINT [ "node", "index" ]
