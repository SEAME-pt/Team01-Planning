# Git / GitHub Actions Documentation

## Table of Contents
1. [What is GitHub Actions?](#what-is-github-actions)
2. [Getting Started](#getting-started)
3. [Workflow Structure](#workflow-structure)
4. [Essential Components](#essential-components)
5. [Common Patterns](#common-patterns)
6. [Project Examples](#project-examples)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)

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

## Essential Components

### Checkout Action
**In most code-based workflows, you’ll start with this** – it downloads your repository code:
```yaml
- name: Checkout repository
  uses: actions/checkout@v4
```

### Installing Dependencies
Install what your project needs:
```yaml
# For C++ projects
- name: Install C++ dependencies
  run: |
    sudo apt-get update
    sudo apt-get install -y build-essential cmake libgtest-dev

# For Python projects
- name: Install Python dependencies
  run: |
    python -m pip install --upgrade pip
    pip install -r requirements.txt

# For Node.js projects
- name: Install Node dependencies
  run: npm install
```

### Running Commands
Execute your build, test, or deployment commands:
```yaml
- name: Build project
  run: |
    mkdir build
    cd build
    cmake ..
    make

- name: Run tests
  run: |
    cd build
    ./run-tests
```

---

## Common Patterns

### Pattern 1: C++ Project with CMake and Tests
```yaml
name: C++ CI

on: [push, pull_request]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      
      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y build-essential cmake libgtest-dev
      
      - name: Build project
        run: |
          mkdir build
          cd build
          cmake -DBUILD_TESTS=ON ..
          make
      
      - name: Run tests
        run: |
          cd build
          ctest --output-on-failure --verbose
```

### Pattern 2: System Setup (Hardware/Special Requirements)
If your project needs special system setup:
```yaml
- name: Setup system requirements
  run: |
    # Load kernel modules (example: CAN interface)
    if sudo modprobe vcan 2>/dev/null; then
      sudo ip link add dev vcan0 type vcan
      sudo ip link set up vcan0
      echo "System setup complete"
    else
      echo "Warning: Special hardware not available"
    fi
```

### Pattern 3: Python Project
```yaml
name: Python CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.12'
      
      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install pytest
      
      - name: Run tests
        run: pytest tests/
```

### Pattern 4: Multi-Step Pipeline
```yaml
name: Full Pipeline

on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check code style
        run: ./lint.sh
  
  test:
    needs: lint              # Wait for lint to pass
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: ./test.sh
  
  deploy:
    needs: [lint, test]      # Wait for both to pass
    if: github.ref == 'refs/heads/main'  # Only on main branch
    runs-on: ubuntu-latest
    steps:
      - name: Deploy
        run: ./deploy.sh
```

---

## Project Examples

### Our C++ Car Control Project
This is the actual workflow used in this repository:

```yaml
name: CI with Unit Tests

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  unit-tests:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      
      - name: Install system dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y cmake build-essential pkg-config \
            libsdl2-dev libgtest-dev can-utils linux-modules-extra-$(uname -r)
      
      - name: Set up virtual CAN interface
        run: |
          if sudo modprobe vcan 2>/dev/null; then
            sudo ip link add dev vcan0 type vcan
            sudo ip link set vcan0 mtu 72
            sudo ip link set up vcan0
          fi
      
      - name: Build Google Test
        run: |
          cd /usr/src/gtest
          sudo cmake CMakeLists.txt
          sudo make
          sudo cp lib/*.a /usr/lib
      
      - name: Build project
        run: |
          mkdir build
          cd build
          cmake -DBUILD_TESTS=ON ..
          make
      
      - name: Run unit tests
        run: |
          cd build
          ctest --output-on-failure --verbose
```

**What this workflow does:**
- Runs on pushes and pull requests
- Installs C++ tools, SDL2, Google Test, and CAN utilities
- Sets up virtual CAN interface for hardware tests
- Builds the project with CMake
- Runs all unit tests with detailed output

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

### 5. **Use Conditions**
```yaml
- name: Deploy to production
  if: github.ref == 'refs/heads/main'
  run: ./deploy.sh

- name: Notify on failure
  if: failure()
  run: echo "Something went wrong!"
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

### Debugging Commands
```yaml
- name: Debug info
  run: |
    echo "Runner OS: ${{ runner.os }}"
    echo "GitHub event: ${{ github.event_name }}"
    echo "Branch: ${{ github.ref }}"
    pwd
    ls -la
```

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