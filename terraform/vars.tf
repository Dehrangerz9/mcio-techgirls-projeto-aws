variable "vpc_cidr_block"{
    description = "CIRD ranges for VPC"
    type = string
    default = "172.20.0.0/16"
}

variable "availability_zones" {
    type = list(string)
    default = ["us-east-2a","us-east-2b"]
}

variable "public_subnets_cidr" {
    type = list(string)
    description = "Public Subnet CIDRs"
    default = ["172.20.48.0/20","172.20.64.0/20"]
}

variable "private_subnets_cidr" {
    type = list(string)
    description = "Private Subnet CIDRs"
    default = ["172.20.0.0/20","172.20.16.0/20"]
}

variable "public_subnets" {
    type = map(string)
    description = "Public subnets used in VPC mapped to AZ letter"
    default = {
        a = "172.20.48.0/20"
        b = "172.20.64.0/20"
    }
}

variable "private_subnets" {
    type = map(string)
    description = "Privates subnets used in VPC mapped to AZ letter"
    default = {
        a = "172.20.0.0/20"
        b = "172.20.16.0/20"
    }
}

variable "whitelisted_ips" {
    type = list(string)
    description = "Whitelisted IPs"
    default = ["168.227.85.235/32"]
}