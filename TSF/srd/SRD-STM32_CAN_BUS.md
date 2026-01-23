---
id: SRD-STM32_CAN_BUS
header: "STM32 CAN Bus Communication System"
text: |
  The STM32 microcontroller shall implement CAN bus communication for receiving control commands from the Raspberry Pi and transmitting speed sensor data and system status. The CAN interface must ensure reliable, real-time data exchange with error detection and recovery, supporting the speed control and emergency stop functionalities.

tsf_type: "Assertion"
verification_method: "CAN bus integration testing with Raspberry Pi, message latency measurements, error injection testing, and protocol compliance verification on STM32 hardware."

children:
  - id: SWD-STM32_CAN_RX
  - id: SWD-STM32_CAN_TX

parents:
  - id: URD-CONTROL_VEHICLE_SPEED
  - id: URD-DASHBOARD_DISPLAY_SPEED

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
tags: ["stm32", "can-bus", "communication", "real-time", "error-handling", "protocol", "priority-high"]

---
# Software Requirement Statement

The STM32 shall implement CAN bus communication that:

- Operates at 500 kbps baud rate with 11-bit identifiers (CAN 2.0B) using STM32 CAN peripheral
- Receives motor control commands from Raspberry Pi with guaranteed delivery
- Transmits speed sensor data to Raspberry Pi with <10ms latency
- Sends system status and diagnostic information via CAN messages
- Implements error detection and automatic retransmission for corrupted messages
- Provides heartbeat messages for connection monitoring with Raspberry Pi
- Handles bus-off recovery and fault-tolerant operation on STM32 hardware
- Supports message prioritization for critical control commands
- Ensures deterministic timing for real-time control applications