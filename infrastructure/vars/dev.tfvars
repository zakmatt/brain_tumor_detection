aws_region = "eu-west-1"

s3_bucket_name = "dev-brain-tumor-detection-model-storage-bucket"

rds_allocated_storage = 20
rds_engine_version    = "16.3"
rds_instance_class    = "db.t3.micro"
rds_db_name           = "devdb"
rds_username          = "devadmin"
rds_password          = "devpassword123"

tags = {
  Environment = "dev"
  Project     = "brain-tumor-detection"
}