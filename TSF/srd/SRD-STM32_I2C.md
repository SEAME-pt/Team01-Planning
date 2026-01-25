---
id: SRD-STM32_I2C
header: "STM32 I2C Motor Control Interface"
text: |
  The system shall implement I2C communication on the STM32 microcontroller for controlling motor actuators. The I2C interface must reliably transmit speed control commands to motors, receive feedback status, and handle communication errors while supporting the vehicle speed control and emergency stop functionalities.

tsf_type: "Assertion"
verification_method: "I2C bus testing, motor control integration testing, signal integrity verification, and fault injection testing."

children:
  - id: SWD-STM32_I2C_DC_MOTOR
  - id: SWD-STM32_I2C_SERVO_MOTOR
  - id: SWD-STM32_I2C_EMERGENCY_STOP

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

- Sends motor speed control commands (0-100% duty cycle) to motor controllers
- Receives motor status feedback including current speed, and fault conditions
- Implements master mode on STM32 for controlling multiple motor slaves
- Provides error detection and retry mechanisms for I2C communication failures
- Supports emergency stop commands with immediate motor shutdown capability
- Maintains synchronization between commanded and actual motor speeds
- Ensures deterministic timing for real-time motor control applications