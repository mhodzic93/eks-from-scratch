terraform {
  backend "s3" {
    bucket = local.states_bucket
    key    = "${local.stack_name}/${path.cwd}.state"
    region = local.aws_region
  }
}
