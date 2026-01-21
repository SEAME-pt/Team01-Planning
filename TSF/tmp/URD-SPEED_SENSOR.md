---
id: URD-SPEED_SENSOR
header: "Vehicle Speed Sensing Capability"
text: |
  The user needs the system to accurately measure and display the real-time speed of the vehicle using a speed sensor. 
  The system must capture, process, and present speed information to the operator with minimal delay and clear visual feedback, 
  supporting both operational safety and compliance with traffic regulations.

tsf_type: "Assertion"
verification_method: "Demonstration during vehicle operation and user acceptance testing. Visual inspection of speed display."

children:
  - id: SRD-SPEED_SENSOR_INPUT 	

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
tags: ["speed-sensor", "vehicle", "real-time", "user-interface", "safety", "priority-high"]

---
# Requirement Statement

The system shall provide users with an accurate, real-time indication of the vehicle’s speed using a dedicated speed sensor, with output continuously shown on the user interface. The information must update at least once per second and be legible under all normal operating conditions.
