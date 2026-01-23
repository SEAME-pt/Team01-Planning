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

The Raspberry Pi implementation exposes low-level C functions and a C++ RAII wrapper which should be used directly by consumers or wrapped in higher-level services:

- socketCan_init(interface: const char *) -> int
  - Opens a PF_CAN/SOCK_RAW socket, binds it to `interface`, enables CAN_FD frames where possible and returns a socket fd or -1 on error.
- check_mtu_support(int s, struct ifreq *ifr) -> int (internal helper)
  - Queries the interface MTU and determines support for CAN or CAN_FD.
- can_try_receive(int socket, struct can_frame *frame) -> int
  - Non-blocking receive for classical frames. Polls with zero timeout and returns -1 if no frame available, otherwise fills `frame` and returns 0.
- canfd_try_receive(int socket, struct canfd_frame *frame) -> int
  - Non-blocking receive for CAN_FD frames; same semantics as can_try_receive.
- can_close(int socket) -> void
  - Close the socket (safe to call with negative values).

C++ wrapper:
- CANController(const std::string &interface)  — ctor opens and initialises, throws `CANException` on failure
- ~CANController() — destructor closes socket
- sendFrame(uint16_t can_id, const int16_t* data, uint8_t len) — throws on error
- sendFrameFD(uint16_t can_id, const int16_t* data, uint8_t len) — throws on error
- receiveFrame(struct can_frame *frame) / receiveFrameFD(struct canfd_frame *frame) — wrappers around non-blocking try receives

## 4. Algorithms
- Read Loop (non-blocking)
  - Use `can_try_receive` / `canfd_try_receive` which internally poll the socket with a zero timeout to avoid blocking the event loop.
  - On frame arrival: validate (ID, DLC), convert to internal model and enqueue for processing.
- Processing
  - Worker threads dequeue frames, run per-ID validation, update last-received timestamps and call registered handlers.
  - Heartbeat/timeouts run periodically to flag missing messages and escalate to emergency handler where required.

- CAN_FD handling
  - Use `check_mtu_support` during initialization to detect whether the interface supports CAN_FD and set `CAN_RAW_FD_FRAMES` via `setsockopt` to enable transmission/reception of CAN_FD frames.
  - For CAN_FD frames, treat `len` up to 64 bytes; BRS (bit-rate switch) may be used for higher throughput.

## 5. Error Handling & Edge Cases
- CAN bus off / controller reset: attempt automatic recovery and escalate to system-level alerts if recovery fails.
- Malformed frames: drop and log; if repeated failures for the same sender occur, mark as suspect.
- Buffer overflow: oldest messages are dropped; metrics incremented for monitoring and validation tests.
- Threading failures: watchdog monitors important threads and triggers restart of the CAN interface if necessary.

## 6. Links to lower levels
- LLTC-RASP_CAN_RX: Tests verifying message receipt, timing (<10ms latency for speed messages), heartbeat handling, and bus-off recovery.

Reference any related LLTC items or test strategies.
