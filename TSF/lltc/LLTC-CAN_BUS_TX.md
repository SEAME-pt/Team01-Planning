---
id: LLTC-CAN_BUS_TX
header: "CAN Bus TX — Basic Functionality"
text: |
  Verify the CAN bus transmit subsystem on both Raspberry Pi and STM32 correctly sends control commands, telemetry, sensor data, and diagnostics, with prioritization, error handling, and timing compliance.

tsf_type: "Test"
verification_method: "Hardware-in-the-loop execution, unit tests, integration tests"

parents:
  - id: SWD-CAN_BUS_TX

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

active: true
derived: false
normative: true
level: 4.0
tags: ["can-bus", "transmit", "functional", "latency", "error-handling"]

---
# Test: CAN Bus Transmit Basic Functionality

Objective:
- Confirm messages are correctly encoded and transmitted on both platforms.
- Verify latency requirements and prioritization.
- Test heartbeat and periodic message scheduling.
- Check bus-off recovery and retransmission.
- Handle malformed data, buffer overflows, and concurrency.
- Ensure reliable delivery and deterministic timing.