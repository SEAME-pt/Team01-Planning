---
id: LLTC-RASP_CAN_RX_BUFFER_OVERFLOW
header: "Rasp CAN RX — Buffer Overflow Handling"
text: |
  Verify behavior when the receive buffer is exhausted under high load and messages are dropped as designed.

tsf_type: "Test"
verification_method: "Stress testing / load tests"

parents:
  - id: SWD-RASP_CAN_RX

reviewers:
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

references:
  - type: "file"
    path: requirements/swd/SWD-RASP_CAN_RX.md

active: true
derived: false
normative: true
level: 4.0
tags: ["overflow", "stress-test"]

---
# Test: Buffer Overflow

Objective:
- Ensure system drops oldest messages gracefully when buffer full and metrics reflect drops.

Steps:
1. Configure a small buffer (test mode) and inject a large burst of frames.
2. Verify oldest messages are dropped and appropriate counters increment.

Acceptance Criteria:
- No crash; oldest messages dropped; metrics/logs show drop events and are retrievable for monitoring.
