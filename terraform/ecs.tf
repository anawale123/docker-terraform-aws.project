# ECS Cluster
resource "aws_ecs_cluster" "flask_app" {
  name = "flask-app"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

#IAM policy role for ecs tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_task_definition" "flask_task" {
  family                   = "flask-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = <<DEFINITION
[
  {
    "name": "flask-app",
    "image": "175680165464.dkr.ecr.eu-west-2.amazonaws.com/flask.app:23032e6",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 5000,
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "REDIS_HOST",
        "value": "${aws_elasticache_cluster.redis.cache_nodes[0].address}"
      },
      {
        "name": "REDIS_PORT",
        "value": "6379"
      }
    ]
  }
]
DEFINITION
}


# ECS Service
resource "aws_ecs_service" "flask_service" {
  name            = "flask-service"
  cluster         = aws_ecs_cluster.flask_app.id
  task_definition = aws_ecs_task_definition.flask_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public_a.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
  }
}
