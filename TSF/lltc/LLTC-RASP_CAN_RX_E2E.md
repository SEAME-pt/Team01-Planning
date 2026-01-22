---
id: LLTC-RASP_CAN_RX_E2E
header: "Rasp CAN RX — End-to-end Integration"
text: |
  End-to-end validation from CAN arrival to consumption by speed controller and telemetry logging.

tsf_type: "Test"
verification_method: "Hardware-in-the-loop integration tests"

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
tags: ["e2e", "integration"]

---
# Test: End-to-end Integration

Objective:
- Validate that a message sent on the CAN bus reaches the speed controller logic and is used correctly (e.g., influences actuator command generation) and that telemetry is recorded.

Steps:
1. Send representative speed message on the bus.
2. Observe downstream consumer behavior (e.g., speed setpoint update) and telemetry logging.

Acceptance Criteria:
- Downstream consumer receives and processes the message within latency bounds; telemetry shows event and traceability ID.
