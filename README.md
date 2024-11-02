# GitOps with Terraform 2024 Starter Code

## Cloudformation

The code in the ./cloudformation directory is optional. It is used to configure the OIDC role used to authenticate your GitHub Actions workflows to AWS. It also allows you to create an S3 bucket if you want to use it as a backend to store terraform state files.

## Terraform

The code in the ./terraform directory is the code for the course. It creates the resources required for the bootcamp. It has been modified and corrected after having linting and formatted applied.

## Bin

This contains various scripts to assist in setting up codespaces.

## Policies

This contains OPA [Open Policy Agent](https://www.openpolicyagent.org/docs/latest/policy-language/) policies used to define guardrail policies.

## Journaling Homework

The `/journal` directory contains journal entries based on the contents covered in the appropriate weeks.

- [X] [Week 0](journal/week0.md)
- [X] [Week 1](journal/week1.md)
- [X] [Week 2](journal/week2.md)
