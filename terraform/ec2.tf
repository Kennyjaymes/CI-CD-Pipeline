resource "aws_instance" "app_server" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "jenkins-server"

  user_data = <<-EOF
              #!/bin/bash
              yum install docker -y
              systemctl start docker
              EOF
}