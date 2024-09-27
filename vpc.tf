provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "new-vpc" {
    cidr_block = "10.0.0.0/16"
    tags={
        Name = "new-vpc"
    }
}
resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.new-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "public-subnet"
  }
}
resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.new-vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "private-subnet"
  }
}
resource "aws_internet_gateway" "internet-gateway-vpc" {
    vpc_id = aws_vpc.new-vpc.id
    tags = {
    Name = "igw-vpc"
    } 
}
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.new-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet-gateway-vpc.id
    }
  tags = {
    Name = "public_route_table"
  }
}