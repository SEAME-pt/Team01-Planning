# Creating GitHub Self-Hosted Runners

## Overview

Self-hosted runners allow you to run GitHub Actions workflows on your own infrastructure. This guide focuses on the process of creating and setting up self-hosted runners at different levels: repository, organization, and enterprise.

## Prerequisites

Before creating a self-hosted runner:
- Access to the target Linux machine (physical, virtual, or container)
- Network connectivity to GitHub.com
- Appropriate permissions:
  - Repository owner (for repo-level)
  - Organization owner (for org-level)
  - Enterprise owner (for enterprise-level)

## Creating a Repository-Level Runner

### Steps

1. **Navigate to Repository Settings**
   - Go to your repository on GitHub
   - Click "Settings" tab
   - In left sidebar, click "Actions" > "Runners"

2. **Add New Runner**
   - Click "New self-hosted runner"
   - Select Linux and your architecture (x64/ARM/ARM64)

3. **Download and Configure**
   - Follow the displayed instructions
   - Download the runner package
   - Extract to a directory (e.g., `/home/runner/actions-runner`)

4. **Run Configuration Script**
   ```bash
   ./config.sh --url https://github.com/YOUR-ORG/YOUR-REPO --token YOUR_TOKEN
   ```

5. **Start the Runner**
   ```bash
   ./run.sh
   ```

### Installing as a Service (Recommended for Production)

After configuration:
```bash
sudo ./svc.sh install
sudo ./svc.sh start
```

## Creating an Organization-Level Runner

### Steps

1. **Navigate to Organization Settings**
   - Go to your organization on GitHub
   - Click "Settings" tab
   - In left sidebar, click "Actions" > "Runners"

2. **Add New Runner**
   - Click "New runner" > "New self-hosted runner"
   - Select Linux and your architecture

3. **Configure on Your Machine**
   - Use the provided URL (organization URL) and token
   - Run config script as above, but with org URL

4. **Optional: Assign to Runner Group**
   - During config, use `--runnergroup GROUP_NAME`
   - Or move later in GitHub settings

## Creating an Enterprise-Level Runner

### Steps

1. **Navigate to Enterprise Settings**
   - Go to your enterprise account
   - Click "Settings" tab
   - Click "Actions" > "Runners"

2. **Add New Runner**
   - Click "New runner" > "New self-hosted runner"
   - Select Linux and your architecture

3. **Configure with Enterprise URL**
   - Use enterprise URL and token
   - Run config script as above

## Runner Groups (Organization/Enterprise)

### Creating a Group

1. In org/enterprise settings > Actions > Runner groups
2. Click "New runner group"
3. Set name and access policy (all repos or selected)

### Adding Runner to Group

During config:
```bash
./config.sh --url $URL --token $TOKEN --runnergroup "group-name"
```

Or move existing runners in settings.

## Custom Labels

Add custom labels during config:
```bash
./config.sh --labels "label1,label2"
```

Or add/remove later in runner settings.

## Verification

After setup, check:
- Runner appears in GitHub settings with "Idle" status
- Terminal shows: "√ Connected to GitHub" and "Listening for Jobs"

## Troubleshooting Common Issues

- **Token Expired**: Generate new token in GitHub settings
- **Network Issues**: Ensure outbound HTTPS to GitHub
- **Permissions**: Verify you have correct access level
- **Service Not Starting**: Check logs in runner directory

## Next Steps

- Configure workflows to use `runs-on: self-hosted`
- Set up monitoring and updates
- Consider autoscaling with Actions Runner Controller

For detailed requirements and advanced options, see [GitHub's official documentation](https://docs.github.com/en/actions/hosting-your-own-runners).