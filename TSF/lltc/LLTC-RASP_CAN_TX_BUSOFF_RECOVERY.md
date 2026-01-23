---
id: LLTC-RASP_CAN_TX_BUSOFF_RECOVERY
header: "Rasp CAN TX — Bus-Off and Recovery"
text: |
  Verify behavior of the transmit stack when the CAN controller enters bus-off and recovery is attempted.

tsf_type: "Test"
verification_method: "Fault injection / hardware tests"

parents:
  - id: SWD-RASP_CAN_TX

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
tags: ["bus-off", "recovery"]

---
# Test: Bus-Off & Recovery

Objective:
- Ensure transmit stack detects bus-off, attempts recovery and reports status appropriately.

Steps:
1. Induce bus errors to push controller into bus-off.
2. Verify recovery attempts and that queued frames are handled according to policy after recovery.

Acceptance Criteria:
- Recovery attempts performed; frames not silently lost without metrics; alerts generated if recovery fails.
