resource "aws_db_instance" "db_instance" {
  allocated_storage      = var.allocated_storage
  db_name                = var.rds_db_name
  engine                 = "postgres"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.username
  password               = var.password
  publicly_accessible  = true
  skip_final_snapshot    = true
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name

  tags = var.tags
}