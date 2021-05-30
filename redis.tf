resource "aws_elasticache_cluster" "myredis" {
  cluster_id           = "clustermyredis"
  engine               = "redis"
  node_type            = "cache.t3.small"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  security_group_ids = [ aws_security_group.My_VPC_Security_Group.id ]
  subnet_group_name = "aws_subnet.myvpc-private"

  tags = {
   Name = "memcache cluster"
}

}

