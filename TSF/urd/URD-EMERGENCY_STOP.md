---
id: URD-EMERGENCY_STOP
header: "Emergency Stop Capability"
text: |
  The user needs the system to provide immediate and reliable emergency stop functionality to halt vehicle operation in critical situations, ensuring safety and preventing accidents.

tsf_type: "Assertion"
verification_method: "Demonstration during vehicle operation, user acceptance testing, and safety validation."

children:
  - id: SRD-STM32_I2C
  - id: SRD-CAN_BUS

parents: []

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

active: true
derived: false
normative: true
level: 1.0
tags: ["emergency-stop", "safety", "vehicle", "priority-high"]

---
# Requirement Statement

The system must allow the user to trigger an emergency stop that immediately shuts down motor operations and brings the vehicle to a safe halt.