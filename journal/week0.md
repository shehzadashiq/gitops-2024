# Week 0

- [Week 0](#week-0)
  - [Environment Used](#environment-used)
  - [Adding Secrets](#adding-secrets)
  - [OIDC Role](#oidc-role)
  - [Branch Protection](#branch-protection)
    - [Branch Protection Rules](#branch-protection-rules)
  - [Added Github PR Template](#added-github-pr-template)
  - [Resources](#resources)

This week acts as an introduction to the bootcamp.

## Environment Used

Instead of using an S3 backend to store my statefiles I will be using [Terraform Cloud Workspaces](https://app.terraform.io/)

## Adding Secrets

To add a secret using the gh client use the following format

`gh secret set secret_name`

E.g to set a secret named `TOP_SECRET` you will use the following command

`gh secret set TOP_SECRET`

To set the same secret in an environment named `Production` use the following format `gh secret set -e environment_name secret_name` e.g.

`gh secret set -e Production TOP_SECRET`

This can then be referenced in an actions file with the following `secret-to-use: ${{ secrets.TOP_SECRET }}`

## OIDC Role

To work within GitHub Actions we use OpenID Connect (OIDC) to authenticate Terraform to AWS for deployments using GitHub Actions. This was covered in Derek's video

[GitHub Actions: Configure OIDC Authentication for AWS and Terraform](https://www.youtube.com/watch?v=USIVWqXVv_U)

As recommended I saved the OIDC role as a variable within my Github Environment.

These were created using the Cloudformation files in this repository

- [oidc-role.yaml](../cfn/oidc-role.yaml)
- [backend-resources.yaml](../cfn/backend-resources.yaml) - I created resources using this but this was not needed as I am using Terraform Cloud Workspaces

## Branch Protection

### Branch Protection Rules

The following protections have applied

- Require a pull request before merging
- Require status checks to pass before merging

![image](https://github.com/user-attachments/assets/72311bea-9db1-483c-a6d7-4897a8c6163e)

The following checks are required to merge a PR to main

- Comment is required on a PR
- Infracost PR Check
- Terraform Plan
- TFLint checks

## Added Github PR Template

The following [PR Template](../.github/pull_request_template.md) was created. It requires the following.

```md
# Description of PR

Outline what the purpose of this PR is

## Contributors

@shehzadashiq

## Checklist

- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
```

## Resources

- [Week 0 Livestream](https://www.youtube.com/watch?v=ciqxSVo4JXk&t=18s)
- [GitHub Actions: Configure OIDC Authentication for AWS and Terraform](https://www.youtube.com/watch?v=USIVWqXVv_U)
