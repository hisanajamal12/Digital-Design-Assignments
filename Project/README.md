# Dynamic Bandwidth Throttler using AXI-Stream

## Overview

This project implements a **Dynamic Bandwidth Throttler** for AXI-Stream data paths using Verilog HDL.

The design monitors outgoing traffic and dynamically adjusts transmission bandwidth using a **closed-loop feedback mechanism**. This ensures controlled data flow, prevents excessive bursts, and maintains system stability under varying traffic conditions.

---

## System Architecture
<img width="1400" height="720" alt="611538812-7d02c7af-bec4-4bc9-aafe-5cdd03cf4172" src="https://github.com/user-attachments/assets/08e275bb-8116-45bb-ab53-97267968bcec" />


The design consists of a sequential data pipeline integrated with a feedback control system.

```text
AXI-Stream Input
        │
        ▼
┌───────────────┐
│ AXIS Reg Slice│
└───────────────┘
        │
        ▼
┌───────────────┐
│   AXIS FIFO   │
└───────────────┘
        │
        ▼
┌───────────────┐
│ Rate Limiter  │
└───────────────┘
        │
        ▼
┌───────────────┐
│ Byte Counter  │
└───────────────┘
        │
        ▼
AXI-Stream Output
```

A control FSM continuously monitors traffic statistics and updates the rate limiter dynamically.

---

## Features

* AXI-Stream compliant interface
* Dynamic bandwidth control
* FIFO-based buffering
* Byte-count monitoring
* Closed-loop feedback control
* Programmable thresholds
* FSM-based throttling logic
* Overflow prevention

---

## Major Modules

### 1. AXIS Register Slice

* Pipeline stage for timing improvement
* Registers incoming AXI-Stream transactions
* Handles backpressure using skid buffering

---

### 2. AXIS FIFO

* Temporary storage for incoming packets
* Handles traffic bursts efficiently
* Provides backpressure support
* Includes high-watermark detection

---

### 3. AXIS Rate Limiter

* Controls transmission bandwidth
* Uses handshake-based throttling (no packet loss)
* Injects wait states to regulate throughput

---

### 4. AXIS Statistics Counter

* Monitors transferred bytes
* Measures bandwidth usage over time windows
* Provides feedback to control FSM

---

### 5. Rate Control FSM

* Reads traffic statistics
* Compares against thresholds
* Dynamically adjusts throttle ratio

---

## Configuration Parameters

| Parameter                | Description                   |
| ------------------------ | ----------------------------- |
| cfg_high_threshold_bytes | Upper bandwidth threshold     |
| cfg_low_threshold_bytes  | Lower bandwidth threshold     |
| rate_limit_num           | Numerator of throttle ratio   |
| rate_limit_denom         | Denominator of throttle ratio |

### Example

```text
rate_limit_num   = 1
rate_limit_denom = 1
```

---

## FSM States

### STATE_IDLE

* Normal operation
* Full throughput
* Activated when traffic is below threshold

---

### STATE_THROTTLE

* Activated when traffic exceeds high threshold
* Reduces output bandwidth

---

### STATE_RECOVERY

* Activated when traffic falls below low threshold
* Gradually restores bandwidth

---

## AXI-Stream Signals

### Input Interface

| Signal        | Description   |
| ------------- | ------------- |
| s_axis_tdata  | Input data    |
| s_axis_tkeep  | Byte enable   |
| s_axis_tvalid | Input valid   |
| s_axis_tready | Input ready   |
| s_axis_tlast  | End of packet |

---

### Output Interface

| Signal        | Description   |
| ------------- | ------------- |
| m_axis_tdata  | Output data   |
| m_axis_tkeep  | Byte enable   |
| m_axis_tvalid | Output valid  |
| m_axis_tready | Output ready  |
| m_axis_tlast  | End of packet |

---

## Detailed Microarchitecture
<img width="1073" height="486" alt="611539305-4bff8759-8c6f-4c1d-a46c-ab699f4be995" src="https://github.com/user-attachments/assets/cd5efbb6-6c44-487d-8abf-ccb8f4e436b3" />


### A. Input Stage (`axis_reg_slice`)

* Provides isolation at input boundary
* Introduces one clock cycle latency
* Uses skid buffer for safe backpressure handling

---

### B. Elastic Buffer (`axis_fifo`)

* 512-depth memory buffer
* Stores incoming data during congestion
* Tracks occupancy using read/write pointers
* Triggers watermark signal at ~80% capacity

---

### C. Rate Limiter (`axis_rate_limit`)

* Controls throughput using ratio-based throttling
* Uses ready signal modulation instead of dropping packets
* Example: 25% bandwidth → 1 cycle active, 3 cycles stall

---

### D. Traffic Monitor (`axis_stat_counter`)

* Tracks output data transfer
* Uses fixed observation window
* Sends byte count to FSM

---

### E. Control FSM (`rate_control_fsm`)

#### STATE_IDLE

* Full throughput (100%)
* Transition if:

  * Byte count exceeds threshold
  * FIFO watermark reached

#### STATE_THROTTLE

* Reduces throughput (e.g., 25%)
* Transition to recovery when traffic reduces

#### STATE_RECOVERY

* Intermediate throughput (e.g., 50%)
* Returns to idle after stabilization

---

## Throttling Mechanism

The system applies **dual backpressure control**:

1. **Downstream Control**

   * Rate limiter regulates output flow

2. **Upstream Control**

   * FIFO fills → backpressure propagates to input

---

## Emergency Watermark Logic

* FIFO occupancy monitored continuously
* If buffer exceeds ~80%:

  * Immediate FSM transition to THROTTLE
* Prevents overflow without waiting for statistics window

---

## Simulation Observations
<img width="1339" height="538" alt="611607941-e11fc421-47fd-41f8-a63d-9ab21748bb79" src="https://github.com/user-attachments/assets/43e9b879-7f90-4d58-b687-e1beaf04c6fd" />
<img width="1337" height="565" alt="611607872-9bc44b45-232c-4023-ae5a-5bc1f25b8d4c" src="https://github.com/user-attachments/assets/f678ff91-6bbf-41f3-ba65-bfa05d31643e" />


The design was verified through simulation:

* AXI-Stream transfers successful
* FIFO buffering validated
* Dynamic throttling observed
* FSM transitions correct
* No data loss

### Observed State Flow

```text
IDLE → THROTTLE → RECOVERY → IDLE
```

### Example Configuration

```text
High Threshold : 0x28 bytes
Low Threshold  : 0x0C bytes
```

---

## Applications

* Network traffic shaping
* Ethernet packet control
* FPGA-based routers
* Data center accelerators
* Video streaming systems
* High-speed communication systems
* QoS (Quality of Service) management

---

## Result

The Dynamic Bandwidth Throttler was successfully implemented and verified using Verilog HDL.

Simulation results confirm:

* Correct FIFO buffering
* Accurate rate limiting
* Reliable bandwidth monitoring
* Proper FSM-based control

---

## Repository

https://github.com/AksharaKMurali/design-assignment-akshara
