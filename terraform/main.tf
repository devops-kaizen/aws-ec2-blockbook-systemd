provider "aws" {
  region = "eu-north-1"
}

resource "aws_key_pair" "deployer_1" {
  key_name   = "ghost_server_key_1"
  public_key = file("../auth/ghost_server_key_1.pub")
}

resource "aws_security_group" "blockbook_sg" {
  name        = "blockbook_sg"
  description = "Security group for Blockbook"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2368
    to_port     = 2368
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-07c8c1b18ca66bb07"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployer_1.key_name

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.blockbook_sg.id]

  tags = {
    Name = "BlockbookServer"
  }
}

output "instance_ip" {
  value = aws_instance.app_server.public_ip
}
