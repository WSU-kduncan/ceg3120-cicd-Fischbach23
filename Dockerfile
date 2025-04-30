# Stage 1: Build the Angular app
FROM node:18-alpine as builder

WORKDIR /app

COPY . .

RUN npm install && npm run build

# Stage 2: Serve the app using NGINX
FROM nginx:alpine

# Copy built Angular files from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
