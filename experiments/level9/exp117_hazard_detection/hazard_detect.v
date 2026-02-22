// Experiment 117: Hazard Detection Unit
// Detects RAW (Read After Write) hazards in a pipeline.
// Stalls if EX stage register = ID stage source register.
// Inputs : ex_rd[4:0], id_rs[4:0], id_rt[4:0], ex_memread
// Outputs: stall
module hazard_detect (
    input  [4:0] ex_rd, id_rs, id_rt,
    input        ex_memread,
    output       stall
);
    assign stall = ex_memread &&
                   ((ex_rd == id_rs) || (ex_rd == id_rt));
endmodule
