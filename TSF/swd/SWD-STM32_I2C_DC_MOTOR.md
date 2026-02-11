---
id: SWD-STM32_I2C_DC_MOTOR
header: "STM32 I2C DC Motor Control Software Design"
text: |
  This document describes the software design for STM32 I2C-based control of DC motors, including speed adjustment, feedback monitoring, and emergency stop functionality.

tsf_type: "Design"
verification_method: "Design review, unit tests, hardware-in-the-loop tests"

children:
  - id: LLTC-STM32_I2C_DC_MOTOR

parents:
  - id: SRD-STM32_I2C

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

active: true
derived: false
normative: true
level: 3.0
tags: ["stm32", "i2c", "dc-motor", "speed-control", "emergency-stop"]

---
# Software Design Description

## 1. Purpose
This design defines how the STM32 controls DC motors via I2C, translating speed commands to duty cycles, monitoring feedback, and handling emergency stops.

## 2. Architecture / Structure
- I2C Master Interface for sending commands to motor controllers.
- Feedback processing for speed and fault detection.
- Emergency stop logic integrated with motor shutdown.

## 3. Interfaces
- Functions for setting motor speed, reading status, and triggering emergency stop.

## 4. Algorithms
- Duty cycle calculation based on speed targets.
- Feedback loop for synchronization.

## 5. Error Handling & Edge Cases
- I2C communication failures, motor faults, emergency overrides.

## 6. Links to lower levels
- LLTC-STM32_I2C_DC_MOTOR: Tests for motor control functionality.