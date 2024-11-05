# Week 1

- [Week 1](#week-1)
  - [Terraform Installation](#terraform-installation)
    - [Create the Terraform Install Script](#create-the-terraform-install-script)
      - [Terraform Install Script Contents](#terraform-install-script-contents)
  - [AWS Installation](#aws-installation)
    - [Create the AWS Install Script](#create-the-aws-install-script)
      - [AWS Install Script Contents](#aws-install-script-contents)
  - [Pre-Commit Installation](#pre-commit-installation)
    - [Pre-Requisites Installation](#pre-requisites-installation)
    - [Working Pre-Commit](#working-pre-commit)
  - [Terraform Workspace Configuration](#terraform-workspace-configuration)
    - [Terraform API Token](#terraform-api-token)
    - [User API Token](#user-api-token)
    - [Github OAuth Token](#github-oauth-token)
    - [Error when action is run](#error-when-action-is-run)
  - [Terraform workspace configuration](#terraform-workspace-configuration-1)
    - [Execution Mode](#execution-mode)
    - [Errors connecting to Workspace](#errors-connecting-to-workspace)
    - [Terraform Workspace login issues](#terraform-workspace-login-issues)
    - [Further writeup](#further-writeup)
  - [Resources](#resources)

## Terraform Installation

As the codespace does not have Terraform installed by default. To simplify the process I created a script from the instructions at [https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli](Install Terraform)

This has been placed in [/bin/terraform_install](../bin/terraform_install.sh)

### Create the Terraform Install Script

```sh
touch bin/terraform_install.sh
chmod u+x bin/terraform_install.sh
```

#### Terraform Install Script Contents

```sh
#!/bin/bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt-get install terraform
```

## AWS Installation

As the codespace does not have AWS installed by default to simplify the process I created a script from the instructions at [https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html](Install AWS CLI)

This has been placed in [/bin/aws_install](../bin/aws_install.sh)

### Create the AWS Install Script

```sh
touch bin/aws_install.sh
chmod u+x bin/aws_install.sh
```

#### AWS Install Script Contents

```bash
cd ../
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

## Pre-Commit Installation

We will be using the following pre-commit checks that are defined in the repositories [.pre-commit-config.yaml](../.pre-commit-config.yaml)

| Check | Purpose | Source |
|-------|---------|--------|
| [terraform_docs](https://github.com/antonbabenko/pre-commit-terraform?tab=readme-ov-file#:~:text=infracost_breakdown-,terraform_docs,-terraform_docs_replace%20(deprecated)) | Generates documentation from Terraform modules in various output formats | [antonbabenko/pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform) |
| [terraform_fmt](https://github.com/antonbabenko/pre-commit-terraform?tab=readme-ov-file#terraform_fmt) | Rewrites Terraform configuration files to a canonical format and style |[antonbabenko/pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform) |
| [terraform_tflint](https://github.com/terraform-linters/tflint) | Terraform Linter | [antonbabenko/pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform) |
| [yammlint](https://github.com/adrienverge/yamllint) | Linter for Yaml files | [adrienverge/yamllint](https://github.com/adrienverge/yamllint) |
| [markdownlint](https://github.com/DavidAnson/markdownlint) | Checker and lint tool for Markdown/CommonMark files | [igorshubovych/markdownlint-cli](https://github.com/igorshubovych/markdownlint-cli) |

Pre-commit needs to be installed with various components

- pre-commit (Installed via pip)
- terraform-docs (Installed via go)

### Pre-Requisites Installation

The Pre-commit tool needs to be installed with the following command

`pip install pre-commit`

I then generated the `.pre-commit-config.yaml` file using the following shell command

```sh
git init
cat <<EOF > .pre-commit-config.yaml
---
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.96.1
    hooks:
      - id: terraform_docs
      - id: terraform_fmt
      - id: terraform_tflint
  - repo: https://github.com/adrienverge/yamllint.git
    rev: v1.29.0
    hooks:
      - id: yamllint
        args: [--strict, -c=.yamllint]      
  - repo: https://github.com/igorshubovych/markdownlint-cli
    rev: v0.41.0
    hooks:
      - id: markdownlint
        args: [--disable=MD013]   
EOF
```

I also generated the [yamllint](../.yamllint) config file using the following code. This specifies the checks that yamllint will use.

```sh
---
cat <<EOF > .yamllint
yaml-files:
  - '*.yaml'
  - '*.yml'
  - '.yamllint'

rules:
  braces: enable
  brackets: enable
  colons: enable
  commas: enable
  comments:
    level: warning
  comments-indentation:
    level: warning
  document-end: disable
  document-start:
    level: warning
  empty-lines: enable
  empty-values: disable
  float-values: disable
  hyphens: enable
  indentation: enable
  key-duplicates: enable
  key-ordering: disable
  line-length: disable
  new-line-at-end-of-file: enable
  new-lines: disable
  octal-values: disable
  quoted-strings: disable
  trailing-spaces: enable
  truthy: disable
```

Once the pre-commit config has been created, install it `pre-commit install`

Verify that the pre-commit is working using `pre-commit run -a`

Terraform-docs was missing so the following error was generated

![image](https://github.com/user-attachments/assets/4523ad85-6278-48c6-9c6e-b933a6afb8fa)

Install terraform-docs using `go install github.com/terraform-docs/terraform-docs@v0.19.0`

### Working Pre-Commit

Once all the required components were installed, running `pre-commit -a` shows the following which means that the pre-commit has been installed successfully and is working as expected.

![image](https://github.com/user-attachments/assets/f8a58cd1-8293-41d8-b162-c87306322d30)

## Terraform Workspace Configuration

As I will be using Terraform Workspaces to store my state file additional permissions are needed. Specifically the tokens `TF_API_TOKEN` that the Github action can use to access the workspace. Setting this up caused some issues but I have outlined them below.

### Terraform API Token

Generate token via [https://app.terraform.io/app/settings/tokens](https://app.terraform.io/app/settings/tokens)

### User API Token

![image](https://github.com/user-attachments/assets/59885c02-47e6-4901-a215-985b2b3e867a)

Creates new Popup

![image](https://github.com/user-attachments/assets/1a3e5cc9-e29a-457f-8534-9f127ec5770b)

### Github OAuth Token

![image](https://github.com/user-attachments/assets/47cae3eb-2a43-4424-835e-4ae41b82665a)

Creates new window

![image](https://github.com/user-attachments/assets/f4a17572-2920-4cf1-a92d-85d6ec8ee8ad)

![image](https://github.com/user-attachments/assets/5a1f1b7a-181d-4e92-966c-81215587bd40)

### Error when action is run

![image](https://github.com/user-attachments/assets/8c61776a-3ec1-4f42-9cd6-bd98ccbb0e11)

Run `terraform login`

Paste the token here you generated earlier:

If successful you should see the following output

![image](https://github.com/user-attachments/assets/2ce5bd13-bfbe-48ca-b38b-403275036eb6)

```sh
Retrieved token for user shehzadashiq


---------------------------------------------------------------------------------

                                          -                                
                                          -----                           -
                                          ---------                      --
                                          ---------  -                -----
                                           ---------  ------        -------
                                             -------  ---------  ----------
                                                ----  ---------- ----------
                                                  --  ---------- ----------
   Welcome to HCP Terraform!                       -  ---------- -------
                                                      ---  ----- ---
   Documentation: terraform.io/docs/cloud             --------   -
                                                      ----------
                                                      ----------
                                                       ---------
                                                           -----
                                                               -


   New to HCP Terraform? Follow these steps to instantly apply an example configuration:

   $ git clone https://github.com/hashicorp/tfc-getting-started.git
   $ cd tfc-getting-started
   $ scripts/setup.sh
```

## Terraform workspace configuration

### Execution Mode

This needs to be changed to local instead of remote under the workspace settings `/settings/general`

![image](https://github.com/user-attachments/assets/79e2b9a7-5992-47ef-af41-4fd2162a9292)

If configured correctly, the workspace summary will show this.

![image](https://github.com/user-attachments/assets/0057b789-4119-41c6-aadb-a55a71366973)

### Errors connecting to Workspace

After setting the workspace up, the following error was shown in the action

![image](https://github.com/user-attachments/assets/6f73fd80-11d8-4da6-ac75-e069264e7cb7)

To resolve this, the following steps need to be carried out

- Generate an API Token
- Add the secret to the repository with the name `TF_API_TOKEN`
- If environments are being used, the secret `TF_API_TOKEN` needs to be added to these environments too
- In the `terraform.yml` file add the following section

```yaml
    # Install the latest version of Terraform CLI and configure the Terraform CLI configuration file with a Terraform Cloud user API token
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v3
      with:
        cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}
```

If successful the terraform action should be able to initialise successfully.

![image](https://github.com/user-attachments/assets/df82f139-98be-4752-acd5-dbccac99bc3a)

### Terraform Workspace login issues

With the `cloud` provider configured to connect to Terraform workspace I encountered the following error.

![image](https://github.com/user-attachments/assets/388de5ea-0c02-4c99-88d0-24cf4f56be56)

### Further writeup

I also wrote an article that expanded on this in further detail and posted it here [https://shehzadashiq.hashnode.dev/configuring-github-actions-to-use-terraform-workspace](https://shehzadashiq.hashnode.dev/configuring-github-actions-to-use-terraform-workspace)

## Resources

- [https://www.youtube.com/watch?v=OULodhha9R4](Week 1 Livestream)
- [https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli](Install Terraform)
- [Markdownlint Pre-Commit Installation](https://rramos.github.io/2024/06/01/markdownlint/)
