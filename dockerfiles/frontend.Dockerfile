FROM node:latest

WORKDIR /app
COPY . /app

RUN chown -R node /app
USER node

ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_OPTIONS=--max_old_space_size=2048

RUN npm install --silent
RUN npm run build

CMD ["bash", "-c", "npm run start -- -p 9000"]
