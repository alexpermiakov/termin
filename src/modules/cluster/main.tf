provider "aws" {
  region = var.region
}
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  cluster_name = "termin-eks-pr-${var.pr_number}"
  zones_count  = length(data.aws_availability_zones.available.names)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "k8s-vpc-pr-${var.pr_number}"

  cidr = "10.0.0.0/20"
  azs  = slice(data.aws_availability_zones.available.names, 0, min(3, local.zones_count))

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

resource "aws_iam_role" "eks_worker_node_role" {
  name = "${local.cluster_name}-worker-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
  role       = aws_iam_role.eks_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.34.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.32"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
  }

  eks_managed_node_groups = {
    general-purpose = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      iam_role_arn = aws_iam_role.eks_worker_node_role.arn
    }
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

resource "aws_eks_access_entry" "org_role" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = "arn:aws:iam::${var.aws_account_id}:role/OrganizationAccountAccessRole"
  type              = "STANDARD"
  kubernetes_groups = ["eks-admins"]
}

# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.eks.cluster_name
# }
# resource "kubernetes_cluster_role" "tf_cluster_role" {
#   metadata {
#     name = "tf-cluster-role"
#   }

#   rule {
#     api_groups = ["rbac.authorization.k8s.io"]
#     resources  = ["clusterrolebindings"]
#     verbs      = ["create", "get", "list", "watch", "update", "delete"]
#   }
# }

# resource "kubernetes_cluster_role_binding" "tf_cluster_role_binding" {
#   metadata {
#     name = "tf-cluster-role-binding"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = kubernetes_cluster_role.tf_cluster_role.metadata[0].name
#   }

#   subject {
#     kind      = "User"
#     name      = "arn:aws:iam::${var.aws_account_id}:role/TerraformExecutionRole"
#     api_group = "rbac.authorization.k8s.io"
#   }

#   depends_on = [module.eks]
# }

# resource "kubernetes_cluster_role_binding" "eks_admins_binding" {
#   metadata {
#     name = "eks-admins-cluster-admin-binding"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = "cluster-admin"
#   }

#   subject {
#     kind      = "Group"
#     name      = "eks-admins"
#     api_group = "rbac.authorization.k8s.io"
#   }

#   depends_on = [kubernetes_cluster_role_binding.tf_cluster_role_binding]
# }

module "irsa-ebs-csi" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.39.0"
  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller"]
}
