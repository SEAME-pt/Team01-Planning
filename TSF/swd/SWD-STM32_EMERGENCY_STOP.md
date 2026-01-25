---
id: SWD-STM32_EMERGENCY_STOP
header: "STM32 Emergency Stop Design"
text: |
  This design specifies the emergency stop mechanism on STM32 for immediate motor shutdown, prioritizing safety with rapid response and override capabilities.

tsf_type: "Design"
verification_method: "Safety testing, response time measurement, fault injection."

children:
  - id: LLTC-STM32_EMERGENCY_RESPONSE_TIME
  - id: LLTC-STM32_EMERGENCY_OVERRIDE

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
tags: ["emergency-stop", "safety", "stm32", "shutdown", "design"]

---
# Software Design Description

## 1. Purpose
This design covers emergency stop functionality on STM32, ensuring immediate cessation of motor operation upon command, with priority over normal control operations.

## 2. Architecture/Structure
- Interrupt-driven emergency stop input
- Safety state machine (normal, emergency, recovery)
- Motor shutdown sequence
- Recovery mechanism with manual reset

## 3. Interfaces
- `emergency_stop_init()`: Configure emergency inputs
- `trigger_emergency_stop()`: Activate stop (internal/external)
- `reset_emergency_state()`: Manual recovery
- `is_emergency_active()`: Check current state

## 4. Algorithms
Pseudocode for emergency stop:
```
interrupt emergency_stop_isr():
    set_emergency_flag()
    disable_motor_pwms()
    send_i2c_stop_commands()
    log_emergency_event()
    enter_safe_state()

function reset_emergency():
    if manual_reset_pressed():
        clear_emergency_flag()
        gradual_motor_restart()
        return_to_normal_control()
```

## 5. Error Handling & Edge Cases
- Multiple stop sources: OR logic for activation
- Stop during acceleration: Immediate brake application
- Communication failure during stop: Hardware cutoff
- False triggers: Debouncing and confirmation