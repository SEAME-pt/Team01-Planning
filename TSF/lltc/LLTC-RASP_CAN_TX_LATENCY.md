---
id: LLTC-RASP_CAN_TX_LATENCY
header: "Rasp CAN TX — Transmit Latency"
text: |
  Measure latency from API send request to availability on the bus and verify it meets SRD bounds.

tsf_type: "Test"
verification_method: "Hardware-in-the-loop timing measurements"

parents:
  - id: SWD-RASP_CAN_TX

reviewers:
  - name: "José Meneses"
    email: "jose.meneses@seame.es"

references:
  - type: "file"
    path: requirements/srd/SRD-RASP_CAN_BUS.md

active: true
derived: false
normative: true
level: 4.0
tags: ["latency", "performance"]

---
# Test: Transmit Latency

Objective:
- Ensure transmit latency from API call to frame on bus is within expected bounds.

Steps:
1. Instrument timestamp at send_frame call and timestamp at a bus monitor.
2. Send multiple messages and compute latency distribution.

Acceptance Criteria:
- 95% of messages are transmitted within specified SRD limits.
