FROM --platform=linux/arm64 node:20-alpine
# I love how Docker is flagging this, meanwhile
# I have to use it for the task lmao

WORKDIR /app

COPY package.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
