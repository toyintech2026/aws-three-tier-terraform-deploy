# Creating a VPC and EKS cluster using Terraform
module "vpc-deployment" {
  source = "./module-vpc"

  environment       = var.environment
  vpc_cidrblock     = var.vpc_cidrblock
  countsub          = var.countsub
  create_subnet     = var.create_subnet
  create_elastic_ip = var.create_elastic_ip

}

#creating an EKS cluster using Terraform
# and deploying it in the VPC created above
module "eks-deployment" {
  source = "./module-eks"

  environment        = var.environment
  vpc_cidrblock      = var.vpc_cidrblock
  countsub           = var.countsub
  create_subnet      = var.create_subnet
  create_elastic_ip  = var.create_elastic_ip
  desired_size       = var.desired_size
  max_size           = var.max_size
  min_size           = var.min_size
  instance_types     = var.instance_types
  capacity_type      = var.capacity_type
  public_subnet_ids  = module.vpc-deployment.public_subnet_ids
  private_subnet_ids = module.vpc-deployment.private_subnet_ids
  cluster_name       = var.cluster_name
  repository_name    = var.repository_name
  domain-name        = var.domain-name
  email              = var.email

}

# module "namecheap-deployment" {
#   source = "./module-dns"
#   domain_name = var.domain_name
#   namecheap_api_user = var.namecheap_api_user
#   namecheap_api_key = var.namecheap_api_key
#   namecheap_username = var.namecheap_username
#   namecheap_client_ip = var.namecheap_client_ip
# }

module "rds-mysql-deployment" {
  source                 = "./module-database"
  environment            = var.environment
  db_instance_class      = var.db_instance_class
  db_allocated_storage   = var.db_allocated_storage
  private_subnet_db_ids  = module.vpc-deployment.private_subnet_db_ids
  db_name                = var.db_name
  db_password            = var.db_password
  db_username            = var.db_username
  aws_security_group_ids = module.vpc-deployment.aws_security_group_ids
}