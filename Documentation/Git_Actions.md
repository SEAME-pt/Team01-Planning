# Git / GitHub Actions Documentation

## Table of Contents
1. [What is GitHub Actions?](#what-is-github-actions)
2. [Getting Started](#getting-started)
3. [Workflow Structure](#workflow-structure)
4. [Using Self-Hosted Runners](#using-self-hosted-runners)
5. [Best Practices](#best-practices)
6. [Troubleshooting](#troubleshooting)

---

## What is GitHub Actions?

GitHub Actions is a CI/CD platform that automatically runs code when certain events happen in your repository (like pushes, pull requests, etc.). It helps you:
- **Automatically test** your code when changes are made
- **Build and deploy** applications
- **Ensure code quality** before merging
- **Save time** by automating repetitive tasks

---

## Getting Started

### 1. Create Workflow Directory
In your repository root, create the workflow directory:
```
your-repo/
├── .github/
│   └── workflows/
│       └── your-workflow.yml
└── src/
```

### 2. Basic Workflow File
Create `.github/workflows/ci.yml`:

```yaml
name: My First Workflow

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Run a simple command
        run: echo "Hello, GitHub Actions!"
```

---

## Workflow Structure

Every GitHub Actions workflow has these parts:

### 1. **Name** (optional)
```yaml
name: CI Pipeline
```

### 2. **Triggers** (`on`)
When the workflow should run:
```yaml
on:
  push:                    # Run on every push
  pull_request:           # Run on every PR
  schedule:
    - cron: '0 2 * * *'    # Run daily at 2 AM (UTC)
```

### 3. **Jobs**
What work to do:
```yaml
jobs:
  job-name:
    runs-on: ubuntu-latest
    steps:
      - name: Do something
        run: echo "Working..."
```

### 4. **Steps**
Individual tasks within a job:
```yaml
steps:
  - name: Checkout code
    uses: actions/checkout@v4    # Use a pre-built action
    
  - name: Run command
    run: echo "Custom command"   # Run shell command
```

---

## Using Self-Hosted Runners

GitHub Actions can run on your own infrastructure using self-hosted runners. This is useful for:
- **Special hardware access** (CAN interfaces, GPUs, etc.)
- **Custom software environments**
- **Security requirements** (keeping code within your network)
- **Cost optimization** for high-compute workloads

### Setting Up Self-Hosted Runners

For detailed setup instructions, see [Self_Hosted_Runners.md](Self_Hosted_Runners.md).

### Running Workflows on Self-Hosted Runners

#### Basic Usage
```yaml
jobs:
  test:
    runs-on: self-hosted  # Use any self-hosted runner
    
    steps:
      - uses: actions/checkout@v4
      - run: echo "Running on self-hosted runner"
```

#### Using Labels for Specific Runners
```yaml
jobs:
  hardware-test:
    runs-on: [self-hosted, linux, x64, can-enabled]  # Runner with CAN hardware
    
    steps:
      - uses: actions/checkout@v4
      - name: Test CAN interface
        run: ./test-can-interface.sh
```

#### Using Runner Groups (Organization/Enterprise)
```yaml
jobs:
  secure-build:
    runs-on:
      group: secure-runners  # Specific runner group
      labels: [linux, x64]
    
    steps:
      - uses: actions/checkout@v4
      - name: Build sensitive project
        run: ./secure-build.sh
```

### Safety Considerations for Self-Hosted Runners

#### 1. **Use with Private Repositories Only**
Self-hosted runners can be dangerous with public repositories because:
- Forks can execute code on your infrastructure
- Malicious PRs could compromise your network

```yaml
# ❌ Dangerous: Public repo with self-hosted runners
on: [push, pull_request]

# ✅ Safer: Private repo or restrict to trusted sources
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
    paths-ignore:
      - 'docs/**'
      - '*.md'
```

#### 2. **Isolate Sensitive Operations**
Use different runners for different trust levels:
```yaml
jobs:
  lint:
    runs-on: ubuntu-latest  # GitHub-hosted for untrusted code
    
  build:
    runs-on: [self-hosted, trusted]  # Self-hosted for trusted builds
    needs: lint
    
  deploy:
    runs-on: [self-hosted, secure]  # Most secure runner for deployment
    needs: build
```

#### 3. **Clean Up After Jobs**
Ensure runners don't retain sensitive data:
```yaml
- name: Clean workspace
  if: always()  # Run even if job fails
  run: |
    # Remove temporary files
    rm -rf /tmp/build-artifacts
    # Clear sensitive environment variables
    unset SECRET_TOKEN
```

#### 4. **Network Security**
- Keep runners in secure networks
- Use VPNs for external access
- Implement firewall rules
- Regularly update runner software

#### 5. **Access Control**
- Use runner groups to limit repository access
- Assign appropriate permissions
- Audit runner usage regularly

#### 6. **Monitor and Log**
```yaml
- name: Log runner info
  run: |
    echo "Runner: ${{ runner.name }}"
    echo "OS: ${{ runner.os }}"
    echo "Architecture: ${{ runner.arch }}"
    echo "Job started at: $(date)"
    
- name: Send notifications on failure
  if: failure()
  run: |
    curl -X POST -H 'Content-type: application/json' \
      --data '{"text":"Self-hosted runner job failed"}' \
      $SLACK_WEBHOOK_URL
```

### Best Practices for Self-Hosted Runners

1. **Dedicated Hardware**: Use separate machines for CI/CD
2. **Regular Updates**: Keep OS and runner software current
3. **Resource Monitoring**: Monitor CPU, memory, and disk usage
4. **Backup Strategies**: Have backup runners for redundancy
5. **Security Scanning**: Regularly scan runners for vulnerabilities
6. **Documentation**: Document your runner setup and policies

### Example: Safe Self-Hosted Workflow

```yaml
name: Secure Hardware Testing

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
    types: [opened, synchronize, reopened]

jobs:
  # Run basic checks on GitHub-hosted runners first
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Lint code
        run: ./lint.sh
      - name: Static analysis
        run: ./static-analysis.sh
  
  # Run hardware tests on self-hosted runners
  hardware-test:
    needs: validate
    runs-on: [self-hosted, linux, x64, can-enabled]
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup CAN interface
        run: |
          sudo modprobe vcan
          sudo ip link add dev vcan0 type vcan
          sudo ip link set up vcan0
      
      - name: Build and test
        run: |
          mkdir build && cd build
          cmake -DBUILD_TESTS=ON ..
          make
          ctest --output-on-failure
      
      - name: Cleanup
        if: always()
        run: |
          sudo ip link delete vcan0
          rm -rf build
---

## Best Practices

### 1. **Use Specific Versions**
```yaml
# Good ✅: Pin to a specific major version for stability and predictable behavior
uses: actions/checkout@v4

# Bad ❌: Using @main follows the latest commits, which can introduce breaking changes without warning
uses: actions/checkout@main
```

### 2. **Start Simple, Add Complexity**
Begin with basic build and test, then add features like:
- Code coverage
- Multiple OS testing
- Deployment
- Notifications

### 3. **Meaningful Names**
```yaml
# Good ✅
- name: Install C++ build dependencies
  run: sudo apt-get install build-essential cmake

# Bad ❌
- name: Install stuff
  run: sudo apt-get install build-essential cmake
```

### 4. **Handle Errors Gracefully**
```yaml
- name: Optional step
  continue-on-error: true
  run: ./might-fail.sh

- name: Required step
  run: ./must-succeed.sh
```

### 6. **Security First with Self-Hosted Runners**
- Use self-hosted runners only with private repositories
- Implement proper access controls and runner groups
- Regularly audit and update runner infrastructure
- Clean up sensitive data after jobs complete
- Monitor runner usage and performance

### 7. **Test on Multiple Runner Types**
```yaml
jobs:
  test-github:
    runs-on: ubuntu-latest
    steps: [...]  # Test on GitHub-hosted
  
  test-self-hosted:
    runs-on: self-hosted
    steps: [...]  # Test on your infrastructure
```

---

## Troubleshooting

### Common Issues

#### 1. **"Command not found" errors**
**Problem:** Missing dependencies
**Solution:** Install required packages:
```yaml
- name: Install dependencies
  run: |
    sudo apt-get update
    sudo apt-get install -y your-required-package
```

#### 2. **Permission errors**
**Problem:** Need root permissions
**Solution:** Use `sudo`:
```yaml
- name: Install system packages
  run: sudo apt-get install -y package-name
```

#### 3. **Workflow doesn't trigger**
**Problem:** Wrong trigger configuration
**Solutions:**
- Check branch names match
- Verify file is in `.github/workflows/`
- Check YAML syntax

#### 4. **Self-Hosted Runner Issues**

**Runner not available:**
- Check if runner service is running: `sudo systemctl status actions.runner.*`
- Verify network connectivity to GitHub
- Check runner logs: `tail -f /home/runner/actions-runner/_diag/*.log`

**Jobs stuck in queue:**
- Ensure runner has required labels
- Check runner group permissions
- Verify runner is online in GitHub settings

**Hardware access failures:**
- Confirm hardware is connected and accessible
- Check permissions for hardware devices
- Verify kernel modules are loaded

**Security concerns:**
- Audit who has access to runner machines
- Ensure runners are in secure networks
- Regularly update runner software and OS

---

## Quick Start Checklist

To create your own GitHub Actions workflow:

1. ✅ Create `.github/workflows/` directory
2. ✅ Create a `.yml` file (e.g., `ci.yml`)
3. ✅ Start with basic template:
   ```yaml
   name: My Workflow
   on: [push, pull_request]
   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - name: Your step
           run: echo "Hello World"
   ```
4. ✅ Add your specific build/test commands
5. ✅ Test by pushing to your repository
6. ✅ Check results in GitHub "Actions" tab
7. ✅ Iterate and improve

---