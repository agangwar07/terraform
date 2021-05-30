resource "aws_elasticache_cluster" "my-cluter" {
  cluster_id           = "cluster-my-cluster"
  engine               = "memcached"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  port                 = 11211
  subnet_group_name = [aws_subnet.myvpc-private, aws_subnet.myvpc-private1]
  security_group_ids = [ aws_security_group.My_VPC_Security_Group.id ]
  
  tags = {
   Name = "memcache cluster"
}
}