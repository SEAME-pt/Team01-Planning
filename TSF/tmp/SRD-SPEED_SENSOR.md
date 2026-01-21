---
id: SRD-SPEED_SENSOR
header: "Vehicle Speed Sensor System"
text: |
  The system shall acquire, process, and provide accurate real-time speed measurements from vehicle speed sensors. The speed sensor system must filter noise, detect faults, and transmit calibrated speed data via CAN bus to support speed display and control functionalities with high reliability and precision.

tsf_type: "Assertion"
verification_method: "Sensor integration testing, accuracy calibration, noise immunity testing, fault detection validation, and CAN transmission verification."

children:
  - id: SWD-SPEED_SENSOR_INTERFACE
  - id: SWD-SPEED_SENSOR_PROCESSING
  - id: SWD-CAN_COMMUNICATION_TX

parents:
  - id: URD-SPEED_SENSOR
  - id: URD-CONTROL_VEHICLE_SPEED

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

references:
  - type: "file"
    path: requirements/srd/speed_sensor_system.md
  - type: "requirement"
    id: SRD-CAN_BUS_COMMUNICATION

active: true
derived: false
normative: true
level: 2.0
tags: ["speed-sensor", "data-acquisition", "signal-processing", "fault-detection", "can-transmission", "priority-high"]

---
# Software Requirement Statement

The system shall implement speed sensor functionality that:

- Interfaces with hall-effect or magnetic speed sensors
- Samples speed data at minimum 100Hz rate for smooth measurements
- Applies digital filtering to remove electrical noise and mechanical vibrations
- Calibrates raw sensor pulses to accurate speed values (km/h or mph)
- Detects sensor faults including open circuits, short circuits, and signal loss
- Provides fallback mechanisms when primary sensor fails
- Transmits processed speed data via CAN bus to Raspberry Pi
- Maintains speed accuracy within ±1 km/h under normal operating conditions
- Supports vehicle speed range of 0-120 km/h with appropriate resolution
- Logs sensor diagnostics for maintenance and troubleshooting
