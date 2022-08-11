data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"
  name    = "vpc_${var.cluster_name}"
  cidr    = var.vpc_cidr_block
  azs     = data.aws_availability_zones.available.names
  private_subnets = [
    for num in [11, 22, 33] :
    cidrsubnet(var.vpc_cidr_block, 8, num)
  ]
  public_subnets = [
    for num in [1, 2, 3] :
    cidrsubnet(var.vpc_cidr_block, 8, num)
  ]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  # enable_ses_endpoint              = true
  # ses_endpoint_private_dns_enabled = true
  # ses_endpoint_security_group_ids  = ["${aws_security_group.ses_endpoint.id}"]

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "true"
  }
}

resource "aws_security_group" "ses_endpoint" {
  name        = "${var.cluster_name}-ses-vpc-endpoint"
  description = "Managed by Terraform (Allow access to the SES VPC Endpoint)"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${var.cluster_name}-ses-vpc-endpoint"
  }
}

resource "aws_security_group_rule" "ses_endpoint_in" {
  type      = "ingress"
  from_port = 0
  to_port   = 65535
  protocol  = "tcp"
  cidr_blocks = [
    for num in [11, 22, 33] :
    cidrsubnet(var.vpc_cidr_block, 8, num)
  ]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.ses_endpoint.id
}

# resource "aws_vpc_peering_connection_accepter" "peer" {
#   vpc_peering_connection_id = var.aws_peering_accepter_vpc_id
#   auto_accept               = true
# }

# resource "aws_route" "peer_eu" {
#   route_table_id            = module.vpc.private_route_table_ids[0]
#   destination_cidr_block    = var.peer_cidr_block
#   vpc_peering_connection_id = var.aws_peering_accepter_vpc_id
#   depends_on                = [aws_vpc_peering_connection_accepter.peer]
# }

resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
