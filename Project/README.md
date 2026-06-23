# Secure Dynamic Bandwidth Throttler (AXI-Stream)

## Overview
This project implements a hardware-level Dynamic Bandwidth Throttler for AXI-Stream data paths using Verilog HDL. Designed with a closed-loop feedback mechanism operating within a single master clock domain, this IP actively protects downstream components from high-speed data floods. 

By monitoring outgoing traffic rates and dynamically adjusting transmission bandwidth through wait-state injection, the system prevents buffer overflows while maintaining data flow within strictly programmable limits.

## System Architecture
The architecture is inherently defensive, applying backpressure simultaneously to both the input and output sides. It consists of a sequential data processing pipeline heavily regulated by a parallel feedback control loop.

<img width="1400" height="720" alt="Architecture Block Diagram" src="https://github.com/user-attachments/assets/8857170a-61d1-4c2c-ad6f-783bd5b45b2b" />

### Data Pipeline Flow
`AXIS Register Slice` ➔ `AXIS Elastic FIFO` ➔ `AXIS Rate Limiter` ➔ `AXIS Traffic Monitor`

<img width="1400" height="720" alt="Pipeline Flow" src="https://github.com/user-attachments/assets/260b02e7-0e1b-4df5-9d37-9fc712a4124e" />

---

## Microarchitecture Specifications

### 1. Input Stage: AXIS Register Slice
Acts as the physical isolation layer at the input boundary, cutting high-fanout combinational paths from external pins.
* **Latency:** Introduces a predictable, single clock-cycle forward delay.
* **Skid Buffer Logic:** Contains a primary register bank and a secondary backup (`skid_reg`). If the downstream FIFO pulls its ready line low, the slice captures any in-flight data inside the `skid_reg` and immediately drops the external `s_axis_tready`, safely freezing the external sender.

### 2. Elastic Memory Buffer: AXIS FIFO
Absorbs traffic bursts when the output side undergoes rate regulation or complete blockage.
* **Structure:** A 512-word deep internal RAM grid with a 37-bit payload width (32-bit TDATA + 4-bit TKEEP + 1-bit TLAST).
* **Occupancy Math:** Live data volume is calculated continuously (`wr_ptr - rd_ptr`).
* **Hardware Watermark:** A hardware comparator checks live occupancy. If the internal depth hits >= 410 words, a dedicated `fifo_watermark_80` signal alerts the state machine to prevent imminent overflow.

### 3. Bandwidth Regulator: AXIS Rate Limiter
The active system throttle valve enforcing strict throughput caps based on FSM commands.
* **Pacing Generator:** Instead of destructively dropping packets, it injects wait-states. For example, under a 25% throughput cap, the logic holds the ready line high for 1 clock cycle and forces it low for the next 3 cycles, causing excess data to gather safely upstream.

### 4. Traffic Monitor: AXIS Statistics Counter
A zero-overhead exit flow meter sitting passively on the master boundary.
* **Windowed Calculation:** Snoops on successful transfers (`tvalid && tready`). Accumulates the exact number of passing bytes over a fixed observation window (e.g., 1,000 clock periods).
* **Reporting:** Upon window expiration, it pulses a `status_valid` signal, exposes the byte sum to the FSM, and resets.

---

## Centralized Rate Control FSM

The FSM links monitoring metrics to active pacing gates, utilizing three primary states:

1. **`STATE_IDLE` (Unthrottled):** Default mode. Operates at full capacity. If traffic exceeds `cfg_high_threshold_bytes` OR the FIFO watermark triggers, it transitions to THROTTLE.
2. **`STATE_THROTTLE` (Active Restriction):** Restricts output capacity (e.g., 25% speed ceiling). Transitions to RECOVERY only when the windowed byte count drops below `cfg_low_threshold_bytes` AND the FIFO watermark is cleared.
3. **`STATE_RECOVERY` (Safe Transition):** Sets an intermediate capacity cap (50%) and starts a 5,000-clock-cycle countdown. A fresh traffic spike cancels recovery and forces a return to THROTTLE. It returns to IDLE only if the timer completes successfully.

### Emergency Watermark Overdrive
Relying solely on the windowed byte count can be too slow during a sudden downstream blockage. To prevent critical memory overflow, the `fifo_watermark_80` signal provides an immediate override. The moment occupancy hits 410 words, the FSM is forced into `STATE_THROTTLE` on the very next clock cycle, guaranteeing instant upstream backpressure.

---

## Interface Signals (AXI-Stream Compliant)

| Signal | Direction | Description |
|--------|-----------|-------------|
| `s_axis_tdata` / `m_axis_tdata` | In / Out | Data payload |
| `s_axis_tkeep` / `m_axis_tkeep` | In / Out | Byte enable qualifiers |
| `s_axis_tvalid` / `m_axis_tvalid`| In / Out | Valid signal |
| `s_axis_tready` / `m_axis_tready`| In / Out | Ready handshake |
| `s_axis_tlast` / `m_axis_tlast` | In / Out | End of packet boundary |

---

## Simulation & Verification

<img width="1337" height="565" alt="Simulation Waveform 1" src="https://github.com/user-attachments/assets/9bc44b45-232c-4023-ae5a-5bc1f25b8d4c" />
<img width="1339" height="538" alt="Simulation Waveform 2" src="https://github.com/user-attachments/assets/e11fc421-47fd-41f8-a63d-9ab21748bb79" />

Waveform analysis confirms the closed-loop traffic control operates as intended:
* **State Transitions Observed:** `IDLE` → `THROTTLE` → `RECOVERY` → `IDLE`
* **Configuration:** High Threshold at `0x28` bytes, Low Threshold at `0x0C` bytes.
* The output stream is successfully throttled upon exceeding the limit and recovers autonomously when traffic normalizes, verifying both FSM transitions and FIFO buffer stability.
* 
