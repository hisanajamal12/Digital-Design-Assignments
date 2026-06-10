# Day 3 - FIFO with FSM (Vivado)

## 📌 Description
This project implements a FIFO (First In First Out) memory along with an FSM that processes data every 3rd clock cycle.

## 📂 Files

### Design Files
- fifo.v
- mod_out.v
- top_module.v

### Testbench
- top_tb.v

## ⚙️ Functionality
- FIFO stores 8-bit data
- Data is read sequentially
- FSM processes every 3rd input
- Output updates at intervals (not every clock)

## 🛠 Tool Used
- Xilinx Vivado

## 📊 Simulation
Waveform shows correct behavior where output updates periodically.
<img width="1304" height="817" alt="Day3 topmod_task2" src="https://github.com/user-attachments/assets/ce228af7-ed56-467f-908e-bbadb2075dd3" />
