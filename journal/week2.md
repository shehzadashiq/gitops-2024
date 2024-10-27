# Week 2

## Infrastructure Costing

Create an account on [https://www.infracost.io/](https://www.infracost.io/) which will allow you to generate a API key.

Infracost has multiple CI/CD integrations that can be used. We will use `GitHub Actions`.

Once an account has been created, generate an API Token under `Organisation Settings->API tokens`

![image](https://github.com/user-attachments/assets/f5c5d87b-e007-47c6-8c11-c476a1002c95)

In Github set the secret in your repository using the following command

`gh secret set INFRACOST_API_KEY`

To set the secret in the `Production` environment use the following command

`gh secret set -e Production INFRACOST_API_KEY`

Copy action to use from the linked repository [https://github.com/infracost/actions](https://github.com/infracost/actions)
