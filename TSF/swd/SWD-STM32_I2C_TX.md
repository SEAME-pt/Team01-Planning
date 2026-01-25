---
id: SWD-STM32_I2C_TX
header: "STM32 I2C Transmit Design for Motor Control"
text: |
  This design specifies the I2C transmit functionality on STM32 for sending motor speed control commands (0-100% duty cycle) to motor controllers in master mode, supporting multiple motor slaves.

tsf_type: "Design"
verification_method: "Code review, unit testing, integration testing with motor controllers."

children:
  - id: LLTC-STM32_I2C_TX_BASIC
  - id: LLTC-STM32_I2C_TX_LATENCY

parents:
  - id: SRD-STM32_I2C

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
tags: ["i2c", "motor-control", "stm32", "transmit", "design"]

---
# Software Design Description

## 1. Purpose
This design covers the I2C transmit operations on STM32 for sending speed control commands to motor actuators. It ensures reliable command transmission with proper duty cycle encoding and multi-slave support.

## 2. Architecture/Structure
- STM32 acts as I2C master
- Motor controllers as I2C slaves with unique addresses
- Transmit buffer for queuing commands
- State machine for handling transmission states

## 3. Interfaces
- `i2c_tx_init()`: Initialize I2C peripheral for transmit
- `i2c_send_speed_command(uint8_t slave_addr, uint8_t duty_cycle)`: Send speed command to specific motor
- `i2c_tx_status()`: Check transmission status

## 4. Algorithms
Pseudocode for sending command:
```
function send_speed_command(slave_addr, duty_cycle):
    prepare_i2c_packet(slave_addr, COMMAND_SPEED, duty_cycle)
    start_i2c_transmission()
    wait_for_ack()
    if ack_received:
        transmit_data()
        return SUCCESS
    else:
        handle_error()
        return FAILURE
```

## 5. Error Handling & Edge Cases
- NACK handling: Retry up to 3 times
- Bus busy: Wait and retry
- Invalid duty cycle: Clamp to 0-100%
- Timeout: Abort transmission after 10ms