output "rabbitmq_public_ip" {
  value       = aws_instance.rabbitmq.public_ip
  description = "IP pública del servidor RabbitMQ"
}


output "postgres_public_ip" {
  value       = aws_instance.postgres.public_ip
  description = "IP pública del servidor PostgreSQL"
}

output "api_public_ip" {
  value       = aws_instance.api.public_ip
  description = "IP pública del servidor API"
}

output "consumer_post_public_ip" {
  value       = aws_instance.consumer_post.public_ip
  description = "IP pública del Consumer POST"
}

output "consumer_delete_public_ip" {
  value       = aws_instance.consumer_delete.public_ip
  description = "IP pública del Consumer DELETE"
}

output "balancer_public_ip" {
  value       = aws_instance.balancer.public_ip
  description = "IP pública del balanceador"
}

output "api_url" {
  value       = "http://${aws_instance.balancer.public_ip}"
  description = "URL de la API a través del balanceador"
}

