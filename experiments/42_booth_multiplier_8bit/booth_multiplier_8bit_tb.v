// Booth Multiplier Testbench
`timescale 1ns/1ps
module booth_multiplier_8bit_tb;
    reg  clk, rst_n, start;
    reg  signed [7:0] multiplicand, multiplier;
    wire signed [15:0] product;
    wire done;

    booth_multiplier_8bit uut (
        .clk(clk),.rst_n(rst_n),.start(start),
        .multiplicand(multiplicand),.multiplier(multiplier),
        .product(product),.done(done)
    );

    always #5 clk = ~clk;

    task multiply;
        input signed [7:0] a, b;
        begin
            multiplicand=a; multiplier=b; start=1;
            @(posedge done); #1;
            if (product !== a*b)
                $display("FAIL: %0d * %0d = %0d (got %0d)", a, b, a*b, product);
            start=0; #10;
        end
    endtask

    initial begin
        $dumpfile("booth_multiplier_8bit.vcd");
        $dumpvars(0, booth_multiplier_8bit_tb);
        clk=0; rst_n=0; start=0; #12; rst_n=1;
        multiply(8'd5,   8'd7);
        multiply(-8'd3,  8'd6);
        multiply(-8'd4, -8'd4);
        multiply(8'd127, 8'd1);
        $display("Booth Multiplier test complete.");
        $finish;
    end
endmodule
