resource "aws_elasticache_cluster" "my-redis" {
  cluster_id           = "cluster-my-redis"
  engine               = "redis"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  security_group_ids = [ aws_security_group.My_VPC_Security_Group.id ]

  tags = {
   Name = "memcache cluster"
}

}