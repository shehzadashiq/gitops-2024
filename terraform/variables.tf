variable "region" {
  type    = string
  default = "us-east-1"
}
variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "TF_VAR_AWS_ACCESS_KEY_ID" {
  type      = string
  sensitive = true
}

variable "TF_VAR_AWS_SECRET_ACCESS_KEY" {
  type      = string
  sensitive = true
}