output "endpoint" {
  value = module.eks.cluster_endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = module.eks.cluster_certificate_authority_data
}

output "worker_security_group_id" {
  value = module.eks.worker_security_group_id
}

output "cluster_security_group_id" {
  # value = module.eks.cluster_security_group_id

  # There is a problem with teraform-eks-aws module now, it returns incorrect value under
  # cluster_security_group_id output. After the fixing upstream module, please, uncomment it back.
  # Bug #1: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/799
  # Bug #2: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/816
  # PR: https://github.com/terraform-aws-modules/terraform-aws-eks/pull/792
  value = data.aws_eks_cluster.current.vpc_config.0.cluster_security_group_id
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "cluster_id" {
  value = module.eks.cluster_id
}
