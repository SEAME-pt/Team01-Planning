---
id: SWD-STM32_SPEED_CONTROL
header: "STM32 Vehicle Speed Control Algorithm Design"
text: |
  This design specifies the speed control algorithm on STM32 for translating speed commands to DC motor duty cycles, maintaining synchronization, and ensuring deterministic timing for vehicle speed management.

tsf_type: "Design"
verification_method: "Algorithm simulation, unit testing, integration testing with motors."

children:
  - id: LLTC-STM32_SPEED_PID_CONTROL
  - id: LLTC-STM32_SPEED_SYNCHRONIZATION

parents:
  - id: SRD-CONTROL_VEHICLE_SPEED

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
tags: ["speed-control", "algorithm", "stm32", "pid", "design"]

---
# Software Design Description

## 1. Purpose
This design covers the speed control logic on STM32, including PID control for maintaining target speeds, duty cycle calculation, and feedback integration for accurate vehicle speed management.

## 2. Architecture/Structure
- PID controller for speed regulation
- Speed-to-duty cycle mapping function
- Feedback integration from motor encoders/sensors
- Real-time task scheduler for control loop

## 3. Interfaces
- `speed_control_init()`: Initialize PID parameters
- `set_target_speed(float target_kmh)`: Set desired vehicle speed
- `update_speed_control()`: Run control loop (called periodically)
- `get_current_speed()`: Return actual speed from feedback

## 4. Algorithms
Pseudocode for PID speed control:
```
function pid_speed_control():
    error = target_speed - current_speed
    integral += error * dt
    derivative = (error - prev_error) / dt
    output = Kp * error + Ki * integral + Kd * derivative
    duty_cycle = clamp(map_speed_to_duty(output), 0, 100)
    send_duty_to_motors(duty_cycle)
    prev_error = error
```

## 5. Error Handling & Edge Cases
- Overspeed: Immediate duty reduction
- Sensor failure: Use estimated speed
- PID windup: Integral clamping
- Invalid target: Ignore and log