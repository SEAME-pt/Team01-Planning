---
id: LLTC-RASP_CAN_TX_BASIC
header: "Rasp CAN TX — Basic Transmit"
text: |
  Verify the Raspberry Pi CAN transmit subsystem transmits valid CAN frames onto the bus
  and that frames are visible to other nodes (e.g., STM32).

tsf_type: "Test"
verification_method: "Hardware-in-the-loop"

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
tags: ["transmit", "functional"]

---
# Test: Basic Transmit

Objective:
- Confirm valid frames sent by RPi appear on the CAN bus and are receivable by target nodes.

Steps:
1. Start the transmit software and a monitoring node.
2. Request a frame transmission via send_frame API with a test CAN ID.
3. Verify the frame is observed on the bus and has correct payload and ID.

Acceptance Criteria:
- Frame visible on bus with expected payload; no transmit error logged.
