FROM node:latest


COPY [".", "/app"]

WORKDIR /app
RUN chown -R node /app
USER node

RUN npm install --silent
RUN npm run build


CMD ["bash", "-c", "npm run start -- -p 9000"]
