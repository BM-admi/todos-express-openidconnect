ARG BASE_IMAGE_TAG=18-bullseye
ARG BASE_IMAGE_REPO=node

FROM ${BASE_IMAGE_REPO}:${BASE_IMAGE_TAG} as final
LABEL org.opencontainers.image.description="BM nodejs OIDC auth express example"

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

# default to port 3000 for node, and 9229 and 9230 (tests) for debug
ARG PORT=3000
ENV PORT $PORT
EXPOSE $PORT 9229 9230

RUN npm i npm@latest -g

RUN mkdir /opt/node_app && chown node:node /opt/node_app
WORKDIR /opt/node_app

# https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#non-root-user
USER node
COPY --chown=node:node package.json package-lock.json* ./
RUN npm ci && npm cache clean --force
ENV PATH /opt/node_app/node_modules/.bin:$PATH

WORKDIR /opt/node_app/app

# Bundle app source
COPY --chown=node:node . ./

HEALTHCHECK --interval=30s CMD node healthcheck.js
EXPOSE 3000

#COPY entrypoint.sh /usr/local/bin/
#ENTRYPOINT ["entrypoint.sh"]

CMD ["npm", "start"]
