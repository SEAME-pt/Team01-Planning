---
id: LLTC-QT_DASHBOARD
header: "QT Dashboard — Basic Functionality"
text: |
  Verify the QT dashboard correctly displays speed, handles updates, units, emergency indicators, accessibility, and persistence.

tsf_type: "Test"
verification_method: "UI testing, integration testing, hardware-in-the-loop tests"

parents:
  - id: SWD-QT_DASHBOARD

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

active: true
derived: false
normative: true
level: 4.0
tags: ["qt", "dashboard", "ui", "display", "functionality"]

---
# Test: QT Dashboard Basic Functionality

Objective:
- Confirm speed display updates correctly and meets latency requirements.
- Test unit conversions, emergency indicators, accessibility features, and data persistence.
- Ensure UI responsiveness and error handling.