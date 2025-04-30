# Stage 1: Build Angular app
FROM node:18-alpine as builder

WORKDIR /app

# Copy only the Angular app subdirectory
COPY angular-site/wsu-hw-ng-main/ /app/

RUN npm install && npm run build

# Stage 2: Serve it with NGINX
FROM nginx:alpine

# UPDATE this path if your app builds to a subfolder like dist/app-name
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
