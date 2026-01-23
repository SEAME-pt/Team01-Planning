---
id: SWD-QT_DASHBOARD
header: "QT Dashboard Software Design"
text: |
  This document describes the software design for the QT-based dashboard application.
  It details the UI components, data ingestion from CAN, persistence for telemetry, and
  interfaces for configuration and diagnostics. The design focuses on timely updates,
  accessibility, and safe display of emergency indicators.

tsf_type: "Design"
verification_method: "Design review, UI acceptance tests, hardware-in-the-loop integration tests"

children:
  - id: LLTC-QT_BASIC_DISPLAY
  - id: LLTC-QT_LATENCY
  - id: LLTC-QT_UNITS
  - id: LLTC-QT_EMERGENCY_INDICATOR
  - id: LLTC-QT_ACCESSIBILITY
  - id: LLTC-QT_PERSISTENCE

parents:
  - id: SRD-QT_DASHBOARD

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

active: true
derived: false
normative: true
level: 3.0
tags: ["qt", "dashboard", "ui", "can", "telemetry"]

---
# Software Design Description

## 1. Purpose
The QT Dashboard presents vehicle speed, status indicators and diagnostic information.
It must be responsive, maintain visual clarity for safety-critical indications and
not interfere with real-time control loops.

## 2. Architecture / Structure
- UI Layer (QT)
	- Views: Speed gauge, numeric readout, status panel, diagnostic pane, settings dialog.
	- Rendering uses a dedicated UI thread/process to avoid blocking control logic.
- Data Adapter
	- Subscribes to CAN messages (via an adapter service or socket) and normalises them into application models.
	- Implements validation, rate-limiting and filtering.
- Persistence & Telemetry
	- Bounded local ring buffer for recent telemetry (e.g., last 60s), with mechanisms for upload/export.
- Configuration & Settings
	- Settings stored persistently (unit selection, contrast mode, thresholds).
- Diagnostics & Monitoring
	- Exposes health metrics (message loss, parsing errors, render latency) and a debug overlay for test mode.

## 3. Interfaces
- CAN Adapter API: subscribe(message_id: int, callback: Callable[[Message], None])
- Settings API: get_setting(key: str) -> Any; set_setting(key: str, value: Any)
- Telemetry API: append_sample(sample: dict) -> None; export(range: TimeRange) -> bytes
- UI Event Hooks: register_ui_event(event_name: str, handler: Callable)

## 4. Algorithms
- Update pipeline:
	- CAN adapter receives frames → validation and conversion → model update → UI diff and render.
	- Use debounce and coalescing to keep UI update frequency ≤ 10 Hz for non-critical info and ≥ 10 Hz for speed updates.
- Emergency handling:
	- On emergency stop message, freeze critical displays and raise a blocking modal if required by UX spec.

## 5. Error Handling & Edge Cases
- Malformed messages: drop and log; increment per-source counters; after N malformed messages mark source as suspect.
- Delayed messages/timeouts: show stale indicator and use last-known-good value until recovery.
- Persistence overflow: enforce strict bounded buffer and rotate oldest samples; ensure storage < 1 MB as per SRD.

## 6. Links to lower levels
- See attached LLTCs for tests covering UI correctness, timing, units, emergency indicator behavior, diagnostics, accessibility, persistence bounds, and end-to-end integration.

## Note about local code
I couldn't read files outside the repository from this environment; if you want me to include concrete class names, file paths or component details from your local `Car_control_Raspberry/Dashboard`, please paste key files or move the code into the repo and I'll incorporate them into the design.

