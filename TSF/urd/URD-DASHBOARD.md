---
id: URD-DASHBOARD
header: "Dashboard Display Capability"
text: |
  The user needs the system to provide a dashboard for displaying real-time vehicle information, including speed, status indicators, and diagnostic data. The dashboard must present data with minimal delay, clear visual feedback, and support user interactions for safe and efficient operation.

tsf_type: "Assertion"
verification_method: "Demonstration during vehicle operation and user acceptance testing. Visual inspection of speed display."

children:
  - id: SRD-QT_DASHBOARD
  - id: SRD-CAN_BUS

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

active: true	
derived: false
normative: true
level: 1.0
tags: ["dashboard", "display", "vehicle", "real-time", "user-interface", "safety", "priority-high"]

---
# Requirement Statement

The system shall provide users with an accurate, real-time dashboard displaying vehicle information, including speed, status indicators, and diagnostics. The information must update frequently and be legible under all normal operating conditions, supporting safe and efficient vehicle operation.