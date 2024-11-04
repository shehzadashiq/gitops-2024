# Week 2

- [Week 2](#week-2)
  - [Common Actions](#common-actions)
  - [Infrastructure Costing](#infrastructure-costing)
  - [TFLinting Action](#tflinting-action)
  - [Port check Action](#port-check-action)
  - [PR Comment Action](#pr-comment-action)
  - [Infrastructure Drift Action](#infrastructure-drift-action)
  - [Terraform Cloud Drift Action](#terraform-cloud-drift-action)
  - [Terraform S3 Drift Action](#terraform-s3-drift-action)

In this week various actions were created. These have been listed below with any requirements needed to work

## Common Actions

As actions need to checkout code they have some common Github actions. These are listed below.

| Action    | Purpose |
| -------- | ------- |
| [actions/checkout@v4](https://github.com/actions/checkout) | Checkout the repository to the GitHub Actions runner    |
| [actions/cache@v4](https://github.com/actions/cache) | Caches plugin dir |
| [aws-actions/configure-aws-credentials@v4](https://github.com/aws-actions/configure-aws-credentials) | Configures AWS Credentials |
| [hashicorp/setup-terraform@v3](https://github.com/hashicorp/setup-terraform) | Installs the latest version of Terraform CLI and configures the Terraform CLI configuration file with a Terraform Cloud user API token |

Actions have also been modified to allow `workflow_dispatch` event. This allows the action to be run manually. This simplifies testing of actions.

## Infrastructure Costing

The [Run Infracost](../.github/workflows/infracost.yml) action checks a PR to see if it fulfills infrastructure policies before allowing a PR merge to complete.

Create an account on [https://www.infracost.io/](https://www.infracost.io/) which will allow you to generate a API key.

Infracost has multiple CI/CD integrations that can be used. We will use `GitHub Actions`.

Once an account has been created, generate an API Token under `Organisation Settings->API tokens`

![image](https://github.com/user-attachments/assets/f5c5d87b-e007-47c6-8c11-c476a1002c95)

In Github set the secret in your repository using the following command

`gh secret set INFRACOST_API_KEY`

To set the secret in the `Production` environment use the following command

`gh secret set -e Production INFRACOST_API_KEY`

Copy action to use from the linked repository [https://github.com/infracost/actions](https://github.com/infracost/actions)

## TFLinting Action

The [Lint](../.github/workflows/tflint.yml) action has been created that lints Terraform files and checks for any errors. A comment is created on the PR when TFLint fails

![image](https://github.com/user-attachments/assets/ee30688c-569f-4557-8dd5-5ac75d415763)

It uses the following action [setup-tflint](https://github.com/terraform-linters/setup-tflint)

To create a comment the following additional code was needed. If there is any failed output a text file `tflint_output.txt` is generated. The next step checks if this file exists and that the current event is a Pull Request. If so it will then output the text as a PR comment.

```yaml
      - name: Run TFLint
        run: |
          tflint -f compact > tflint_output.txt || true
          if [ -s tflint_output.txt ]; then
            echo "TFLINT_FAILED=true" >> $GITHUB_ENV
          else
            echo "TFLINT_FAILED=false" >> $GITHUB_ENV
          fi

      - name: Comment on PR with TFLint Issues
        if: env.TFLINT_FAILED == 'true' && github.event_name == 'pull_request'
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs');
            const tflintOutput = fs.readFileSync('./terraform/tflint_output.txt', 'utf8');
            const commentBody = `### :warning: TFLint Issues Detected\n\n\`\`\`\n${tflintOutput}\n\`\`\`\nPlease review the above issues reported by TFLint.`;

            await github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
              body: commentBody,
            });
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Port check Action

The [Check Port Accessibility](../.github/workflows/portcheck.yml) action has been created to check if the Grafana port is accessible. If the port is not accessible an issue is raised.

![image](https://github.com/user-attachments/assets/be209967-6320-4b17-8929-241e85680065)

If the port is accessible and an issue has been raised it closes it.

![image](https://github.com/user-attachments/assets/28cc1314-ac9b-47bf-90da-3df627d7106a)

This will show as the github-actions closing the issue.

![image](https://github.com/user-attachments/assets/b0dbc3b6-0b93-4d5c-adb5-dffdab752707)

An example of an issue that has been opened and closed is [https://github.com/shehzadashiq/gitops-2024/issues/49](https://github.com/shehzadashiq/gitops-2024/issues/49)

This is achieved by a running a terraform plan and extracting it's output.

Once the output has been extracted, regex is used to extract the URL and port. These are then stored as environment variables.

```bash
          url=$(jq -r '.grafana_ip.value' < /tmp/plan.json)
          # port=$(jq -r '.instance_port.value' < /tmp/plan.json)

          # Use regex to extract IP and port from the URL
          ip=$(echo "$url" | sed -E 's|http://([^:]+):([0-9]+)|\1|')
          port=$(echo "$url" | sed -E 's|http://([^:]+):([0-9]+)|\2|')

          if [[ -z "$ip" || -z "$port" ]]; then
            echo "Error: IP or PORT value is empty."
            exit 1
          fi

          echo "IP=$ip" >> $GITHUB_ENV
          echo "PORT=$port" >> $GITHUB_ENV
```

We then use the shell to check if the port is accessible. For the action to continue we need to ensure the following property is set `continue-on-error: true`

This ensures that even on a failure the action continues to run

```yaml
      # Step Check if the port is accessible
      - name: Check Port Accessibility
        id: check-port
        run: |
          echo "Checking if $IP:$PORT is accessible..."
          timeout 5 bash -c "cat < /dev/null > /dev/tcp/$IP/$PORT"
        continue-on-error: true
```

To open an issue we use the action [actions/github-script@v6](https://github.com/actions/github-script) with the following Javascript

```js
            const ip = process.env.IP;
            const port = process.env.PORT;
            const issueTitle = `Grafana Port is not accessible`;
            const issueBody = `Port 3000 on IP ${ip} could not be reached. Please investigate the issue.`;

            // Check if an issue already exists
            const existingIssues = await github.rest.issues.listForRepo({
              owner: context.repo.owner,
              repo: context.repo.repo,
              state: 'open',
            });

            // Only create an issue if one with the same title does not exist
            if (!existingIssues.data.some(issue => issue.title === issueTitle)) {
              await github.rest.issues.create({
                owner: context.repo.owner,
                repo: context.repo.repo,
                title: issueTitle,
                body: issueBody,
              });
            }
```

To close the issue we use the action [actions/github-script@v6](https://github.com/actions/github-script) with the following Javascript. This step runs only if the Check Port Accessibility step succeeds.

It searches for an open issue with the title `Grafana Port is not accessible`. If such an issue exists, it closes the issue by updating its state to closed.

```js
            const ip = process.env.IP;
            const port = process.env.PORT;
            const issueTitle = `Grafana Port is not accessible`;

            const existingIssues = await github.rest.issues.listForRepo({
              owner: context.repo.owner,
              repo: context.repo.repo,
              state: 'open',
            });

            // Find and close the issue if it exists
            const issueToClose = existingIssues.data.find(issue => issue.title === issueTitle);
            if (issueToClose) {
              await github.rest.issues.update({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: issueToClose.number,
                state: 'closed',
              });
            }
```

## PR Comment Action

The [Enforce Comment Requirement on PR](../.github/workflows/pr_comment_check.yml) will not allow a PR to merge unless a comment exists on it. If a comment exists it will pass otherwise it will fail.

This is used in conjunction with a branch protection rule to ensure that the PR can only be merged if the checks pass.

It uses the [actions/github-script@v6](https://github.com/actions/github-script)

The following

```yaml
---
name: Enforce Comment Requirement on PR

on:
  pull_request:
    types: [opened, edited, synchronize, reopened]
  pull_request_review_comment:
    types: [created, deleted, edited]

jobs:
  check-comments:
    runs-on: ubuntu-latest
    steps:
      - name: Check for PR Comments
        uses: actions/github-script@v6
        env:
          GITHUB_TOKEN: ${{ github.token }}
        with:
          script: |
            const { data: comments } = await github.rest.issues.listComments({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
            });

            if (comments.length === 0) {
              core.setFailed("PR cannot be merged until it has at least one comment.");
            } else {
              console.log("PR has comments and is ready for review.");
            }

```

## Infrastructure Drift Action

The [Drift Detection](../.github/workflows/drift.yml) action checks to see if there is any drift in the infrastructure. If any drift is detected, an issue is raised. If the drift is resolved then it will close the issue.

An example of an issue that has been opened and closed is [https://github.com/shehzadashiq/gitops-2024/issues/70](https://github.com/shehzadashiq/gitops-2024/issues/70)

This is achieved by a running a terraform plan and saving its output to a file

```yaml
      # Check for Drift with Terraform Plan
      - name: Terraform Plan
        id: plan
        run: |
          terraform plan -input=false > plan.txt
          if grep -q "0 to add, 0 to change, 0 to destroy" plan.txt; then
            echo "No drift detected."
            echo "DRIFT=false" >> $GITHUB_ENV
          else
            echo "Drift detected!"
            echo "DRIFT=true" >> $GITHUB_ENV
          fi
```

Once the output has been extracted, we extract only the 5 lines where any changes are found. These are then stored as environment variables.

```yaml
      # Read and Extract Drift Details
      - name: Extract Plan Output
        if: env.DRIFT == 'true'
        id: extract-plan
        run: |
          # Extract lines showing changes only
          grep -A 5 'Plan:' plan.txt > drift_details.txt || echo "No specific changes found in plan."
          # Convert to a GitHub-friendly format
          if [ -s drift_details.txt ]; then
            echo "DRIFT_DETAILS=$(cat drift_details.txt | sed 's/$/  /' | tr '\n' '\\n')" >> $GITHUB_ENV
          else
            echo "DRIFT_DETAILS=No specific drift changes detected." >> $GITHUB_ENV
          fi
```

To open an issue we use the action [actions/github-script@v6](https://github.com/actions/github-script) with the following Javascript

```yaml
      # Create Issue if Drift is Detected
      - name: Create Issue if Drift Detected
        if: env.DRIFT == 'true'
        uses: actions/github-script@v6
        with:
          script: |
            const issueTitle = 'Terraform Drift Detected';
            const issueBody = `Terraform drift has been detected in the infrastructure.\n\n
                    Please review the details in the latest Terraform plan output.\n\n
                    Here are the details from the latest plan:\n\n
                    \`\`\`\n${process.env.DRIFT_DETAILS}\n\`\`\`\n\n`;

            const existingIssues = await github.rest.issues.listForRepo({
              owner: context.repo.owner,
              repo: context.repo.repo,
              state: 'open',
            });

            if (!existingIssues.data.some(issue => issue.title === issueTitle)) {
              await github.rest.issues.create({
                owner: context.repo.owner,
                repo: context.repo.repo,
                title: issueTitle,
                body: issueBody,
              });
            }
```

An issue raised with the title `Terraform Drift Detected`.

The output is also attached as an attachment to the action.

To close the issue we use the action [actions/github-script@v6](https://github.com/actions/github-script) with the following Javascript. This step runs only if no infrastructure drift exists.

It searches for an open issue with the title `Terraform Drift Detected`. If such an issue exists, it closes the issue by updating its state to closed.

```yaml
      # Close Issue if Drift is Resolved
      - name: Close Issue if Drift is Resolved
        if: env.DRIFT == 'false'
        uses: actions/github-script@v6
        with:
          script: |
            const issueTitle = 'Terraform Drift Detected';

            const existingIssues = await github.rest.issues.listForRepo({
              owner: context.repo.owner,
              repo: context.repo.repo,
              state: 'open',
            });

            // Find and close the issue if it exists
            const issueToClose = existingIssues.data.find(issue => issue.title === issueTitle);
            if (issueToClose) {
              await github.rest.issues.update({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: issueToClose.number,
                state: 'closed',
              });
            }
```

## Terraform Cloud Drift Action

I found this action [https://github.com/slok/tfe-drift](https://github.com/slok/tfe-drift) which could be used with workspaces hosted in Terraform cloud.

I had  intended to use [Drift Detection - Terraform Cloud](../.github/workflows/drift_terraform_cloud.yml) action to run against Terraform cloud where I am storing my state files. This version of drift detection does not work with Terraform cloud as it requires remote execution to be enabled on the workspaces which causes other actions to fail.

```yaml
---
name: 'Drift Detection - Terraform Cloud'

on:
  workflow_dispatch:
  schedule:
    # - cron:  '0 * * * *' # Every hour.
    # - cron: '*/5 * * * *'
    - cron: '0 0 * * *'  # Runs daily at midnight (UTC)

jobs:
  drift-detection:
    runs-on: ubuntu-latest
    steps:
      - uses: slok/tfe-drift-action@v0.4.0
        id: tfe-drift
        with:
          tfe-token: ${{ secrets.TFE_TOKEN }}
          tfe-org: ${{ secrets.TFE_ORGANIZATION }}
          limit-max-plans: 3
```

## Terraform S3 Drift Action

This action [Drift Detection S3](../.github/workflows/drift_s3.yml) can access state files stored in a S3 backend. As the state files for this project are stored in Terraform Workspace this action is not needed.

This version of drift detection does not work with Terraform cloud as it cannot access the TF_API_TOKEN

```yaml
---
name: 'Drift Detection S3'

on:
  workflow_dispatch:
  schedule:
    # - cron: '*/30 * * * *'
    - cron: '0 0 * * *'  # Runs daily at midnight (UTC)

jobs:
  detect_drift:
    uses: ./.github/workflows/plan.yml
    permissions:
      contents: read
      id-token: write
      pull-requests: write
    secrets:
      ROLE_TO_ASSUME: ${{ secrets.ROLE_TO_ASSUME }}
      cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}      
```
