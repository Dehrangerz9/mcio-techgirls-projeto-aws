
# Security Group para a instância EC2 do WordPress
resource "aws_security_group" "wordpress_sg" {
  name_prefix = "wordpress-sg-"
  vpc_id      = aws_vpc.wordpress_vpc.id

  description = "Permitir tráfego para o servidor WordPress"
  

  # Regra para permitir tráfego HTTP(entrada)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  # Regra para permitir tráfego HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  # Regra para permitir SSH (apenas para IPs específicos)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["x.x.x.x/x"] 
  }



  # Regra para permitir todo o tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-wordpress-sg"
  }
}

output "app_security_group_id" {
  value = aws_security_group.app_sg.id
}

#Security Group para o banco de dados (MySQL)
resource "aws_security_group" "database_sg" {
  name_prefix = "database-sg-"
  vpc_id      = aws_vpc.wordpress_vpc.id

  description = "Permitir tráfego para o banco de dados"

  # Regras de entrada
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id] # Permitir acesso apenas do WordPress
    description     = "Permitir tráfego Banco de dados "
  }

  # Regras de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-sg"
  }
}

# Security Group para observabilidade 
resource "aws_security_group" "observability_sg" {
  name_prefix = "observability-sg-"
  vpc_id      = aws_vpc.wordpress_vpc.id

  description = "Permitir tráfego para observabilidade"

  # Regras de entrada
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Grafana 
    description = "Grafana HTTP"
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Prometheus 
    description = "Prometheus HTTP"
  }

  # Regras de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "observability-sg"
  }
}