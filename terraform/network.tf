#vpc
resource "aws_vpc" "main" {
    cidr_block = var.main_vpc_cidr_blocks
    tags  =  {
       Name = "main-vpc"
    }
}

#internet-Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "main-igw"
    }
}

#public subnet 
resource "aws_subnet" "public_a" {
    vpc_id = aws_vpc.main.id
    cidr_block   = var.public_a_cidr_block
    availability_zone = "eu-west-2a"
    tags = {
        Name = "Public_a"
    }
}

#Route-table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    tags = {
      Name = "public_rt" 
    }
}

resource "aws_route" "public_internet" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

}



#Route table assiociation
resource "aws_route_table_association" "public_a" {
    subnet_id = aws_subnet.public_a.id
    route_table_id = aws_route_table.public.id
}

#Security-group

# Security Group
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-security-group"
  description = "ECS security group"
  vpc_id      = aws_vpc.main.id


  
  ingress {
  description = "Allow traffic to Flask app"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  
}


  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ecs_security_group" }
}

#private subnet redis
resource "aws_subnet" "private_a" {
    vpc_id =  aws_vpc.main.id
    availability_zone = "eu-west-2a"
    cidr_block = var.private_a_cidr_block
    tags = {
        Name = "Private_a" 
    }
}



#Redis security group
resource "aws_security_group" "ecs-redis-sg"{
     name = "ecs-redis-cache" 
     description = " ecs redis cache security group" 
     vpc_id = aws_vpc.main.id
    

    ingress {
    description = " ecs redis security group" 
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

}

#ecs cache redis private

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
    name = "redis-subnet-group" 
    subnet_ids = [aws_subnet.private_a.id ]

}