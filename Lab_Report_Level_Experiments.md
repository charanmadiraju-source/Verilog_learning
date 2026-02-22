# Lab Report – Level Experiments

This document summarizes each Verilog experiment living under the `experiments/level*` folders. Each entry points to the folder that holds the RTL and accompanying testbench (where present).

*Generated on 2026-02-22 from the repository directory structure.*

> To regenerate the full PDF lab book, run `python generate_level_lab_report.py`.
> The script walks every `experiments/level*` folder and rewrites `Lab_Report_Level_Experiments.pdf`.
>
> The generated PDF is a **comprehensive B.Tech-style lab report** (362 pages, 160 experiments) that includes for each experiment:
> - **Aim** – derived from source code comments and experiment title
> - **Apparatus / Requirements** – standard Verilog lab tools (Vivado/ModelSim/iverilog)
> - **Theory** – category-specific technical description (logic gates, arithmetic, FSMs, memories, etc.)
> - **Algorithm / Design Methodology** – step-by-step design and verification approach
> - **Verilog RTL Source Code** – full source of the RTL module(s)
> - **Testbench / Simulation Code** – full self-checking testbench source
> - **Expected Simulation Results** – truth tables and timing descriptions
> - **Schematic / Block Diagram Description** – structural description from code comments
> - **Result & Conclusion** – standardised conclusion statement
>
> **Dependencies:** `pip install fpdf2==2.8.6`

## Level 1 — Fundamentals (basic gates and simple combinational logic)

| # | Experiment | Key Files | Folder |
|---|------------|-----------|--------|
| 01 | Basic Gates Module | basic_gates.v, basic_gates_tb.v | `experiments/level1/exp01_basic_gates_module` |
| 02 | And Gate Behavioral | and_gate.v, and_gate_tb.v | `experiments/level1/exp02_and_gate_behavioral` |
| 03 | Or Gate Behavioral | or_gate.v, or_gate_tb.v | `experiments/level1/exp03_or_gate_behavioral` |
| 04 | Not Gate | not_gate.v, not_gate_tb.v | `experiments/level1/exp04_not_gate` |
| 05 | Universal Gates | universal_gates.v, universal_gates_tb.v | `experiments/level1/exp05_universal_gates` |
| 06 | Xor Gate | xor_gate.v, xor_gate_tb.v | `experiments/level1/exp06_xor_gate` |
| 07 | Half Adder | half_adder.v, half_adder_tb.v | `experiments/level1/exp07_half_adder` |
| 08 | Full Adder Gate Level | full_adder_gate.v, full_adder_gate_tb.v | `experiments/level1/exp08_full_adder_gate_level` |
| 09 | Full Adder Dataflow | full_adder_dataflow.v, full_adder_dataflow_tb.v | `experiments/level1/exp09_full_adder_dataflow` |
| 10 | Full Adder Behavioral | full_adder_behavioral.v, full_adder_behavioral_tb.v | `experiments/level1/exp10_full_adder_behavioral` |

## Level 2 — Combinational building blocks (mux/decoder/encoder/comparator)

| # | Experiment | Key Files | Folder |
|---|------------|-----------|--------|
| 11 | Mux 2to1 Gate | mux2to1_gate.v, mux2to1_gate_tb.v | `experiments/level2/exp11_mux_2to1_gate` |
| 12 | Mux 2to1 Conditional | mux2to1.v, mux2to1_tb.v | `experiments/level2/exp12_mux_2to1_conditional` |
| 13 | Mux 4to1 Dataflow | mux4to1.v, mux4to1_tb.v | `experiments/level2/exp13_mux_4to1_dataflow` |
| 14 | Mux 8to1 Behavioral | mux8to1.v, mux8to1_tb.v | `experiments/level2/exp14_mux_8to1_behavioral` |
| 15 | Mux 16to1 Hierarchical | mux16to1.v, mux16to1_tb.v | `experiments/level2/exp15_mux_16to1_hierarchical` |
| 16 | Decoder 2to4 | decoder_2to4.v, decoder_2to4_tb.v | `experiments/level2/exp16_decoder_2to4` |
| 17 | Decoder 3to8 Enable | decoder_3to8.v, decoder_3to8_tb.v | `experiments/level2/exp17_decoder_3to8_enable` |
| 18 | Encoder 4to2 Priority | encoder_4to2.v, encoder_4to2_tb.v | `experiments/level2/exp18_encoder_4to2_priority` |
| 19 | Encoder 8to3 Priority | encoder_8to3.v, encoder_8to3_tb.v | `experiments/level2/exp19_encoder_8to3_priority` |
| 20 | Comparator 1bit | comparator_1bit.v, comparator_1bit_tb.v | `experiments/level2/exp20_comparator_1bit` |
| 21 | Comparator 2bit | comparator_2bit.v, comparator_2bit_tb.v | `experiments/level2/exp21_comparator_2bit` |
| 22 | Comparator 4bit Dataflow | comparator_4bit.v, comparator_4bit_tb.v | `experiments/level2/exp22_comparator_4bit_dataflow` |
| 23 | Multiplier 2bit | multiplier_2bit.v, multiplier_2bit_tb.v | `experiments/level2/exp23_multiplier_2bit` |
| 24 | BCD to 7seg | bcd_to_7seg.v, bcd_to_7seg_tb.v | `experiments/level2/exp24_bcd_to_7seg` |
| 25 | Parity Generator | parity_gen.v, parity_gen_tb.v | `experiments/level2/exp25_parity_generator` |

## Level 3 — Arithmetic datapaths (adders, subtractors, multipliers)

| # | Experiment | Key Files | Folder |
|---|------------|-----------|--------|
| 26 | Rca 4bit Hierarchical | rca_4bit.v, rca_4bit_tb.v | `experiments/level3/exp26_rca_4bit_hierarchical` |
| 27 | Rca 4bit Dataflow | rca_4bit_df.v, rca_4bit_df_tb.v | `experiments/level3/exp27_rca_4bit_dataflow` |
| 28 | Rca 8bit | rca_8bit.v, rca_8bit_tb.v | `experiments/level3/exp28_rca_8bit` |
| 29 | Cla 4bit | cla_4bit.v, cla_4bit_tb.v | `experiments/level3/exp29_cla_4bit` |
| 30 | Cla 16bit | cla_16bit.v, cla_16bit_tb.v | `experiments/level3/exp30_cla_16bit` |
| 31 | Subtractor 4bit | subtractor_4bit.v, subtractor_4bit_tb.v | `experiments/level3/exp31_subtractor_4bit` |
| 32 | Adder Subtractor 4bit | adder_subtractor_4bit.v, adder_subtractor_4bit_tb.v | `experiments/level3/exp32_adder_subtractor_4bit` |
| 33 | BCD Adder | bcd_adder.v, bcd_adder_tb.v | `experiments/level3/exp33_bcd_adder` |
| 34 | BCD Adder 2digit | bcd_adder_2digit.v, bcd_adder_2digit_tb.v | `experiments/level3/exp34_bcd_adder_2digit` |
| 35 | Array Multiplier 4bit | array_mult_4bit.v, array_mult_4bit_tb.v | `experiments/level3/exp35_array_multiplier_4bit` |
| 36 | Divider 4bit Restoring | divider_4bit.v, divider_4bit_tb.v | `experiments/level3/exp36_divider_4bit_restoring` |
| 37 | Comparator 4bit Egl | comparator_egl.v, comparator_egl_tb.v | `experiments/level3/exp37_comparator_4bit_egl` |
| 38 | ALU 4op | alu_4op.v, alu_4op_tb.v | `experiments/level3/exp38_alu_4op` |
| 39 | ALU 8op | alu_8op.v, alu_8op_tb.v | `experiments/level3/exp39_alu_8op` |
| 40 | Barrel Shifter 4bit | barrel_shifter_4bit.v, barrel_shifter_4bit_tb.v | `experiments/level3/exp40_barrel_shifter_4bit` |

## Level 4 — Sequential elements and registers

| # | Experiment | Key Files | Folder |
|---|------------|-----------|--------|
| 41 | Sr Latch Nand | sr_latch_nand.v, sr_latch_nand_tb.v | `experiments/level4/exp41_sr_latch_nand` |
| 42 | D Latch | d_latch.v, d_latch_tb.v | `experiments/level4/exp42_d_latch` |
| 43 | Dff Posedge | dff.v, dff_tb.v | `experiments/level4/exp43_dff_posedge` |
| 44 | Dff Async Reset | dff_async_rst.v, dff_async_rst_tb.v | `experiments/level4/exp44_dff_async_reset` |
| 45 | Dff Sync Reset | dff_sync_rst.v, dff_sync_rst_tb.v | `experiments/level4/exp45_dff_sync_reset` |
| 46 | Dff Enable | dff_en.v, dff_en_tb.v | `experiments/level4/exp46_dff_enable` |
| 47 | Dff Set Reset | dff_sr.v, dff_sr_tb.v | `experiments/level4/exp47_dff_set_reset` |
| 48 | Tff | tff.v, tff_tb.v | `experiments/level4/exp48_tff` |
| 49 | Jkff | jkff.v, jkff_tb.v | `experiments/level4/exp49_jkff` |
| 50 | Register 8bit | register_8bit.v, register_8bit_tb.v | `experiments/level4/exp50_register_8bit` |
| 51 | Siso 8bit | siso_8bit.v, siso_8bit_tb.v | `experiments/level4/exp51_siso_8bit` |
| 52 | Piso 8bit | piso_8bit.v, piso_8bit_tb.v | `experiments/level4/exp52_piso_8bit` |
| 53 | Sipo 8bit | sipo_8bit.v, sipo_8bit_tb.v | `experiments/level4/exp53_sipo_8bit` |
| 54 | Bidir Shift 8bit | bidir_shift_8bit.v, bidir_shift_8bit_tb.v | `experiments/level4/exp54_bidir_shift_8bit` |
| 55 | Regfile 8X8 | regfile_8x8.v, regfile_8x8_tb.v | `experiments/level4/exp55_regfile_8x8` |

## Level 5 — Counters, shift logic, and timing

| # | Experiment | Key Files | Folder |
|---|------------|-----------|--------|
| 56 | Counter Up 4bit | counter_up_4bit.v, counter_up_4bit_tb.v | `experiments/level5/exp56_counter_up_4bit` |
| 57 | Counter Down 4bit | counter_down_4bit.v, counter_down_4bit_tb.v | `experiments/level5/exp57_counter_down_4bit` |
| 58 | Counter Updown 4bit | counter_updown_4bit.v, counter_updown_4bit_tb.v | `experiments/level5/exp58_counter_updown_4bit` |
| 59 | Counter Load Enable | counter_load_en.v, counter_load_en_tb.v | `experiments/level5/exp59_counter_load_enable` |
| 60 | Counter 8bit Tc | counter_8bit_tc.v, counter_8bit_tc_tb.v | `experiments/level5/exp60_counter_8bit_tc` |
| 61 | Counter Mod N | counter_mod_n.v, counter_mod_n_tb.v | `experiments/level5/exp61_counter_mod_n` |
| 62 | BCD Counter | bcd_counter.v, bcd_counter_tb.v | `experiments/level5/exp62_bcd_counter` |
| 63 | BCD Counter 2digit | bcd_counter_2digit.v, bcd_counter_2digit_tb.v | `experiments/level5/exp63_bcd_counter_2digit` |
| 64 | Ring Counter 4bit | ring_counter_4bit.v, ring_counter_4bit_tb.v | `experiments/level5/exp64_ring_counter_4bit` |
| 65 | Johnson Counter 4bit | johnson_counter_4bit.v, johnson_counter_4bit_tb.v | `experiments/level5/exp65_johnson_counter_4bit` |
| 66 | LFSR 4bit | lfsr_4bit.v, lfsr_4bit_tb.v | `experiments/level5/exp66_lfsr_4bit` |
| 67 | LFSR 8bit | lfsr_8bit.v, lfsr_8bit_tb.v | `experiments/level5/exp67_lfsr_8bit` |
| 68 | Delay Counter | delay_counter.v, delay_counter_tb.v | `experiments/level5/exp68_delay_counter` |
| 69 | Freq Divider | freq_divider.v, freq_divider_tb.v | `experiments/level5/exp69_freq_divider` |
| 70 | Prog Freq Divider | prog_freq_divider.v, prog_freq_divider_tb.v | `experiments/level5/exp70_prog_freq_divider` |

## Level 6 — Finite-state machines and control paths

| # | Experiment | Key Files | Folder |
|---|------------|-----------|--------|
| 71 | Simple Moore FSM | simple_moore_fsm.v, simple_moore_fsm_tb.v | `experiments/level6/exp71_simple_moore_fsm` |
| 72 | Seq Detect 101 Moore | seq_det_101_moore.v, seq_det_101_moore_tb.v | `experiments/level6/exp72_seq_detect_101_moore` |
| 73 | Seq Detect 1011 Moore | seq_det_1011_moore.v, seq_det_1011_moore_tb.v | `experiments/level6/exp73_seq_detect_1011_moore` |
| 74 | Seq Detect 1101 Mealy | seq_det_1101_mealy.v, seq_det_1101_mealy_tb.v | `experiments/level6/exp74_seq_detect_1101_mealy` |
| 75 | Traffic Light | traffic_light.v, traffic_light_tb.v | `experiments/level6/exp75_traffic_light` |
| 76 | Traffic Light Pedestrian | traffic_light_ped.v, traffic_light_ped_tb.v | `experiments/level6/exp76_traffic_light_pedestrian` |
| 77 | Vending Machine Simple | vending_machine.v, vending_machine_tb.v | `experiments/level6/exp77_vending_machine_simple` |
| 78 | Vending Machine Complex | vending_complex.v, vending_complex_tb.v | `experiments/level6/exp78_vending_machine_complex` |
| 79 | Elevator 2floor | elevator_2floor.v, elevator_2floor_tb.v | `experiments/level6/exp79_elevator_2floor` |
| 80 | Elevator 4floor | elevator_4floor.v, elevator_4floor_tb.v | `experiments/level6/exp80_elevator_4floor` |
| 81 | Washing Machine | washing_machine.v, washing_machine_tb.v | `experiments/level6/exp81_washing_machine` |
| 82 | Password Lock | password_lock.v, password_lock_tb.v | `experiments/level6/exp82_password_lock` |
| 83 | UART Tx | uart_tx.v, uart_tx_tb.v | `experiments/level6/exp83_uart_tx` |
| 84 | UART Rx | uart_rx.v, uart_rx_tb.v | `experiments/level6/exp84_uart_rx` |
| 85 | SPI Simple FSM | spi_master_fsm.v, spi_master_fsm_tb.v | `experiments/level6/exp85_spi_simple_fsm` |

## Level 7 — Memories, FIFOs, and buffering

| # | Experiment | Key Files | Folder |
|---|------------|-----------|--------|
| 86 | RAM 8X8 Async | ram_8x8_async.v, ram_8x8_async_tb.v | `experiments/level7/exp86_ram_8x8_async` |
| 87 | RAM 16X8 Sync | ram_16x8_sync.v, ram_16x8_sync_tb.v | `experiments/level7/exp87_ram_16x8_sync` |
| 88 | RAM 8X8 Dual Port | ram_dp.v, ram_dp_tb.v | `experiments/level7/exp88_ram_8x8_dual_port` |
| 89 | RAM 8X8 True Dual Port | ram_tdp.v, ram_tdp_tb.v | `experiments/level7/exp89_ram_8x8_true_dual_port` |
| 90 | ROM 32X8 | rom_32x8.v, rom_32x8_tb.v | `experiments/level7/exp90_rom_32x8` |
| 91 | Sync FIFO | sync_fifo.v, sync_fifo_tb.v | `experiments/level7/exp91_sync_fifo` |
| 92 | Async FIFO | async_fifo.v, async_fifo_tb.v | `experiments/level7/exp92_async_fifo` |
| 93 | LIFO Stack | lifo_stack.v, lifo_stack_tb.v | `experiments/level7/exp93_lifo_stack` |
| 94 | CAM 4X4 | cam_4x4.v, cam_4x4_tb.v | `experiments/level7/exp94_cam_4x4` |
| 95 | Cache Direct Mapped | cache_direct.v, cache_direct_tb.v | `experiments/level7/exp95_cache_direct_mapped` |

## Level 8 — Advanced arithmetic algorithms and DSP cores

| # | Experiment | Key Files | Folder |
|---|------------|-----------|--------|
| 96 | Carry Save Adder 8bit | csa_8bit.v, csa_8bit_tb.v | `experiments/level8/exp96_carry_save_adder_8bit` |
| 97 | Wallace Tree Mult 4bit | wallace_tree_mult_4bit.v, wallace_tree_mult_4bit_tb.v | `experiments/level8/exp97_wallace_tree_mult_4bit` |
| 98 | Sequential Multiplier | seq_multiplier.v, seq_multiplier_tb.v | `experiments/level8/exp98_sequential_multiplier` |
| 99 | Booth Encoder | booth_encoder.v, booth_encoder_tb.v | `experiments/level8/exp99_booth_encoder` |
| 100 | Radix4 Booth Mult | radix4_booth_mult.v, radix4_booth_mult_tb.v | `experiments/level8/exp100_radix4_booth_mult` |
| 101 | Restoring Division 8bit | restoring_div.v, restoring_div_tb.v | `experiments/level8/exp101_restoring_division_8bit` |
| 102 | Nonrestoring Division | nonrestoring_div.v, nonrestoring_div_tb.v | `experiments/level8/exp102_nonrestoring_division` |
| 103 | Srt Division | srt_div.v, srt_div_tb.v | `experiments/level8/exp103_srt_division` |
| 104 | Integer Sqrt | integer_sqrt.v, integer_sqrt_tb.v | `experiments/level8/exp104_integer_sqrt` |
| 105 | Fixed Point Adder | fp_adder_q44.v, fp_adder_q44_tb.v | `experiments/level8/exp105_fixed_point_adder` |
| 106 | Fixed Point Multiplier | fp_mult_q44.v, fp_mult_q44_tb.v | `experiments/level8/exp106_fixed_point_multiplier` |
| 107 | Fp16 Adder | fp16_adder.v, fp16_adder_tb.v | `experiments/level8/exp107_fp16_adder` |
| 108 | Fp16 Multiplier | fp16_mult.v, fp16_mult_tb.v | `experiments/level8/exp108_fp16_multiplier` |
| 109 | Cordic Rotation | cordic_rotation.v, cordic_rotation_tb.v | `experiments/level8/exp109_cordic_rotation` |
| 110 | Cordic Vectoring | cordic_vectoring.v, cordic_vectoring_tb.v | `experiments/level8/exp110_cordic_vectoring` |

## Level 9 — Pipelined datapaths and microarchitecture

| # | Experiment | Key Files | Folder |
|---|------------|-----------|--------|
| 111 | Pipeline 2stage Adder | pipe_adder_2stage.v, pipe_adder_2stage_tb.v | `experiments/level9/exp111_pipeline_2stage_adder` |
| 112 | Pipeline 4stage Mult | pipe_mult_4stage.v, pipe_mult_4stage_tb.v | `experiments/level9/exp112_pipeline_4stage_mult` |
| 113 | Pipeline FIR Filter | fir_filter_4tap.v, fir_filter_4tap_tb.v | `experiments/level9/exp113_pipeline_fir_filter` |
| 114 | Parallel Prefix Adder | kogge_stone_4bit.v, kogge_stone_4bit_tb.v | `experiments/level9/exp114_parallel_prefix_adder` |
| 115 | Superscalar ALU | superscalar_alu.v, superscalar_alu_tb.v | `experiments/level9/exp115_superscalar_alu` |
| 116 | Datapath Pipeline 4stage | datapath_pipe.v, datapath_pipe_tb.v | `experiments/level9/exp116_datapath_pipeline_4stage` |
| 117 | Hazard Detection | hazard_detect.v, hazard_detect_tb.v | `experiments/level9/exp117_hazard_detection` |
| 118 | Forwarding Unit | forwarding_unit.v, forwarding_unit_tb.v | `experiments/level9/exp118_forwarding_unit` |
| 119 | Branch Predictor | branch_predictor.v, branch_predictor_tb.v | `experiments/level9/exp119_branch_predictor` |
| 120 | Out Of Order Issue | ooo_issue.v, ooo_issue_tb.v | `experiments/level9/exp120_out_of_order_issue` |

## Level 10 — Subsystem IP and digital interfaces

| # | Experiment | Key Files | Folder |
|---|------------|-----------|--------|
| 121 | Risc Cpu 4instr | risc4.v, risc4_tb.v | `experiments/level10/exp121_risc_cpu_4instr` |
| 122 | Risc Cpu 8instr | risc8.v, risc8_tb.v | `experiments/level10/exp122_risc_cpu_8instr` |
| 123 | VGA Sync | vga_sync.v, vga_sync_tb.v | `experiments/level10/exp123_vga_sync` |
| 124 | PWM Controller | pwm_ctrl.v, pwm_ctrl_tb.v | `experiments/level10/exp124_pwm_controller` |
| 125 | SPI Master | spi_master.v, spi_master_tb.v | `experiments/level10/exp125_spi_master` |
| 126 | I2C Master | i2c_master_simple.v, i2c_master_simple_tb.v | `experiments/level10/exp126_i2c_master` |
| 127 | UART FIFO | uart_fifo_top.v, uart_fifo_top_tb.v | `experiments/level10/exp127_uart_fifo` |
| 128 | DMA Controller Simple | dma_simple.v, dma_simple_tb.v | `experiments/level10/exp128_dma_controller_simple` |
| 129 | Interrupt Controller | irq_ctrl.v, irq_ctrl_tb.v | `experiments/level10/exp129_interrupt_controller` |
| 130 | Timer Watchdog | timer_wdog.v, timer_wdog_tb.v | `experiments/level10/exp130_timer_watchdog` |
| 131 | LFSR CRC | crc8.v, crc8_tb.v | `experiments/level10/exp131_lfsr_crc` |
| 132 | Hamming Encoder | hamming_enc.v, hamming_enc_tb.v | `experiments/level10/exp132_hamming_encoder` |
| 133 | Hamming Decoder | hamming_dec.v, hamming_dec_tb.v | `experiments/level10/exp133_hamming_decoder` |
| 134 | Conv Encoder | conv_enc.v, conv_enc_tb.v | `experiments/level10/exp134_conv_encoder` |
| 135 | Viterbi Decoder | viterbi_dec.v, viterbi_dec_tb.v | `experiments/level10/exp135_viterbi_decoder` |
| 136 | Manchester Encoder | manchester_enc.v, manchester_enc_tb.v | `experiments/level10/exp136_manchester_encoder` |
| 137 | Nrz Encoder | nrz_enc.v, nrz_enc_tb.v | `experiments/level10/exp137_nrz_encoder` |
| 138 | AXI Lite Slave | axi_lite_slave.v, axi_lite_slave_tb.v | `experiments/level10/exp138_axi_lite_slave` |
| 139 | Wishbone Slave | wb_slave.v, wb_slave_tb.v | `experiments/level10/exp139_wishbone_slave` |
| 140 | DSP MAC | dsp_mac.v, dsp_mac_tb.v | `experiments/level10/exp140_dsp_mac` |

## Level 11 — Verification infrastructure

| # | Experiment | Key Files | Folder |
|---|------------|-----------|--------|
| 141 | Assertion Based Tb | fifo_with_assertions.v, fifo_with_assertions_tb.v | `experiments/level11/exp141_assertion_based_tb` |
| 142 | Functional Coverage | alu_coverage.v, alu_coverage_tb.v | `experiments/level11/exp142_functional_coverage` |
| 143 | Constrained Random | crv_adder_tb.v | `experiments/level11/exp143_constrained_random` |
| 144 | Protocol Checker | valid_ready_checker.v, valid_ready_checker_tb.v | `experiments/level11/exp144_protocol_checker` |
| 145 | Scoreboard Comparator | scoreboard.v, scoreboard_tb.v | `experiments/level11/exp145_scoreboard_comparator` |
| 146 | Clock Domain Crossing Check | cdc_checker.v, cdc_checker_tb.v | `experiments/level11/exp146_clock_domain_crossing_check` |
| 147 | Timing Constraint Checker | setup_hold_checker.v, setup_hold_checker_tb.v | `experiments/level11/exp147_timing_constraint_checker` |
| 148 | Power Aware Tb | power_monitor.v, power_monitor_tb.v | `experiments/level11/exp148_power_aware_tb` |
| 149 | Formal Property | formal_counter_props.v, formal_counter_props_tb.v | `experiments/level11/exp149_formal_property` |
| 150 | Self Checking Tb | self_checking_adder_tb.v | `experiments/level11/exp150_self_checking_tb` |

## Level 12 — SoC integration and system control

| # | Experiment | Key Files | Folder |
|---|------------|-----------|--------|
| 151 | SOC Bus Interconnect | soc_bus.v, soc_bus_tb.v | `experiments/level12/exp151_soc_bus_interconnect` |
| 152 | Memory Controller | mem_ctrl.v, mem_ctrl_tb.v | `experiments/level12/exp152_memory_controller` |
| 153 | Gpio Controller | gpio_ctrl.v, gpio_ctrl_tb.v | `experiments/level12/exp153_gpio_controller` |
| 154 | UART With Interrupt | uart_irq.v, uart_irq_tb.v | `experiments/level12/exp154_uart_with_interrupt` |
| 155 | SPI With DMA | spi_dma.v, spi_dma_tb.v | `experiments/level12/exp155_spi_with_dma` |
| 156 | I2C With Controller | i2c_ctrl.v, i2c_ctrl_tb.v | `experiments/level12/exp156_i2c_with_controller` |
| 157 | AXI Crossbar 2X2 | axi_crossbar_2x2.v, axi_crossbar_2x2_tb.v | `experiments/level12/exp157_axi_crossbar_2x2` |
| 158 | System Timer | sys_timer.v, sys_timer_tb.v | `experiments/level12/exp158_system_timer` |
| 159 | Power Management | power_mgmt.v, power_mgmt_tb.v | `experiments/level12/exp159_power_management` |
| 160 | Complete SOC | complete_soc.v, complete_soc_tb.v | `experiments/level12/exp160_complete_soc` |
