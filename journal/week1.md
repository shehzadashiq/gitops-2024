# Week 1

- [Week 1](#week-1)
  - [Pre-Commit Installation](#pre-commit-installation)
    - [Pre-Requisites Installation](#pre-requisites-installation)
    - [Terraform Installation](#terraform-installation)
    - [Working Pre-Commit](#working-pre-commit)

## Pre-Commit Installation

Pre-commit needs to be installed with various components

- pre-commit (Installed via pip)
- terraform-docs (Installed via go)

### Pre-Requisites Installation

Pre-commit needs to be installed with the following command

`pip install pre-commit`

I then generated the `.pre-commit-config.yaml` file using the following shell command

```sh
git init
cat <<EOF > .pre-commit-config.yaml
repos:
- repo: https://github.com/antonbabenko/pre-commit-terraform
  rev: v1.96.1
  hooks:
    - id: terraform_fmt
    - id: terraform_docs
EOF
```

Once the pre-commit config has been created, install it `pre-commit install`

Verify that the pre-commit is working using `pre-commit run -a`

Terraform-docs was missing so the following error ws generated

![image](https://github.com/user-attachments/assets/4523ad85-6278-48c6-9c6e-b933a6afb8fa)

Install terraform-docs using `go install github.com/terraform-docs/terraform-docs@v0.19.0`

After this the work still complained that terraform was missing

### Terraform Installation

As the codespace does not have Terraform installed by default. To simplify the process I created a script from the instructions at [https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli](Install Terraform)

This has been placed in `scripts\terraform_install`

```sh
touch bin/terraform_install.sh
chmod u+x bin/terraform_install.sh
```

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

### Working Pre-Commit

Once all the required components were installed, running `pre-commit -a` shows the following which means that the pre-commit has been installed successfully and is working as expected.

## Terraform API Token

Generate token via [https://app.terraform.io/app/settings/tokens](https://app.terraform.io/app/settings/tokens)

### User API Token

![image](https://github.com/user-attachments/assets/59885c02-47e6-4901-a215-985b2b3e867a)

Creates new Popup

![image](https://github.com/user-attachments/assets/1a3e5cc9-e29a-457f-8534-9f127ec5770b)


### Github OAuth Token

![image](https://github.com/user-attachments/assets/47cae3eb-2a43-4424-835e-4ae41b82665a)

Creates new window

![image](https://github.com/user-attachments/assets/f4a17572-2920-4cf1-a92d-85d6ec8ee8ad)


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

![image](https://github.com/user-attachments/assets/5a1f1b7a-181d-4e92-966c-81215587bd40)
