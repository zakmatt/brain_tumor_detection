variable "rds_db_name" {
  description = "Name of the rds"
  type        = string
  default     = "mydb"
}

variable "allocated_storage" {
  description = "The allocated storage for the RDS instance"
  type        = number
}

variable "engine_version" {
  description = "The database engine version"
  type        = string
}

variable "instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
}

variable "username" {
  description = "The username for the RDS instance"
  type        = string
}

variable "password" {
  description = "The password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "vpc_security_group_ids" {
  description = "The security group IDs for the RDS instance"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "The subnet group name for the RDS instance"
  type        = string
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
}