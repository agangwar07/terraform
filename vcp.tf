#Create AWS VPC
resource "aws_vpc" "myvpc" {
    cidr_block           = var.vpcCIDRblock
    instance_tenancy     = var.instanceTenancy 
    enable_dns_support   = var.dnsSupport 
    enable_dns_hostnames = var.dnsHostNames
    enable_classiclink   = "false"

  tags = {
    Name = "myvpc"
  }
}

# Public Subnets in Custom VPC
resource "aws_subnet" "myvpc-public" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnetpublicCIDRblock1
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone

  tags = {
    Name = "myvpc-public"
  }
}

resource "aws_subnet" "myvpc-public" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnetpublicCIDRblock2
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone1

  tags = {
    Name = "myvpc-public"
  }
}

# Private Subnets in Custom VPC
resource "aws_subnet" "myvpc-private" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnetprivateCIDRblock1
  map_public_ip_on_launch = "false"
  availability_zone       = var.availabilityZone

  tags = {
    Name = "myvpc-private"
  }
}

resource "aws_subnet" "myvpc-private1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnetprivateCIDRblock2
  map_public_ip_on_launch = "false"
  availability_zone       = var.availabilityZone1

  tags = {
    Name = "myvpc-private1"
  }
}

#NACL for private subnet
resource "aws_network_acl" "mynacl" {
    vpc_id = aws_vpc.myvpc.id
    subnet_ids = [ aws_subnet.myvpc-private.id , aws_subnet.myvpc-private1.id]

  tags = {
      Name = "NACLs for private subnets"
  }
}

resource "aws_eip" "myvpc-nat" {
  vpc = true
}

# Custom internet Gateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "internet gateway"
  }
}

#Routing Table for the Custom VPC
resource "aws_route_table" "myvpc-public" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }

  tags = {
    Name = "my-public"
  }
}

resource "aws_route_table" "myvpc-public1" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }

  tags = {
    Name = "my-public1"
  }
}

resource "aws_nat_gateway" "myvpc-nat-gw" {
  allocation_id = aws_eip.myvpc-nat.id
  subnet_id     = aws_subnet.myvpc-public.id
}

resource "aws_route_table" "myvpc-private" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block     = var.destinationCIDRblock
    nat_gateway_id = aws_nat_gateway.myvpc-nat-gw.id
  }

  tags = {
    Name = "myvpc-private"
  }
}

resource "aws_route_table" "myvpc-private1" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block     = var.destinationCIDRblock
    nat_gateway_id = aws_nat_gateway.myvpc-nat-gw.id
  }

  tags = {
    Name = "myvpc-private"
  }
}

# route associations private
resource "aws_route_table_association" "myvpc-private" {
  subnet_id      = aws_subnet.myvpc-private.id
  route_table_id = aws_route_table.myvpc-private.id
}

resource "aws_route_table_association" "myvpc-private1" {
  subnet_id      = aws_subnet.myvpc-private1.id
  route_table_id = aws_route_table.myvpc-private1.id
}

resource "aws_route_table_association" "myvpc-public" {
  subnet_id      = aws_subnet.myvpc-public.id
  route_table_id = aws_route_table.myvpc-public.id
}

resource "aws_route_table_association" "myvpc-public1" {
  subnet_id      = aws_subnet.myvpc-public1.id
  route_table_id = aws_route_table.myvpc-public1.id
}