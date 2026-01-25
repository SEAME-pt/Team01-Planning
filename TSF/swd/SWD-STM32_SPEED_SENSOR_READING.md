---
id: SWD-STM32_SPEED_SENSOR_READING
header: "STM32 Speed Sensor Data Reading Design"
text: |
  This design specifies the data acquisition from speed sensors on STM32, including interface protocols, sampling rates, and initial data validation for reliable speed measurement.

tsf_type: "Design"
verification_method: "Hardware integration testing, signal capture analysis, unit testing."

children:
  - id: LLTC-STM32_SPEED_SENSOR_INPUT
  - id: LLTC-STM32_SPEED_SENSOR_SAMPLING

parents:
  - id: SRD-SPEED_SENSOR

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
tags: ["speed-sensor", "data-acquisition", "stm32", "interface", "design"]

---
# Software Design Description

## 1. Purpose
This design covers the reading of speed sensor data on STM32, supporting various sensor types (CAN, analog, digital) with proper timing and initial validation.

## 2. Architecture/Structure
- Multi-interface support (CAN, ADC, GPIO)
- Interrupt-driven or polled reading
- Buffer for raw sensor data
- Timestamping for data correlation

## 3. Interfaces
- `speed_sensor_init(sensor_type, config)`: Initialize sensor interface
- `read_speed_raw()`: Get raw sensor value
- `get_sensor_status()`: Check sensor connectivity

## 4. Algorithms
Pseudocode for sensor reading:
```
function read_speed_sensor():
    if sensor_type == CAN:
        receive_can_message(speed_id)
        extract_speed_data()
    elif sensor_type == ANALOG:
        adc_value = read_adc_channel()
        speed = convert_adc_to_speed(adc_value)
    validate_range(speed)
    timestamp = get_current_time()
    store_buffer(speed, timestamp)
```

## 5. Error Handling & Edge Cases
- No signal: Timeout and error flag
- Invalid data: Discard and retry
- Multiple sensors: Arbitration logic
- Power loss: Graceful degradation