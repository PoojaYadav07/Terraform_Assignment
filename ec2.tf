# Create Security Group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch EC2 Instance in Public Subnet
resource "aws_instance" "public_ec2" {
  ami           = "ami-0c55b159cbfafe1f0" # Provide your AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = tls_private_key.ssh_key.key_name
  security_groups = [aws_security_group.ec2_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "PublicEC2"
  }
}

# Launch EC2 Instance in Private Subnet
resource "aws_instance" "private_ec2" {
  ami           = "ami-0c55b159cbfafe1f0" # Provide your AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = tls_private_key.ssh_key.key_name
  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "PrivateEC2"
  }
}
