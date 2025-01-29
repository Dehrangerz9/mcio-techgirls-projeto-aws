provider "aws" {
    region = "us-east-2"
  
}
resource "aws_vpc" "example_vpc"{
    cidr_block              = var.vpc_cidr_block
    instance_tenancy        = "default"
    enable_dns_hostnames    = true
}

resource "aws_subnet" "private_subnets"{
    vpc_id = aws_vpc.example_vpc.id
    count = length(var.private_subnets)
    cidr_block = element(var.private_subnets_cidr,count.index)
    availability_zone = element(var.availability_zones,count.index)
}

resource "aws_subnet" "public_subnets"{
    vpc_id = aws_vpc.example_vpc.id
    count = length(var.public_subnets)
    cidr_block = element(var.public_subnets_cidr,count.index)
    availability_zone = element(var.availability_zones,count.index)
}

resource "aws_internet_gateway" "internet_gateway"{
    vpc_id = aws_vpc.example_vpc.id
}

resource "aws_route_table" "public_route_table"{
    vpc_id = aws_vpc.example_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }
}

resource "aws_eip" "nat_eip" {
    count = length(var.public_subnets)
    domain = "vpc"
    depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "nat_gateway" {
    count = length(var.public_subnets)
    allocation_id = element(aws_eip.nat_eip.*.id,count.index)
    subnet_id = element(aws_subnet.public_subnets[*].id,count.index)
    depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_route_table" "private_route_table"{
    vpc_id = aws_vpc.example_vpc.id
    count = length(var.private_subnets)
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = element(aws_nat_gateway.nat_gateway.*.id,count.index)
    }
}

resource "aws_route_table_association" "public_subnets"{
    count = length(var.public_subnets_cidr)
    route_table_id = aws_route_table.public_route_table.id
    subnet_id = element(aws_subnet.public_subnets[*].id,count.index)
}

resource "aws_route_table_association" "private_subnets"{
    count = length(var.private_subnets)
    route_table_id = element(aws_route_table.private_route_table[*].id,count.index)
    subnet_id = element(aws_subnet.private_subnets[*].id,count.index)
}