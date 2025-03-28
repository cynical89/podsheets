FROM kkarczmarczyk/node-yarn:8.0 AS builder
ADD . /src
WORKDIR /src
RUN yarn install
RUN yarn build

FROM node:8-jessie
COPY --from=builder /src/server/build /app
# for server side, the build is just translate tsx to js, no packaging, we still need node_module to run.
COPY --from=builder /src/server/node_modules /app/node_modules
COPY --from=builder /src/server/public /app/public
COPY --from=builder /src/server/views /app/views
WORKDIR /app
CMD node ./src/index.js
