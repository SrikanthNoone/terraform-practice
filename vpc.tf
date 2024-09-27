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
resource "aws_route_table_association" "public_route_table_association" {
    subnet_id = aws_subnet.public-subnet.id
    route_table_id = aws_route_table.public_route_table.id
}
resource "aws_instance" "public-instance" {
    ami = "ami-0e86e20dae9224db8"
    instance_type = "t2.micro"
    key_name = "aws"
    subnet_id = aws_subnet.public-subnet.id
    vpc_security_group_ids = [aws_security_group.ssh_access.id]
    tags = {
      Name = "sample-terraform"
    }
}
resource "aws_security_group" "ssh_access" {
  name_prefix = "ssh_access"
  vpc_id      =  aws_vpc.new-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}