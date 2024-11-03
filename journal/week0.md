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

![image](https://github.com/user-attachments/assets/a34d625f-1ebc-4c56-a9e7-2781b0b3958f)

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
