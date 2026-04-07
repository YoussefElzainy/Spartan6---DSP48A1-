# DSP48A1 FPGA Design & Testbench

This project contains a complete **Verilog implementation** of the DSP48A1 slice for Xilinx FPGAs (Spartan-6 / Artix-7), along with testbenches, simulation scripts, constraint files, and reports. The DSP48A1 slice is a configurable **multiply-accumulate (MAC) unit** optimized for math-intensive digital signal processing (DSP) applications.  

---

## Table of Contents
1. [Project Overview](#project-overview)
2. [DSP48A1 Features](#dsp48a1-features)
3. [Parameters & Attributes](#parameters--attributes)
4. [Data & Control Ports](#data--control-ports)
5. [Cascade Ports](#cascade-ports)
6. [Testbench Overview](#testbench-overview)
7. [Simulation & Verification](#simulation--verification)
8. [Synthesis & Implementation](#synthesis--implementation)
9. [Constraint Files](#constraint-files)
10. [Deliverables](#deliverables)
    
---

## Project Overview
The DSP48A1 is a dedicated hardware slice used for high-speed arithmetic operations such as multiplication, addition, subtraction, and accumulation. This project implements the DSP48A1 slice with configurable **pipeline stages** for inputs, multiplier, and output, supporting **both synchronous and asynchronous resets**.  

The design also allows **cascading multiple DSP48A1 slices** for larger MAC operations. Testbenches are provided for **self-checking verification** of all arithmetic paths. The project supports simulation in **QuestaSim** and implementation in **Vivado**.  

---

## DSP48A1 Features
- **Configurable pipeline stages:** Inputs A, B, C, D, multiplier (M), and output (P).  
- **Control of arithmetic operations** via OPMODE input.  
- **Synchronous or asynchronous resets** for all registers.  
- **Cascade support** for connecting multiple DSP slices (BCIN/BCOUT, PCIN/PCOUT).  
- **Flexible B input:** Direct input or cascaded input from previous DSP48A1.  
- **Testbench with multiple DSP paths** and self-checking expected outputs.  

---

## Parameters & Attributes

| Parameter        | Description                                                                                  | Default |
|-----------------|----------------------------------------------------------------------------------------------|---------|
| A0REG, A1REG    | Number of pipeline registers on A input path                                                 | 0,1     |
| B0REG, B1REG    | Number of pipeline registers on B input path                                                 | 0,1     |
| CREG, DREG      | Pipeline stages for C and D inputs                                                           | 1       |
| MREG, PREG      | Pipeline stages for multiplier (M) and output (P)                                            | 1       |
| CARRYINREG      | Pipeline register for carry-in                                                               | 1       |
| CARRYOUTREG     | Pipeline register for carry-out                                                              | 1       |
| OPMODEREG       | Register for OPMODE control                                                                  | 1       |
| CARRYINSEL      | Carry-in selection: either `"CARRYIN"` or `"OPMODE5"`                                         | "OPMODE5" |
| B_INPUT         | Select B port input: `"DIRECT"` or `"CASCADE"`                                               | "DIRECT" |
| RSTTYPE         | Reset type: `"SYNC"` or `"ASYNC"`                                                           | "SYNC"  |

---

## Data & Control Ports

**Data Ports:**

| Signal | Width | Function |
|--------|-------|----------|
| A      | 18    | Input to multiplier or post-adder/subtracter |
| B      | 18    | Input to pre-adder/subtracter or multiplier |
| C      | 48    | Input to post-adder/subtracter |
| D      | 18    | Input to pre-adder/subtracter |
| M      | 36    | Multiplier output, registered or direct |
| P      | 48    | Primary output, registered or direct |
| CARRYIN | 1    | Carry input for post-adder/subtracter |
| CARRYOUT | 1   | Carry output for cascaded DSP48A1 slices |
| CARRYOUTF | 1  | Carry output for FPGA logic |

**Control Ports:**

| Signal | Function |
|--------|---------|
| CLK    | DSP clock |
| OPMODE | Selects arithmetic operations |
| CEA..CEP | Clock enables for registers (A, B, C, D, M, P, carry, OPMODE) |
| RSTA..RSTP | Active-high reset for registers (sync/async depending on RSTTYPE) |

---

## Cascade Ports

| Signal | Function |
|--------|---------|
| BCOUT  | Cascade output for B port |
| PCIN   | Cascade input for P port |
| PCOUT  | Cascade output for P port |

---

## Testbench Overview
The testbench verifies DSP48A1 functionality using four main DSP paths:

1. **Path 1:** Pre-subtractor → post-subtractor → multiplier → P output  
2. **Path 2:** Pre-adder → post-adder → P output  
3. **Path 3:** Post-addition only (no pre-adder/subtractor)  
4. **Path 4:** Post-subtractor with D:A:B concatenation  

The testbench applies directed inputs, waits for pipeline propagation, and performs **self-checking** against expected outputs.

---

## Simulation & Verification
- Simulation is done in **QuestaSim** using `.do` files.  
- Verification includes:
  - Reset operation check  
  - Multiple DSP paths verification  
  - Output comparison with expected values  
- Waveform snapshots are captured for all scenarios.

---

## Synthesis & Implementation
- **Vivado** is used for elaboration, synthesis, and implementation.  
- Timing analysis and utilization reports are generated.  
- Constraint file sets a **100 MHz clock** on pin W5.  
- FPGA part used: **xc7a200tffg1156-3** (Artix-7, large I/O support).

---

## Constraint Files
- Timing constraint only (clock definition).  
- Clock frequency: 100 MHz.  
- Pin assignment: W5 for clock input.

---

## Deliverables
1. RTL Verilog code  
2. Testbench code with stimulus generation  
3. QuestaSim `.do` scripts  
4. Simulation waveforms with expected outputs  
5. Vivado constraint file  
6. Schematic snapshots after elaboration and synthesis  
7. Utilization & timing reports  
8. Linting reports showing no errors  
