---
id: LLTC-STM32_SPEED_SENSOR
header: "STM32 Speed Sensor — Basic Functionality"
text: |
  Verify the STM32 speed sensor reading subsystem correctly acquires data, validates inputs, and samples at required rates.

tsf_type: "Test"
verification_method: "Hardware-in-the-loop execution, unit tests"

parents:
  - id: SWD-STM32_SPEED_SENSOR

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

active: true
derived: false
normative: true
level: 4.0
tags: ["stm32", "speed-sensor", "data-acquisition"]

---
# Test: STM32 Speed Sensor Reading Basic Functionality

Objective:
- Confirm sensor data input and sampling work correctly.
- Test data validation and error handling.