---
id: LLTC-RASP_CAN_TX_HEARTBEAT
header: "Rasp CAN TX — Heartbeat & Periodic Messages"
text: |
  Verify periodic transmissions (heartbeats/telemetry) are sent at configured intervals and recover after interruptions.

tsf_type: "Test"
verification_method: "Hardware-in-the-loop"

parents:
  - id: SWD-RASP_CAN_TX

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
tags: ["heartbeat", "periodic"]

---
# Test: Heartbeat & Periodic Messages

Objective:
- Ensure periodic transmissions occur reliably and resume after transient failures.

Steps:
1. Configure a periodic heartbeat and measure inter-arrival time at a monitor.
2. Interrupt interface briefly and confirm transmission resumes within recovery window.

Acceptance Criteria:
- Inter-arrival within tolerance; automatic resume after transient interruption.
