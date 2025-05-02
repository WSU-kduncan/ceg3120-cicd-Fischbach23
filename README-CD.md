# Project 5 - Continuous Deployment

## Project Overview

The goal of this project is to demonstrate a full CI/CD pipeline for a Dockerized Angular application using GitHub Actions, DockerHub, and an EC2 instance. This includes:

- Using semantic versioning with Git tags  
- Triggering GitHub Actions to build and push updated images to DockerHub  
- Automatically updating a running Docker container on an EC2 instance via a webhook listener and refresh script

---

## Part 1 - Semantic Versioning

Semantic versioning was implemented using Git tags to ensure each image push to DockerHub includes distinct tags. These tags were handled through a GitHub Action workflow.

### Git Tagging

Commands used:

```
git tag -a v1.0.14 -m "Trigger deploy"
git push origin v1.0.14
```

Tags were pushed to GitHub, triggering the GitHub Actions workflow.

### GitHub Actions Workflow

Workflow is defined in `.github/workflows/docker-build.yml` and includes:

- Trigger on tag push  
- Docker metadata-action for tag parsing  
- DockerHub login via secrets  
- Build and push using `build-push-action@v5`

Tags pushed:

- `latest`  
- `major.minor` (e.g., `1.0`)  
- `major` (e.g., `1`)

---

## Part 2 - Continuous Deployment

### EC2 Instance Details

- **Instance Type**: t2.medium (2 vCPU, 4GB RAM)  
- **Volume Size**: 30 GB  
- **AMI**: Amazon Linux 2023  
- **Security Group Configuration**:  
  - Inbound: 22 (SSH), 80 (App), 9000 (Webhook)  
  - Outbound: All traffic

---

### Installing & Testing Docker

Installed using:

```
sudo yum install docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
```

Validated with:

```
docker --version
docker run hello-world
```

Pulled and tested project image:

```
docker pull fischbooo/fischbach-ceg3120:latest
docker run -d -p 80:80 fischbooo/fischbach-ceg3120:latest
```

---

### Bash Scripting

A script named `refresh.sh` was created to:

- Pull latest image  
- Stop and remove old container  
- Run the updated container

```
#!/bin/bash
IMAGE_NAME="fischbooo/fischbach-ceg3120"
CONTAINER_NAME="fischbach-app"

docker pull $IMAGE_NAME
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true
docker run -d --name $CONTAINER_NAME -p 80:80 $IMAGE_NAME
```

---

### Webhook Configuration

Webhook was installed manually via precompiled binary and configured with:

- Hook definition file `webhook.json`

```
[
  {
    "id": "dockerhub",
    "execute-command": "/home/ec2-user/refresh.sh",
    "command-working-directory": "/home/ec2-user",
    "pass-arguments-to-command": [],
    "response-message": "Deploy started."
  }
]
```

---

### Running the Webhook

Service file: `webhook.service`

```
[Unit]
Description=Webhook Listener Service
After=network.target

[Service]
ExecStart=/home/ec2-user/webhook -hooks /home/ec2-user/webhook.json -ip 0.0.0.0 -port 9000 -verbose
Restart=always
User=ec2-user

[Install]
WantedBy=multi-user.target
```

Enabled with:

```
sudo cp deployment/webhook.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable webhook
sudo systemctl start webhook
```

---

### Webhook Testing and Issues

Webhook service was running successfully on port 9000. However, trigger attempts repeatedly returned:

```
Hook rules were not satisfied.
```

After multiple tests with `curl`, including:

```
curl -X POST http://localhost:9000/hooks/dockerhub
curl -X POST http://52.205.14.185:9000/hooks/dockerhub
```

Webhook service remained running, but did not execute the refresh script.

**Manual fallback was used for refresh.sh** to ensure demonstration completion.





## Resources
 
- [GitHub Actions Docs](https://docs.github.com/en/actions)  
- [docker/build-push-action](https://github.com/docker/build-push-action)  
- [docker/metadata-action](https://github.com/docker/metadata-action)  
- [Docker Install on Amazon Linux](https://docs.docker.com/engine/install/centos/)



- [ChatGPT] - Help me in creating the Part 2 of my README.md. I gave it all of my files that I created and gave it the prompt "Take all my file I have given you and create me a read me" I also gave it a outline to follow for the creation of my README.md

- [ChatGPT] - Helped me in the creation of everything in my deployment folder. In the prompt I gave it for each was "create ______" where "______" is the file tht needed to be created. Every time I had an error with any of the files I just put it back in ChatGPT and it spit out a new version of the file.


- This project is far from being correct and I know that. I didn't complete project 4 correctly and that put me into a major disadvantage. 100% my fault I understand that. I also can no longer work on this project due to my docker desktop application being corrupt. I have tried almost everything to redownload it but nothing has worked. 
