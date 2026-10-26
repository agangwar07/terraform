# terraform
 
Terraform configuration for a small AWS web stack: a custom VPC with public and private subnets, a load-balanced Auto Scaling group running Tomcat, a MariaDB database on RDS, and Redis and Memcached clusters on ElastiCache.
 
This is a learning project from 2021. See [Known issues](#known-issues) before applying it to a real account.
 
## Architecture
 
```
Internet
   |
 [ELB :80] ---> [Auto Scaling group: 2 x t2.micro, Tomcat on :8080]   (public subnets)
                         |
                         +--> RDS MariaDB 10.4          (private subnets)
                         +--> ElastiCache Redis         (private subnets)
                         +--> ElastiCache Memcached     (private subnets)
```
 
Private subnets reach the internet through a NAT gateway placed in a public subnet.
 
## Files
 
| File | What it defines |
|------|-----------------|
| `provider.tf` | AWS provider, authenticated with `var.access_key` and `var.secret_key` |
| `vcp.tf` | VPC, two public and two private subnets, internet gateway, NAT gateway and EIP, route tables and associations, NACL for the private subnets |
| `security_group.tf` | One shared security group: ingress on 22, 80, 8080, 3306, 6379 and 11211, open egress |
| `instance.tf` | Classic ELB (port 80 to instance port 8080), launch configuration (t2.micro), Auto Scaling group (min 2, max 2), `ELB` output with the load balancer DNS name |
| `installtomcat.sh` | Bootstrap script that installs Tomcat 8.5.43 as a systemd service |
| `rds.tf` | MariaDB 10.4 on `db.t2.micro`, 20 GB gp2, 30-day backups, single-AZ, DB subnet group and parameter group |
| `redis.tf` | ElastiCache Redis 3.2.10, one `cache.t3.small` node |
| `memcache.tf` | ElastiCache Memcached, one `cache.t3.small` node |
 
## Prerequisites
 
- Terraform (the code targets the AWS provider 3.x era; pin the provider, for example `~> 3.0`, if newer versions complain)
- An AWS account and an IAM user with permission to create the resources above
- A `variables.tf` or `terraform.tfvars` file. **It is not included in this repository** and has to be supplied. The configuration reads these variables:
| Variable | Used for |
|----------|----------|
| `access_key`, `secret_key` | AWS credentials |
| `region` | Region, also the key for the AMI lookup |
| `AMIS` | Map of region to AMI ID (must be an Ubuntu/Debian image, since the install script uses `apt-get`) |
| `vpcCIDRblock`, `instanceTenancy`, `dnsSupport`, `dnsHostNames` | VPC settings |
| `subnetpublicCIDRblock1`, `subnetpublicCIDRblock2` | Public subnet CIDRs |
| `subnetprivateCIDRblock1`, `subnetprivateCIDRblock2` | Private subnet CIDRs |
| `availabilityZone`, `availabilityZone1` | AZs for the two subnet pairs |
| `mapPublicIP` | Auto-assign public IPs in public subnets |
| `destinationCIDRblock` | Destination for the private route tables (normally `0.0.0.0/0`) |
| `ingressCIDRblock` | Allowed source ranges in the security group |
 
Avoid committing real keys. Use environment variables (`TF_VAR_access_key`, `TF_VAR_secret_key`) or the standard AWS credential chain instead.
 
## Usage
 
```bash
terraform init
terraform plan
terraform apply
```
 
The ELB DNS name is printed as the `ELB` output. To remove everything:
 
```bash
terraform destroy
```
 
The stack includes a NAT gateway, an ELB and two EC2 instances, which all bill by the hour while they exist.
 
## Known issues
 
These come from reading the code and are worth fixing before reuse:
 
- **Hardcoded database password.** `rds.tf` contains the master password in plain text. Move it to a sensitive variable or AWS Secrets Manager, and change it if it was ever used for anything real.
- **User data is not loaded.** `instance.tf` sets `user_data = "installtomcat.sh"`, which passes the literal string rather than the file contents. Use `file("installtomcat.sh")`.
- **Cache subnet groups.** `redis.tf` and `memcache.tf` set `subnet_group_name = "aws_subnet.myvpc-private"` as a quoted string. No `aws_elasticache_subnet_group` resource exists in the repo, so the clusters will not land in the private subnets as intended.
- **Copy-paste tag.** The Redis cluster is tagged `memcache cluster`.
- **Security group is broad.** One group serves the web tier, database and caches, and the SSH and cache ports are opened to `var.ingressCIDRblock`. The MySQL rule (3306) has no CIDR set. Separate groups per tier would be safer.
- **Tomcat download URL.** The script pins Tomcat 8.5.43 on an Apache distribution mirror. Old releases are usually moved to the archive, so the URL may need updating.
- **Aging resources.** Launch configurations, `enable_classiclink`, `vpc = true` on the EIP and `name` on `aws_db_instance` are deprecated or removed in recent AWS provider versions.
## Suggested next steps
 
- Add `variables.tf` with defaults and descriptions
- Split the security group by tier
- Replace the launch configuration with a launch template
- Add a remote state backend (S3 with DynamoDB locking)
 
