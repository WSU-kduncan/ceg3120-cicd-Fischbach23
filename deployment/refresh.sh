#!/bin/bash
echo "Webhook triggered at $(date)" >> /home/ec2-user/refresh.log


# Name of your image and container
IMAGE_NAME="fischbooo/fischbach-ceg3120"
CONTAINER_NAME="fischbach-app"

echo "[$(date)] Pulling latest image: $IMAGE_NAME"
docker pull $IMAGE_NAME

echo "[$(date)] Stopping existing container (if running)..."
docker stop $CONTAINER_NAME 2>/dev/null || true

echo "[$(date)] Removing old container (if it exists)..."
docker rm $CONTAINER_NAME 2>/dev/null || true

echo "[$(date)] Running new container..."
docker run -d --name $CONTAINER_NAME -p 80:80 $IMAGE_NAME

echo "[$(date)] Deployment complete."
