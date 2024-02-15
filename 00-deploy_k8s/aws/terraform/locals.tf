locals {
  aws_region    = var.aws_region
  stack_name    = "${var.project}-${var.environment}"
  states_bucket = var.states_bucket

  azs      = slice(data.aws_availability_zones.available.names, 0, 2)
  vpc_cidr = var.vpc_cidr

  tags = {
    Environment = var.environment
  }
}
