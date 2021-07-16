FROM node:14-alpine as builder
WORKDIR /code

COPY ./package.json ./package.json
COPY ./yarn.lock ./yarn.lock
COPY ./index.js ./index.js

RUN yarn --pure-lockfile --production

FROM arm32v7/node:14-alpine
WORKDIR /code

COPY --from=builder /code /code

CMD ["yarn", "start"]