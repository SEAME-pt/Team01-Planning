---
id: SRD-SPEED_SENSOR
header: "Vehicle Speed Sensor Interface"
text: |
  The system shall interface with vehicle speed sensors to accurately measure and report current vehicle speed. This includes reading sensor data, performing signal processing, and providing filtered speed values for control systems while handling sensor faults and ensuring data integrity.

tsf_type: "Assertion"
verification_method: "Sensor integration testing, accuracy validation, fault injection testing, and signal integrity verification."

children:
  - id: SWD-STM32_SPEED_SENSOR

parents:
  - id: URD-CONTROL_VEHICLE
  - id: URD-DASHBOARD

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

references:
  - type: "file"
    path: TSF/urd/URD-CONTROL_VEHICLE.md
  - type: "file"
    path: TSF/urd/URD-DASHBOARD.md

active: true
derived: false
normative: true
level: 2.0
tags: ["speed-sensor", "interface", "stm32", "data-processing", "fault-handling", "priority-high"]

---
# Software Requirement Statement

The system shall implement speed sensor interface by:

- Reading speed data from sensors connected via digital inputs
- Providing speed measurements with accuracy of ±1 km/h
- Detecting sensor faults (e.g., signal loss, out-of-range values) and reporting errors
- Updating speed values at a minimum rate of 10 Hz for real-time control
- Converting raw sensor data to standardized speed units (rpm)
- Maintaining data integrity through checksums or parity checks where applicable