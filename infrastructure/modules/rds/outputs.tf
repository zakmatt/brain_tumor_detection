output "db_instance_identifier" {
  description = "The RDS instance identifier"
  value       = aws_db_instance.db_instance.id
}

output "db_instance_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.db_instance.endpoint
}
