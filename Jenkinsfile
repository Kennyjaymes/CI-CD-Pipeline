pipeline {
    agent any

    tools {
        terraform "terraform-1.0.10"
    }
    environment {
        AWS_REGION = "us-east-1"
        ACCOUNT_ID = "Darkky"
        ECR_REPO = "cicd-repo"
    }

    stages {

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    bat 'terraform init'
                    bat 'terraform apply -auto-approve'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    bat 'docker build -t cicd-app .'
                }
            }
        }

        stage('Push to ECR') {
            steps {
                bat """
                aws ecr get-login-password --region %AWS_REGION% ^
                | docker login --username AWS --password-stdin %ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com

                docker tag cicd-app:latest %ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/%ECR_REPO%:latest

                docker push %ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/%ECR_REPO%:latest
                """
            }
        }

        stage('Deploy to EKS') {
            steps {
                bat """
                aws eks update-kubeconfig --region %AWS_REGION% --name cicd-eks
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                """
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {

                    def EC2_IP = bat(
                        script: 'cd terraform && terraform output -raw ec2_public_ip',
                        returnStdout: true
                    ).trim()

                    bat """
                    ssh ec2-user@%EC2_IP% docker pull %ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/%ECR_REPO%:latest
                    ssh ec2-user@%EC2_IP% docker run -d -p 80:80 %ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/%ECR_REPO%:latest
                    """
                }
            }
        }

    }

    post {
        success {
            slackSend channel: '#alerts', message: "Pipeline Successful"
        }

        failure {
            slackSend channel: '#alerts', message: "Pipeline Failed"
        }
    }
}