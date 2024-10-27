# Week 0

Introduction to bootcamp.

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
