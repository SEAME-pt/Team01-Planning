---
id: LLTC-CAN_BUS_RX
header: "CAN Bus RX — Basic Functionality"
text: |
  Verify the CAN bus receive subsystem on both Raspberry Pi and STM32 correctly receives standard CAN frames, validates them, dispatches to consumers, handles errors, and meets timing and reliability requirements.

tsf_type: "Test"
verification_method: "Hardware-in-the-loop execution, unit tests, integration tests"

parents:
  - id: SWD-CAN_BUS_RX

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
tags: ["can-bus", "receive", "functional", "latency", "error-handling"]

---
# Test: CAN Bus Receive Basic Functionality

Objective:
- Confirm valid CAN frames are received on both platforms, parsed, validated, and delivered to registered handlers.
- Verify latency requirements (<10ms for critical messages).
- Test heartbeat monitoring and timeout handling.
- Check bus-off recovery and fault-tolerant operation.
- Handle malformed frames, buffer overflows, and concurrency.
- Ensure deterministic timing and prioritization.