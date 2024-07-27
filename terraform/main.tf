provider "aws" {
  region = "eu-north-1"
}

# Create the key pair if it does not exist
resource "aws_key_pair" "blockbook_key" {
  count = length(data.aws_key_pair.existing_key.key_name) == 0 ? 1 : 0
  key_name   = "blockbook_key"
  public_key = file("../auth/blockbook_key.pub")
}

# Check if the security group exists
data "aws_security_group" "existing_sg" {
  filter {
    name   = "group-name"
    values = ["blockbook_sg"]
  }
}

# Create the security group if it does not exist
resource "aws_security_group" "blockbook_sg" {
  count       = length(data.aws_security_group.existing_sg.ids) == 0 ? 1 : 0
  name        = "blockbook_sg"
  description = "Security group for Blockbook"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Mainnet Ports
  ingress {
    from_port   = 8066
    to_port     = 8066
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 38366
    to_port     = 38366
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9066
    to_port     = 9066
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9166
    to_port     = 9166
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Testnet Ports
  ingress {
    from_port   = 18066
    to_port     = 18066
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 48366
    to_port     = 48366
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 19066
    to_port     = 19066
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 19166
    to_port     = 19166
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP for Ping
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

resource "aws_instance" "blockbook_server" {
  ami           = "ami-07c8c1b18ca66bb07"
  instance_type = "t3.micro"

  key_name = length(data.aws_key_pair.existing_key.key_name) > 0 ? data.aws_key_pair.existing_key.key_name : aws_key_pair.blockbook_key[0].key_name

  associate_public_ip_address = true

  vpc_security_group_ids = length(data.aws_security_group.existing_sg.ids) > 0 ? [data.aws_security_group.existing_sg.id] : [aws_security_group.blockbook_sg[0].id]

  tags = {
    Name = "BlockbookServer"
  }

  # Ensure the instance depends on the security group
  depends_on = [aws_security_group.blockbook_sg]
}

output "blockbook_instance_ip" {
  value = aws_instance.blockbook_server.public_ip
}
