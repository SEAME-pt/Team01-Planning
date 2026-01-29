---
id: SRD-STM32_I2C
header: "STM32 Vehicle Control System"
text: |
  The STM32 microcontroller shall implement vehicle speed control by managing the speed of I2C-connected DC motors and servo motors, reading battery levels, and handling emergency stops. This includes processing speed commands received via CAN from the Raspberry Pi, translating them to motor duty cycles, monitoring feedback, and ensuring safe and responsive vehicle operation.

tsf_type: "Assertion"
verification_method: "I2C bus testing, motor control integration testing, signal integrity verification, and fault injection testing."

children:
  - id: SWD-STM32_I2C_DC_MOTOR
  - id: SWD-STM32_I2C_SERVO_MOTOR

parents:
  - id: URD-CONTROL_VEHICLE
  - id: URD-EMERGENCY_STOP

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

references:
  - type: "file"
    path: TSF/srd/SRD-CAN_BUS.md

active: true
derived: false
normative: true
level: 2.0
tags: ["speed-control", "i2c", "motor-control", "battery", "stm32", "communication", "actuators", "sensors", "emergency-stop", "priority-high"]

---
# Software Requirement Statement

The STM32 shall control vehicle speed and implement I2C communication that:

- Receives speed commands from the Raspberry Pi via CAN bus
- Translates speed targets (0-120 km/h) to DC motor duty cycles (0-100%)
- Sends motor speed control commands (0-100% duty cycle) to motor controllers via I2C
- Receives motor status feedback including current speed, and fault conditions via I2C
- Reads battery voltage and current levels from sensors via I2C
- Implements master mode on STM32 for controlling multiple motor slaves and sensors
- Provides error detection and retry mechanisms for I2C communication failures
- Supports emergency stop commands with immediate motor shutdown capability
- Maintains synchronization between commanded and actual vehicle speeds within 5% tolerance
- Ensures deterministic timing for real-time motor control applications