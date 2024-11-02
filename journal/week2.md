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

## Port check Action

An action has been created to check if the Grafana port is accessible. If the port is not accessible an issue is raised.

![image](https://github.com/user-attachments/assets/be209967-6320-4b17-8929-241e85680065)

If the port is accessible and an issue has been raised it closes it.

![image](https://github.com/user-attachments/assets/28cc1314-ac9b-47bf-90da-3df627d7106a)

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

To open an issue we use the action `actions/github-script@v6` with the following Javascript

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

To close the issue we use the action `actions/github-script@v6` with the following Javascript. This step runs only if the Check Port Accessibility step succeeds.

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
