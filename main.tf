# 1. RabbitMQ EC2
resource "aws_instance" "rabbitmq" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.rabbitmq_sg.id]
  user_data              = file("${path.module}/install_rabbitmq.sh")

  tags = {
    Name = "iot-rabbitmq"
    Role = "MessageBroker"
  }
}

# 2. PostgreSQL EC2
resource "aws_instance" "postgres" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]
  user_data              = file("${path.module}/install_postgres.sh")

  tags = {
    Name = "iot-postgres"
    Role = "Database"
  }
}

# 3. API REST (FastAPI) EC2
resource "aws_instance" "api" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.api_sg.id]
  iam_instance_profile   = "LabInstanceProfile"
  user_data = file("${path.module}/install_api.sh")

  tags = {
    Name = "iot-api"
    Role = "BackendAPI"
  }
}

# 4. Consumer POST EC2
resource "aws_instance" "consumer_post" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.consumer_post_sg.id]
  iam_instance_profile   = "LabInstanceProfile"
  user_data = templatefile("${path.module}/install_consumer_post.sh", { docker_user = var.docker_user })

  tags = {
    Name = "iot-consumer-post"
    Role = "AsyncWorker"
  }
}

# 5. Consumer DELETE EC2
resource "aws_instance" "consumer_delete" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.consumer_delete_sg.id]
  iam_instance_profile   = "LabInstanceProfile"
  user_data = templatefile("${path.module}/install_consumer_delete.sh", { docker_user = var.docker_user })

  tags = {
    Name = "iot-consumer-delete"
    Role = "AsyncWorker"
  }
}

# 6. Balanceador EC2 (antes producer)
resource "aws_instance" "balancer" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.balancer_sg.id]
  iam_instance_profile   = "LabInstanceProfile"
  user_data = templatefile("${path.module}/install_balancer.sh", { docker_user = var.docker_user })
  depends_on             = [aws_ssm_parameter.api_ip]

  tags = {
    Name = "iot-balancer"
    Role = "LoadBalancer"
  }
}

# SSM Parameter Store
resource "aws_ssm_parameter" "rabbitmq_ip" {
  name  = "/iot/dev/rabbitmq/public_ip"
  type  = "String"
  value = aws_instance.rabbitmq.public_ip
}

resource "aws_ssm_parameter" "postgres_ip" {
  name  = "/iot/dev/postgres/public_ip"
  type  = "String"
  value = aws_instance.postgres.public_ip
}

resource "aws_ssm_parameter" "api_ip" {
  name  = "/iot/dev/api/public_ip"
  type  = "String"
  value = aws_instance.api.public_ip
}

resource "aws_ssm_parameter" "consumer_post_ip" {
  name  = "/iot/dev/consumer-post/public_ip"
  type  = "String"
  value = aws_instance.consumer_post.public_ip
}

resource "aws_ssm_parameter" "consumer_delete_ip" {
  name  = "/iot/dev/consumer-delete/public_ip"
  type  = "String"
  value = aws_instance.consumer_delete.public_ip
}

resource "aws_ssm_parameter" "balancer_ip" {
  name  = "/iot/dev/balancer/public_ip"
  type  = "String"
  value = aws_instance.balancer.public_ip
}
