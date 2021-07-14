terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region  = "us-west-2"
  access_key = "DONOTCOMMITME"
  secret_key = "DONOTCOMMITME"
}

provider "aws" {
  alias = "california"
  region  = "us-west-1"
  access_key = "DONOTCOMMITME"
  secret_key = "DONOTCOMMITME"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_instance" "app_server_west" {
  provider = aws.california
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  instance_tenancy = "default"

  tags = {
    Name        = "aws-import-test1"
    Environment = "aws-import-test1"
    Application = "Bear"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_subnet" "public-a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.7.192.0/27"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "public-a"
    Environment = "aws-import-test1"
    Application = "Bear"
  }
}

