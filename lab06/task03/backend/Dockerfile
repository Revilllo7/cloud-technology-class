FROM node:18-alpine

WORKDIR /app

COPY index.js .

RUN npm init -y && npm install express mysql2

CMD ["node", "index.js"]
