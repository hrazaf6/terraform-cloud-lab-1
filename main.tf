module "vpc" {
  source        = "./aws-vpc"
  cidr_block    = "172.40.0.0/16"
  environment   = "development"
  name          = "Hamid"
  public_subnet = ["pub1", "pub2", "pub3"]
}

output "vpc_id" {
  value = module.vpc.vpc_id
}