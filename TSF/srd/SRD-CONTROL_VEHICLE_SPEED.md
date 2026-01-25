---
id: SRD-CONTROL_VEHICLE_SPEED
header: "Control Vehicle DC Motors Speed"
text: |
  The STM32 microcontroller shall implement vehicle speed control by managing the speed of I2C-connected DC motors through the I2C protocol. This includes processing speed commands, translating them to motor duty cycles, monitoring feedback, and implementing emergency stop functionality to ensure safe and responsive vehicle operation.

tsf_type: "Assertion"
verification_method: "Unit testing, integration testing with motor controllers, simulation of speed control scenarios, and safety validation for emergency stops."

children:
  - id: SWD-STM32_SPEED_CONTROL
  - id: SWD-STM32_EMERGENCY_STOP

parents:
  - id: URD-CONTROL_VEHICLE_SPEED

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

references:
  - type: "file"
    path: TSF/srd/SRD-STM32_I2C.md
  - type: "file"
    path: TSF/srd/SRD-STM32_CAN_BUS.md
  - type: "file"
    path: TSF/srd/SRD-RASP_CAN_BUS.md


active: true
derived: false
normative: true
level: 2.0
tags: ["speed-control", "dc-motors", "stm32", "i2c", "emergency-stop", "priority-high"]

---
# Software Requirement Statement

The STM32 shall control vehicle speed by:

- Receiving speed commands from the Raspberry Pi via CAN bus
- Translating speed targets (0-120 km/h) to DC motor duty cycles (0-100%)
- Sending I2C commands to DC motor controllers for speed adjustment
- Receiving feedback on actual motor speeds and fault conditions via I2C
- Maintaining synchronization between commanded and actual vehicle speeds within 5% tolerance
- Implementing emergency stop functionality with immediate motor shutdown on command
- Providing deterministic response times (<100ms) for speed changes and stops
- Handling communication errors with retry mechanisms and fallback to safe states
- Supporting multiple DC motors for differential drive or multi-wheel control