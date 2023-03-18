terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


data "aws_ami" "amazon-linux-2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*"]
  }
}


resource "aws_instance" "tfmyec2" {
  ami = data.aws_ami.amazon-linux-2.id
  instance_type = var.instance_type
  count = var.num_of_instance
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.tf-sec-gr.id]
  tags = {
    Name = "${var.tag}-Instance"
  }

  user_data = <<EOF
  #! /bin/bash
  yum update -y
  yum install httpd -y
  FOLDER="https://github.com/eneseren25/Terraform-Kittens-Carousel-Project/tree/main/static-web"
  cd /var/www/html
  wget https://raw.githubusercontent.com/eneseren25/Terraform-Kittens-Carousel-Project/main/static-web/index.html
  wget https://raw.githubusercontent.com/eneseren25/Terraform-Kittens-Carousel-Project/main/static-web/cat0.jpg
  wget https://raw.githubusercontent.com/eneseren25/Terraform-Kittens-Carousel-Project/main/static-web/cat1.jpg
  wget https://raw.githubusercontent.com/eneseren25/Terraform-Kittens-Carousel-Project/main/static-web/cat2.jpg
  wget https://raw.githubusercontent.com/eneseren25/Terraform-Kittens-Carousel-Project/main/static-web/cat3.png
  systemctl start httpd
  systemctl enable httpd
  EOF

}

resource "aws_security_group" "tf-sec-gr" {
  name = "${var.tag}-sec-grp"
  tags = {
    Name = "${var.tag}-Sec-Grop"
  }

  dynamic "ingress" {
    for_each = var.proje-sec
    iterator = port
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port =0
    protocol = "-1"
    to_port =0
    cidr_blocks = ["0.0.0.0/0"]
  }
}