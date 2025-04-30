# Use a Node image to build the app
FROM node:18-alpine as builder

WORKDIR /app

COPY . .

RUN npm install && npm run build

# Use a lightweight image to serve the Angular app
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
