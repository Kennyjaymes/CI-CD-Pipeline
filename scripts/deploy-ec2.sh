#!/bin/bash
docker pull $IMAGE
docker rm -f app || true
docker run -d -p 80:80 --name app $IMAGE