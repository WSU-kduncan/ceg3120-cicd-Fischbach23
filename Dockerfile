FROM node:18

# Install a static file server
RUN npm install -g http-server

# Set working directory
WORKDIR /app

# Copy all your site content into the image
COPY . .

# Expose port 80 and serve files
EXPOSE 80
CMD ["http-server", ".", "-p", "80"]
