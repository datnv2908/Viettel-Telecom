FROM node:16.0.0 as build_wap
WORKDIR /app/imuzik/wap
COPY package.json yarn.lock ./

RUN yarn
COPY . ./

RUN yarn build

FROM node:current-alpine3.16 as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /app/imuzik/wap
COPY package.json yarn.lock ./
RUN apk add curl
RUN apk add net-tools
RUN yarn install --production=true

COPY --from=build_wap /app/imuzik/wap/next.config.js ./
COPY --from=build_wap /app/imuzik/wap/.next ./.next

CMD ["yarn", "next", "start", "-p", "80"]




