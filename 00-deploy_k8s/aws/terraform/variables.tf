variable "aws_region" {}
variable "environment" {}
variable "project" {}
variable "states_bucket" {}
variable "vpc_cidr" {
  default =  "10.0.0.0/16"
}
