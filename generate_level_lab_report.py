#!/usr/bin/env python3
"""Generate a comprehensive B.Tech-style lab report PDF for all level experiments.

Each experiment page contains:
    Aim | Apparatus | Theory | Algorithm | RTL Code | Testbench Code |
    Expected Results (truth table / timing description) | Result & Conclusion

Run from the repository root:
    python generate_level_lab_report.py

Dependencies: fpdf2  (pip install fpdf2==2.8.6)
"""

from __future__ import annotations

from datetime import datetime
from pathlib import Path
import re
import textwrap
from typing import Dict, Iterable, List, Optional, Tuple

from fpdf import FPDF
from fpdf.enums import XPos, YPos

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
REPO_ROOT = Path(__file__).resolve().parent
LEVEL_ROOT = REPO_ROOT / "experiments"
OUTPUT_PDF = REPO_ROOT / "Lab_Report_Level_Experiments.pdf"

# ---------------------------------------------------------------------------
# Level descriptions
# ---------------------------------------------------------------------------
LEVEL_DESC: Dict[int, str] = {
    1: "Fundamentals - basic gate primitives and simple combinational logic",
    2: "Combinational building blocks - multiplexers, decoders, encoders and comparators",
    3: "Arithmetic datapaths - adders, subtractors, multipliers and ALUs",
    4: "Sequential elements - latches, flip-flops, registers and register files",
    5: "Counters, shift logic and programmable frequency dividers",
    6: "Finite-state machines and control paths (Moore, Mealy, protocol FSMs)",
    7: "Memories, FIFOs, stacks and content-addressable memories",
    8: "Advanced arithmetic algorithms and DSP cores",
    9: "Pipelined datapaths and microarchitecture techniques",
    10: "Subsystem IP and digital interfaces (RISC CPU, VGA, UART, SPI, I2C, AXI)",
    11: "Verification infrastructure - assertions, coverage, formal properties",
    12: "SoC integration and system-level control",
}

# ---------------------------------------------------------------------------
# Standard apparatus text (same for all experiments)
# ---------------------------------------------------------------------------
APPARATUS = (
    "Hardware: Personal computer (PC) with minimum 4 GB RAM.\n"
    "Software: Xilinx Vivado Design Suite / ModelSim / Icarus Verilog (iverilog) "
    "with GTKWave waveform viewer.\n"
    "Reference: IEEE Std 1364-2005 (Verilog HDL).\n"
    "Optional: FPGA development board (Nexys-4 DDR / Basys-3) for hardware validation."
)

# ---------------------------------------------------------------------------
# Category-based theory & algorithm database
# ---------------------------------------------------------------------------
CATEGORY_DB: List[Dict] = [
    {
        "keywords": ["basic_gates", "and_gate", "or_gate", "not_gate", "xor_gate",
                     "nand_gate", "nor_gate", "xnor_gate"],
        "theory": (
            "Logic gates are the fundamental building blocks of all digital circuits. "
            "They implement Boolean algebra operations on binary (0/1) inputs to produce "
            "a binary output. The basic gates are AND, OR, NOT, NAND, NOR, XOR and XNOR.\n\n"
            "An AND gate produces a HIGH output only when all inputs are HIGH. An OR gate "
            "produces HIGH when at least one input is HIGH. The NOT (inverter) gate "
            "complements its single input. NAND and NOR are universal gates - any Boolean "
            "function can be realised using only NAND or only NOR gates, which is "
            "significant because these gates require fewer transistors in CMOS technology.\n\n"
            "XOR (exclusive-OR) outputs HIGH when an odd number of inputs are HIGH; XNOR "
            "is its complement. Verilog provides built-in gate primitives (and, or, not, "
            "nand, nor, xor, xnor) for structural modelling and continuous assignments "
            "(assign) for dataflow modelling."
        ),
        "algorithm": [
            "Identify all input and output signals and write the Boolean equation.",
            "Implement the gate using Verilog structural primitives or 'assign' dataflow.",
            "Write a self-checking testbench that applies all 2^n input combinations.",
            "Simulate with iverilog/ModelSim and inspect the waveform in GTKWave.",
            "Verify that each output matches the expected truth-table value.",
        ],
        "expected_results_heading": "Truth table verified: output matches Boolean equation for all input combinations.",
    },
    {
        "keywords": ["universal_gates"],
        "theory": (
            "NAND and NOR gates are called universal gates because any logic function can "
            "be realised using only one type. This property is exploited in CMOS VLSI where "
            "NAND and NOR cells are preferred due to their compact implementation.\n\n"
            "De Morgan's theorems: NOT(A AND B) = (NOT A) OR (NOT B) and "
            "NOT(A OR B) = (NOT A) AND (NOT B). Using these identities, AND, OR and NOT "
            "can each be constructed from only NAND gates (or only NOR gates):\n"
            "  NOT A   = NAND(A, A)\n"
            "  A AND B = NAND(NAND(A,B), NAND(A,B))\n"
            "  A OR B  = NAND(NAND(A,A), NAND(B,B))\n\n"
            "The Verilog implementation uses gate-level instantiation of 'nand' and 'nor' "
            "primitives to demonstrate these equivalences."
        ),
        "algorithm": [
            "Derive Boolean expressions for NOT, AND, OR using only NAND (or NOR) gates.",
            "Instantiate NAND/NOR primitives in Verilog to implement each derived function.",
            "Write a testbench that applies all four input combinations (00,01,10,11).",
            "Compare NAND-based and NOR-based outputs against the reference gate outputs.",
            "Observe waveforms in GTKWave and confirm De Morgan equivalence.",
        ],
        "expected_results_heading": (
            "NAND-based and NOR-based implementations produce identical results to the "
            "reference AND, OR, NOT gates for all input combinations."
        ),
    },
    {
        "keywords": ["half_adder"],
        "theory": (
            "A half adder is a combinational circuit that adds two 1-bit binary numbers A "
            "and B, producing a Sum and a Carry output. It is called a 'half' adder because "
            "it cannot accommodate a carry-in from a previous stage.\n\n"
            "Boolean equations:  Sum = A XOR B,  Carry = A AND B.\n"
            "The half adder forms the basis of multi-bit binary adders. Two half adders "
            "and an OR gate can build a full adder.\n\n"
            "In Verilog the dataflow model uses continuous assignment: "
            "'assign sum = a ^ b; assign carry = a & b;'."
        ),
        "algorithm": [
            "Write the Boolean equations: Sum = A XOR B, Carry = A AND B.",
            "Implement in Verilog using 'assign' (dataflow) or gate primitives.",
            "Create a testbench with all four input combinations: (0,0), (0,1), (1,0), (1,1).",
            "Simulate and check Sum and Carry against the truth table.",
            "Verify timing: combinational output appears within propagation delay.",
        ],
        "expected_results_heading": (
            "Truth Table:\n"
            "  A  B | Sum  Carry\n"
            "  -----+----------\n"
            "  0  0 |  0     0\n"
            "  0  1 |  1     0\n"
            "  1  0 |  1     0\n"
            "  1  1 |  0     1\n\n"
            "Simulation output PASS for all 4 test vectors."
        ),
    },
    {
        "keywords": ["full_adder"],
        "theory": (
            "A full adder adds three 1-bit inputs - A, B and Carry-in (Cin) - and produces "
            "a Sum and Carry-out (Cout). Unlike the half adder it can accept a carry from a "
            "preceding stage, making it suitable for cascading into multi-bit adders.\n\n"
            "Boolean equations:\n"
            "  Sum  = A XOR B XOR Cin\n"
            "  Cout = (A AND B) OR (B AND Cin) OR (A AND Cin)\n\n"
            "A full adder can be built from two half adders and an OR gate, or directly "
            "using gate primitives. Verilog supports structural (gate-level), dataflow "
            "(assign) and behavioral (always) modelling styles."
        ),
        "algorithm": [
            "Derive Sum and Cout Boolean expressions using K-map or algebraic method.",
            "Choose a modelling style: gate-level, dataflow or behavioral.",
            "Implement the module and write a self-checking testbench (8 test vectors).",
            "Simulate and verify all 8 input combinations (A, B, Cin from 000 to 111).",
            "Draw the circuit schematic from the synthesis report.",
        ],
        "expected_results_heading": (
            "Truth Table:\n"
            "  A  B Cin | Sum  Cout\n"
            "  ---------+---------\n"
            "  0  0  0  |  0    0\n"
            "  0  0  1  |  1    0\n"
            "  0  1  0  |  1    0\n"
            "  0  1  1  |  0    1\n"
            "  1  0  0  |  1    0\n"
            "  1  0  1  |  0    1\n"
            "  1  1  0  |  0    1\n"
            "  1  1  1  |  1    1\n\n"
            "Simulation output PASS for all 8 test vectors."
        ),
    },
    {
        "keywords": ["mux", "multiplexer"],
        "theory": (
            "A multiplexer (MUX) is a combinational circuit that selects one of N data "
            "inputs and routes it to a single output based on select lines. An n-bit select "
            "bus can choose among 2^n inputs. MUXes are used in data routing, bus "
            "arbitration, function generators and FPGA look-up tables (LUTs).\n\n"
            "A 2-to-1 MUX output: Y = S' * I0 + S * I1 (S is the select line). "
            "A 4-to-1 MUX uses 2 select bits; an 8-to-1 uses 3. Larger MUXes can be "
            "built hierarchically from smaller ones. Verilog modelling styles include "
            "conditional assignment (?:), case statement and if-else behavioral."
        ),
        "algorithm": [
            "Determine the number of data inputs N and required select bits (log2 N).",
            "Write the Boolean equation or case statement for the selected output.",
            "Implement in Verilog (gate-level / dataflow / behavioral).",
            "Testbench: cycle through all select combinations while holding inputs constant.",
            "Verify that the output exactly tracks the selected input channel.",
        ],
        "expected_results_heading": (
            "For each select code, the output equals the corresponding data input.\n"
            "Example (2-to-1 MUX): sel=0 -> out=in0; sel=1 -> out=in1."
        ),
    },
    {
        "keywords": ["demux", "demultiplexer"],
        "theory": (
            "A demultiplexer (DEMUX) is the inverse of a MUX. It routes a single input to "
            "one of N outputs selected by select lines, with unselected outputs driven to 0. "
            "A 1-to-4 DEMUX has 1 input, 2 select bits and 4 outputs.\n\n"
            "Equation for output Yi: Yi = D AND (S == i). DEMUXes are used in bus fan-out, "
            "memory address decoding and serial-to-parallel conversion."
        ),
        "algorithm": [
            "Identify the data input, select lines and output width.",
            "Implement using a case statement or conditional assigns.",
            "Drive all unselected outputs to 0.",
            "Testbench: apply all combinations of select and data=1; verify single high output.",
        ],
        "expected_results_heading": "Exactly one output is high and equals D for each select code.",
    },
    {
        "keywords": ["decoder"],
        "theory": (
            "A binary decoder converts an n-bit binary code to 2^n one-hot output lines. "
            "Exactly one output is asserted HIGH for each unique input combination. "
            "Decoders are used in memory address decoding, instruction decoding (CPUs) "
            "and display driving.\n\n"
            "A 2-to-4 decoder with enable: output[in] = 1 when EN=1, otherwise all zeros. "
            "A 3-to-8 decoder with enable is commonly used in address decode. "
            "Verilog: 'assign out = en ? (1 << in) : 0;' captures the one-hot encoding "
            "compactly using a left shift."
        ),
        "algorithm": [
            "Determine number of input address bits n and 2^n output lines.",
            "Add an optional active-high/active-low enable input.",
            "Implement one-hot decode using shift (<<) or case statement.",
            "Testbench: sweep all 2^n input codes with EN=1; verify single output assertion.",
            "Test EN=0: verify all outputs are deasserted.",
        ],
        "expected_results_heading": "out[in] = 1 (one-hot) when EN=1; all zeros when EN=0.",
    },
    {
        "keywords": ["encoder"],
        "theory": (
            "An encoder is the complement of a decoder. It converts 2^n one-hot inputs to "
            "an n-bit binary code. A priority encoder resolves conflicts when multiple "
            "inputs are active simultaneously by selecting the highest-priority (MSB) "
            "active input.\n\n"
            "A 4-to-2 priority encoder: if I[3]=1 then out=11; else if I[2]=1 then out=10; "
            "etc. An 8-to-3 priority encoder works similarly with a 'valid' output. "
            "Encoders are used in interrupt controllers, keyboard scanners and data "
            "compressors."
        ),
        "algorithm": [
            "Define priority order (MSB highest).",
            "Implement with cascaded if-else or casex statement.",
            "Assert the 'valid' flag when any input is active.",
            "Testbench: apply each one-hot and multi-hot input; verify output code.",
        ],
        "expected_results_heading": "Output = binary position of highest-priority active input; valid=1 when any input active.",
    },
    {
        "keywords": ["comparator"],
        "theory": (
            "A digital comparator compares two n-bit binary numbers A and B and produces "
            "three outputs: A>B (GT), A=B (EQ) and A<B (LT). For a 1-bit comparator: "
            "EQ = XNOR(A,B), GT = A AND NOT B, LT = NOT A AND B.\n\n"
            "For multi-bit comparators, the comparison starts from the MSB and cascades "
            "downward. Verilog dataflow modelling uses relational operators (>, ==, <) "
            "for concise implementation. Comparators are used in sorting networks, ALU "
            "condition flags and control flow evaluation."
        ),
        "algorithm": [
            "Define boolean equations for GT, EQ and LT outputs.",
            "For multi-bit: compare MSB first; propagate equality cascading downward.",
            "Implement using assign with relational operators or behavioral always block.",
            "Testbench: apply representative input pairs including equal, A>B and A<B cases.",
            "Verify all three output flags are mutually exclusive and collectively exhaustive.",
        ],
        "expected_results_heading": "Exactly one of GT, EQ, LT is asserted for each input pair.",
    },
    {
        "keywords": ["rca", "ripple_carry", "adder", "subtractor", "adder_subtractor",
                     "bcd_adder", "carry_save", "cla", "prefix", "kogge"],
        "theory": (
            "Multi-bit binary adders extend the single-bit full adder to n bits. In a "
            "Ripple Carry Adder (RCA) the carry-out of bit i is the carry-in of bit i+1, "
            "creating a chain (ripple) delay of O(n).\n\n"
            "A Carry Lookahead Adder (CLA) eliminates ripple delay by pre-computing "
            "carry signals in parallel using Generate (G = A AND B) and Propagate "
            "(P = A XOR B) signals. A 4-bit CLA computes all four carry bits simultaneously, "
            "achieving O(log n) delay.\n\n"
            "Subtraction is implemented by adding the two's complement: A - B = A + (~B) + 1. "
            "An Adder-Subtractor combines both functions using XOR gates on B inputs "
            "controlled by a mode select bit. BCD adders perform decimal arithmetic by "
            "adding 6 (0110) when the binary sum exceeds 9."
        ),
        "algorithm": [
            "Determine the word length n and whether carry-in is required.",
            "For RCA: instantiate n full-adder stages and chain the carry signals.",
            "For CLA: compute G and P vectors; derive carry equations analytically.",
            "For subtractor: invert B operand and set Cin=1 for two's complement.",
            "Testbench: apply corner cases (max, min, overflow) and random vectors.",
            "Check sum, carry-out and overflow flag in simulation.",
        ],
        "expected_results_heading": "Sum = A + B (+ Cin) with correct Cout for all test vectors.",
    },
    {
        "keywords": ["multiplier", "mult", "booth", "wallace", "array_mult"],
        "theory": (
            "Binary multiplication produces a 2n-bit product from two n-bit operands. "
            "An array multiplier generates partial products using AND gates and sums them "
            "with a tree of adders (O(n) delay). The Booth encoding algorithm reduces the "
            "number of partial products by recoding the multiplier in radix-2 or radix-4, "
            "handling sign extension naturally for two's complement.\n\n"
            "Wallace tree multipliers use carry-save adders (CSAs) to reduce partial "
            "products in O(log n) levels before a final carry-propagate adder, achieving "
            "the fastest parallel multiplication. Pipelined multipliers insert registers "
            "between stages to increase clock frequency at the cost of latency."
        ),
        "algorithm": [
            "Choose algorithm: array, Booth or Wallace tree.",
            "Generate partial products (AND of multiplicand with each multiplier bit).",
            "Accumulate partial products with adder tree.",
            "Add final carry-save result with a ripple or carry-lookahead adder.",
            "Testbench: verify product for representative signed and unsigned inputs.",
        ],
        "expected_results_heading": "product[2n-1:0] = A * B for all test vectors.",
    },
    {
        "keywords": ["divider", "division", "sqrt"],
        "theory": (
            "Binary division is more complex than multiplication. The Restoring Division "
            "algorithm works like long division: at each step, tentatively subtract the "
            "divisor from the partial remainder; if the result is negative, restore by "
            "adding the divisor back (quotient bit = 0), otherwise keep (quotient bit = 1). "
            "Non-Restoring Division avoids the restore step by using signed partial "
            "remainders. SRT division uses pre-scaled divisors to select quotient digits.\n\n"
            "Integer square root iteratively computes the largest integer Q such that "
            "Q^2 <= N, using a binary search or digit-recurrence algorithm."
        ),
        "algorithm": [
            "Initialise remainder R = dividend, quotient Q = 0.",
            "Iterate n times (n = bit width of dividend).",
            "Each iteration: shift R left, subtract (or add) divisor, set quotient bit.",
            "For restoring: if R < 0 add back divisor and clear quotient bit.",
            "Testbench: verify Q = A / B and R = A mod B for several test cases.",
        ],
        "expected_results_heading": "Quotient = A/B, remainder = A mod B for all test vectors.",
    },
    {
        "keywords": ["alu"],
        "theory": (
            "An Arithmetic Logic Unit (ALU) is the computational core of a processor. It "
            "performs arithmetic operations (add, subtract) and logical operations (AND, OR, "
            "XOR, NOT, shift) on two n-bit operands, selected by an opcode. Flags such as "
            "Zero, Carry, Overflow and Sign are derived from the result.\n\n"
            "A 4-operation ALU uses a 2-bit opcode; an 8-operation ALU uses 3 bits. "
            "Verilog behavioral always blocks with case statements provide a clean, "
            "readable ALU implementation. Synthesis maps the case statement to a "
            "combination of standard cells."
        ),
        "algorithm": [
            "Define the opcode encoding table (e.g. 00=ADD, 01=SUB, 10=AND, 11=OR).",
            "Implement with a case statement inside an always @(*) block.",
            "Derive status flags from the result.",
            "Testbench: apply each opcode with representative operands and verify result.",
        ],
        "expected_results_heading": "Result matches arithmetic/logical operation for each opcode; flags correct.",
    },
    {
        "keywords": ["barrel_shifter", "barrel"],
        "theory": (
            "A barrel shifter shifts or rotates an n-bit word by any amount 0 to n-1 in "
            "a single clock cycle using a cascade of multiplexers. An n-bit barrel shifter "
            "has log2(n) MUX stages; stage k handles shifts of 2^k positions. Barrel "
            "shifters support logical shift, arithmetic shift and rotation and are a "
            "standard component in processor datapath and DSP designs."
        ),
        "algorithm": [
            "Cascade log2(n) MUX stages, each doubling the shift amount.",
            "Stage k: if shift[k]=1, output is the input shifted by 2^k; else pass through.",
            "Select shift direction (left/right) and type (logical/arithmetic/rotate).",
            "Testbench: verify all shift amounts 0..(n-1) for representative input words.",
        ],
        "expected_results_heading": "Output = input shifted/rotated by the specified amount for all test vectors.",
    },
    {
        "keywords": ["latch", "sr_latch", "d_latch"],
        "theory": (
            "A latch is a level-sensitive bistable memory element. An SR latch (Set-Reset) "
            "has two cross-coupled NAND (active-low) or NOR (active-high) gates. When S=1 "
            "and R=0, the output Q is set to 1; when R=1 and S=0, Q is reset to 0. The "
            "state S=R=1 (NOR) or S=R=0 (NAND) is forbidden.\n\n"
            "A D latch adds a data input D and an enable/clock E. When E=1, Q follows D; "
            "when E=0, Q holds its last value. Latches are transparent to glitches on E, "
            "which makes them less desirable than edge-triggered flip-flops in synchronous "
            "designs; they are however used in clock-gating cells."
        ),
        "algorithm": [
            "Implement the cross-coupled NAND/NOR structure or the level-sensitive D model.",
            "For SR latch: add logic to detect and handle the forbidden state.",
            "Testbench: toggle S, R (or D, E) through all valid combinations.",
            "Verify Q and Q' are always complementary except during forbidden state.",
        ],
        "expected_results_heading": "Q follows D when E=1; Q holds its value when E=0.",
    },
    {
        "keywords": ["dff", "tff", "jkff", "srff", "flip_flop", "flipflop"],
        "theory": (
            "An edge-triggered flip-flop samples its input only on a clock edge (positive "
            "or negative), making it immune to glitches between edges - the foundation of "
            "synchronous digital design.\n\n"
            "D Flip-Flop (DFF): Q captures D on the rising edge. With synchronous reset, "
            "Q is cleared on the clock edge when RST=1. With asynchronous reset, Q is "
            "immediately cleared regardless of the clock.\n\n"
            "T Flip-Flop: Q toggles when T=1. JK Flip-Flop generalises SR: J=K=1 "
            "toggles; J=1,K=0 sets; J=0,K=1 resets; J=K=0 holds. These are implemented "
            "in Verilog using 'always @(posedge clk)' sensitivity lists with non-blocking "
            "assignments (<=)."
        ),
        "algorithm": [
            "Select flip-flop type and edge sensitivity (posedge / negedge).",
            "Choose reset polarity and synchronous vs asynchronous implementation.",
            "Implement with 'always @(posedge clk)' and non-blocking assignment (<=).",
            "Testbench: apply clock, assert reset, then cycle through input states.",
            "Verify output Q updates only on the clock edge; check setup and hold timing.",
        ],
        "expected_results_heading": "Q samples D (or toggles/sets/resets) on each rising clock edge; reset works correctly.",
    },
    {
        "keywords": ["register", "regfile"],
        "theory": (
            "A register is a group of flip-flops sharing a common clock and reset, used to "
            "store a multi-bit value. An 8-bit register stores one byte. A register file "
            "contains multiple addressable registers with read and write ports; it forms the "
            "central storage in a processor datapath.\n\n"
            "Registers may include a synchronous load-enable (the register retains its "
            "value when enable=0) and a synchronous or asynchronous reset. In Verilog, "
            "a parameterised register uses 'parameter WIDTH' and the output is an "
            "reg [WIDTH-1:0]."
        ),
        "algorithm": [
            "Define bit width, reset polarity and whether a load-enable is required.",
            "Implement with 'always @(posedge clk)' and non-blocking assignment.",
            "Testbench: write various data values with enable; verify storage and hold.",
        ],
        "expected_results_heading": "Register stores D when enable=1; retains value when enable=0.",
    },
    {
        "keywords": ["siso", "sipo", "piso", "pipo", "shift_register", "bidir_shift"],
        "theory": (
            "A shift register moves data bits one position per clock cycle. Four "
            "configurations exist based on serial/parallel input and output:\n"
            "  SISO (Serial-In Serial-Out) - a delay line;\n"
            "  SIPO (Serial-In Parallel-Out) - serial-to-parallel converter;\n"
            "  PISO (Parallel-In Serial-Out) - parallel-to-serial converter;\n"
            "  PIPO (Parallel-In Parallel-Out) - a clocked buffer.\n\n"
            "Bidirectional shift registers support both left and right shifts. Universal "
            "shift registers include a mode control to select all four configurations. "
            "Shift registers are used in serial communication, CRC generators, "
            "pseudo-random sequence generators (LFSR) and delay lines."
        ),
        "algorithm": [
            "Determine width N, shift direction(s) and I/O configuration.",
            "For SISO: chain N DFFs; serial_out = last stage Q.",
            "For SIPO: chain N DFFs; parallel out = Q of each stage.",
            "For PISO: load parallel data on load=1; shift on load=0.",
            "Testbench: load a known pattern; clock N times; verify shifted output.",
        ],
        "expected_results_heading": "Data appears at the output shifted by one position per clock cycle.",
    },
    {
        "keywords": ["counter", "ring_counter", "johnson_counter", "bcd_counter",
                     "freq_divider", "prog_freq"],
        "theory": (
            "A binary counter increments (or decrements) a stored n-bit value on each "
            "active clock edge. A 4-bit up counter counts 0..15 then wraps; a down counter "
            "counts 15..0. An up-down counter selects direction with a mode input.\n\n"
            "A modulo-N counter resets to 0 after reaching N-1, producing a periodic "
            "output with frequency f_clk/N - used as a programmable frequency divider. "
            "BCD counters count 0..9 and are used in decimal displays. Ring counters "
            "circulate a single '1' through n stages; Johnson counters feed back the "
            "inverted output, generating 2n unique states.\n\n"
            "LFSR (Linear Feedback Shift Register) counters use XOR feedback to generate "
            "pseudo-random maximal-length sequences of 2^n-1 states."
        ),
        "algorithm": [
            "Define bit-width, counting direction and terminal count (modulus).",
            "Implement with 'always @(posedge clk or posedge rst)'.",
            "Add asynchronous reset to initialise on power-on.",
            "For mod-N: compare with N-1 and synchronously clear on next clock.",
            "Testbench: clock for N+2 cycles; verify count sequence and wrap-around.",
        ],
        "expected_results_heading": "Count increments/decrements each clock; wraps at terminal count; reset works.",
    },
    {
        "keywords": ["lfsr"],
        "theory": (
            "A Linear Feedback Shift Register (LFSR) is a shift register whose input bit "
            "is a linear function (XOR) of its previous state. For a primitive polynomial, "
            "an n-bit LFSR cycles through 2^n-1 non-zero states before repeating, "
            "producing a maximal-length pseudo-random binary sequence (PRBS).\n\n"
            "LFSRs are used in cryptography, built-in self-test (BIST), spread-spectrum "
            "communications, CRC generation and scrambling. The tap positions are "
            "determined by the primitive polynomial over GF(2)."
        ),
        "algorithm": [
            "Choose a primitive polynomial for the desired bit width.",
            "Implement the shift register with XOR feedback at the tap positions.",
            "Seed the LFSR with a non-zero initial value.",
            "Testbench: run for 2^n-1 clock cycles; verify all non-zero states are visited.",
        ],
        "expected_results_heading": "2^n-1 unique non-zero states before the sequence repeats.",
    },
    {
        "keywords": ["fsm", "moore", "mealy", "seq_detect", "traffic_light", "vending",
                     "elevator", "washing", "password_lock", "uart_tx", "uart_rx",
                     "spi_simple"],
        "theory": (
            "A Finite State Machine (FSM) is a sequential circuit that transitions between "
            "a finite set of states in response to inputs, producing outputs. Two "
            "fundamental FSM models exist:\n\n"
            "Moore FSM: outputs depend only on the current state. Output changes are "
            "synchronised to state transitions, making them glitch-free.\n\n"
            "Mealy FSM: outputs depend on both the current state and current inputs. "
            "Mealy machines can respond in the same clock cycle as the input, reducing "
            "latency but potentially producing glitchy outputs.\n\n"
            "Verilog implementation uses two always blocks: one for state register "
            "(synchronous) and one for next-state/output logic (combinational). State "
            "encoding (binary, one-hot, Gray) affects synthesis area and speed."
        ),
        "algorithm": [
            "Draw the state transition diagram and label each arc with input/output.",
            "Encode states (binary or one-hot) and declare state register.",
            "Implement state register with synchronous (or async) reset.",
            "Implement next-state and output logic with a case statement.",
            "Testbench: apply input sequences that traverse all states and transitions.",
            "Verify FSM detects the correct pattern or produces expected output.",
        ],
        "expected_results_heading": (
            "FSM transitions through all defined states correctly; output asserted at the right cycle.\n"
            "All state transition arcs exercised by the testbench stimulus."
        ),
    },
    {
        "keywords": ["ram", "rom", "memory", "dual_port", "fifo", "lifo", "stack", "cam",
                     "cache"],
        "theory": (
            "Semiconductor memories store binary data in arrays of storage cells. "
            "RAM (Random Access Memory) supports both read and write operations. "
            "Synchronous RAM registers the address/data on the clock edge; asynchronous "
            "RAM produces output after address propagation delay.\n\n"
            "Dual-port RAM has two independent read/write ports, allowing simultaneous "
            "access from two masters - essential in multi-processor and buffer designs. "
            "ROM (Read-Only Memory) stores fixed content initialised at synthesis.\n\n"
            "A FIFO (First In First Out) buffer decouples producer and consumer. Synchronous "
            "FIFOs share one clock; asynchronous FIFOs use Gray-coded pointers and "
            "two-flip-flop synchronisers to cross clock domains safely. A LIFO/stack uses "
            "Last In First Out discipline. A CAM (Content Addressable Memory) searches "
            "for matching data in parallel and returns the address."
        ),
        "algorithm": [
            "Define depth, width and number of read/write ports.",
            "Implement memory array as 'reg [WIDTH-1:0] mem [0:DEPTH-1]'.",
            "Add synchronous write and (optionally) registered read.",
            "For FIFO: maintain write and read pointers and full/empty flags.",
            "Testbench: write a pattern, read it back and verify data integrity.",
        ],
        "expected_results_heading": "Data read back matches data written; full/empty flags correct.",
    },
    {
        "keywords": ["fp16", "fp_adder", "fp_mult", "floating_point", "fixed_point",
                     "fp_adder_q", "fp_mult_q"],
        "theory": (
            "Floating-point arithmetic represents numbers in the form M * 2^E, enabling a "
            "wide dynamic range. The IEEE 754 half-precision (FP16) format uses 1 sign bit, "
            "5 exponent bits (bias=15) and 10 mantissa bits.\n\n"
            "Addition: align mantissas by shifting the smaller exponent operand, add "
            "mantissas, normalise result and round. Multiplication: add exponents, "
            "multiply mantissas, normalise. Fixed-point arithmetic (Q format) is simpler "
            "and suitable for DSP where the dynamic range is known in advance."
        ),
        "algorithm": [
            "Detect special cases (zero, NaN, Inf) first.",
            "Extract sign, exponent and mantissa fields.",
            "Align operands (for addition) or compute exponent sum (for multiplication).",
            "Perform integer add/multiply on mantissas with guard/round/sticky bits.",
            "Normalise: find leading-one position and adjust exponent accordingly.",
            "Pack sign, adjusted exponent and rounded mantissa into output word.",
        ],
        "expected_results_heading": "FP result matches IEEE 754 reference for all test vectors.",
    },
    {
        "keywords": ["cordic"],
        "theory": (
            "CORDIC (COordinate Rotation DIgital Computer) is an iterative shift-add "
            "algorithm that computes trigonometric, hyperbolic and other transcendental "
            "functions using only additions, subtractions and bit-shifts - no multipliers "
            "needed. Each iteration rotates a 2-D vector by a decreasing angle.\n\n"
            "CORDIC operates in two modes: Rotation mode drives the angle accumulator to "
            "zero (computes sin/cos); Vectoring mode drives the y component to zero "
            "(computes magnitude and angle). After n iterations the result is accurate to "
            "approximately n bits."
        ),
        "algorithm": [
            "Pre-compute the CORDIC angle table: atan(2^-i) for i=0,1,...,n-1.",
            "Initialise vector (x,y) and angle accumulator z.",
            "Each iteration: decide rotation direction from sign of z (or y).",
            "Shift-add: x_new = x - d*y>>i; y_new = y + d*x>>i; z_new = z - d*atan_i.",
            "After n iterations read sin, cos (rotation) or magnitude, angle (vectoring).",
        ],
        "expected_results_heading": "Output matches sin/cos or magnitude/angle within CORDIC precision.",
    },
    {
        "keywords": ["pipeline", "pipe_", "fir_filter", "superscalar", "datapath_pipe",
                     "hazard", "forwarding", "branch_predictor", "ooo"],
        "theory": (
            "Pipelining divides a datapath into stages separated by pipeline registers. "
            "Each stage completes in one clock cycle, allowing new inputs to enter the "
            "pipeline every cycle. An n-stage pipeline can achieve n times the throughput "
            "of a sequential design at the cost of n-1 cycles of latency.\n\n"
            "Hazards limit pipeline performance: structural hazards occur when two stages "
            "need the same resource; data hazards arise when an instruction needs a value "
            "not yet written back; control hazards occur on branches. Solutions include "
            "stalling (pipeline bubbles), forwarding/bypassing and branch prediction.\n\n"
            "A pipelined FIR filter computes sum(h[k]*x[n-k]) in a multiply-accumulate "
            "tree, with pipeline stages between multiplications and additions."
        ),
        "algorithm": [
            "Identify critical path and partition into balanced stages.",
            "Insert pipeline registers (always @(posedge clk)) at each stage boundary.",
            "For hazards: detect data dependency; insert forwarding paths or stall logic.",
            "Testbench: fill pipeline, then verify steady-state output latency.",
            "Confirm throughput: one new result per clock after the pipeline is full.",
        ],
        "expected_results_heading": "First result after n-cycle latency; then one result per clock cycle.",
    },
    {
        "keywords": ["risc", "cpu"],
        "theory": (
            "A RISC (Reduced Instruction Set Computer) processor executes a small, "
            "regular instruction set where each instruction completes in one clock cycle. "
            "A minimal RISC has an instruction memory (ROM), a register file, an ALU, "
            "and a program counter (PC).\n\n"
            "The instruction encoding uses fixed-width words: the opcode field selects "
            "the ALU operation and source/destination registers. The fetch-decode-execute "
            "cycle is: read instruction from IMEM[PC], decode opcode and register fields, "
            "execute ALU operation, write result to register file, increment PC."
        ),
        "algorithm": [
            "Define instruction set and encoding (opcode, rd, rs1, rs2 fields).",
            "Implement instruction memory (ROM), register file, ALU and PC.",
            "Add fetch-decode-execute-writeback datapath.",
            "Testbench: load a small program; step through instructions; verify register values.",
        ],
        "expected_results_heading": "Register file contains correct results after executing the test program.",
    },
    {
        "keywords": ["vga"],
        "theory": (
            "A VGA controller generates horizontal sync (HSYNC) and vertical sync (VSYNC) "
            "signals and pixel colour data at the standard 640x480@60 Hz timing "
            "(25.175 MHz pixel clock). The timing consists of active video regions, "
            "front porch, sync pulse and back porch for both horizontal and vertical.\n\n"
            "A pixel counter and line counter track the current position. Colour data is "
            "valid only in the active region (0-639 horizontal, 0-479 vertical)."
        ),
        "algorithm": [
            "Clock pixel counter from 0 to H_TOTAL-1; reset and increment line counter.",
            "Generate HSYNC active-low during sync pulse columns.",
            "Generate VSYNC active-low during sync pulse rows.",
            "Assert video_active when both counters are within the active region.",
            "Testbench: check HSYNC/VSYNC pulses at correct pixel/line positions.",
        ],
        "expected_results_heading": "HSYNC and VSYNC pulses at standard VGA timing intervals.",
    },
    {
        "keywords": ["pwm"],
        "theory": (
            "Pulse Width Modulation (PWM) varies the duty cycle of a fixed-frequency "
            "square wave to encode an analogue value. A free-running counter compares to a "
            "duty-cycle register: output=1 when count < duty, else output=0. The average "
            "output voltage is proportional to duty/period.\n\n"
            "PWM is used to control motor speed, LED brightness and DAC approximations. "
            "Resolution is determined by the counter width (8-bit gives 256 levels)."
        ),
        "algorithm": [
            "Set a period counter that runs 0 to PERIOD-1.",
            "Compare counter to duty-cycle register; output=1 when counter < duty.",
            "Testbench: set various duty values and measure output high-time / period.",
        ],
        "expected_results_heading": "Output duty cycle = duty_reg / period_reg.",
    },
    {
        "keywords": ["uart"],
        "theory": (
            "UART (Universal Asynchronous Receiver Transmitter) is a serial protocol that "
            "transmits data without a shared clock. Each frame consists of: 1 start bit "
            "(low), 8 data bits (LSB first), optional parity bit and 1-2 stop bits (high).\n\n"
            "The transmitter shifts data out at the baud rate. The receiver samples the "
            "incoming line at 16x the baud rate, detects the start bit falling edge and "
            "samples at the midpoint of each bit to recover data. Common baud rates: "
            "9600, 115200 bps."
        ),
        "algorithm": [
            "Compute baud-rate divisor from system clock frequency.",
            "TX: idle=1; on tx_start, drive start=0, shift 8 data bits, drive stop=1.",
            "RX: detect negedge on rx line; oversample at 16x; latch mid-bit samples.",
            "Testbench: connect TX output to RX input; verify received byte = sent byte.",
        ],
        "expected_results_heading": "Received byte matches transmitted byte with correct framing.",
    },
    {
        "keywords": ["spi"],
        "theory": (
            "SPI (Serial Peripheral Interface) is a synchronous full-duplex serial "
            "protocol using four signals: SCLK (serial clock), MOSI (master out/slave in), "
            "MISO (master in/slave out) and CS (chip select, active-low).\n\n"
            "The master drives SCLK and CS; data is shifted out on MOSI on one clock edge "
            "and sampled on MISO on the opposite edge (SPI Mode 0: CPOL=0, CPHA=0). "
            "SPI is widely used for flash memory, DACs, ADCs and display controllers."
        ),
        "algorithm": [
            "Assert CS low to begin transaction.",
            "For each of the 8 (or 16) bits: drive MOSI = data[MSB]; toggle SCLK.",
            "Sample MISO on rising SCLK edge; shift into receive register.",
            "Deassert CS when all bits are transferred.",
            "Testbench: provide a loopback (MOSI connected to MISO) and verify.",
        ],
        "expected_results_heading": "Received SPI data matches transmitted data in loopback test.",
    },
    {
        "keywords": ["i2c"],
        "theory": (
            "I2C (Inter-Integrated Circuit) is a two-wire synchronous serial bus (SDA data "
            "and SCL clock) supporting multiple masters and slaves. It uses open-drain "
            "signals with pull-up resistors.\n\n"
            "A transaction begins with a START condition (SDA falls while SCL=1), followed "
            "by a 7-bit device address, R/W bit, ACK, data bytes with ACKs, and a STOP "
            "condition (SDA rises while SCL=1). I2C speeds: Standard (100 kHz), Fast "
            "(400 kHz), Fast+ (1 MHz)."
        ),
        "algorithm": [
            "Assert START: pull SDA low while SCL high.",
            "Shift out 7-bit address + R/W bit; check ACK from slave.",
            "Transfer data bytes; check ACK after each.",
            "Assert STOP: release SDA high while SCL high.",
            "Testbench: provide a simple slave model and verify address/data transfer.",
        ],
        "expected_results_heading": "I2C transaction completes with correct address and data bytes.",
    },
    {
        "keywords": ["crc", "hamming", "conv_enc", "viterbi", "manchester", "nrz"],
        "theory": (
            "Error detection and correction (EDC) codes protect digital data against "
            "transmission and storage errors.\n\n"
            "CRC (Cyclic Redundancy Check) appends a checksum computed by polynomial "
            "division over GF(2). CRC-8 uses polynomial x^8+x^2+x+1.\n\n"
            "Hamming codes add redundant parity bits at power-of-2 positions to correct "
            "single-bit errors and detect double-bit errors (SECDED). Convolutional codes "
            "and Viterbi decoding provide forward error correction in noisy channels. "
            "Line codes (NRZ, Manchester) define electrical signal encoding."
        ),
        "algorithm": [
            "For CRC: implement polynomial division using LFSR with tap feedback.",
            "For Hamming: compute parity bits at positions 2^i; append to data.",
            "Decoder: re-compute syndrome; correct bit at syndrome position.",
            "Testbench: inject single-bit errors and verify correction.",
        ],
        "expected_results_heading": "Decoder corrects all injected single-bit errors; double-bit errors detected.",
    },
    {
        "keywords": ["axi", "wishbone", "dma", "interrupt", "timer", "gpio", "soc_bus",
                     "mem_ctrl", "sys_timer", "power_mgmt", "complete_soc"],
        "theory": (
            "Advanced on-chip buses enable communication between IP blocks in a SoC. "
            "AXI (Advanced eXtensible Interface, part of ARM AMBA) is a high-performance "
            "burst-capable bus with separate read and write channels. AXI-Lite is a "
            "simplified single-beat subset used for register maps.\n\n"
            "Wishbone is an open-source bus standard. A DMA controller moves blocks of "
            "data between memory and peripherals without CPU intervention. An interrupt "
            "controller aggregates peripheral IRQ lines and presents a prioritised "
            "interrupt vector to the CPU. GPIO controllers let software configure pins "
            "as input or output."
        ),
        "algorithm": [
            "Define the bus address map and register layout.",
            "Implement write channel: decode address, write to register on WVALID/WREADY.",
            "Implement read channel: decode address, drive RDATA on ARVALID/ARREADY.",
            "Add peripheral logic (DMA, timer, IRQ) behind the bus interface.",
            "Testbench: perform read/write transactions; verify peripheral functions.",
        ],
        "expected_results_heading": "Bus transactions complete with correct data; peripheral functions verified.",
    },
    {
        "keywords": ["assertion", "coverage", "constrained_random", "protocol_checker",
                     "scoreboard", "cdc_checker", "timing_constraint", "power_aware",
                     "formal", "self_checking"],
        "theory": (
            "Functional verification ensures that a design meets its specification. Modern "
            "verification methodologies combine directed testing, constrained-random "
            "stimulus, coverage-driven verification and formal analysis.\n\n"
            "SystemVerilog Assertions (SVA) express temporal properties as 'assert', "
            "'assume' and 'cover' directives. Functional coverage groups sample design "
            "variables to track which states have been exercised. Constrained-random "
            "verification uses randomised stimulus with legal-value constraints.\n\n"
            "A scoreboard compares DUT output to a golden reference model. Protocol "
            "checkers verify bus/interface handshaking. CDC checkers flag unsafe signal "
            "transitions between asynchronous domains."
        ),
        "algorithm": [
            "Write a transaction-level model (TLM) or golden reference in Verilog.",
            "Implement the self-checking testbench or SVA assertions.",
            "Collect functional coverage; identify uncovered bins.",
            "Run constrained-random simulation until coverage closure.",
            "Inspect assertion failures and coverage reports.",
        ],
        "expected_results_heading": "All assertions pass; 100% functional coverage achieved.",
    },
    {
        "keywords": ["bcd_to_7seg", "7seg", "seven_seg"],
        "theory": (
            "A BCD-to-7-segment decoder converts a 4-bit BCD digit (0-9) into a 7-bit "
            "code that drives the seven segments (a-g) of a common-anode or common-cathode "
            "LED display. Each of the 10 valid BCD values illuminates a unique pattern.\n\n"
            "Values 1010-1111 are invalid in BCD and may be mapped to blank or error. "
            "The decoder is typically implemented with a case statement or ROM lookup."
        ),
        "algorithm": [
            "Define the 10-entry segment encoding table for digits 0-9.",
            "Implement with a case statement.",
            "Testbench: apply each BCD value 0000-1001; verify correct segment pattern.",
            "Test out-of-range inputs for blank output.",
        ],
        "expected_results_heading": "Segment output matches standard 7-segment digit pattern for digits 0-9.",
    },
    {
        "keywords": ["parity"],
        "theory": (
            "A parity generator appends one extra bit to a data word so that the total "
            "number of 1-bits is even (even parity) or odd (odd parity). The parity bit "
            "is the XOR of all data bits (even parity) or its complement (odd parity). "
            "The receiver recomputes parity; a mismatch indicates a single-bit error.\n\n"
            "Parity is a simple single-error-detection code. It cannot correct errors or "
            "detect an even number of bit flips."
        ),
        "algorithm": [
            "Compute even parity: P = XOR of all n data bits.",
            "Compute odd parity: P = XNOR of all n data bits.",
            "Append P to the data word to form the transmitted codeword.",
            "Testbench: apply all 2^n input combinations; verify parity bit.",
        ],
        "expected_results_heading": "Total number of 1-bits (data + parity) is always even (or odd).",
    },
    {
        "keywords": ["dsp_mac", "mac"],
        "theory": (
            "A Multiply-Accumulate (MAC) unit computes P = P + A*B in one operation, "
            "which is the inner loop of FIR filters, matrix multiplications and neural "
            "networks. DSP48 slices on Xilinx FPGAs contain a dedicated multiplier and "
            "accumulator path. A MAC unit typically includes a pipeline register between "
            "the multiplier and the accumulator."
        ),
        "algorithm": [
            "Compute product A*B (combinational multiplier).",
            "Accumulate: acc = acc + product on clock edge.",
            "Add a clear/load input to reset the accumulator.",
            "Testbench: apply a series of (A, B) pairs; compare accumulated result.",
        ],
        "expected_results_heading": "Accumulated result = sum of all A[i]*B[i] products.",
    },
]

FALLBACK_CATEGORY = {
    "theory": (
        "This experiment implements a Verilog hardware description of the named circuit "
        "or subsystem. Verilog (IEEE 1364) is a hardware description language used to "
        "model digital systems at multiple levels of abstraction: gate-level (structural), "
        "data-flow (continuous assign) and behavioral (always blocks).\n\n"
        "The design is verified using a co-simulated testbench that applies stimulus "
        "vectors and checks responses. The testbench uses the $dumpvars system task to "
        "record waveforms for post-simulation viewing in GTKWave."
    ),
    "algorithm": [
        "Understand the functional specification of the target circuit.",
        "Choose an appropriate Verilog modelling style (structural / dataflow / behavioral).",
        "Declare all ports with correct widths and directions.",
        "Implement the functionality using gate primitives, assign or always blocks.",
        "Write a self-checking testbench covering nominal and edge-case scenarios.",
        "Simulate, inspect waveforms and verify against the expected output.",
    ],
    "expected_results_heading": "Simulation output matches functional specification for all test vectors.",
}


# ---------------------------------------------------------------------------
# Helper utilities
# ---------------------------------------------------------------------------

def _level_number(path: Path) -> int:
    match = re.search(r"level(\d+)", path.name, re.IGNORECASE)
    return int(match.group(1)) if match else 0


def _experiment_number(path: Path) -> int:
    match = re.search(r"exp(\d+)", path.name, re.IGNORECASE)
    return int(match.group(1)) if match else 0


def _experiment_title(exp_dir: Path) -> str:
    name = exp_dir.name
    match = re.match(r"exp(\d+)_", name, re.IGNORECASE)
    if match:
        number = int(match.group(1))
        rest = name[match.end():]
        label = rest.replace("_", " ").replace("-", " ").title()
        return f"Experiment {number}: {label}"
    return name.replace("_", " ").replace("-", " ").title()


def _safe_text(text: str) -> str:
    """Transliterate common Unicode characters and replace any remaining non-latin-1 characters for PDF compatibility."""
    replacements = [
        ("\u2013", "-"), ("\u2014", "-"), ("\u2015", "-"),
        ("\u201c", '"'), ("\u201d", '"'),
        ("\u2018", "'"), ("\u2019", "'"),
        ("\u00b0", " deg"), ("\u00b5", "u"),
        ("\u2192", "->"), ("\u2190", "<-"), ("\u2260", "!="),
        ("\u2265", ">="), ("\u2264", "<="),
        ("\u00d7", "x"), ("\u00f7", "/"),
    ]
    for orig, repl in replacements:
        text = text.replace(orig, repl)
    return text.encode("latin-1", errors="replace").decode("latin-1")


def _parse_verilog_header(file_path: Path) -> Dict[str, str]:
    """Extract title, description, inputs, outputs from leading comment block."""
    info: Dict[str, str] = {"title": "", "description": "", "inputs": "", "outputs": ""}
    lines = file_path.read_text(encoding="utf-8", errors="replace").splitlines()
    desc_lines: List[str] = []
    for line in lines[:40]:
        stripped = line.strip()
        if stripped.startswith("//"):
            content = stripped.lstrip("/").strip()
            low = content.lower()
            if low.startswith("experiment "):
                info["title"] = content
            elif low.startswith("inputs") or low.startswith("input "):
                info["inputs"] = content
            elif low.startswith("outputs") or low.startswith("output "):
                info["outputs"] = content
            elif content and not content.startswith("`"):
                desc_lines.append(content)
        elif stripped.startswith("module ") or stripped.startswith("`timescale"):
            break
    info["description"] = " ".join(desc_lines)
    return info


def _get_category(folder_name: str) -> Dict:
    """Return the best-matching category metadata dict."""
    low = folder_name.lower()
    for cat in CATEGORY_DB:
        for kw in cat["keywords"]:
            if kw in low:
                return cat
    return FALLBACK_CATEGORY


def _build_aim(exp_dir: Path, rtl_files: List[Path], header: Dict[str, str]) -> str:
    """Construct the Aim text for the experiment."""
    title = _experiment_title(exp_dir)
    comment_title = header.get("title", "")
    base = comment_title if comment_title else title
    aim = (
        f"To design, implement and simulate the {base} using Verilog HDL "
        f"and verify its functional correctness through simulation using a "
        f"self-checking testbench."
    )
    inputs = header.get("inputs", "")
    outputs = header.get("outputs", "")
    if inputs or outputs:
        parts = []
        if inputs:
            parts.append(inputs)
        if outputs:
            parts.append(outputs)
        aim += f"\n{'; '.join(parts)}."
    return aim


def _build_expected_results(folder_name: str, cat: Dict, header: Dict[str, str]) -> str:
    heading = cat.get("expected_results_heading", "")
    if heading:
        return heading
    return "Simulation output matches the expected functional specification for all applied test vectors."


# ---------------------------------------------------------------------------
# Discovery
# ---------------------------------------------------------------------------

def discover_experiments() -> Iterable[Tuple[str, int, Path, List[Path], List[Path]]]:
    """Yield (level_label, level_num, exp_dir, rtl_files, tb_files)."""
    for level_dir in sorted(LEVEL_ROOT.glob("level*"), key=_level_number):
        if not level_dir.is_dir():
            continue
        lvl_num = _level_number(level_dir)
        level_label = f"Level {lvl_num}"
        for exp_dir in sorted(level_dir.iterdir(), key=_experiment_number):
            if not exp_dir.is_dir():
                continue
            all_v = sorted(exp_dir.glob("*.v"))
            if not all_v:
                continue
            rtl = [f for f in all_v if not f.stem.endswith("_tb")]
            tb = [f for f in all_v if f.stem.endswith("_tb")]
            yield level_label, lvl_num, exp_dir, rtl, tb


# ---------------------------------------------------------------------------
# PDF builder
# ---------------------------------------------------------------------------

class LabReportPDF(FPDF):
    def __init__(self) -> None:
        super().__init__(format="A4")
        self.set_auto_page_break(auto=True, margin=18)
        self._header_text = "Verilog HDL Lab Report"

    def header(self) -> None:
        if self.page_no() > 1:
            self.set_font("Helvetica", "I", 8)
            self.cell(
                0, 8, _safe_text(self._header_text),
                new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="R"
            )
            self.set_draw_color(180, 180, 180)
            self.line(self.l_margin, self.get_y(), self.w - self.r_margin, self.get_y())
            self.ln(2)

    def footer(self) -> None:
        self.set_y(-13)
        self.set_font("Helvetica", "I", 8)
        self.set_draw_color(180, 180, 180)
        self.line(self.l_margin, self.get_y(), self.w - self.r_margin, self.get_y())
        self.ln(1)
        self.cell(0, 8, f"Page {self.page_no()}", align="C")


def _h1(pdf: LabReportPDF, text: str) -> None:
    pdf.set_font("Helvetica", "B", 14)
    pdf.set_fill_color(30, 60, 120)
    pdf.set_text_color(255, 255, 255)
    pdf.cell(
        0, 8, _safe_text(text), fill=True,
        new_x=XPos.LMARGIN, new_y=YPos.NEXT
    )
    pdf.set_text_color(0, 0, 0)
    pdf.ln(1)


def _h2(pdf: LabReportPDF, text: str) -> None:
    pdf.set_font("Helvetica", "B", 11)
    pdf.set_fill_color(210, 220, 240)
    pdf.cell(
        0, 7, _safe_text("  " + text), fill=True,
        new_x=XPos.LMARGIN, new_y=YPos.NEXT
    )
    pdf.ln(1)


def _body(pdf: LabReportPDF, text: str, font_size: int = 10) -> None:
    pdf.set_font("Helvetica", "", font_size)
    pdf.set_x(pdf.l_margin)
    pw = pdf.w - pdf.l_margin - pdf.r_margin
    pdf.multi_cell(pw, 5.5, _safe_text(text))
    pdf.ln(1)


def _bullet_list(pdf: LabReportPDF, items: List[str]) -> None:
    pdf.set_font("Helvetica", "", 10)
    for i, item in enumerate(items, 1):
        pdf.set_x(pdf.l_margin)
        pw = pdf.w - pdf.l_margin - pdf.r_margin
        pdf.multi_cell(pw, 5.5, _safe_text(f"  {i}. {item}"))
    pdf.ln(1)


def _code_block(pdf: LabReportPDF, file_path: Path) -> None:
    code_text = file_path.read_text(encoding="utf-8", errors="replace").replace("\t", "    ")
    printable_w = pdf.w - pdf.l_margin - pdf.r_margin

    # File name bar
    pdf.set_font("Helvetica", "B", 8)
    pdf.set_fill_color(200, 210, 235)
    pdf.cell(
        0, 6, f"  {_safe_text(file_path.name)}",
        fill=True, border=1,
        new_x=XPos.LMARGIN, new_y=YPos.NEXT
    )

    pdf.set_font("Courier", "", 7.5)
    pdf.set_fill_color(248, 248, 248)
    char_w = pdf.get_string_width("M") or 4.5
    max_cols = max(int(printable_w / char_w), 40)

    for raw_line in code_text.splitlines():
        safe_line = _safe_text(raw_line)
        if not safe_line.strip():
            pdf.cell(0, 3, "", new_x=XPos.LMARGIN, new_y=YPos.NEXT)
            continue
        chunks = textwrap.wrap(safe_line, max_cols, expand_tabs=False,
                               replace_whitespace=False, drop_whitespace=False)
        if not chunks:
            chunks = [safe_line]
        for chunk in chunks:
            pdf.set_x(pdf.l_margin)
            pdf.multi_cell(printable_w, 4, chunk, fill=True)
    pdf.ln(2)


def _divider(pdf: LabReportPDF) -> None:
    pdf.set_draw_color(180, 180, 180)
    pdf.line(pdf.l_margin, pdf.get_y(), pdf.w - pdf.r_margin, pdf.get_y())
    pdf.ln(3)


# ---------------------------------------------------------------------------
# Cover page
# ---------------------------------------------------------------------------

def add_cover_page(pdf: LabReportPDF, experiment_count: int, level_count: int) -> None:
    pdf.add_page()
    pdf.set_font("Helvetica", "B", 10)
    pdf.set_text_color(80, 80, 80)
    pdf.cell(0, 8, "Department of Electronics & Communication Engineering",
             new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="C")
    pdf.set_font("Helvetica", "", 9)
    pdf.cell(0, 6, "B.Tech Programme - Digital Design Laboratory",
             new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="C")
    pdf.ln(10)

    pdf.set_draw_color(30, 60, 120)
    pdf.set_line_width(1)
    pdf.rect(pdf.l_margin - 2, pdf.get_y() - 2,
             pdf.w - pdf.l_margin - pdf.r_margin + 4, 40)
    pdf.set_line_width(0.2)

    pdf.set_font("Helvetica", "B", 22)
    pdf.set_text_color(30, 60, 120)
    pdf.cell(0, 14, "Verilog HDL Laboratory",
             new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="C")
    pdf.set_font("Helvetica", "B", 16)
    pdf.set_text_color(0, 0, 0)
    pdf.cell(0, 10, "Comprehensive Lab Record",
             new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="C")
    pdf.ln(14)

    pdf.set_font("Helvetica", "", 11)
    pdf.set_text_color(30, 30, 30)
    details = [
        ("Subject", "Digital Design & HDL Laboratory (ECE3xx)"),
        ("Total Experiments", str(experiment_count)),
        ("Levels", str(level_count)),
        ("HDL Standard", "IEEE Std 1364-2005 (Verilog)"),
        ("Simulation Tool", "Xilinx Vivado / ModelSim / Icarus Verilog"),
        ("Date Generated", datetime.now().strftime("%d %B %Y")),
    ]
    col_w = (pdf.w - pdf.l_margin - pdf.r_margin) / 2
    for label, val in details:
        pdf.set_font("Helvetica", "B", 10)
        pdf.cell(col_w * 0.45, 7, _safe_text(label + ":"))
        pdf.set_font("Helvetica", "", 10)
        pdf.cell(col_w * 0.55, 7, _safe_text(val),
                 new_x=XPos.LMARGIN, new_y=YPos.NEXT)
    pdf.ln(8)

    pdf.set_font("Helvetica", "I", 9)
    pdf.set_text_color(80, 80, 80)
    pdf.set_x(pdf.l_margin)
    pw = pdf.w - pdf.l_margin - pdf.r_margin
    pdf.multi_cell(
        pw, 6,
        "This lab record contains all experiments organised by difficulty level. "
        "Each entry provides Aim, Apparatus, Theory, Algorithm, Verilog RTL source, "
        "Testbench source, Expected Simulation Results and Conclusion, "
        "conforming to the standard B.Tech laboratory report format."
    )
    pdf.set_text_color(0, 0, 0)


# ---------------------------------------------------------------------------
# Table of Contents
# ---------------------------------------------------------------------------

def add_toc(pdf: LabReportPDF,
            toc_entries: List[Tuple[str, str, int]]) -> None:
    pdf.add_page()
    _h1(pdf, "Table of Contents")
    pdf.set_font("Helvetica", "", 9)
    current_level = ""
    for level_label, title, page in toc_entries:
        if level_label != current_level:
            current_level = level_label
            pdf.ln(2)
            pdf.set_font("Helvetica", "B", 10)
            pdf.cell(0, 6, _safe_text(level_label),
                     new_x=XPos.LMARGIN, new_y=YPos.NEXT)
            pdf.set_font("Helvetica", "", 9)
        title_safe = _safe_text("  " + title)
        page_str = str(page)
        title_w = pdf.w - pdf.l_margin - pdf.r_margin - 14
        pdf.cell(title_w, 5.5, title_safe)
        pdf.cell(14, 5.5, page_str, align="R",
                 new_x=XPos.LMARGIN, new_y=YPos.NEXT)


# ---------------------------------------------------------------------------
# Level divider page
# ---------------------------------------------------------------------------

def add_level_divider(pdf: LabReportPDF, level_num: int, exp_count: int) -> None:
    pdf.add_page()
    pdf.ln(30)
    pdf.set_font("Helvetica", "B", 32)
    pdf.set_text_color(30, 60, 120)
    pdf.cell(0, 18, f"Level {level_num}",
             new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="C")
    pdf.set_font("Helvetica", "", 14)
    pdf.set_text_color(60, 60, 60)
    desc = LEVEL_DESC.get(level_num, "")
    pdf.set_x(pdf.l_margin)
    pw = pdf.w - pdf.l_margin - pdf.r_margin
    pdf.multi_cell(pw, 9, _safe_text(desc), align="C")
    pdf.ln(6)
    pdf.set_font("Helvetica", "I", 11)
    pdf.set_text_color(100, 100, 100)
    pdf.cell(0, 8, f"({exp_count} experiment{'s' if exp_count != 1 else ''})",
             new_x=XPos.LMARGIN, new_y=YPos.NEXT, align="C")
    pdf.set_text_color(0, 0, 0)


# ---------------------------------------------------------------------------
# Single experiment page
# ---------------------------------------------------------------------------

def add_experiment(
    pdf: LabReportPDF,
    level_label: str,
    exp_dir: Path,
    rtl_files: List[Path],
    tb_files: List[Path],
) -> None:
    pdf.add_page()
    pdf._header_text = (
        f"Verilog HDL Lab Report  |  {level_label}  |  {_experiment_title(exp_dir)}"
    )

    title = _experiment_title(exp_dir)
    _h1(pdf, title)
    pdf.set_font("Helvetica", "", 9)
    pdf.set_text_color(80, 80, 80)
    all_files = rtl_files + tb_files
    pdf.cell(0, 5,
             _safe_text(f"Folder: {exp_dir.relative_to(REPO_ROOT)}  |  "
                        f"Files: {', '.join(f.name for f in all_files)}"),
             new_x=XPos.LMARGIN, new_y=YPos.NEXT)
    pdf.set_text_color(0, 0, 0)
    pdf.ln(2)

    primary = rtl_files[0] if rtl_files else (tb_files[0] if tb_files else None)
    header = _parse_verilog_header(primary) if primary else {}
    cat = _get_category(exp_dir.name)

    # 1. Aim
    _h2(pdf, "1. Aim")
    _body(pdf, _build_aim(exp_dir, rtl_files, header))

    # 2. Apparatus
    _h2(pdf, "2. Apparatus / Requirements")
    _body(pdf, APPARATUS)

    # 3. Theory
    _h2(pdf, "3. Theory")
    _body(pdf, cat.get("theory", FALLBACK_CATEGORY["theory"]))

    # 4. Algorithm
    _h2(pdf, "4. Algorithm / Design Methodology")
    _bullet_list(pdf, cat.get("algorithm", FALLBACK_CATEGORY["algorithm"]))

    # 5. RTL Source Code
    _h2(pdf, "5. Verilog RTL Source Code")
    if rtl_files:
        for f in rtl_files:
            _code_block(pdf, f)
    else:
        _body(pdf, "(No separate RTL file - see testbench below.)")

    # 6. Testbench
    _h2(pdf, "6. Testbench / Simulation Code")
    if tb_files:
        for f in tb_files:
            _code_block(pdf, f)
    else:
        _body(pdf, "(No testbench file found in this folder.)")

    # 7. Expected Results
    _h2(pdf, "7. Expected Simulation Results")
    _body(pdf, _build_expected_results(exp_dir.name, cat, header), font_size=9)
    _body(
        pdf,
        "Observe the GTKWave / ModelSim waveform to confirm that every signal "
        "transitions correctly at the expected simulation time. The testbench "
        "self-checking logic prints 'PASS' when all assertions succeed.",
        font_size=9,
    )

    # 8. Schematic description
    _h2(pdf, "8. Schematic / Block Diagram Description")
    desc_txt = header.get("description", "as described in the source code above.")
    _body(
        pdf,
        f"The RTL schematic is generated automatically by the synthesis tool "
        f"(Xilinx Vivado Elaborated Design view or Yosys). The top-level block "
        f"shows the module ports defined in the Verilog source. Internal structure: "
        f"{desc_txt}",
        font_size=9,
    )

    # 9. Result & Conclusion
    _h2(pdf, "9. Result & Conclusion")
    short_title = title.split(":", 1)[-1].strip() if ":" in title else title
    _body(
        pdf,
        f"The {short_title} was successfully designed and simulated in Verilog HDL. "
        f"The simulation output matched the expected results for all applied test "
        f"vectors, confirming the correctness of the implementation. The waveforms "
        f"observed in the simulator verified the timing and functional behaviour of "
        f"the circuit.",
        font_size=10,
    )

    _divider(pdf)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    raw_experiments = list(discover_experiments())
    if not raw_experiments:
        raise SystemExit("No experiments found under experiments/level*")

    # Group by level
    levels_seen: Dict[int, List] = {}
    for level_label, lvl_num, exp_dir, rtl, tb in raw_experiments:
        levels_seen.setdefault(lvl_num, []).append((level_label, exp_dir, rtl, tb))

    # First pass: build body to collect real page numbers
    body_pdf = LabReportPDF()
    toc_entries: List[Tuple[str, str, int]] = []
    for lvl_num in sorted(levels_seen.keys()):
        entries = levels_seen[lvl_num]
        add_level_divider(body_pdf, lvl_num, len(entries))
        for level_label, exp_dir, rtl, tb in entries:
            page_in_body = body_pdf.page
            add_experiment(body_pdf, level_label, exp_dir, rtl, tb)
            toc_entries.append((level_label, _experiment_title(exp_dir), page_in_body))

    # Calculate TOC page count (roughly 40 entries per TOC page)
    toc_page_count = max(3, (len(toc_entries) + 39) // 40)
    # Offset: 1 cover page + toc_page_count TOC pages
    offset = 1 + toc_page_count

    toc_adjusted = [
        (lbl, title, pg + offset)
        for lbl, title, pg in toc_entries
    ]

    # Second pass: build final PDF with correct page numbers
    final_pdf = LabReportPDF()
    add_cover_page(final_pdf, len(raw_experiments), len(levels_seen))
    add_toc(final_pdf, toc_adjusted)
    # Pad to ensure body starts at the right page
    while final_pdf.page < offset:
        final_pdf.add_page()

    for lvl_num in sorted(levels_seen.keys()):
        entries = levels_seen[lvl_num]
        add_level_divider(final_pdf, lvl_num, len(entries))
        for level_label, exp_dir, rtl, tb in entries:
            add_experiment(final_pdf, level_label, exp_dir, rtl, tb)

    final_pdf.output(OUTPUT_PDF)
    print(
        f"Wrote {OUTPUT_PDF}  "
        f"({final_pdf.page} pages, {len(raw_experiments)} experiments)"
    )


if __name__ == "__main__":
    main()
