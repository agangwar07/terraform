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
  cidr_block              = var.subnetpublicCIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone

  tags = {
    Name = "myvpc-public"
  }
}

# Private Subnets in Custom VPC
resource "aws_subnet" "myvpc-private" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnetprivateCIDRblock
  map_public_ip_on_launch = "false"
  availability_zone       = var.availabilityZone

  tags = {
    Name = "myvpc-private"
  }
}

#NACL for private subnet
resource "aws_network_acl" "mynacl" {
    vpc_id = aws_vpc.myvpc.id
    subnet_ids = [ aws_subnet.myvpc-private.id ]

  tags = {
      Name = "NACLs for private subnets"
  }
}

resource "aws_eip" "myvpc-nat" {
  vpc = true
}

resource "aws_nat_gateway" "myvpc-nat-gw" {
  allocation_id = aws_eip.myvpc-nat.id
  subnet_id     = aws_subnet.myvpc-public.id
}

resource "aws_route_table" "myvpc-private" {
  vpc_id = aws_vpc.my-vpc.id
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