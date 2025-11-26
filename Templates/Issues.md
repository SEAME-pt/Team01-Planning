# 📌 Issue Creation Process Overview

This document describes the full process for creating and organizing issues using a structured hierarchy. The goal is to ensure clarity, consistency, and traceability across the entire project.

# 1. EPIC (Top-Level Issue)

Type: Epic
Purpose: Represents a large, general, high-level objective (e.g., SDV Architecture).
Because EPICs are broad, they must be created carefully.

## How to Create an EPIC

An EPIC must include:

### ➡️ Summary

A clear and detailed explanation of the global objective.

It must answer:

What is the purpose of this EPIC?

What major system or domain does it cover?

Why is it needed?

### ➡️ Tasks (Inside the EPIC Issue)

This section lists all high-level tasks the EPIC covers.
Each task should relate directly to one future User Story.

Example:

### Tasks

CAN-FD Communication Layer:
- [ ] Research, select, and acquire a CAN-FD transceiver compatible with Raspberry Pi 5 and STM32
- [ ] Implement CAN-FD communication protocol layer on STM32

Hardware Integration:
- [ ] Integrate the CAN-FD transceiver with the hardware setup
- [ ] Validate electrical compatibility and wiring

➡️ Sub-Issues (User Stories)

Every EPIC must have multiple User Stories linked as sub-issues.
These represent the second layer of work decomposition.

# 2. User Stories (Second Layer)

Type: Feature

Label: User Story

A User Story represents a concrete functionality from a user or system perspective.

A User Story must include:

### ➡️ Summary

A concise explanation of the functional goal.

### ➡️ Description

A user-focused or system-focused explanation:

What should be achieved?

Why is this needed?

What component benefits from it?

### ➡️ Tasks

A list of high-level steps needed to complete the User Story.
These tasks will later become individual issues.

### ➡️ Sub-Issues (Tasks)

When a developer picks a task from the User Story:

They must create a new issue for that task.

Set the new issue’s type to Task.

Link it under the User Story (as a sub-issue).

Move it to In Progress.

# 3. Tasks (Third Layer – Actual Work Items)

Type: Task

Labels:

If it’s documentation → add label: documentation

Otherwise add relevant labels

Tasks represent the smallest unit of work.

How to Write a Task Issue

Each Task issue must contain:

### ➡️ Summary

Clear description of the task, including:

What must be done

The scope or component affected

Any constraints or expected outcome

### ➡️ Task Section

Include the following checkboxes to identify the nature of the change:
```markdown
- [ ] Update  
- [ ] Bug  
- [ ] Feature  
- [ ] Documentation  
```

If "Documentation" is checked → add the label documentation

# 📌 Workflow Summary

Create the EPIC

Add detailed summary

Add global tasks

Create User Stories beneath it

Create User Stories (type Feature, label User Story)

Add summary + description

Add tasks inside the issue

No one works directly on these checkboxes

Developers convert them into Task issues

Developers pick a task from a User Story

Create a new Task issue

Add summary + checkbox section

Link it under the User Story

Move it to In Progress

Tasks are worked on and closed

User Story closes when all tasks are complete

Epic closes when all User Stories are complete
