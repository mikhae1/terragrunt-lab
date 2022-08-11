resource "random_password" "rds_master_password" {
  length  = 16
  special = false
}

resource "aws_rds_cluster_parameter_group" "age-gate-aurora-mysql57" {
  name   = "${var.cluster_name}-age-gate-aurora-mysql57"
  family = "aurora-mysql5.7"
  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "dedicated"
  }
}

resource "aws_db_parameter_group" "age-gate-aurora-mysql57" {
  name   = "${var.cluster_name}-age-gate-aurora-mysql57"
  family = "aurora-mysql5.7"
  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "dedicated"
  }
  parameter {
    apply_method = "immediate"
    name         = "general_log"
    value        = "0"
  }
}

module "rds-aurora" {
  source                              = "terraform-aws-modules/rds-aurora/aws"
  version                             = "~> v2.0"
  name                                = "rds-${var.cluster_name}-age-gate"
  engine                              = "aurora-mysql"
  engine_version                      = "5.7.mysql_aurora.2.09.2"
  instance_type                       = var.instance_type
  vpc_id                              = var.vpc_id
  subnets                             = var.vpc_public_subnets
  iam_database_authentication_enabled = true
  preferred_backup_window             = "04:00-07:00"
  preferred_maintenance_window        = "Mon:01:00-Mon:04:00"
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.age-gate-aurora-mysql57.name
  db_parameter_group_name             = aws_db_parameter_group.age-gate-aurora-mysql57.name
  replica_count                       = var.replica_count
  publicly_accessible                 = true
  allowed_security_groups             = [var.cluster_security_group_id]
  allowed_cidr_blocks                 = var.allowed_cidr_blocks
  password                            = random_password.rds_master_password.result
  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "dedicated"
  }
}

provider "mysql" {
  # this endpoint will only work with EPAM VPN (RU or EU) connected
  endpoint = module.rds-aurora.this_rds_cluster_endpoint
  username = module.rds-aurora.this_rds_cluster_master_username
  password = random_password.rds_master_password.result
}

resource "mysql_user" "salmon" {
  user        = "Salmon"
  host        = "%"
  auth_plugin = "AWSAuthenticationPlugin"
  tls_option  = "SSL"
}

resource "mysql_grant" "salmon" {
  user     = mysql_user.salmon.user
  host     = "%"
  database = "*"
  # RDS master user doesn't have all privileges itself, so granting ALL PRIVILEGES is impossible
  privileges = ["SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, PROCESS, REFERENCES, INDEX, ALTER, SHOW DATABASES, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER"]
  grant      = true
}
