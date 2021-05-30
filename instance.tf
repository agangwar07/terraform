#AWS ELB Configuration
resource "aws_elb" "my-elb" {
  name            = "my-elb"
  subnets         = [aws_subnet.myvpc-public.id]
  security_groups = [aws_security_group.My_VPC_Security_Group.id]
  
  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  tags = {
    Name = "my-loadbalancer"
  }
}

#AWS Instances

resource "aws_instance" "MyWebInstance" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  vpc_security_group_ids = [ aws_security_group.y_VPC_Security_Group.id ]
  subnet_id = aws_subnet.myvpc-public-1.id
  count = 2
  load_balancers            = [aws_elb.my-elb.name]

  tags = {
    Name = "custom_instance"
  }

  user_data = "installapache.sh"

}

output "pubic_ip" {
  value = aws_instance.MyFirstInstance.public_ip
}