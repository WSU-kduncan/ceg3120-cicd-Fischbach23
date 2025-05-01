# Use the official NGINX base image (Alpine is small and efficient)
FROM nginx:alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Remove the default NGINX index page
RUN rm -rf ./*

# Copy your custom HTML file into the container
COPY index.html .

# Expose port 80 to the host
EXPOSE 80

# Start NGINX (already set in the base image's CMD)
