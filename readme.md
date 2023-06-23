### Create a key pair for your ec2 instance
In the terminal type
```
ssh-keygen -m PEM

```

```
resource "aws_key_pair" "my_aws_key_pair" {
  key_name   = "ec2-keypair"          # Replace with your desired key pair name
  public_key = file("E:/Aws/key.pub") # Replace with the path to your public key file
}
```


### Get the access key and secret key from aws console
```
provider "aws" {
  region     = "us-east-1"
  access_key = "your_access_key"
  secret_key = "your_sceret_key"
}
```

### Create security group specify your vpc id 
```
resource "aws_security_group" "rdp-sg" {
  name        = "rdp-sg"
  description = "Allow RDP inbound traffic"
  vpc_id      = "vpc-id"

  ingress {
    description = "RDP from VPC"
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
```


### Create ec2 instance
```
resource "aws_instance" "my_ec2" {
  ami             = "ami-04132f301c3e4f138"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.my_aws_key_pair.key_name
  security_groups = [aws_security_group.rdp-sg.name]
  tags = {
    Name = "Your EC2 Server"
  }

}
```

### To output the public ip of the ec2 instance
```
output "output" {
  value = aws_instance.my_ec2.public_ip
}
```

### To run the terraform file
```
terraform init
terraform plan
terraform apply
```
