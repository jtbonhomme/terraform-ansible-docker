##Setup variables

variable "ami" {}
variable "image-flavor" {}
variable "key-pair" {}
variable "aws-region" {}
variable "tag-name" {}
variable "tag-cpaccount" {}
variable "master-count" {}
variable "node-count" {}

##Define AWS provider
provider "aws" {
  region            = "${var.aws-region}"
}

##Create a security group for deployment.
resource "aws_security_group" "dep-k8s-sg" {
  name              = "deployment-k8s-sg"
  description       = "Allow incoming ssh from anywhere, and any outgoing connexion to anywhere"
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

##Create masters instances
resource "aws_instance" "k8s-master" {
  count             = "${var.master-count}"
  ami               = "${var.ami}"
  instance_type     = "${var.image-flavor}"
  key_name          = "${var.key-pair}"
  vpc_security_group_ids = ["${aws_security_group.dep-k8s-sg.id}"]
  associate_public_ip_address = true

  tags {
    Name            = "${var.tag-name}-k8s-master-${count.index}"
    "C+Account"     = "${var.tag-cpaccount}"
  }
}

##Create masters instances
resource "aws_instance" "k8s-node" {
  count             = "${var.node-count}"
  ami               = "${var.ami}"
  instance_type     = "${var.image-flavor}"
  key_name          = "${var.key-pair}"
  vpc_security_group_ids = ["${aws_security_group.dep-k8s-sg.id}"]
  associate_public_ip_address = true

  tags {
    Name            = "${var.tag-name}-k8s-node-${count.index}"
    "C+Account"     = "${var.tag-cpaccount}"
  }
}
