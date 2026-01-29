---
id: SWD-CAN_BUS_TX
header: "CAN Bus Transmit Software Design"
text: |
  This document describes the software design for transmitting CAN messages on both Raspberry Pi and STM32 platforms, responsible for sending control commands, telemetry, sensor data, and diagnostics onto the vehicle CAN bus with prioritisation, queuing, and error handling.

tsf_type: "Design"
verification_method: "Design review, unit tests, hardware-in-the-loop integration tests"

children:
  - id: LLTC-CAN_BUS_TX

parents:
  - id: SRD-CAN_BUS

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
tags: ["can-bus", "transmit", "raspberry-pi", "stm32", "socketcan", "sensor"]

---
# Software Design Description

## 1. Purpose
This design defines how both Raspberry Pi and STM32 transmit command, telemetry, sensor data, and diagnostic messages onto the CAN bus reliably and within timing constraints while respecting CAN arbitration and priorities.

## 2. Architecture / Structure
### Raspberry Pi Implementation
- Transmission Queue
  - Prioritised queue for outgoing frames (priority based on CAN ID and criticality).
  - Support for rate limiting and scheduling for periodic messages (heartbeats, telemetry).
- CAN Interface Layer
  - Uses SocketCAN for frame transmission, handles interface bring-up and error states.

### STM32 Implementation
- Sensor Aggregation & Encoding
  - Collect sensor data, encode into CAN frames, calculate checksums if required.
- Scheduling & Prioritisation
  - Ensure periodic sensor messages meet update rate and jitter requirements.
- Hardware Abstraction Layer

## 3. Interfaces
### Raspberry Pi
Similar to receive interfaces, with transmit functions.

### STM32
- Functions for encoding and sending sensor data and status messages.

## 4. Algorithms
### Raspberry Pi
- Queue management with priority; non-blocking sends.

### STM32
- Periodic scheduling of transmissions; handle retries on errors.

## 5. Error Handling & Edge Cases
- Bus-off recovery; retransmission policies; buffer overflow handling.

## 6. Links to lower levels
- LLTC-RASP_CAN_TX_* and LLTC-STM32_CAN_TX_* series covering basic transmission, latency, heartbeat, bus-off recovery, malformed handling, buffer overflow, and concurrency.