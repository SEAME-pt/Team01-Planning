---
id: LLTC-RASP_CAN_RX_LATENCY
header: "Rasp CAN RX — Latency Requirements"
text: |
  Verify latency from CAN frame arrival to handler invocation meets the SRD (<10 ms for speed messages).

tsf_type: "Test"
verification_method: "Hardware-in-the-loop timing measurements"

parents:
  - id: SWD-RASP_CAN_RX

reviewers:
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

references:
  - type: "file"
    path: requirements/srd/SRD-RASP_CAN_BUS.md

active: true
derived: false
normative: true
level: 4.0
tags: ["latency", "performance"]

---
# Test: Latency Measurement

Objective:
- Measure end-to-end latency for critical CAN messages (speed control) from physical arrival to consumer delivery.

Steps:
1. Instrument CAN interface with timestamp at reception and record dispatch timestamps in handler.
2. Send a burst of speed messages at nominal rate.
3. Compute distribution (min/median/95th/99th percentile) of latencies.

Acceptance Criteria:
- 95% of messages have latency < 10 ms and 99% < 20 ms.
- No systemic contention or queuing beyond thresholds observed.
