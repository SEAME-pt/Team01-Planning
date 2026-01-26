---
id: URD-CONTROL_VEHICLE_SPEED
header: "Vehicle Speed Control Capability"
text: |
  The user needs the system to provide mechanisms for controlling the vehicle's speed, including setting target speeds, maintaining constant speeds through cruise control, and safely adjusting acceleration and deceleration. This ensures operational efficiency, safety, and compliance with speed regulations while allowing manual override capabilities.

tsf_type: "Assertion"
verification_method: "Demonstration during vehicle operation, user acceptance testing, and integration testing with speed sensor inputs."

children:
  - id: SRD-STM32_CAN_BUS
  - id: SRD-RASP_CAN_BUS
  - id: SRD-CONTROL_VEHICLE_SPEED
  - id: SRD-STM32_I2C
  - id: SRD-SPEED_SENSOR

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
tags: ["speed-control", "vehicle", "cruise-control", "safety", "user-interface", "priority-high"]

---
# Requirement Statement

The system shall enable users to control the vehicle's speed through dedicated controls for setting target speeds, activating and deactivating cruise control, and adjusting acceleration/deceleration rates. The system must integrate with speed sensing capabilities to maintain desired speeds within acceptable tolerances, provide clear feedback on control status, and allow immediate manual override for safety. Speed control operations must prioritize safety by respecting maximum speed limits and enabling rapid deceleration when required.