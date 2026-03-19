resource "aws_instance" "ec2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_1.id

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  key_name = "CICD-Project"  # 👈 ADD THIS

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install docker -y
    service docker start
    usermod -aG docker ec2-user
  EOF
}