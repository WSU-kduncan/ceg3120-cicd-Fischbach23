FROM node:18-bullseye

WORKDIR /app

COPY . .

RUN npm install && npm install -g http-server

RUN npx ng build wsu-hw-ng --configuration production

WORKDIR /app/dist/wsu-hw-ng

EXPOSE 80

CMD ["http-server", "-p", "80"]
