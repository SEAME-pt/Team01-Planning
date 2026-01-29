---
id: LLTC-STM32_I2C_DC_MOTOR
header: "STM32 I2C DC Motor — Basic Functionality"
text: |
  Verify the STM32 I2C DC motor control subsystem correctly sets speeds, monitors feedback, and handles emergency stops.

tsf_type: "Test"
verification_method: "Hardware-in-the-loop execution, unit tests"

parents:
  - id: SWD-STM32_I2C_DC_MOTOR

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
tags: ["stm32", "i2c", "dc-motor", "speed-control", "emergency-stop"]

---
# Test: STM32 I2C DC Motor Basic Functionality

Objective:
- Confirm speed commands are sent via I2C and motors respond correctly.
- Verify feedback reading and synchronization.
- Test emergency stop triggers immediate shutdown.