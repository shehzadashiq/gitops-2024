output "grafana_ip" {
  value = "http://${aws_instance.grafana_server.public_ip}:3000"
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  value = data.aws_region.current.name
}