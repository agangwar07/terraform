resource "aws_security_group" "My_VPC_Security_Group" {
  vpc_id       = aws_vpc.myvpc.id
  name         = "My VPC Security Group"
  description  = "My VPC Security Group"
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  } 

   ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  } 

  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
  }

    ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
  }

    ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
   Name = "My VPC Security Group"
   Description = "My VPC Security Group"
}
}