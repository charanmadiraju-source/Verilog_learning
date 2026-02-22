// Full Subtractor Testbench
`timescale 1ns/1ps
module full_subtractor_tb;
    reg  a, b, bin;
    wire diff, bout;

    full_subtractor uut (.a(a), .b(b), .bin(bin), .diff(diff), .bout(bout));

    integer i;
    reg signed [2:0] res;

    initial begin
        $dumpfile("full_subtractor.vcd");
        $dumpvars(0, full_subtractor_tb);
        for (i = 0; i < 8; i = i + 1) begin
            {a, b, bin} = i[2:0]; #10;
            res = a - b - bin;
            if (diff !== res[0] || bout !== (res[2]))
                $display("FAIL: a=%b b=%b bin=%b -> diff=%b bout=%b",
                         a, b, bin, diff, bout);
        end
        $display("Full subtractor test complete.");
        $finish;
    end
endmodule
