resource "aws_instance" "grafana" {
    ami                         = "ami-07c65f0fc562b275d"
    instance_type               = "t2.micro"
    subnet_id                   = element(aws_subnet.public_subnets[*].id,0)
    key_name                    = "wordpress-ssh-key"
    vpc_security_group_ids      = [aws_security_group.public-whitelisted.id]
    associate_public_ip_address = true
    user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y wget
              sudo tee /etc/yum.repos.d/grafana.repo <<EOF2
              [grafana]
              name=grafana
              baseurl=https://packages.grafana.com/oss/rpm
              repo_gpgcheck=1
              enabled=1
              gpgcheck=1
              gpgkey=https://packages.grafana.com/gpg.key
              EOF2
              sudo yum install -y grafana
              sudo systemctl enable grafana-server
              sudo systemctl start grafana-server
              EOF
    tags = {
        Name = "Grafana EC2 Instance"
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