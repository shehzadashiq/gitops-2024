# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret

resource "github_actions_secret" "TF_API_TOKEN" {
  repository      = "shehzadashiq/gitops-2024 "
  secret_name     = "TF_API_TOKEN"
  plaintext_value = var.TF_TOKEN_app_terraform_io
}