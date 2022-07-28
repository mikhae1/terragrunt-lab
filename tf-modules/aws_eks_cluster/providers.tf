provider "kubernetes" {
  host                   = data.aws_eks_cluster.current.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.current.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.current.token
  load_config_file       = false
  version                = "1.11.1"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.current.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.current.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.current.token
    load_config_file       = false
  }
  version = "1.1.1"
}
