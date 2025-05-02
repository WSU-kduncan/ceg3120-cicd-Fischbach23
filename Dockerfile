# Use official Node.js image as the base
FROM node:18

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire project (including src/, angular.json, etc.)
COPY . .

# Build the Angular app for production
RUN npm run build

# Use a lightweight web server to serve the Angular dist folder
# (optional, depends on how you're serving it)
# FROM nginx:alpine
# COPY --from=build-stage /app/dist/your-angular-app-name /usr/share/nginx/html

# If you're running `ng serve` (dev mode)
EXPOSE 4200
CMD ["npm", "start"]
