---
id: LLTC-STM32_I2C_SERVO_MOTOR
header: "STM32 I2C Servo Motor — Basic Functionality"
text: |
  Verify the STM32 I2C servo motor control subsystem correctly sets positions and monitors feedback.

tsf_type: "Test"
verification_method: "Hardware-in-the-loop execution, unit tests"

parents:
  - id: SWD-STM32_I2C_SERVO_MOTOR

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
tags: ["stm32", "i2c", "servo-motor", "position-control"]

---
# Test: STM32 I2C Servo Motor Basic Functionality

Objective:
- Confirm position commands are sent via I2C and servos respond correctly.
- Verify feedback reading and position accuracy.