CI/CD Pipeline: Docker → ECR → EKS & EC2
Overview

This project implements a complete CI/CD pipeline that builds a Docker image, pushes it to Amazon ECR, and deploys the application to both an Amazon EKS cluster and an EC2 instance. All infrastructure components including ECR, EKS, networking, and EC2 are provisioned using Terraform within the Jenkins pipeline.

Technologies Used

Jenkins

Terraform
Docker

Amazon ECR

Amazon EKS

Amazon EC2

Slack (for notifications)

Pipeline Stages

Terraform initialization and infrastructure provisioning

Docker image build

Image push to ECR

Deployment to EKS using Kubernetes manifests

Deployment to EC2 using Docker runtime

Slack notifications after each stage

Infrastructure Provisioned
ECR repository

EKS cluster and node group

EC2 instance

VPC and subnets

Notifications

Each stage sends success or failure notifications to the Slack alerts channel.