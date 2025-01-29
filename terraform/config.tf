terraform {
    required_version = ">= 1.5.3"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.69.0"
        }
    }

    backend "s3" {
        bucket = "yume-wp-s3-bucket"
        key = "backend.tfstate"
        region = "us-east-2"
        encrypt = true 
        dynamodb_table = "tf-backend"
    }
}