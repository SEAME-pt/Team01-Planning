---
id: LLTC-RASP_CAN_RX_CONCURRENCY
header: "Rasp CAN RX — Concurrency / Watchdog"
text: |
  Verify proper thread/process isolation, watchdog behavior and recovery on component failures.

tsf_type: "Test"
verification_method: "Fault injection, integration tests"

parents:
  - id: SWD-RASP_CAN_RX

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"

references:
  - type: "file"
    path: requirements/swd/SWD-RASP_CAN_RX.md

active: true
derived: false
normative: true
level: 4.0
tags: ["concurrency", "watchdog", "recovery"]

---
# Test: Concurrency and Watchdog

Objective:
- Confirm the CAN RX system can recover from worker thread crashes and that watchdog restarts critical services.

Steps:
1. Deliberately crash a worker thread or block it indefinitely.
2. Verify watchdog detects the failure and restarts relevant subsystems within configured time limits.

Acceptance Criteria:
- Watchdog restarts failed components; no system hangs; recovery is logged and metrics updated.
