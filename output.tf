output "load_balancer_url" {
  description = "The public DNS name of application load balancer"
  value = "http://${aws_alb.app_alb.dns_name}"
}

output "database_endpoint" {
  description = "The internal endpoint URL of the RDS Database"
  value = aws_db_instance.app_db.endpoint
}