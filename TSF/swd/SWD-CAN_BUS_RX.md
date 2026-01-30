---
id: SWD-CAN_BUS_RX
header: "CAN Bus Receive Software Design"
text: |
  This document describes the software design for receiving CAN messages on both Raspberry Pi and STM32 platforms, responsible for validating, processing, and delivering CAN messages from the vehicle CAN bus to the upper-level control software (e.g., speed control, diagnostics, emergency stop).

tsf_type: "Design"
verification_method: "Design review, unit tests, hardware-in-the-loop integration tests"

children:
  - id: LLTC-CAN_BUS_RX

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
tags: ["can-bus", "receiver", "raspberry-pi", "stm32", "socketcan", "driver"]

---
# Software Design Description

## 1. Purpose
This design defines how both Raspberry Pi and STM32 will receive CAN frames from the vehicle CAN bus, validate and dispatch them to the rest of the system while meeting timing, reliability, and fault-handling requirements from the SRD.

## 2. Architecture / Structure
### Raspberry Pi Implementation
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
  - Uses a small worker thread pool or event loop to avoid blocking CAN reads.

### STM32 Implementation
- CAN Interface & ISR
  - Low-latency interrupt-driven reception from the CAN peripheral.
- Validation Layer
  - Per-message validation: CAN ID, payload length, range checks and optional message counters/sequence numbers.
- Safety Gateway
  - Enforce safety constraints (e.g., rate limits, allowed ranges) and provide fail-safe default behaviour for invalid commands.

## 3. Interfaces
### Raspberry Pi
The Raspberry Pi implementation exposes low-level C functions and a C++ RAII wrapper:

- socketCan_init(interface: const char *) -> int
- can_try_receive(int socket, struct can_frame *frame) -> int
- canfd_try_receive(int socket, struct canfd_frame *frame) -> int
- can_close(int socket) -> void

C++ wrapper:
- CANController(const std::string &interface)
- sendFrame(uint16_t can_id, const int16_t* data, uint8_t len)
- receiveFrame(struct can_frame *frame) / receiveFrameFD(struct canfd_frame *frame)

### STM32
- register_command_handler(cmd_id: int, handler: Callable[[bytes], None])
- get_last_command(cmd_id: int) -> Optional[bytes]

## 4. Algorithms
### Raspberry Pi
- Read Loop (non-blocking): Use non-blocking receives, validate, enqueue for processing.
- Processing: Worker threads dequeue, validate, update timestamps, call handlers.
- CAN_FD handling: Detect support and enable accordingly.

### STM32
- Validate and enqueue commands; apply in deterministic control loop.

## 5. Error Handling & Edge Cases
- CAN bus off / controller reset: Attempt automatic recovery and escalate if fails.
- Malformed frames: Drop and log; mark suspect senders if repeated.
- Buffer overflow: Drop oldest messages; increment metrics.
- Threading failures: Watchdog monitors and restarts if necessary.

## 6. Links to lower levels
- LLTC-RASP_CAN_RX_* and LLTC-STM32_CAN_RX_* series covering basic functionality, latency, heartbeat, bus-off recovery, malformed frames, buffer overflow, and concurrency.