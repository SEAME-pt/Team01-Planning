---
id: SRD-QT_DASHBOARD
header: "QT Dashboard Display Requirements"
text: |
  The QT dashboard shall display vehicle speed and associated status information to
  the driver and to diagnostic systems. The display shall be clear, responsive, and
  provide visual prioritisation for safety‑critical information (e.g., emergency stop,
  fault indicators).

tsf_type: "Assertion"
verification_method: "Integration testing, UI acceptance tests, manual inspection"

children:
  - id: SWD-QT_DASHBOARD

parents:
  - id: URD-DASHBOARD_DISPLAY_SPEED

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

active: true
derived: false
normative: true
level: 2.0
tags: ["dashboard", "qt", "display", "ui", "safety"]

---
# Software Requirement Statement

The QT Dashboard shall satisfy the following requirements:

- Display real-time vehicle speed in km/h with an accuracy of ±0.5 km/h for speeds in range 0–200 km/h.
- Update the displayed speed at least every 100 ms with end-to-end latency from the CAN message arrival to visual update under 150 ms for speed messages.
- Support configurable unit (km/h or mph) selectable in settings and persist the user choice across reboots.
- Prominently display emergency stop state: when an emergency stop is active, show a red, high-contrast indicator and freeze the speed display to the last safe value.
- Ensure visual contrast and text size meet accessibility guidelines for read‑ability at 50 cm under nominal cabin lighting.
- Provide a test-mode that overlays a timestamp and a message trace for debugging and verification.
- The dashboard shall not block critical control loops; UI rendering must run in a separate process or thread ensuring no perceptible impact on real-time control (control loop jitter increase < 1 ms).
- On startup, show a visible loading state and ensure the speed display initializes to a detectable default (e.g., 0.0 km/h) within 2 s of boot.
- Handle malformed or delayed speed messages gracefully: ignore malformed messages, mark source as suspect after three consecutive malformed messages, and display a warning icon.

## Verification
Each requirement above shall have corresponding tests in the LLTC set for `SWD-QT_DASHBOARD`:

- Functional tests for display correctness and units.
- Timing tests for update rate and latency (HIL measurements).
- Accessibility and contrast checks (manual inspection or automated screenshot-based tests).
- Fault injection tests for CAN errors, malformed messages and persistence limits.

---

