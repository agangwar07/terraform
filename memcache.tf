resource "aws_elasticache_cluster" "my-cluter" {
  cluster_id           = "cluster-my-cluster"
  engine               = "memcached"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.4"
  port                 = 11211
  security_group_ids = [ ws_security_group.My_VPC_Security_Group.id ]
  
  tags = {
   Name = "memcache cluster"
}
}