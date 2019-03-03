variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "APPID" {}
variable "aws_region" {
  default = "eu-central-1"
}
//variable "vpc_id" {
//  default = "vpc-5744433c"
//}
//variable "security_groups" {
//  type = "list"
//  default = ["sg-e8693c86"]
//}
//variable "subnets" {
//  type = "list"
//  default = ["subnet-06c12e6c", "subnet-48a1fb35", "subnet-99f5dcd4"]
//}
variable "az_count" {
  default = 3
}
