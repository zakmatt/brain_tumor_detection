terraform {
  required_version = ">= 1.0"
  backend "s3" {
    bucket  = "tf-state-brain-tumor-detection"
    key     = "brain-tumor-detection-stg.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3" {
  source = "./modules/s3"

  bucket_name = var.s3_bucket_name
  tags        = var.tags
}

resource "aws_vpc" "mlflow_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "mlflow_subnet_1" {
  vpc_id     = aws_vpc.mlflow_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "mlflow-subnet-1"
  }
}

resource "aws_subnet" "mlflow_subnet_2" {
  vpc_id     = aws_vpc.mlflow_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "mlflow-subnet-2"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_mlflow_security_group"
  description = "Allow PostgreSQL traffic"
  vpc_id      = aws_vpc.mlflow_vpc.id

  ingress {
    description = "PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-mlflow-sg"
  }
}

resource "aws_db_subnet_group" "mlflow_db_subnet_group" {
  name       = "mlflow-db-subnet-group"
  subnet_ids = [aws_subnet.mlflow_subnet_1.id, aws_subnet.mlflow_subnet_2.id]

  tags = {
    Name = "mlflow-db-subnet-group"
  }
}

module "rds" {
  source = "./modules/rds"

  allocated_storage      = var.rds_allocated_storage
  engine_version         = var.rds_engine_version
  instance_class         = var.rds_instance_class
  rds_db_name               = var.rds_db_name
  username               = var.rds_username
  password               = var.rds_password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.mlflow_db_subnet_group.name
  tags                   = var.tags
}