---
id: SRD-SPEED_SENSOR_INPUT
header: "Software Processing of Vehicle Speed Sensor Data"
text: |
  The system shall acquire raw signals from the speed sensor, process them into calibrated speed values, and update the displayed vehicle speed in real-time on the user interface. The calculated speed must update at least once per second and be displayed with a minimum resolution of 1 km/h (or 1 mph, as appropriate). The processing pipeline shall handle signal noise, sensor faults, and missing data gracefully to ensure reliability during normal operation.

tsf_type: "Assertion"
verification_method: "Unit and integration tests verifying acquisition, processing, and display logic; simulation with speed sensor signals."

children:    # You might refine into SWD or further SRDs
  - id: SWD-SPEED_SENSOR_PROCESSING

parents:
  - id: URD-SPEED_SENSOR

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

references:
  - type: "file"
    path: requirements/srd/speed_sensor_input.md

active: true
derived: false
normative: true
level: 2.0
tags: ["speed-sensor", "processing", "display", "real-time", "fault-tolerance"]

---
# Software Requirement Statement

The software shall continuously acquire input data from the vehicle speed sensor, process the data to calculate the current speed (with a minimum update rate of 1Hz and a minimum resolution of 1 km/h), and present it on the user interface.  
The processing must:
- Filter out signal noise (using averaging, digital filters, or equivalent methods)
- Detect and handle sensor faults or data loss gracefully, alerting the user if necessary
- Maintain robust operation regardless of typical sensor variances

The displayed speed shall be updated without noticeable lag and remain legible under all standard operating conditions.
---

