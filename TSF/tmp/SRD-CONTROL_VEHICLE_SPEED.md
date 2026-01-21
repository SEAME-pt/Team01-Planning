---
id: SRD-CONTROL_VEHICLE_SPEED
header: "Vehicle Speed Control System"
text: |
  The system shall implement speed control functionality that receives user inputs for target speeds, integrates with speed sensor data via CAN communication, and commands motor actuators through I2C interface. The control system must maintain speed within specified tolerances, handle cruise control activation/deactivation, provide acceleration/deceleration control, and ensure safety through manual override and emergency stop integration.

tsf_type: "Assertion"
verification_method: "Integration testing with CAN bus simulation, I2C motor control testing, closed-loop control validation, safety testing, and user interface testing."

children:
  - id: SWD-SPEED_CONTROL_ALGORITHMS
  - id: SWD-CAN_COMMUNICATION_RX
  - id: SWD-I2C_MOTOR_INTERFACE
#  - id: SWD-USER_INTERFACE_INTEGRATION
#  - id: SWD-SAFETY_MONITORING

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
    path: requirements/srd/vehicle_speed_control.md
  - type: "requirement"
    id: SRD-CAN_BUS_COMMUNICATION
  - type: "requirement"
    id: SRD-SPEED_SENSOR
  - type: "requirement"
    id: SRD-STM32_I2C


active: true
derived: false
normative: true
level: 2.0
tags: ["speed-control", "can-communication", "i2c-interface", "control-algorithms", "safety", "priority-high"]

---
# Software Requirement Statement

The system shall implement a closed-loop speed control mechanism that:

- Receives target speed inputs from user interface controls
- Acquires current speed data from speed sensors via CAN bus communication with the Raspberry Pi
- Calculates control commands using PID or equivalent algorithms to maintain speed within ±2 km/h tolerance
- Transmits motor control signals to the STM32 via CAN, which then relays commands to motors through I2C interface
- Supports cruise control mode with automatic speed maintenance and manual override capability
- Provides acceleration/deceleration control with configurable rates (0.5-2.0 m/s²)
- Integrates with emergency stop functionality for immediate braking override
- Monitors system health and provides fault detection for communication failures
- Updates control loop at minimum 10Hz frequency for responsive operation
- Ensures safety by respecting maximum speed limits and enabling rapid deceleration when required
