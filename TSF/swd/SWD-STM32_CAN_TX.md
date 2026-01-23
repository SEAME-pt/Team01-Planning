---
id: SWD-STM32_CAN_TX
header: "STM32 CAN Transmit Software Design"
text: |
 This document describes how the STM32 firmware transmits speed sensor data,
 status and diagnostics over the CAN bus. It includes timing requirements, message
 formatting, and error handling for on‑board controllers.

tsf_type: "Design"
verification_method: "Design review, unit tests on firmware, hardware-in-the-loop tests"

children:
  - id: LLTC-STM32_CAN_TX_BASIC
  - id: LLTC-STM32_CAN_TX_LATENCY
  - id: LLTC-STM32_CAN_TX_HEARTBEAT
  - id: LLTC-STM32_CAN_TX_BUSOFF_RECOVERY
  - id: LLTC-STM32_CAN_TX_MALFORMED
  - id: LLTC-STM32_CAN_TX_BUFFER_OVERFLOW
  - id: LLTC-STM32_CAN_TX_CONCURRENCY

parents:
  - id: SRD-STM32_CAN_BUS

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
tags: ["stm32", "can-bus", "transmit", "sensor"]

---
# Software Design Description

## 1. Purpose
This design defines how the STM32 will publish sensor data and status over CAN,
ensuring message integrity, timeliness and recoverability per SRD requirements.

## 2. Architecture / Structure
- Sensor Aggregation & Encoding
  - Collect sensor data, encode into CAN frames, calculate any application-level checksums where required.
- Scheduling & Prioritisation
  - Ensure periodic sensor messages meet update rate and jitter requirements.
- Hardware Abstraction Layer
  - Interacts with MCUs CAN peripheral and handles bus errors and interrupts.

## 3. Interfaces
#- init_can(bitrate: int)
#- send_sensor_frame(can_id: int, payload: bytes)
#- set_periodic_sensor(can_id: int, period_ms: int)

## 4. Algorithms
- Fixed-rate transmission for sensor messages and event-driven transmissions for status/diagnostics.

## 5. Error Handling & Edge Cases
- Bus errors: follow CAN controller recommendations, attempt reset and recovery.
- Corrupted payloads: log and attempt retransmission when appropriate.

## 6. Links to lower levels
- LLTC-STM32_CAN_TX_* series covering basic functionality, latency, heartbeat, bus-off recovery, malformed frames, buffer overflow, concurrency.

