# Week 0

- [Week 0](#week-0)
  - [Adding Secrets](#adding-secrets)
  - [Branch Protection](#branch-protection)
    - [Branch Protection Rules](#branch-protection-rules)
  - [Added Github PR Template](#added-github-pr-template)

This week acts as an introduction to the bootcamp.

## Adding Secrets

To add a secret using the gh client use the following format

`gh secret set secret_name`

E.g to set a secret named `TOP_SECRET` you will use the following command

`gh secret set TOP_SECRET`

To set the same secret in an environment named `Production` use the following format `gh secret set -e environment_name secret_name` e.g.

`gh secret set -e Production TOP_SECRET`

This can then be referenced in an actions file with the following `secret-to-use: ${{ secrets.TOP_SECRET }}`

## Branch Protection

### Branch Protection Rules

The following protections have applied

- Require a pull request before merging
- Require status checks to pass before merging

![image](https://github.com/user-attachments/assets/5010a999-79e3-4f04-8c48-ea1a4529fc80)

## Added Github PR Template

The following [PR Template](../.github/pull_request_template.md) was created.
