resource "aws_key_pair" "deployer" {
  key_name   = "devops-pet-project-key"
  public_key = file("~/.ssh/devops-pet-project.pub")

  tags = {
    Name        = "pet-project-ssh-key"
    Environment = "dev"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "pet-project-web-sg"
  description = "Allow HTTP, HTTPS and restricted SSH traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "pet-project-web-sg"
    Environment = "dev"
  }
}