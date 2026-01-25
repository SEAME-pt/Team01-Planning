---
id: SRD-RASP_CAN_BUS
header: "Raspberry pi 5 CAN Bus communication System"
text: |
  The Raspberry pi 5 shall implement CAN bus communication for sending control commands to stm32 and receiving speed sensor data and system status. The CAN interface must ensure reliable, real-time data exchange with error detection and recovery, supporting the speed control, emergency stop functionalities and other functionalities.

tsf_type: "Assertion"
verification_method: "CAN bus integration testing with STM32, message latency measurements, error injection testing, and protocol compliance verification on raspberry pi 5 hardware"

children:
  - id: SWD-RASP_CAN_RX.md
  - id: SWD-RASP_CAN_TX.md

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
tags: ["rasp5", "can-bus", "communication", "real-time", "protocol", "priority-high"]

---
# Software Requirement Statement

The Raspberry pi 5 shall implement CAN bus communication that:

- Operates at 500 kbps baud rate with 11-bit identifiers (CAN 2.0B) using CAN hat peripheral
- Send motor control commands to STM32 with guaranteed delivery
- Receive speed sensor data from STM32 with <10ms latency
- Sends system status and diagnostic information via CAN messages
- Implements error detection and automatic retransmission for corrupted messages
- Handles bus-off recovery and fault-tolerant operation on RASP hardware
- Supports message prioritization for critical control commands
- Ensures deterministic timing for real-time control applications