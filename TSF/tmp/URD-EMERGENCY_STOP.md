---
id: URD-EMERGENCY_STOP
header: "Emergency Stop Capability"
text: |
  The user needs the system to provide immediate and reliable emergency stop functionality to halt the vehicle in critical situations. This ensures occupant safety by allowing rapid deceleration and stopping when hazards are detected or manual intervention is required, preventing accidents and minimizing injury risk.

tsf_type: "Assertion"
verification_method: "Demonstration during emergency scenarios, user acceptance testing, safety validation testing, and integration testing with braking systems."

children:
  - id: SRD-EMERGENCY_STOP

parents: []

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
tags: ["emergency-stop", "safety", "critical", "braking", "user-interface", "priority-critical"]

---
# Requirement Statement

The system shall provide an emergency stop mechanism that can be activated manually by the user through dedicated controls or automatically triggered by safety systems. Upon activation, the system must immediately initiate maximum braking force to bring the vehicle to a complete stop as quickly and safely as possible, while maintaining vehicle stability and occupant protection. The emergency stop shall override all other control systems, provide clear visual and audible feedback to the user, and include fail-safe mechanisms to ensure functionality even in system failures.
