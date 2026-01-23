---
id: LLTC-RASP_CAN_TX_MALFORMED
header: "Rasp CAN TX — Malformed Frame Handling"
text: |
  Verify that the transmit stack does not transmit malformed frames and logs errors when invalid data is requested.

tsf_type: "Test"
verification_method: "Unit tests and integration tests"

parents:
  - id: SWD-RASP_CAN_TX

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"

references:
  - type: "file"
    path: requirements/swd/SWD-RASP_CAN_TX.md

active: true
derived: false
normative: true
level: 4.0
tags: ["validation", "malformed"]

---
# Test: Malformed Frame Handling

Objective:
- Ensure malformed frames are rejected by the API and not transmitted.

Steps:
1. Call send_frame with invalid payload sizes or invalid IDs.
2. Verify API returns failure and no frame appears on the bus; errors are logged.

Acceptance Criteria:
- No malformed frames on bus; errors logged and metrics incremented.
