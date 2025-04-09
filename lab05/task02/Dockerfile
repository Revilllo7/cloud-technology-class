FROM node:alpine

WORKDIR /app

COPY app /app

RUN npm install

ENV NODE_ENV=production

EXPOSE 3000

CMD ["node", "server.js"]
