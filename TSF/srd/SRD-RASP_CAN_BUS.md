---
id: SRD-RASP_CAN_BUS
header: "Raspberry Pi CAN Bus Communication System"
text: |
  The Raspberry Pi shall implement CAN bus communication for sending control commands to the STM32 and receiving speed sensor data and system status. The CAN interface must ensure reliable, real-time data exchange with error detection and recovery, supporting the speed control, speed sensing, and emergency stop functionalities.

tsf_type: "Assertion"
verification_method: "CAN bus integration testing with STM32, message latency measurements, error injection testing, and protocol compliance verification on Raspberry Pi hardware."

children:
  - id: SWD-RASP_CAN_RX
  - id: SWD-RASP_CAN_TX

parents:
  - id: URD-CONTROL_VEHICLE_SPEED
  - id: URD-SPEED_SENSOR
  - id: URD-EMERGENCY_STOP

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

references:
  - type: "file"
    path: requirements/srd/rasp_can_bus.md
  - type: "standard"
    name: "CAN 2.0B Specification"
  - type: "requirement"
    id: SRD-CAN_BUS_COMMUNICATION

active: true
derived: false
normative: true
level: 2.0
tags: ["raspberry-pi", "can-bus", "communication", "real-time", "error-handling", "protocol", "priority-high"]

---
# Software Requirement Statement

The Raspberry Pi shall implement CAN bus communication that:

- Operates at 500 kbps baud rate with 11-bit identifiers (CAN 2.0B) using CAN interface hardware
- Sends motor control commands to STM32 with guaranteed delivery
- Receives speed sensor data from STM32 with <10ms latency
- Receives system status and diagnostic information via CAN messages
- Implements error detection and automatic retransmission for corrupted messages
- Provides heartbeat messages for connection monitoring with STM32
- Handles bus-off recovery and fault-tolerant operation on Raspberry Pi hardware
- Supports message prioritization for critical control commands
- Maintains message integrity through CRC checking
- Logs communication errors for diagnostics via Raspberry Pi logging system
- Monitors CAN bus health and reports faults to user interface
- Ensures deterministic timing for real-time control applications
- Logs communication errors for diagnostics via STM32 serial interface
- Monitors CAN bus health and reports faults to Raspberry Pi
- Ensures deterministic timing for real-time control applications
