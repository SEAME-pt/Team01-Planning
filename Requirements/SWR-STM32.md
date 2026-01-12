|Requirement ID   | Type   | Description                           |
|-----------------|--------|---------------------------------------|
| SWR-STM32-001   | SWR    | Calculate wheel RPM                   |
| SWR-STM32-002   | SWR    | Transmit RPM via CAN                  |
| SWR-STM32-003   | SWR    | Reception & validation of wheel speed |
| SWR-STM32-004   | SWR    | Wheel speed presentation in dashboard |
| SWR-STM32-005   | SWR    | Transmit engine RPM via CAN           |
| SWR-STM32-006   | SWR    | Reception & validation of engine RPM  |
| SWR-STM32-007   | SWR    | Control DC motors via I2C software    |
| SWR-STM32-008   | SWR    | Control servo motors via I2C software |
| SWR-STM32-009   | SWR    | Transmit data over CAN bus            |
| SWR-STM32-010   | SWR    | Receive and validate CAN messages     |
| SWR-STM32-011   | SWR    | Control DC motors via I2C             |
| SWR-STM32-012   | SWR    | Control servo motors via I2C          |
| RSR-STM32-001   | RSR    | Handle sensor failure safely          |
| RSR-STM32-002   | RSR    | Handle can comunication failure safely|
| RSR-STM32-003   | RSR    | Handle sensor failure safely          |
| RSR-STM32-004   | RSR    | Handle CAN failure safely             |
| RSR-STM32-005   | RSR    | Handle I2C bus failure safely         |

---

ID: SWR-STM32-001  
Title: Wheel speed calculation  
Type: Functional  
Priority: High  
Source: System  

Description:  
The software shall calculate wheel speed in RPM based on the number of sensor pulses measured during a fixed sampling period.

Rationale:  
Wheel speed is required for vehicle telemetry and safety monitoring.

Parent Requirement:  
SR-STM32-001

Related Components:  
- Sensor Thread  
- Timer Driver

Verification:  
Unit Test

Acceptance Criteria:  
- RPM equals (pulses / pulses_per_rev) * (60 / sampling_time)

---

ID: SWR-STM32-002  
Title: CAN transmission of wheel speed  
Type: Interface  
Priority: High  
Source: System  

Description:  
The software shall transmit the calculated wheel speed over the CAN bus to the Raspberry Pi.

Rationale:  
Wheel speed data must be available to central processing and logging.

Parent Requirement:  
SR-STM32-001

Related Components:  
- CAN Bus Interface  

Verification:  
Integration Test

Acceptance Criteria:  
- A CAN frame containing the wheel speed is transmitted every 10 ms

---

ID: SWR-STM32-003  
Title: Reception and validation of wheel speed CAN message  
Type: Interface  
Priority: High  
Source: System  

Description:  
The STM32 shall verify that received CAN messages containing wheel speed data are uncorrupted and within a valid range.

Rationale:  
Valid data transmission is critical for safety and reliability.

Parent Requirement:  
SR-STM32-001

Related Components:  
- CAN Bus Interface  
- Data Validation Module

Verification:  
Unit Test, Fault Injection

Acceptance Criteria:  
- All received CAN messages are checked for integrity (e.g., checksum, CRC).
- Corrupted or out-of-range messages are discarded and an error is logged.

---

ID: SWR-STM32-004  
Title: Wheel speed presentation in Qt dashboard  
Type: Interface  
Priority: High  
Source: System  

Description:  
The Qt dashboard shall display the most recent wheel speed readings as received from the vehicle system.

Rationale:  
Accurate and timely visual presentation of wheel speed is necessary for operator awareness and monitoring.

Parent Requirement:  
SR-STM32-001 SR-STM32-002

Related Components:  
- Qt Dashboard Application  
- CAN Interface  
- Raspberry Pi 5

Verification:  
System Test

Acceptance Criteria:  
- The wheel speed shown in the Qt dashboard matches the most recent value received over the CAN bus.
- The displayed value is updated within 20 ms of receiving new data.

---

ID: RSR-STM32-001  
Title: Handle sensor failure safely  
Type: Safety  
Priority: High  
Source: Safety  

Description:  
The software shall detect loss or malfunction of the wheel speed sensor and transition the system to a safe state within 20 ms.

Rationale:  
Correct and timely detection of sensor failures is critical for the safety integrity of vehicle operation.

Parent Requirement:  
SR-STM32-001

Related Components:  
- Speed Sensor Module  
- Safety Monitor

Verification:  
Fault Injection Test, System Test

Acceptance Criteria:  
- Loss or malfunction of the speed sensor is detected within 20 ms.
- Upon detection, the system disables dependent outputs and logs an error message.

---

ID: RSR-STM32-002  
Title: Handle CAN communication failure safely  
Type: Safety  
Priority: High  
Source: Safety  

Description:  
The software shall detect CAN bus communication failures and transition the system to a safe state within 20 ms of failure detection.

Rationale:  
Timely detection and mitigation of CAN bus failures is essential to maintain system safety and reliability.

Parent Requirement:  
SR-STM32-001 SR-STM32-003

Related Components:  
- CAN Bus Interface  
- Safety Monitor

Verification:  
Fault Injection Test, System Test

Acceptance Criteria:  
- Loss of CAN bus communication or repeated CAN errors (e.g., bus-off state) are detected within 20 ms.
- Upon detection, the system disables dependent outputs and logs an appropriate error message.
- Recovery procedure is triggered if communication is re-established.

---

ID: SWR-STM32-005  
Title: CAN transmission of engine RPM  
Type: Interface  
Priority: High  
Source: System  

Description:  
The software shall transmit the calculated engine RPM over the CAN bus.

Rationale:  
Engine RPM data must be available for monitoring and logging.

Parent Requirement:  
SWR-STM32-009

Related Components:  
- CAN Bus Interface  

Verification:  
Integration Test

Acceptance Criteria:  
- A CAN frame containing the engine RPM is transmitted every 10 ms

---

ID: SWR-STM32-006  
Title: Reception and validation of engine RPM CAN message  
Type: Interface  
Priority: High  
Source: System  

Description:  
The software shall verify that received CAN messages containing engine RPM data are uncorrupted and within a valid range.

Rationale:  
Valid engine RPM data is critical for safety and reliability.

Parent Requirement:  
SWR-STM32-010

Related Components:  
- CAN Bus Interface  
- Data Validation Module

Verification:  
Unit Test, Fault Injection

Acceptance Criteria:  
- All received CAN messages are checked for integrity (e.g., checksum, CRC).
- Corrupted or out-of-range messages are discarded and an error is logged.

---

ID: SWR-STM32-009  
Title: CAN Data Transmission  
Type: Interface  
Priority: High  
Source: System  

Description:  
The system shall transmit various data over the CAN bus to other components.

Rationale:  
Data transmission is required for system communication and telemetry.

Related Components:  
- CAN Bus Interface  

Verification:  
Integration Test

Acceptance Criteria:  
- Data is transmitted in CAN frames every 10 ms

---

ID: SWR-STM32-010  
Title: CAN Data Reception and Validation  
Type: Interface  
Priority: High  
Source: System  

Description:  
The system shall receive and validate CAN messages from other components.

Rationale:  
Valid data reception is critical for safety and reliability.

Related Components:  
- CAN Bus Interface  
- Data Validation Module

Verification:  
Unit Test, Fault Injection

Acceptance Criteria:  
- Received CAN messages are checked for integrity (e.g., checksum, CRC).
- Corrupted or out-of-range messages are discarded and an error is logged.

---

ID: SWR-STM32-011  
Title: I2C Control of DC Motors  
Type: Interface  
Priority: High  
Source: System  

Description:  
The system shall control DC motors using I2C communication to send commands for speed and direction.

Rationale:  
Precise control of DC motors is required for vehicle propulsion and auxiliary functions.

Related Components:  
- I2C Bus Interface  
- DC Motor Driver  

Verification:  
Integration Test

Acceptance Criteria:  
- I2C commands are sent to control motor speed (0-100%) and direction (forward/reverse).
- Commands are acknowledged and executed within 10 ms.

---

ID: SWR-STM32-012  
Title: I2C Control of Servo Motors  
Type: Interface  
Priority: High  
Source: System  

Description:  
The system shall control servo motors using I2C communication to send commands for position and torque.

Rationale:  
Accurate positioning of servo motors is necessary for steering and actuation systems.

Related Components:  
- I2C Bus Interface  
- Servo Motor Controller  

Verification:  
Integration Test

Acceptance Criteria:  
- I2C commands are sent to set servo position (0-180 degrees) and torque limits.
- Commands are acknowledged and executed within 10 ms.

---

ID: RSR-STM32-005  
Title: Handle I2C bus failure safely  
Type: Safety  
Priority: High  
Source: Safety  

Description:  
The software shall detect I2C bus communication failures and transition the system to a safe state within 20 ms of failure detection.

Rationale:  
Timely detection and mitigation of I2C bus failures is essential to maintain system safety and reliability for motor control.

Parent Requirement:  
SWR-STM32-011 SWR-STM32-012

Related Components:  
- I2C Bus Interface  
- Safety Monitor

Verification:  
Fault Injection Test, System Test

Acceptance Criteria:  
- Loss of I2C bus communication or repeated I2C errors are detected within 20 ms.
- Upon detection, the system disables motor outputs and logs an appropriate error message.
- Recovery procedure is triggered if communication is re-established.

---

ID: SWR-STM32-007  
Title: Software control of DC motors via I2C  
Type: Functional  
Priority: High  
Source: System  

Description:  
The software shall calculate and transmit I2C commands to control DC motor speed and direction based on input parameters.

Rationale:  
Software implementation is required to translate high-level commands into I2C protocol for DC motor operation.

Parent Requirement:  
SWR-STM32-011

Related Components:  
- I2C Driver  
- Motor Control Algorithm  

Verification:  
Unit Test, Integration Test

Acceptance Criteria:  
- I2C frames are generated for speed (0-100%) and direction commands.
- Commands are sent within 5 ms of receiving input.

---

ID: SWR-STM32-008  
Title: Software control of servo motors via I2C  
Type: Functional  
Priority: High  
Source: System  

Description:  
The software shall calculate and transmit I2C commands to control servo motor position and torque based on input parameters.

Rationale:  
Software implementation is required to translate high-level commands into I2C protocol for servo motor operation.

Parent Requirement:  
SWR-STM32-012

Related Components:  
- I2C Driver  
- Servo Control Algorithm  

Verification:  
Unit Test, Integration Test

Acceptance Criteria:  
- I2C frames are generated for position (0-180 degrees) and torque commands.
- Commands are sent within 5 ms of receiving input.