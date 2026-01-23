terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Data source to get the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true       # bool - we want the newest matching AMI
  owners      = ["amazon"] # list(string) - who published this AMI

  filter {
    name   = "name"                               # string
    values = ["al2023-ami-2023*-kernel-*-x86_64"] # list(string)
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create SSH key pair for EC2 instance
resource "aws_key_pair" "wordpress" {
  key_name   = "wordpress-${var.student_name}"  # string interpolation
  public_key = file("~/.ssh/wordpress-lab.pub") # file() returns string

  tags = {
    Name         = "WordPress SSH Key - ${var.student_name}"
    Environment  = "Learning"
    ManagedBy    = "Terraform"
    Student      = var.student_name
    AutoTeardown = "8h"
  }
}
# Security group for WordPress server
resource "aws_security_group" "wordpress" {
  name        = "wordpress-${var.student_name}"
  description = "Security group for WordPress server"

  # SSH access from your IP only
  ingress {
    description = "SSH from my IP"
    from_port   = 22          # number
    to_port     = 22          # number
    protocol    = "tcp"       # string
    cidr_blocks = [var.my_ip] # list(string) - note the brackets!
  }

  # HTTP access from anywhere (for WordPress)
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # list with one element
  }

  # HTTPS access from anywhere (for future SSL)
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # CRITICAL: Terraform does NOT add default egress rules!
  # Without this, your instance cannot reach the internet
  # to download packages, WordPress, or anything else.
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" means all protocols (string, not number!)
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "wordpress-sg-${var.student_name}"
    Environment  = "Learning"
    ManagedBy    = "Terraform"
    Student      = var.student_name
    AutoTeardown = "8h"
  }
}
# EC2 instance running WordPress
resource "aws_instance" "wordpress" {
  ami                    = data.aws_ami.amazon_linux_2023.id # string from data source
  instance_type          = var.instance_type                 # string from variable
  key_name               = aws_key_pair.wordpress.key_name   # string from resource
  vpc_security_group_ids = [aws_security_group.wordpress.id] # list(string)!

  # User data script to install WordPress
  user_data = file("${path.module}/user_data.sh") # file() returns string

  # IMDSv2 configuration (enhanced security)
  # This is an object/block type with specific attributes
  metadata_options {
    http_endpoint               = "enabled"  # string - not a bool!
    http_tokens                 = "required" # string - not a bool!
    http_put_response_hop_limit = 1          # number
    instance_metadata_tags      = "enabled"  # string
  }

  # Root volume configuration - another nested block
  root_block_device {
    volume_size = var.root_volume_size      # number from variable
    volume_type = "gp3"                     # string
    encrypted   = var.enable_ebs_encryption # bool from variable
  }

  tags = {
    Name         = "wordpress-${var.student_name}"
    Environment  = "Learning"
    ManagedBy    = "Terraform"
    Student      = var.student_name
    AutoTeardown = "8h"
  }
}
