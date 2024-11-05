# GitOps with Terraform 2024 Starter Code

- [GitOps with Terraform 2024 Starter Code](#gitops-with-terraform-2024-starter-code)
  - [.github](#github)
  - [Cloudformation](#cloudformation)
  - [Terraform](#terraform)
  - [Bin](#bin)
  - [Policies](#policies)
  - [Journaling Homework](#journaling-homework)
  - [Grading Rubric](#grading-rubric)

## .github

The [.github](.github/) folder contains resources for the repository.

- [workflows](.github/workflows/) contains workflows for actions
- [pull_request_template](.github/pull_request_template.md) contains the PR template used for PRs

## Cloudformation

The code in the [/cfn](./cfn/) directory is optional. It is used to configure the OIDC role used to authenticate your GitHub Actions workflows to AWS. It also allows you to create an S3 bucket if you want to use it as a backend to store terraform state files.

## Terraform

The code in the [/terraform](./terraform/) directory is the code for the course. It creates the resources required for the bootcamp. It has been modified and corrected after having linting and formatted applied.

## Bin

This contains various scripts to assist in setting up codespaces and local environments.

## Policies

This contains OPA [Open Policy Agent](https://www.openpolicyagent.org/docs/latest/policy-language/) policies used to define guardrail policies.

## Journaling Homework

The [/journal](./journal/) directory contains journal entries based on the contents covered in the appropriate weeks.

- [X] [Week 0](journal/week0.md) - This covers basic setup of the environment
- [X] [Week 1](journal/week1.md) - This covers the basic actions for the project
- [X] [Week 2](journal/week2.md) - This covers the more advanced actions for the project
- [X] [Week 3](journal/week3.md) - This covers items I would like to have carried out but ran out of time

## Grading Rubric

This [Grading Rubric](https://docs.google.com/spreadsheets/d/1rzgmrz60tY4HzUiJ_Cc4_W6dPRW9_j8avzOubugnCns/edit?usp=sharing) is used to mark the project.
