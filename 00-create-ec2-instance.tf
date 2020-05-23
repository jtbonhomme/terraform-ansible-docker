##Setup variables

variable "ami" {
}

variable "image-flavor" {
}

variable "key-pair" {
}

variable "aws-region" {
}

variable "tag-name" {
}

variable "tag-cpaccount" {
}

##Define AWS provider
provider "aws" {
  region = var.aws-region
}

##Create a security group for deployment.
resource "aws_security_group" "dep-ec2-sg" {
  name        = "deployment-ec2-sg"
  description = "Allow incoming ssh and htp connexion on port 81 from anywhere, and any outgoing connexion to anywhere"
  ingress {
    from_port   = 22
    to_port     = 22
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

##Create masters instances
resource "aws_instance" "ec2-master" {
  ami                         = var.ami
  instance_type               = var.image-flavor
  key_name                    = var.key-pair
  vpc_security_group_ids      = [aws_security_group.dep-ec2-sg.id]
  associate_public_ip_address = true

  root_block_device {
        volume_size = 160
  }

  tags = {
    Name        = replace("${var.tag-name}-ec2-master-${timestamp()}","-","_")
    "C+Account" = var.tag-cpaccount
  }
}

