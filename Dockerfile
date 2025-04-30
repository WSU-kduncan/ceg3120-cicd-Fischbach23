FROM node:18-alpine

WORKDIR /app

COPY . .

RUN npm install && npm install -g http-server

EXPOSE 80

CMD ["http-server", "dist"]
