variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "APPID" {}
variable "aws_region" {
  default = "eu-central-1"
}
variable "az_count" {
  default = 3
}
variable "deployer_cidr" {
  default = "0.0.0.0/0"
}
