FROM node:latest

WORKDIR /app
COPY . /app

RUN chown -R node /app
USER node

RUN npm install --silent

ENV NEXT_TELEMETRY_DISABLED=1

RUN npm run build

CMD ["bash", "-c", "npm run start -- -p 9000"]
