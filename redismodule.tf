module "redis" {
  source = "umotif-public/elasticache-redis/aws"
  version = "~> 1.5.0"

  name_prefix           = "core-example"
  number_cache_clusters = 1
  node_type             = "cache.t3.small"

  engine_version           = "5.0.6"
  port                     = 6379
  maintenance_window       = "mon:03:00-mon:04:00"
  snapshot_window          = "04:00-06:00"
  snapshot_retention_limit = 7

  automatic_failover_enabled = true

  apply_immediately = true
  family            = "redis5.0"
  description       = "Test elasticache redis."

  ingress_cidr_blocks = ["0.0.0.0/0"]

  parameter = [
    {
      name  = "repl-backlog-size"
      value = "16384"
    }
  ]

  tags = {
    Project = "myproject"
  }
}