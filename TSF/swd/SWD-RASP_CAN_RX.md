---
id: SWD-RASP_CAN_RX
header: "Raspberry Pi CAN Receive Software Design"
text: |
  This document describes the software design for the Raspberry Pi component responsible
  for receiving, validating and delivering CAN messages from the vehicle CAN bus to the
  upper-level control software (e.g. speed control, diagnostics, emergency stop).

tsf_type: "Design"
verification_method: "Design review, unit tests, hardware-in-the-loop integration tests"

children:
  - id: LLTC-RASP_CAN_RX_BASIC
  - id: LLTC-RASP_CAN_RX_LATENCY
  - id: LLTC-RASP_CAN_RX_HEARTBEAT
  - id: LLTC-RASP_CAN_RX_BUSOFF_RECOVERY
  - id: LLTC-RASP_CAN_RX_MALFORMED
  - id: LLTC-RASP_CAN_RX_BUFFER_OVERFLOW
  - id: LLTC-RASP_CAN_RX_CONCURRENCY
  - id: LLTC-RASP_CAN_RX_E2E

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
tags: ["raspberry-pi", "can-bus", "receiver", "socketcan", "driver"]

---
# Software Design Description

## 1. Purpose
This design defines how the Raspberry Pi will receive CAN frames from the vehicle CAN bus,
validate and dispatch them to the rest of the system while meeting timing, reliability and
fault-handling requirements from the SRD.

## 2. Architecture / Structure
- CAN Interface Layer
  - Runs on the Raspberry Pi and uses the Linux SocketCAN interface to access the CAN controller.
  - Responsible for configuring the CAN interface (bitrate, filters, start/stop) and performing low-level reads.
- Message Processing Layer
  - Per-message validation and parsing (identifier checks, length checks, sequence/heartbeat tracking).
  - Filter and route messages to appropriate consumers (speed control, telemetry, emergency handler).
- Buffering and Timers
  - Circular buffer for incoming messages sized to hold bursts (configurable, default 1024 messages).
  - Timers for heartbeat/timeouts per message class.
- API / Dispatcher
  - Thread-safe API for consumers to register callbacks or request the latest message of a given type.
  - Uses a small worker thread pool or event loop (depending on platform constraints) to avoid blocking CAN reads.

## 3. Interfaces
- Public API (Python-like signatures for clarity)
  - start_can(interface: str, bitrate: int = 500000) -> None
  - stop_can() -> None
  - register_handler(can_id: int, callback: Callable[[bytes], None]) -> HandlerId
  - get_latest(can_id: int) -> Optional[bytes]
  - configure_filter(mask: int, id: int) -> None

## 4. Algorithms
- Read Loop
  - Continuously read frames from SocketCAN, convert to internal message structure and push to the buffer.
  - For each frame perform lightweight validation and enqueue for processing.
- Processing
  - Consumer worker threads dequeue frames, run per-ID validation, update last-received timestamps, and call registered handlers.
  - Heartbeat and timeout detection runs periodically to flag missing messages and escalate to the emergency handler if needed.

## 5. Error Handling & Edge Cases
- CAN bus off / controller reset: attempt automatic recovery and escalate to system-level alerts if recovery fails.
- Malformed frames: drop and log; if repeated failures for the same sender occur, mark as suspect.
- Buffer overflow: oldest messages are dropped; metrics incremented for monitoring and validation tests.
- Threading failures: watchdog monitors important threads and triggers restart of the CAN interface if necessary.

## 6. Links to lower levels
- LLTC-RASP_CAN_RX: Tests verifying message receipt, timing (<10ms latency for speed messages), heartbeat handling, and bus-off recovery.

Reference any related LLTC items or test strategies.
