---
id: LLTC-RASP_CAN_RX_MALFORMED
header: "Rasp CAN RX — Malformed Frame Handling"
text: |
  Verify malformed or unexpected frames are safely handled (dropped, logged, and possibly marked suspect).

tsf_type: "Test"
verification_method: "Unit tests and fault injection"

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
tags: ["malformed", "validation"]

---
# Test: Malformed Frames

Objective:
- Ensure malformed frames do not cause crashes, are logged, and are treated per policy (dropped or flagged).

Steps:
1. Send frames with invalid DLC, truncated payloads, or mismatched checksums.
2. Verify the frames are dropped and appropriate logs/metrics are produced.

Acceptance Criteria:
- No crash; malformed frames dropped and counted in metrics; repeated offenders flagged as suspect.
