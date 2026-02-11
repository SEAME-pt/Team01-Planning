---
id: SRD-QT_DASHBOARD
header: "Qt Dashboard Display System"
text: |
  The system shall implement a Qt-based dashboard for displaying vehicle speed and other metrics. The dashboard must provide real-time updates, user-friendly interface, and reliable data presentation with error handling for communication failures.

tsf_type: "Assertion"
verification_method: "UI testing, integration testing with data sources, usability evaluation, and performance benchmarking."

children:
  - id: SWD-QT_DASHBOARD

parents:
  - id: URD-DASHBOARD

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

references:
  - type: "file"
    path: TSF/urd/URD-DASHBOARD.md

active: true
derived: false
normative: true
level: 2.0
tags: ["qt", "dashboard", "display", "gui", "speed", "user-interface", "priority-high"]

---
# Software Requirement Statement

The Qt dashboard shall:

- Display current vehicle speed with high visibility and accuracy
- Receive speed data from Raspberry Pi via network or direct interface
- Update display at least 5 times per second for smooth visualization
- Provide clear numerical and graphical speed indicators
- Handle communication errors by showing last known speed or error messages
- Support configurable display units (km/h, mph)
- Include safety warnings for overspeed conditions
- Maintain responsive UI during high CPU load
- Support multiple display resolutions and themes
