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

#AutoScaling Launch Configuration
resource "aws_launch_configuration" "my-launchconfig" {
  name_prefix     = "my-launchconfig"
  image_id        = lookup(var.AMIS, var.region)
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.My_VPC_Security_Group.id]


  lifecycle {
    create_before_destroy = true
  }
}


#Autoscaling Group
resource "aws_autoscaling_group" "my-autoscaling" {
  name                      = "my-autoscaling"
  vpc_zone_identifier       = [aws_subnet.myvpc-public.id, aws_subnet.myvpc-public1.id]
  launch_configuration      = aws_launch_configuration.my-launchconfig.name
  min_size                  = 2
  max_size                  = 2
  load_balancers            = [aws_elb.my-elb.name]
  force_delete              = true
  user_data       =   "installtomcat.sh"

  tag {
    key                 = "Name"
    value               = "My Custom EC2 instance via LB"
    propagate_at_launch = true
  }
}

output "ELB" {
  value = aws_elb.my-elb.dns_name
}