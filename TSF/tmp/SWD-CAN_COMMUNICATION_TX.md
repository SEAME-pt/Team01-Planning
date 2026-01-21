---
id: SWD-CAN_COMMUNICATION_TX
header: "CAN Communication Transmit Module Design"
text: |
  This design specifies the software architecture for CAN message transmission from the Raspberry Pi to STM32, including message queuing, priority handling, error recovery, and hardware interface management.

tsf_type: "Design"
verification_method: "Design review, code inspection, unit testing, integration testing, and performance testing."

children:
  - id: LLTC-CAN_TX_MESSAGE_QUEUING
  - id: LLTC-CAN_TX_ERROR_HANDLING
  - id: LLTC-CAN_TX_PRIORITY_SCHEDULING

parents:
  - id: SRD-CAN_BUS_COMMUNICATION

reviewers:
  - name: "Afonso Mota"
    email: "afonso.mota@seame.pt"
  - name: "José Meneses"
    email: "jose.meneses@seame.pt"

reviewed: ''

references:
  - type: "file"
    path: designs/swd/can_tx_module.md
  - type: "standard"
    name: "CAN 2.0B Specification"

active: true
derived: false
normative: true
level: 3.0
tags: ["can-transmission", "software-design", "communication", "real-time", "error-handling"]

---
# Software Design Description

## 1. Purpose
This design implements the transmission side of CAN bus communication, enabling reliable delivery of control commands and status messages from the Raspberry Pi to the STM32 microcontroller. It satisfies the transmission requirements of SRD-CAN_BUS_COMMUNICATION.

## 2. Architecture/Structure
The module consists of four main components:
- **Message Queue Manager**: Priority-based queue with 16-slot buffer
- **Message Formatter**: Converts application data to CAN 2.0B frames
- **Transmission Controller**: Interfaces with CAN hardware controller
- **Error Handler**: Manages retransmissions and fault recovery

## 3. Interfaces
**Public API:**
- `can_tx_init()`: Initialize transmission module
- `can_tx_send(message, priority)`: Queue message for transmission
- `can_tx_get_status()`: Get transmission statistics

**Data Structures:**
- `CanMessage`: {id, data[8], length, priority}
- `TxStatus`: {queued, sent, failed, retries}

## 4. Algorithms
**Priority Scheduling:**
```
while queue not empty:
  message = dequeue_highest_priority()
  if bus_available():
    transmit(message)
    wait_for_ack(timeout=100ms)
  else:
    requeue_with_backoff()
```

**Error Recovery:**
```
on_transmission_error:
  increment_retry_count()
  if retries < 3:
    requeue_message()
  else:
    log_fault()
    notify_application()
```

## 5. Error Handling & Edge Cases
- **Bus Off**: Automatic recovery with 1-second delay
- **Arbitration Loss**: Immediate retransmission
- **Queue Overflow**: Drop lowest priority messages
- **Hardware Faults**: Fallback to error state with logging
- **Multi-threading**: Mutex protection for queue access
