data "terraform_remote_state" "aws" {
  backend = "local"
  config {
    path = "../aws/terraform.tfstate"
  }
}