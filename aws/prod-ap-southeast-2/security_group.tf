module "security_group" {
  source = "../modules/security-group"
  env    = "prod"
  vpc_id = module.network.vpc.id

  security_group = {
    name = "PDNS-prod-sg"
  }
}
