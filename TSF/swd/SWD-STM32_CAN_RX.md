---
id: SWD-STM32_CAN_RX
header: "STM32 CAN Receive Software Design"
text: |
  This document describes how the STM32 firmware receives and processes control
  commands sent from the Raspberry Pi via CAN. It covers message parsing, validation,
  timing constraints and safety checks before acting on commands.

tsf_type: "Design"
verification_method: "Design review, unit tests on firmware, hardware-in-the-loop tests"

children:
  - id: LLTC-STM32_CAN_RX_BASIC
  - id: LLTC-STM32_CAN_RX_LATENCY
  - id: LLTC-STM32_CAN_RX_HEARTBEAT
  - id: LLTC-STM32_CAN_RX_BUSOFF_RECOVERY
  - id: LLTC-STM32_CAN_RX_MALFORMED
  - id: LLTC-STM32_CAN_RX_BUFFER_OVERFLOW
  - id: LLTC-STM32_CAN_RX_CONCURRENCY
  - id: LLTC-STM32_CAN_RX_E2E

parents:
  - id: SRD-STM32_CAN_BUS
  - id: URD-CONTROL_VEHICLE_SPEED

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
tags: ["stm32", "can-bus", "receive", "control"]

---
# Software Design Description

## 1. Purpose
Define how the STM32 processes incoming control commands safely and deterministically,
ensuring only validated commands affect actuators and system state.

## 2. Architecture / Structure
-- CAN Interface & ISR
  - Low-latency interrupt-driven reception from the CAN peripheral.
-- Validation Layer
  - Per-message validation: CAN ID, payload length, range checks and optional message counters/sequence numbers.
-- Safety Gateway
  - Enforce safety constraints (e.g., rate limits, allowed ranges) and provide fail-safe default behaviour for invalid commands.

## 3. Interfaces
- register_command_handler(cmd_id: int, handler: Callable[[bytes], None])
- get_last_command(cmd_id: int) -> Optional[bytes]

## 4. Algorithms
- Validate and enqueue commands; apply them in a deterministic control loop tick to ensure predictable timing.

## 5. Error Handling & Edge Cases
- Malformed commands: drop and log; maybe send diagnostic messages back to RPi.
- Bus-off: attempt recovery and escalate if persistent.

## 6. Links to lower levels
- LLTC-STM32_CAN_RX_* series covering basic functionality, latency, heartbeat, bus-off recovery, malformed frames, buffer overflow, concurrency and e2e integration.

