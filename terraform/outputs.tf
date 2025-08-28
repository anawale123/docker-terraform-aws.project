output "ecs_id" {
    description = " ecs-fargate Id"
    value = aws_ecs_cluster.flask_app
}

output "elastic-cache-redis" {
    description = " elastic-cache-redis Id"
    value = aws_elasticache_cluster.redis
}

output "main_vpc" {
  description = "Main VPC ID"
  value       = aws_vpc.main.id
}

output "public_a" {
  description = "Public subnet A ID"
  value       = aws_subnet.public_a.id
}

output "private_a" {
  description = "Private subnet A ID"
  value       = aws_subnet.private_a.id
}


