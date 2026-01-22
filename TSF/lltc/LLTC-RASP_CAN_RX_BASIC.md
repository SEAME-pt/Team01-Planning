---
id: LLTC-RASP_CAN_RX_BASIC
header: "Rasp CAN RX — Basic Receive and Dispatch"
text: |
  Verify the Raspberry Pi CAN receive subsystem correctly receives standard CAN frames,
  validates them, and dispatches to registered consumers.

tsf_type: "Test"
verification_method: "Hardware-in-the-loop execution, unit tests"

parents:
  - id: SWD-RASP_CAN_RX

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"


active: true
derived: false
normative: true
level: 4.0
tags: ["receive", "dispatch", "functional"]

---
# Test: Basic Receive and Dispatch

Objective:
- Confirm valid CAN frames are received over SocketCAN, parsed and delivered to registered handlers.

Preconditions:
- CAN interface configured at 500 kbps.
- Test harness can transmit valid CAN frames onto the bus.

Steps:
1. Start the CAN RX software and register a test handler for a specific CAN ID.
2. Send a valid CAN frame with that ID and payload.
3. Observe the handler is invoked with the expected payload.

Acceptance Criteria:
- Handler receives the exact payload within the processing window.
- No errors logged for a correctly formed message.
