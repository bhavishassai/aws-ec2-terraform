terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region     = "us-east-1"
  access_key = "your_access_key"
  secret_key = "your_sceret_key"
}

# Create a new key pair 
resource "aws_key_pair" "my_aws_key_pair" {
  key_name   = "ec2-keypair"          # Replace with your desired key pair name
  public_key = file("E:/Aws/key.pub") # Replace with the path to your public key file
}


resource "aws_instance" "my_ec2" {
  ami             = "ami-04132f301c3e4f138"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.my_aws_key_pair.key_name
  security_groups = [aws_security_group.rdp-sg.name]
  tags = {
    Name = "Your EC2 Server"
  }

}
resource "aws_security_group" "rdp-sg" {
  name        = "rdp-sg"
  description = "Allow RDP inbound traffic"
  vpc_id      = "specify your vpc id"

  ingress {
    description = "RDP"
    from_port   = 3389
    to_port     = 3389
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
output "output" {
  value = aws_instance.my_ec2.public_ip
}


