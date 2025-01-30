resource "aws_instance" "grafana" {
    ami                         = "ami-07c65f0fc562b275d"
    instance_type               = "t2.micro"
    subnet_id                   = element(aws_subnet.public_subnets[*].id,0)
    key_name                    = "wordpress-ssh-key"
    vpc_security_group_ids      = [aws_security_group.public-whitelisted.id]
    associate_public_ip_address = true
    user_data                   = file("grafana.sh")
    tags = {
        Name = "Grafana & Prometheus EC2 Instance"
    }
}

output "grafana_public_ip" {
  description = "O endereço de IP público da instância Grafana"
  value       = aws_instance.grafana.public_ip
}

output "grafana_endpoint" {
  description = "DNS name of the Grafana EC2 instance"
  value       = aws_instance.grafana.public_dns
}