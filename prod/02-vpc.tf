#####################################
### VPC MODULE
#####################################

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  version            = "5.5.1"
  name               = "${var.tag_env}-VPC"
  cidr               = "10.0.0.0/16"
  enable_nat_gateway = true
  single_nat_gateway = true
  create_database_subnet_route_table = false
  azs                = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.4.0/24", "10.0.5.0/24"]
  database_subnets   = ["10.0.41.0/24", "10.0.42.0/24"]

  tags                               = { "Name" = "${var.tag_env}-VPC" }
  public_subnet_tags                 = { "Name" = "${var.tag_env}-Public-Subnet" }
  private_subnet_tags                = { "Name" = "${var.tag_env}-Private-Subnet" }
  database_subnet_tags               = { "Name" = "${var.tag_env}-Database-Subnet" }
}
