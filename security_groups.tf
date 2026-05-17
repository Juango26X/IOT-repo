# ==========================================
# Security Group: RabbitMQ
# ==========================================
resource "aws_security_group" "rabbitmq_sg" {
  name        = "rabbitmq_sg"
  description = "Allow SSH, AMQP, and RabbitMQ Management API"
  vpc_id      = data.aws_vpc.default.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # RabbitMQ AMQP
  ingress {
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # RabbitMQ Management UI
  ingress {
    from_port   = 15672
    to_port     = 15672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rabbitmq_sg"
  }
}

# ==========================================
# Security Group: PostgreSQL
# ==========================================
resource "aws_security_group" "postgres_sg" {
  name        = "postgres_sg"
  description = "Allow SSH and PostgreSQL"
  vpc_id      = data.aws_vpc.default.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # PostgreSQL
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "postgres_sg"
  }
}

# ==========================================
# Security Group: API REST (FASTAPi)
# ==========================================
resource "aws_security_group" "api_sg" {
  name        = "api_sg"
  description = "Allow SSH and Flask API"
  vpc_id      = data.aws_vpc.default.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Flask API
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "api_sg"
  }
}

# ==========================================
# Security Group: Consumer POST
# Solo SSH — inicia conexiones salientes hacia RabbitMQ y Postgres
# ==========================================
resource "aws_security_group" "consumer_post_sg" {
  name        = "consumer_post_sg"
  description = "Allow SSH only for Consumer POST (initiates outbound connections)"
  vpc_id      = data.aws_vpc.default.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "consumer_post_sg"
  }
}

# ==========================================
# Security Group: Consumer DELETE
# Solo SSH — inicia conexiones salientes hacia RabbitMQ y Postgres
# ==========================================
resource "aws_security_group" "consumer_delete_sg" {
  name        = "consumer_delete_sg"
  description = "Allow SSH only for Consumer DELETE (initiates outbound connections)"
  vpc_id      = data.aws_vpc.default.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "consumer_delete_sg"
  }
}

# ==========================================
# Security Group: Balancer
# ==========================================
resource "aws_security_group" "balancer_sg" {
  name        = "balancer_sg"
  description = "Allow SSH only for Producer (initiates outbound connections)"
  vpc_id      = data.aws_vpc.default.id

  # SSH
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "balancer_sg"
  }
}
