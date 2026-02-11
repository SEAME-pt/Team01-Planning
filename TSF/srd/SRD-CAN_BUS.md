---
id: SRD-CAN_BUS
header: "CAN Bus Communication System"
text: |
  The system shall implement CAN bus communication for reliable, real-time data exchange between Raspberry Pi and STM32, supporting speed control, emergency stop, and data transmission functionalities with error detection and recovery.

tsf_type: "Assertion"
verification_method: "CAN bus integration testing, message latency measurements, error injection testing, and protocol compliance verification on both Raspberry Pi and STM32 hardware."

children:
  - id: SWD-CAN_BUS_RX
  - id: SWD-CAN_BUS_TX

parents:
  - id: URD-CONTROL_VEHICLE
  - id: URD-DASHBOARD
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
tags: ["can-bus", "communication", "real-time", "protocol", "priority-high"]

---
# Software Requirement Statement

The CAN bus communication shall:

- Operate at 500 kbps baud rate with 11-bit identifiers (CAN 2.0B)
- Support sending motor control commands from Raspberry Pi to STM32 with guaranteed delivery
- Support receiving speed sensor data from STM32 to Raspberry Pi with <10ms latency
- Send system status and diagnostic information via CAN messages
- Implement error detection and automatic retransmission for corrupted messages
- Provide heartbeat messages for connection monitoring
- Handle bus-off recovery and fault-tolerant operation
- Support message prioritization for critical control commands
- Ensure deterministic timing for real-time control applications