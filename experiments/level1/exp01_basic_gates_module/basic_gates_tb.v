// Testbench: Experiment 1 – Basic Gates Module
`timescale 1ns/1ps
module basic_gates_tb;
    reg  a, b;
    wire out_and, out_or, out_not, out_nand, out_nor, out_xor, out_xnor;

    basic_gates uut (
        .a(a), .b(b),
        .out_and(out_and), .out_or(out_or),  .out_not(out_not),
        .out_nand(out_nand), .out_nor(out_nor),
        .out_xor(out_xor),  .out_xnor(out_xnor)
    );

    integer errors = 0;

    task check;
        input exp_and, exp_or, exp_not, exp_nand, exp_nor, exp_xor, exp_xnor;
        begin
            if (out_and  !== exp_and)  begin $display("FAIL AND  a=%b b=%b: got %b exp %b", a, b, out_and,  exp_and);  errors = errors + 1; end
            if (out_or   !== exp_or)   begin $display("FAIL OR   a=%b b=%b: got %b exp %b", a, b, out_or,   exp_or);   errors = errors + 1; end
            if (out_not  !== exp_not)  begin $display("FAIL NOT  a=%b b=%b: got %b exp %b", a, b, out_not,  exp_not);  errors = errors + 1; end
            if (out_nand !== exp_nand) begin $display("FAIL NAND a=%b b=%b: got %b exp %b", a, b, out_nand, exp_nand); errors = errors + 1; end
            if (out_nor  !== exp_nor)  begin $display("FAIL NOR  a=%b b=%b: got %b exp %b", a, b, out_nor,  exp_nor);  errors = errors + 1; end
            if (out_xor  !== exp_xor)  begin $display("FAIL XOR  a=%b b=%b: got %b exp %b", a, b, out_xor,  exp_xor);  errors = errors + 1; end
            if (out_xnor !== exp_xnor) begin $display("FAIL XNOR a=%b b=%b: got %b exp %b", a, b, out_xnor, exp_xnor); errors = errors + 1; end
        end
    endtask

    initial begin
        $dumpfile("basic_gates.vcd");
        $dumpvars(0, basic_gates_tb);

        // a b | AND OR  NOT NAND NOR XOR XNOR
        a=0; b=0; #10; check(0, 0, 1, 1, 1, 0, 1);
        a=0; b=1; #10; check(0, 1, 1, 1, 0, 1, 0);
        a=1; b=0; #10; check(0, 1, 0, 1, 0, 1, 0);
        a=1; b=1; #10; check(1, 1, 0, 0, 0, 0, 1);

        if (errors == 0)
            $display("PASS: All basic gate tests passed.");
        else
            $display("FAIL: %0d error(s) detected.", errors);
        $finish;
    end
endmodule
