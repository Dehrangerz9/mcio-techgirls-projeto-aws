resource "aws_instance" "public_ec2" {
    ami                         = "ami-07c65f0fc562b275d"
    instance_type               = "t2.micro"
    subnet_id                   = element(aws_subnet.public_subnets[*].id,0)
    key_name                    = "wordpress-ssh-key"
    vpc_security_group_ids      = [aws_security_group.public-whitelisted.id]
    associate_public_ip_address = true
    user_data                   = file("user_data.sh")
    tags = {
        Name = "Public EC2 Instance"
    }
}

output "ec2_public_ip" {
    description = "O endereco de Ip publico da instancia EC2"
    value       = aws_instance.public_ec2.public_ip
}

output "ec2_endpoint" {
    description = "DNS name of the EC2 instance"
    value       = aws_instance.public_ec2.public_dns
}