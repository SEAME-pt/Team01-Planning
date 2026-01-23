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

This project provides a thin C/C++ abstraction over Linux SocketCAN. The concrete
interfaces available in the Raspberry Pi codebase are:

- socketCan_init(interface: const char*) -> int
  - Create a PF_CAN SOCK_RAW socket bound to the named interface and enable CAN_FD frames.
  - Returns a socket file descriptor >= 0 on success or -1 on error.
- check_mtu_support(int s, struct ifreq *ifr) -> int (internal)
  - Query the interface MTU and determine whether it supports CAN (classical) or CAN_FD.
- can_send_frame(int socket, uint16_t can_id, const int16_t* data, uint8_t len) -> int
  - Transmit a Classical CAN frame (DLC max 8). Validates standard 11-bit CAN IDs (0x000–0x7FF).
  - Returns 0 on success or -1 on error.
- can_send_frame_fd(int socket, uint16_t can_id, const int16_t* data, uint8_t len) -> int
  - Transmit a CAN_FD frame (payload up to 64 bytes). Uses CANFD_BRS flag for bit-rate switching.
  - Returns 0 on success or -1 on error.
- can_close(int socket) -> void
  - Close the provided socket descriptor (safe no-op for negative descriptors).

In C++ there is a `CANController` RAII wrapper that exposes higher-level APIs:

- CANController::CANController(const std::string &interface)
  - Constructor opens and initialises the socket (throws CANException on failure).
- CANController::sendFrame(uint16_t can_id, const int16_t* data, uint8_t len)
  - Sends a classical CAN frame; throws `CANException` on failure or if not initialised.
- CANController::sendFrameFD(uint16_t can_id, const int16_t* data, uint8_t len)
  - Sends a CAN_FD frame; throws `CANException` on failure or if not initialised.

Notes:
- The low-level APIs perform input validation (ID range, maximum payload length) and will truncate payloads beyond the supported sizes.
- The C++ wrapper uses exceptions to signal error conditions; the C APIs return -1 and set errno.

## 4. Algorithms
- Prioritised scheduling ensures critical control messages are sent first.
- For require_ack frames, a lightweight ACK protocol over CAN (application-level ACK) may be used
  with retransmission on timeout.
 - Transmission details
   - Low-level send operations use the `write()` syscall to the PF_CAN socket. Depending on socket flags this may block; use a worker thread or set the socket non-blocking to avoid blocking the main control loop.
   - During initialization `check_mtu_support` determines whether CAN_FD is supported and `setsockopt(..., CAN_RAW_FD_FRAMES, ...)` is used to enable FD frames when available.
   - For CAN_FD frames the implementation sets `CANFD_BRS` to enable Bit Rate Switching.
   - The transmit routines perform input validation and will truncate payloads that exceed allowed sizes (8 or 64 bytes).

## 5. Error Handling & Edge Cases
- CAN bus off: attempt recovery and escalate to system alerts if unsuccessful.
- Queue overflow: drop lowest priority messages and increment metrics.
- Partial send failures: retry according to policy; record persistent failures.

## 6. Links to lower levels
- LLTC-RASP_CAN_TX_* series: tests validating basic transmit, latency, heartbeat, bus-off recovery, malformed frames, buffer overflow, concurrency and end-to-end integration.

