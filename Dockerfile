ARG BASE_IMAGE_TAG=18-bullseye
ARG BASE_IMAGE_REPO=node

FROM ${BASE_IMAGE_REPO}:${BASE_IMAGE_TAG} as build
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install

FROM ${BASE_IMAGE_REPO}:${BASE_IMAGE_TAG} as final
LABEL org.opencontainers.image.description="BM nodejs OIDC auth express example"
WORKDIR /app
COPY --from=build /usr/src/app ./
# Bundle app source
COPY . ./
EXPOSE 3000
ENTRYPOINT ["npm", "start"]
