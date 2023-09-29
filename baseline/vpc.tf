# Create the VPC
resource "aws_vpc" "ps_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ps-vpc"
  }
}

# Create public subnets
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.ps_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = "us-east-2${element(["a", "b"], count.index % 2)}"

  tags = {
    Name = "ps-vpc-public-us-east-2${element(["a", "b"], count.index % 2)}"
  }
}

# Create private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.ps_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = "us-east-2${element(["a", "b"], count.index % 2)}"

  tags = {
    Name = "ps-vpc-private-us-east-2${element(["a", "b"], count.index % 2)}"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ps_vpc.id

  tags = {
    Name = "ps-vpc-internet-gw"
  }
}

# Create a NAT Gateway in each public subnet
resource "aws_nat_gateway" "nat_gateways" {
  count = length(var.public_subnet_cidrs)

  allocation_id = aws_eip.nat_eips[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "ps-vpc-nat-gw"
  }
}

# Create Elastic IPs for the NAT Gateways
resource "aws_eip" "nat_eips" {
  count = length(var.public_subnet_cidrs)

  domain = "vpc"

  tags = {
    Name = "ps-vpc-nat-gw-eip"
  }
}

# Create a route table for the public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.ps_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "ps-vpc-public-rt"
  }
}

# Associate the public subnets with the public route table
resource "aws_route_table_association" "public_subnet_associations" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a route table for each private subnet
resource "aws_route_table" "private_route_tables" {
  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.ps_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateways[count.index].id
  }

  tags = {
    Name = "ps-vpc-private-rt-us-east-2${element(["a", "b"], count.index % 2)}"
  }
}

# Associate the private subnets with their respective route tables
resource "aws_route_table_association" "private_subnet_associations" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[count.index].id
}
