pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO   = 'cicd-repo'
        SLACK_CHANNEL = '#alerts'
    }

    stages {

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
            post {
                success { slackSend(channel: env.SLACK_CHANNEL, message: 'Terraform applied ✅') }
                failure { slackSend(channel: env.SLACK_CHANNEL, message: 'Terraform failed ❌') }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t cicd-app ./app'
            }
            post {
                success { slackSend(channel: env.SLACK_CHANNEL, message: 'Docker image built ✅') }
                failure { slackSend(channel: env.SLACK_CHANNEL, message: 'Docker build failed ❌') }
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

                docker tag cicd-app:latest ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
                docker push ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
                '''
            }
            post {
                success { slackSend(channel: env.SLACK_CHANNEL, message: 'Docker pushed to ECR ✅') }
                failure { slackSend(channel: env.SLACK_CHANNEL, message: 'ECR push failed ❌') }
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                aws eks update-kubeconfig --name cicd-eks
                kubectl set image deployment/cicd-app cicd-app=ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
                kubectl apply -f k8s/service.yaml
                '''
            }
            post {
                success { slackSend(channel: env.SLACK_CHANNEL, message: 'Deployed to EKS ✅') }
                failure { slackSend(channel: env.SLACK_CHANNEL, message: 'EKS deploy failed ❌') }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh']) {
                    sh '''
                    ssh ec2-user@EC2_PUBLIC_IP \
                    "docker pull Darkky.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest && \
                     docker run -d -p 80:80 Darkky.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest"
                    '''
                }
            }
            post {
                success { slackSend(channel: env.SLACK_CHANNEL, message: 'Deployed to EC2 ✅') }
                failure { slackSend(channel: env.SLACK_CHANNEL, message: 'EC2 deploy failed ❌') }
            }
        }
    }
}