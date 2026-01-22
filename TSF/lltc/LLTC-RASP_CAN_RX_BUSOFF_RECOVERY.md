---
id: LLTC-RASP_CAN_RX_BUSOFF_RECOVERY
header: "Rasp CAN RX — Bus‑Off and Recovery"
text: |
  Verify behavior when the CAN controller enters bus-off and the system attempts recovery.

tsf_type: "Test"
verification_method: "Hardware fault injection, CAN error simulation"

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
tags: ["bus-off", "recovery", "fault-injection"]

---
# Test: Bus‑Off & Recovery

Objective:
- Confirm the system detects bus-off, attempts configured automatic recovery, and reports failure if recovery fails.

Steps:
1. Induce bus errors to force the controller into bus-off state.
2. Observe the software's recovery attempts and timing.

Acceptance Criteria:
- System attempts to restart the interface within configured retries and reports status; if recovery fails, alerts are raised.
