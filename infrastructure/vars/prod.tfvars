aws_region = "eu-west-1"

s3_bucket_name = "prod-brain-tumor-detection-model-storage-bucket"

rds_allocated_storage = 20
rds_engine_version    = "16.3"
rds_instance_class    = "db.t3.micro"
rds_db_name           = "proddb"
rds_username          = "prodadmin"
rds_password          = "prodpassword123"
rds_vpc_security_group_ids = ""
rds_db_subnet_group_name   = ""

tags = {
  Environment = "prod"
  Project     = "brain-tumor-detection"
}