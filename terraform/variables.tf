variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

# tflint-ignore: terraform_unused_declarations
variable "TF_TOKEN_app_terraform_io" {
  type    = string
  default = ""
}