module "baseline" {
  source = "./baseline"

  vpc_cidr             = var.vpc_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs

  domain_name = var.account_domain_name
}
