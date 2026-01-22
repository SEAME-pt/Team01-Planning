---
id: LLTC-RASP_CAN_RX_HEARTBEAT
header: "Rasp CAN RX — Heartbeat & Timeout Handling"
text: |
  Verify heartbeat detection for periodic messages and correct timeout handling when messages stop.

tsf_type: "Test"
verification_method: "Hardware-in-the-loop, simulated message loss"

parents:
  - id: SWD-RASP_CAN_RX

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"

references:
  - type: "file"
    path: requirements/srd/SRD-RASP_CAN_BUS.md

active: true
derived: false
normative: true
level: 4.0
tags: ["heartbeat", "timeout"]

---
# Test: Heartbeat & Timeout

Objective:
- Ensure missing periodic messages trigger the configured timeout and escalation.

Steps:
1. Start normal periodic messages for a heartbeat ID and verify system marks the source as healthy.
2. Stop sending heartbeats and verify the system marks it as missing after the configured timeout.

Acceptance Criteria:
- System flags missing heartbeat after timeout and triggers the configured escalation path (log/event/notification).
