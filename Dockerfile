# Use official NGINX image
FROM nginx:alpine

# Copy your local files (index.html, etc.) to the default NGINX public directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80
