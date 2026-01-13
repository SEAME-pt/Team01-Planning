# Requirements Instructions Template

This template defines the structure and rules for writing software requirements for each project.

### Rules

- Single statement per requirement.
- Clear and unambiguous verb.
- Avoid words such as "and/or".
- Do not be ambiguous.
- One requirement per ID.
- Must be testable.
- Must use the keyword "shall".
- No implementation details.
- No compound sentences.
- Requirements shall describe expected behavior, including failure cases when applicable.
- Every requirement shall be verifiable by at least one defined verification method.

# 1 Requirements Header

### Requirements Overview Table

Start every requirements file with a small table listing all requirement IDs and their descriptions.

```text
|Requirement ID | Type | Description
|---------------|------|-------------
| SWR-STM32-001 | SR  | Calculate wheel RPM
| SWR-STM32-002 | SWR  | Transmit RPM via CAN
| RSR-STM32-001 | RSR  | Handle sensor failure safely
```

When filling out this table, start by listing the SR first, followed by its corresponding child requirements (SWR and RSR).

### ID Rules
 - System Requirements (SR)
 - Software Requirements (SWR)
 - Robustness/Safety Requirements (RSR)
 - Unit & Integration Tests (UT) & (IT)

ID format:
SR-<PLATFORM>-<NUMBER>
SWR-<PLATFORM>-<NUMBER>
RSR-<PLATFORM>-<NUMBER>

```text
ID: SWR-STM32-001
Title: Short descriptive title
Type: Functional | Safety | Interface | Performance | Diagnostic
Priority: High | Medium | Low
Source: System | Stakeholder | Safety | Derived
```

### Notes
The main difference between SWR and RSR is:
 - SWR -> What the software is supposed to do when everything is OK.
 - RSR -> What the software shall do when things go wrong.

Diferences in Type label:
 - Functional	->	What the system does in normal operation.
 - Safety		->	What the system does to avoid harm.
 - Interface	->	How the system communicates with other systems.
 - Performance	->	Timing, latency, throughput, limits.
 - Diagnostic	->	Observability and debugging (debug messages, error counters etc...)

Priority:
 - How bad is it if this is broken?

Diferences in Source label:
 - System		->	Derived from system-level behavior.
 - Stakeholder	->	Requested by a human or organization.
 - Safety		-> 	Required due to danger or risk.
 - Derived		->	Not explicitly requested (inferred from other requirements).

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
System-level requirement from which this requirement is derived.
If this requirement is top-level, this field may be omitted.
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

Acceptance criteria should be objective, measurable, and binary (pass/fail).
```text
Acceptance Criteria:
- Given valid sensor pulses, RPM is calculated correctly
- CAN frame is transmitted within 10 ms
```

# Example of a requirement

```text
ID: SR-STM32-001
Title: Wheel speed telemetry
Type: Functional
Priority: High
Source: Stakeholder

Description:
The system shall provide wheel speed telemetry to the Raspberry Pi.

Rationale:
Wheel speed telemetry is required for monitoring vehicle behavior and system status.

Verification:
System Test

Acceptance Criteria:
- The Raspberry Pi receives valid wheel speed data during normal operation.

---

ID: SWR-STM32-001
Title: Wheel speed calculation
Type: Functional
Priority: High
Source: System

Description:
The software shall calculate wheel speed in RPM based on the number of sensor pulses 
measured during a fixed sampling period.

Rationale:
Calculated wheel speed is required to fulfill the system-level telemetry requirement.

Parent Requirement:
SR-STM32-001

Related Components:
- Sensor Thread
- Timer Driver

Verification:
Unit Test

Acceptance Criteria:
- RPM equals (pulses / pulses_per_rev) × (60 / sampling_time).
```
---

# 1 Traceability_matrix

It’s a single place that links:

Requirements
 - Code
 - Tests
 - Verification status

# Example of Traceability table

```text
| Requirement ID | Verification | Code Location | Test ID      | Description
| -------------- | ------------ | ------------- | ------------ | ------------
| SWR-STM32-001  | Pass         | sensor.c      | UT-STM32-001 | Calculate RPM
| SWR-STM32-002  | Pass         | can_tx.c      | IT-STM32-001 | CAN TX RPM
| RSR-STM32-001  | Pass         | sensor.c      | UT-STM32-002 | Sensor failure safe state

| Line Coverage | Function Coverage |
| ------------- | ----------------- |
| 95%           | 100%              |
```


# Example of Project Structure

```text
project_root/
├── requirements/
│   ├── requirements.md
│
├── tests/
│   ├── unit/
│   │   ├── ut_stm32_speed.md      # spec for speed module
│   │   ├── ut_stm32_can.md        # spec for CAN module
│   │   └── test_speed.c           # unit tests for speed logic
│   │
│   ├── integration/
│   │   ├── it_stm32_can_flow.md   # end-to-end CAN tests
│   │   └── test_can_flow.c
│
├── traceability/
│   └── traceability_matrix.md
│
├── src/
│   ├── speed/
│   ├── can/
│   └── ...
└── README.md
```
