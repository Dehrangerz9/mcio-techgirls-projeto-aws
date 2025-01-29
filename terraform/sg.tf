resource "aws_security_group" "public-whitelisted"{
    name        = "public-whitelisted-ips"
    description = "allows acess via vpn"
    vpc_id      = aws_vpc.example_vpc.id
    ingress {
        description = "VPN IP"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = var.whitelisted_ips
    }

    ingress {
        description = "VPN IP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = var.whitelisted_ips
    }

    egress {
        cidr_blocks = ["0.0.0.0/0"]
        description = "outgoing traffic"
        from_port   = 0
        protocol    = "-1"
        to_port     = 0
    }
}

resource "aws_security_group" "private_rds_sg" {
    name        = "privated-rds"
    description = "Allows EC2 instance in public subnet to connect to RDS"
    vpc_id      = aws_vpc.example_vpc.id

    ingress {
        description     = "Allows MySQL acess from Ec2"
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups = [aws_security_group.public-whitelisted.id]
    }
}