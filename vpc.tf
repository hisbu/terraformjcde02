# terraform custom vpc
resource "aws_vpc" "main" {
  cidr_block            = "10.0.0.0/16"
  instance_tenancy      = "default"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  enable_classiclink    = false

  tags = {
    Name = "vpc-tf-main"
  }
}

#====> Subnet

resource "aws_subnet" "main-public-1" {
  vpc_id                    = aws_vpc.main.id
  cidr_block                = "10.0.1.0/24"
  map_public_ip_on_launch   = true
  availability_zone         = "us-west-1a"

  tags = {
    Name = "Main-public-1"
  }
}

resource "aws_subnet" "main-public-2" {
  vpc_id                    = aws_vpc.main.id
  cidr_block                = "10.0.2.0/24"
  map_public_ip_on_launch   = true
  availability_zone         = "us-west-1c"

  tags = {
    Name = "Main-public-2"
  }
}

# ====> Internet Gateway
resource "aws_internet_gateway" "myInterGw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

#====> Route Tables
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myInterGw.id
  }

  tags = {
    Name = "main-public-1"
  }
}

#====> Route associations public
resource "aws_route_table_association" "main-public-1" {
  subnet_id      = aws_subnet.main-public-1.id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_route_table_association" "main-public-2" {
  subnet_id      = aws_subnet.main-public-2.id
  route_table_id = aws_route_table.public-route.id
}