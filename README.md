# Verilog Learning – Step-by-Step Guide

Self-study resource for learning Verilog HDL from the ground up.

---

## Table of Contents

1. [Verilog Concepts](#verilog-concepts)
2. [Experiments – Ordered by Difficulty](#experiments--ordered-by-difficulty)
3. [Directory Structure](#directory-structure)

---

## Verilog Concepts

### 1. Basics
- What is Verilog? HDL vs. programming languages
- Module declaration and instantiation
- Port types: `input`, `output`, `inout`
- Data types: `wire`, `reg`, `integer`, `real`, `time`
- Scalar vs. vector signals (bit-width specification)
- Constants and parameters (`parameter`, `localparam`)
- Comments (`//` and `/* */`)

### 2. Operators
- Arithmetic operators: `+`, `-`, `*`, `/`, `%`
- Relational operators: `==`, `!=`, `<`, `>`, `<=`, `>=`
- Logical operators: `&&`, `||`, `!`
- Bitwise operators: `&`, `|`, `^`, `~`, `~^`
- Reduction operators: `&`, `|`, `^` (unary)
- Shift operators: `<<`, `>>`, `<<<`, `>>>`
- Concatenation `{}` and replication `{n{}}` operators
- Conditional (ternary) operator: `? :`

### 3. Gate-Level Modeling
- Built-in primitive gates: `and`, `or`, `not`, `nand`, `nor`, `xor`, `xnor`
- `buf` and `bufif0`/`bufif1` (tri-state buffers)
- Gate delays (rise, fall, turn-off)

### 4. Dataflow Modeling
- Continuous assignment: `assign`
- Expressions and net-level logic

### 5. Behavioral Modeling
- `always` block with sensitivity list
- Combinational logic: `always @(*)`
- Sequential logic: `always @(posedge clk)` / `always @(negedge clk)`
- Procedural statements: `if-else`, `case`, `casex`, `casez`
- Looping constructs: `for`, `while`, `repeat`, `forever`
- Blocking (`=`) vs. non-blocking (`<=`) assignments

### 6. Structural Modeling
- Hierarchical design using module instantiation
- Named vs. positional port mapping

### 7. Testbenches & Simulation
- `initial` block and `$finish`
- System tasks: `$display`, `$monitor`, `$strobe`, `$dumpfile`, `$dumpvars`
- Time control: `#delay`, `@(event)`, `wait`
- Writing self-checking testbenches

### 8. Sequential Logic Concepts
- D flip-flop, T flip-flop, JK flip-flop, SR flip-flop
- Synchronous vs. asynchronous reset
- Registers and shift registers
- Counters (up, down, up-down)

### 9. Memory & Storage
- ROM modeling
- RAM modeling (single-port, dual-port)
- FIFOs (first-in first-out buffers)

### 10. Advanced Concepts
- Tasks and Functions
- Generate statements (`generate`, `genvar`)
- `defparam` and parameter overriding
- Tri-state logic and buses
- Timing: setup time, hold time, propagation delay
- Finite State Machines (FSM): Moore and Mealy
- Pipelining
- Clock domain crossing (CDC) basics
- Synthesis-friendly coding guidelines
- FPGA vs. ASIC design considerations

---

## New Structured Curriculum (160 Experiments)

The following curriculum provides a more granular, step-by-step progression from first
principles to system-on-chip components.  Each level builds on the previous one.

### Level 1 – Fundamentals (Basic Gates & Simple Combinational Logic)

| # | Experiment | Folder | Concepts Practiced |
|---|------------|--------|--------------------|
| 01 | [Basic Gates Module](experiments/level1/exp01_basic_gates_module/) | `exp01_basic_gates_module` | `and`, `or`, `not`, `nand`, `nor`, `xor`, `xnor` primitives |
| 02 | [2-Input AND Gate (Behavioral)](experiments/level1/exp02_and_gate_behavioral/) | `exp02_and_gate_behavioral` | `assign` statement, `&` boolean operator |
| 03 | [2-Input OR Gate (Behavioral)](experiments/level1/exp03_or_gate_behavioral/) | `exp03_or_gate_behavioral` | Continuous assignment, `|` operator |
| 04 | [NOT / Inverter Gate](experiments/level1/exp04_not_gate/) | `exp04_not_gate` | Unary `~` operator |
| 05 | [Universal Gates (NAND/NOR as NOT, AND, OR)](experiments/level1/exp05_universal_gates/) | `exp05_universal_gates` | De Morgan's theorem implementation |
| 06 | [2-Input XOR Gate](experiments/level1/exp06_xor_gate/) | `exp06_xor_gate` | `^` operator, inequality detection |
| 07 | [Half Adder](experiments/level1/exp07_half_adder/) | `exp07_half_adder` | XOR for sum, AND for carry, multi-output |
| 08 | [Full Adder (Gate-Level)](experiments/level1/exp08_full_adder_gate_level/) | `exp08_full_adder_gate_level` | Structural modeling, hierarchical design |
| 09 | [Full Adder (Dataflow)](experiments/level1/exp09_full_adder_dataflow/) | `exp09_full_adder_dataflow` | Boolean equation implementation |
| 10 | [Full Adder (Behavioral)](experiments/level1/exp10_full_adder_behavioral/) | `exp10_full_adder_behavioral` | `always @(*)` combinational blocks |

> **Levels 2–12** (experiments 11–160) will be added in subsequent PRs.

---

## Original Experiments – Ordered by Difficulty

### Level 1 – Beginner (Gate-Level & Basic Combinational Logic)

| # | Experiment | Concepts Practiced |
|---|------------|--------------------|
| 01 | [Half Adder](experiments/01_half_adder/) | `xor`, `and` gates, `assign` |
| 02 | [Full Adder](experiments/02_full_adder/) | Cascading half adders, gate-level modeling |
| 03 | [Half Subtractor](experiments/03_half_subtractor/) | `xor`, `and`, `not` gates |
| 04 | [Full Subtractor](experiments/04_full_subtractor/) | Cascading half subtractors |
| 05 | [2-to-1 Multiplexer (MUX)](experiments/05_mux_2to1/) | Conditional `assign`, `case` |
| 06 | [4-to-1 Multiplexer](experiments/06_mux_4to1/) | `case` statement, port mapping |
| 07 | [1-to-2 Demultiplexer (DEMUX)](experiments/07_demux_1to2/) | `case` statement |
| 08 | [2-to-4 Decoder](experiments/08_decoder_2to4/) | `case`, one-hot encoding |
| 09 | [4-to-2 Encoder](experiments/09_encoder_4to2/) | Priority logic |
| 10 | [8-to-3 Priority Encoder](experiments/10_priority_encoder_8to3/) | `casez`, priority |

### Level 2 – Elementary (Arithmetic & Multi-bit Circuits)

| # | Experiment | Concepts Practiced |
|---|------------|--------------------|
| 11 | [4-Bit Ripple Carry Adder](experiments/11_ripple_carry_adder_4bit/) | Structural instantiation, carry chain |
| 12 | [4-Bit Carry Look-Ahead Adder (CLA)](experiments/12_cla_adder_4bit/) | Generate/propagate logic |
| 13 | [4-Bit Binary Subtractor](experiments/13_subtractor_4bit/) | 2's complement, borrow logic |
| 14 | [4-Bit Adder-Subtractor](experiments/14_adder_subtractor_4bit/) | XOR-based inversion, `mode` select |
| 15 | [8-to-1 Multiplexer](experiments/15_mux_8to1/) | Nested `case`, wider buses |
| 16 | [4-to-16 Decoder](experiments/16_decoder_4to16/) | `generate` loop |
| 17 | [Comparator (1-bit & 4-bit)](experiments/17_comparator_4bit/) | Equality, greater/less logic |
| 18 | [4-Bit Binary to Gray Code Converter](experiments/18_binary_to_gray/) | XOR reduction |
| 19 | [4-Bit Gray to Binary Converter](experiments/19_gray_to_binary/) | Cascaded XOR logic |
| 20 | [BCD to 7-Segment Display Decoder](experiments/20_bcd_to_7seg/) | `case`, display encoding |

### Level 3 – Intermediate (Sequential Circuits)

| # | Experiment | Concepts Practiced |
|---|------------|--------------------|
| 21 | [D Flip-Flop (sync & async reset)](experiments/21_dff/) | `always @(posedge clk)`, `reset` |
| 22 | [T Flip-Flop](experiments/22_tff/) | Toggle behavior |
| 23 | [JK Flip-Flop](experiments/23_jkff/) | All flip-flop states |
| 24 | [SR Flip-Flop](experiments/24_srff/) | Set-Reset logic |
| 25 | [4-Bit Register](experiments/25_register_4bit/) | Parallel load |
| 26 | [4-Bit SISO Shift Register](experiments/26_siso_shift_register/) | Serial in/out |
| 27 | [4-Bit SIPO Shift Register](experiments/27_sipo_shift_register/) | Serial-to-parallel conversion |
| 28 | [4-Bit PISO Shift Register](experiments/28_piso_shift_register/) | Parallel-to-serial conversion |
| 29 | [4-Bit PIPO Shift Register](experiments/29_pipo_shift_register/) | Parallel load and output |
| 30 | [Universal Shift Register](experiments/30_universal_shift_register/) | Mode-controlled shifting |

### Level 4 – Intermediate-Advanced (Counters & State Machines)

| # | Experiment | Concepts Practiced |
|---|------------|--------------------|
| 31 | [4-Bit Ripple (Asynchronous) Counter](experiments/31_ripple_counter_4bit/) | Cascaded flip-flops |
| 32 | [4-Bit Synchronous Up Counter](experiments/32_sync_up_counter_4bit/) | Synchronous design |
| 33 | [4-Bit Synchronous Down Counter](experiments/33_sync_down_counter_4bit/) | Count direction |
| 34 | [4-Bit Up-Down Counter](experiments/34_up_down_counter_4bit/) | Mode select |
| 35 | [Mod-N Counter](experiments/35_mod_n_counter/) | `parameter`, `generate` |
| 36 | [BCD Counter (Mod-10)](experiments/36_bcd_counter/) | Decade counting |
| 37 | [Ring Counter](experiments/37_ring_counter/) | One-hot shift |
| 38 | [Johnson Counter](experiments/38_johnson_counter/) | Twisted ring |
| 39 | [Moore FSM – Sequence Detector (101)](experiments/39_moore_fsm_seq_detector/) | FSM encoding, state transitions |
| 40 | [Mealy FSM – Sequence Detector (1011)](experiments/40_mealy_fsm_seq_detector/) | Output depends on input+state |

### Level 5 – Advanced (Arithmetic & Memory Modules)

| # | Experiment | Concepts Practiced |
|---|------------|--------------------|
| 41 | [4-Bit Multiplier (Combinational)](experiments/41_multiplier_4bit/) | Partial products, `generate` |
| 42 | [8-Bit Multiplier (Booth's Algorithm)](experiments/42_booth_multiplier_8bit/) | Signed multiplication algorithm |
| 43 | [16-Bit Barrel Shifter](experiments/43_barrel_shifter_16bit/) | Shift-by-n in one cycle |
| 44 | [32-Bit ALU](experiments/44_alu_32bit/) | Full arithmetic-logic unit |
| 45 | [Single-Port Synchronous RAM](experiments/45_single_port_ram/) | Memory arrays, read/write |
| 46 | [Dual-Port RAM](experiments/46_dual_port_ram/) | Simultaneous access |
| 47 | [ROM (Look-Up Table)](experiments/47_rom/) | `initial` memory initialization |
| 48 | [Synchronous FIFO](experiments/48_sync_fifo/) | Read/write pointers, full/empty flags |
| 49 | [Asynchronous FIFO](experiments/49_async_fifo/) | Gray code pointers, CDC |
| 50 | [LFSR (Linear Feedback Shift Register)](experiments/50_lfsr/) | Pseudo-random sequence generation |

### Level 6 – Expert (Communication & Interface Protocols)

| # | Experiment | Concepts Practiced |
|---|------------|--------------------|
| 51 | [UART Transmitter](experiments/51_uart_tx/) | Serial protocol, baud rate |
| 52 | [UART Receiver](experiments/52_uart_rx/) | Start/stop bit detection |
| 53 | [SPI Master](experiments/53_spi_master/) | CPOL/CPHA, shift register |
| 54 | [I2C Master (simplified)](experiments/54_i2c_master/) | Open-drain bus, ACK/NACK |
| 55 | [PWM Generator](experiments/55_pwm_generator/) | Duty cycle, counter-based |
| 56 | [VGA Controller (640×480)](experiments/56_vga_controller/) | Horizontal/vertical sync timing |
| 57 | [PS/2 Keyboard Interface](experiments/57_ps2_keyboard/) | Serial scan-code decoding |
| 58 | [Debounce Circuit](experiments/58_debounce/) | Filtering mechanical noise |
| 59 | [Clock Divider](experiments/59_clock_divider/) | Integer and fractional division |
| 60 | [Pipelined 8-bit Multiplier](experiments/60_pipelined_multiplier/) | Multi-stage pipeline registers |

---

## Directory Structure

```
Verilog_learning/
├── README.md                          ← This file (concepts + experiments list)
└── experiments/
    ├── 01_half_adder/
    │   ├── half_adder.v               ← RTL implementation
    │   └── half_adder_tb.v            ← Testbench
    ├── 02_full_adder/
    │   ├── full_adder.v
    │   └── full_adder_tb.v
    ├── ...
    └── 60_pipelined_multiplier/
        ├── pipelined_multiplier.v
        └── pipelined_multiplier_tb.v
```

Each experiment folder contains:
- **`<module>.v`** – synthesizable RTL design
- **`<module>_tb.v`** – self-checking simulation testbench

---

## How to Simulate

Using [Icarus Verilog](http://iverilog.icarus.com/) (free, open-source):

```bash
# Compile
iverilog -o sim experiments/02_full_adder/full_adder.v \
                  experiments/02_full_adder/full_adder_tb.v

# Run simulation
vvp sim

# View waveforms (requires GTKWave)
gtkwave dump.vcd
```

---

## Resources

- [Verilog IEEE Standard (1364-2005)](https://ieeexplore.ieee.org/document/1620780)
- [ASIC World Verilog Tutorial](https://www.asic-world.com/verilog/veritut.html)
- [HDLBits – Online Verilog Practice](https://hdlbits.01xz.net/wiki/Main_Page)
- [Icarus Verilog Simulator](http://iverilog.icarus.com/)
- [GTKWave Waveform Viewer](http://gtkwave.sourceforge.net/)
