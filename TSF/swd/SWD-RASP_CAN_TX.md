---
id: SWD-RASP_CAN_TX
header: "Raspberry Pi CAN Transmit Software Design"
text: |
  This document describes the Raspberry Pi component responsible for transmitting
  control commands and telemetry onto the vehicle CAN bus. It covers message
  prioritisation, queuing, retransmission policies, and safety-critical constraints.

tsf_type: "Design"
verification_method: "Design review, unit tests, hardware-in-the-loop integration tests"

children:
  - id: LLTC-RASP_CAN_TX_BASIC
  - id: LLTC-RASP_CAN_TX_LATENCY
  - id: LLTC-RASP_CAN_TX_HEARTBEAT
  - id: LLTC-RASP_CAN_TX_BUSOFF_RECOVERY
  - id: LLTC-RASP_CAN_TX_MALFORMED
  - id: LLTC-RASP_CAN_TX_BUFFER_OVERFLOW
  - id: LLTC-RASP_CAN_TX_CONCURRENCY
  - id: LLTC-RASP_CAN_TX_E2E

parents:
  - id: SRD-RASP_CAN_BUS

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
tags: ["raspberry-pi", "can-bus", "transmit", "socketcan"]

---
# Software Design Description

## 1. Purpose
Define how the Raspberry Pi transmits command and telemetry messages onto the CAN bus
reliably and within timing constraints while respecting CAN arbitration and priorities.

## 2. Architecture / Structure
- Transmission Queue
  - Prioritised queue for outgoing frames (priority based on CAN ID and message criticality).
  - Support for rate limiting and scheduling for periodic messages (heartbeats, telemetry).
- CAN Interface Layer
  - Uses SocketCAN for frame transmission, handles interface bring-up and error states.
- Retry & Acknowledgement
  - Retransmission policies for messages requiring higher confidence (with back-off and retry limits).
- Monitoring & Metrics
  - Counters for transmit failures, retries, queue drops; diagnostics exported for telemetry.

## 3. Interfaces
- start_tx(interface: str, bitrate: int = 500000) -> None
- stop_tx() -> None
- send_frame(can_id: int, payload: bytes, priority: int = 0, require_ack: bool = False) -> bool
- configure_periodic(can_id: int, period_ms: int, payload: bytes) -> TimerId

## 4. Algorithms
- Prioritised scheduling ensures critical control messages are sent first.
- For require_ack frames, a lightweight ACK protocol over CAN (application-level ACK) may be used
  with retransmission on timeout.

## 5. Error Handling & Edge Cases
- CAN bus off: attempt recovery and escalate to system alerts if unsuccessful.
- Queue overflow: drop lowest priority messages and increment metrics.
- Partial send failures: retry according to policy; record persistent failures.

## 6. Links to lower levels
- LLTC-RASP_CAN_TX_* series: tests validating basic transmit, latency, heartbeat, bus-off recovery, malformed frames, buffer overflow, concurrency and end-to-end integration.

