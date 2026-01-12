# Requirements Instructions Template

This template defines how to write a `requirements.md` file for each project.
Each repo aims to promote traceability, safety-critical development, and testability.

### Rules

- Single statement per requirement;
- Clear and unambiguous verb;
- Avoid words such as "and/or";
- Do not be ambiguous;
- One requirement per ID;
- Must be testable;
- Must use the keyword "shall";
- No implementation details;
- No compound sentences;
- Requirements shall describe expected behavior, including failure cases when applicable;


# 1 Requirements Header

### Requirements Overview Table

Start every requirements file with a small table listing all requirement IDs and their descriptions.

```text
|Requirement ID | Type | Description
|---------------|------|-------------
| SWR-STM32-001 | SWR  | Calculate wheel RPM
| SWR-STM32-002 | SWR  | Transmit RPM via CAN
| RSR-STM32-001 | RSR  | Handle sensor failure safely
```

### ID Rules
 - Software Requirements (SWR)
 - Robustness/Safety Requirements (RSR)
 - Unit & Integration Tests (UT) & (IT)

ID format:
SWR-<PLATFORM>-<NUMBER>
RSR-<PLATFORM>-<NUMBER>

```text
ID: SWR-STM32-001
Title: Short descriptive title
Type: Functional | Safety | Interface | Performance | Diagnostic
Priority: High | Medium | Low
Source: System | Stakeholder | Safety | Derived
```

# 2 Requirement Statement

```text
Description:
The software shall ...
```

# 3 Rationale (optional but strongly recommended)

```text
Explains why this requirement exists.
```

# 4 Traceability

```text
Parent Requirement:
SR-XXX

Related Components:
- CAN_TX thread
- Speed Sensor module

Verified By:
- UT-STM32-001
- IT-STM32-002
```

# 5 Verification Method

```text
Verification:
Unit Test | Integration Test | System Test | Analysis | Inspection
```
# 6 Acceptance Criteria

```text
Acceptance Criteria:
- Given valid sensor pulses, RPM is calculated correctly
- CAN frame is transmitted within 10 ms
```

# Example of a requirement

```text
ID: SWR-001
Title: Wheel speed calculation
Type: Functional
Priority: High
Source: System

Description:
The software shall calculate wheel speed in RPM based on the number of sensor pulses measured during a fixed sampling period.

Rationale:
Wheel speed is required for vehicle telemetry and safety monitoring.

Parent Requirement:
SR-001

Related Components:
- Sensor Thread
- Timer Driver

Verification:
Unit Test

Acceptance Criteria:
- RPM equals (pulses / pulses_per_rev) * (60 / sampling_time)

---

ID: SWR-002
Title: CAN transmission of wheel speed
Type: Interface
Priority: High
Source: System

Description:
The software shall transmit the calculated wheel speed over the CAN bus to the Raspberry Pi.

Verification:
Integration Test

Acceptance Criteria:
- A CAN frame containing the wheel speed is transmitted every 10 ms
```

---