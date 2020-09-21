variable "AWS_ACCESS_KEY" {
    description = "aws access key"
    type = string
    default = ""
 }

variable "AWS_SECRET_KEY" { 
    description = "aws secret key"
    type = string
    default = ""
}

variable "AWS_REGION" { 
    description = "aws region"
    type    = string
    default = "us-east-1"
}

variable "AWS_AMIS" {
    description = "map of ubuntu ami id"
    type    = map(string)
    default = {
        us-east-1 = "ami-0dba2cb6798deb6d8"
        us-east-2 = "ami-07efac79022b86107"
        us-west-1 = "ami-021809d9177640a20"
    }
}

variable "AWS_AMIS_AWSLINUX" {
    description = "map of aws linux ami id"
    type    = map(string)
    default = {
        us-east-1 = "ami-0c94855ba95c71c99"
        us-east-2 = "ami-0603cbe34fd08cb81"
        us-west-1 = "ami-0e65ed16c9bf1abc7"
    }
}

variable "AWS_INSTANCE_TYPE" { 
    description = "aws instance type"
    type    = string
    default = "t2.micro"
}

variable "AWS_VPC_ID" { 
    description = "map of vpc id"
    type    = map(string)
    default = {
        us-east-1 = "vpc-101cf86d"
        us-east-2 = "vpc-3fee3554"
        us-west-1 = "vpc-f822d39e"
    }
}

variable "PATH_TO_PRIVATE_KEY" { 
    description = "path to private key terraformkey"
    type        = string
}

variable "PATH_TO_PUBLIC_KEY" {
    description = "path to public key terraformkey.pub"
    type        = string
 }