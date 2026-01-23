---
id: SRD-STM32_I2C
header: "STM32 I2C Motor Control Interface"
text: |
  The system shall implement I2C communication on the STM32 microcontroller for controlling motor actuators. The I2C interface must reliably transmit speed control commands to motors, receive feedback status, and handle communication errors while supporting the vehicle speed control and emergency stop functionalities.

tsf_type: "Assertion"
verification_method: "I2C bus testing, motor control integration testing, signal integrity verification, and fault injection testing."

children:
  - id: SWD-I2C_PROTOCOL_INTERFACE

parents:
  - id: URD-CONTROL_VEHICLE_SPEED
  - id: URD-EMERGENCY_STOP

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

active: true
derived: false
normative: true
level: 2.0
tags: ["i2c", "motor-control", "stm32", "communication", "actuators", "priority-high"]

---
# Software Requirement Statement

The system shall implement I2C communication on STM32 that:

- Operates at 400 kHz fast mode with 7-bit addressing
- Sends motor speed control commands (0-100% duty cycle) to motor controllers
- Receives motor status feedback including current speed, temperature, and fault conditions
- Implements master mode on STM32 for controlling multiple motor slaves
- Provides error detection and retry mechanisms for I2C communication failures
- Supports emergency stop commands with immediate motor shutdown capability
- Maintains synchronization between commanded and actual motor speeds
- Handles bus arbitration and multi-master scenarios if required
- Monitors I2C bus health and reports communication faults
- Ensures deterministic timing for real-time motor control applications