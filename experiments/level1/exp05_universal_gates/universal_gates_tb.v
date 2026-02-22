// Testbench: Experiment 5 – Universal Gates (NAND/NOR as NOT, AND, OR)
`timescale 1ns/1ps
module universal_gates_tb;
    reg  a, b;
    wire nand_not_a, nand_and, nand_or;
    wire nor_not_a,  nor_and,  nor_or;

    universal_gates uut (
        .a(a), .b(b),
        .nand_not_a(nand_not_a), .nand_and(nand_and), .nand_or(nand_or),
        .nor_not_a(nor_not_a),   .nor_and(nor_and),   .nor_or(nor_or)
    );

    integer errors = 0;

    task check_row;
        input exp_not, exp_and, exp_or;
        begin
            // NAND-based
            if (nand_not_a !== exp_not) begin $display("FAIL NAND-NOT  a=%b b=%b: got %b exp %b", a, b, nand_not_a, exp_not); errors = errors + 1; end
            if (nand_and   !== exp_and) begin $display("FAIL NAND-AND  a=%b b=%b: got %b exp %b", a, b, nand_and,   exp_and); errors = errors + 1; end
            if (nand_or    !== exp_or)  begin $display("FAIL NAND-OR   a=%b b=%b: got %b exp %b", a, b, nand_or,    exp_or);  errors = errors + 1; end
            // NOR-based
            if (nor_not_a !== exp_not) begin $display("FAIL NOR-NOT   a=%b b=%b: got %b exp %b", a, b, nor_not_a, exp_not); errors = errors + 1; end
            if (nor_and   !== exp_and) begin $display("FAIL NOR-AND   a=%b b=%b: got %b exp %b", a, b, nor_and,   exp_and); errors = errors + 1; end
            if (nor_or    !== exp_or)  begin $display("FAIL NOR-OR    a=%b b=%b: got %b exp %b", a, b, nor_or,    exp_or);  errors = errors + 1; end
        end
    endtask

    initial begin
        $dumpfile("universal_gates.vcd");
        $dumpvars(0, universal_gates_tb);

        // a b | NOT-a  AND  OR
        a=0; b=0; #10; check_row(1, 0, 0);
        a=0; b=1; #10; check_row(1, 0, 1);
        a=1; b=0; #10; check_row(0, 0, 1);
        a=1; b=1; #10; check_row(0, 1, 1);

        if (errors == 0)
            $display("PASS: Universal gates test complete.");
        else
            $display("FAIL: %0d error(s) detected.", errors);
        $finish;
    end
endmodule
