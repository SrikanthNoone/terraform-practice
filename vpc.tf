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