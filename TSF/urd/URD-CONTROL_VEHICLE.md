---
id: URD-CONTROL_VEHICLE
header: "Vehicle Control Capability"
text: |
  The user needs the system to provide mechanisms for controlling the vehicle's speed and direction, including setting target speeds, maintaining constant speeds through cruise control, adjusting acceleration and deceleration, and steering for directional control. This ensures operational efficiency, safety, and compliance with regulations while allowing manual override capabilities.

tsf_type: "Assertion"
verification_method: "Demonstration during vehicle operation, user acceptance testing, and integration testing with speed sensor inputs."

children:
  - id: SRD-CAN_BUS
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
tags: ["speed-control", "direction-control", "vehicle", "cruise-control", "steering", "safety", "user-interface", "priority-high"]

---
# Requirement Statement

The system shall enable users to control the vehicle's speed and direction through dedicated controls for setting target speeds, activating and deactivating cruise control, adjusting acceleration/deceleration rates, and steering for directional changes. The system must integrate with speed sensing and steering mechanisms to maintain desired speeds and directions within acceptable tolerances, provide clear feedback on control status, and allow immediate manual override for safety. Vehicle control operations must prioritize safety by respecting maximum speed limits, enabling rapid deceleration when required, and ensuring precise directional control.
