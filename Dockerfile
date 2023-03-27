ARG NODE_VERSION=19
# Use full nodejs image to build
FROM node:$NODE_VERSION AS build

WORKDIR /app

COPY . .
RUN npm ci && \
    npm run build:ci && \
    npm prune --production && \
    curl -sf https://gobinaries.com/tj/node-prune | sh && \
    node-prune

# Copy contents to the run stage
FROM node:$NODE_VERSION-alpine

WORKDIR /app

COPY --from=build --chown=node:node /app/package*.json /app
COPY --from=build --chown=node:node /app/dist /app/dist
COPY --from=build --chown=node:node /app/node_modules /app/node_modules

EXPOSE 3000

USER node

ENTRYPOINT [ "npm" ]

CMD [ "start" ]
