output "ecr_url" {
  value = aws_ecr_repository.repo.repository_url
}

output "ec2_ip" {
  value = aws_instance.ec2.public_ip
}