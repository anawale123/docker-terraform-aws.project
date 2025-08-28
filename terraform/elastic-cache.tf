resource "aws_elasticache_cluster" "redis" {
    cluster_id = "ecs-redis" 
    engine  = "redis"
    node_type = "cache.t2.micro"
    num_cache_nodes = 1
    subnet_group_name = aws_elasticache_subnet_group.redis_subnet_group.name
    security_group_ids =  [aws_security_group.ecs-redis-sg.id]
}