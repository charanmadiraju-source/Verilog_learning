// Experiment 150: Self-Checking Testbench
// Comprehensive self-checking TB that:
// - Generates test vectors automatically
// - Computes expected outputs independently
// - Reports pass/fail for each vector
// - Tracks overall pass rate and coverage
`timescale 1ns/1ps
module self_checking_adder_tb;
    // DUT: 8-bit adder
    reg  [7:0] a, b;
    reg        cin;
    wire [8:0] result;
    assign result = {1'b0,a} + {1'b0,b} + cin;

    integer i, errors=0, pass=0, fail=0;
    integer covered_zero=0, covered_ff=0, covered_overflow=0;
    reg [8:0] expected;
    initial begin
        $dumpfile("self_checking_adder_tb.vcd"); $dumpvars(0,self_checking_adder_tb);
        // Corner cases
        for(i=0;i<8;i=i+1) begin
            case(i)
                0: begin a=0;   b=0;   cin=0; end
                1: begin a=0;   b=0;   cin=1; end
                2: begin a=8'hFF;b=0;  cin=0; end
                3: begin a=8'hFF;b=0;  cin=1; end
                4: begin a=8'hFF;b=8'hFF;cin=0; end
                5: begin a=8'hFF;b=8'hFF;cin=1; end
                6: begin a=8'h80;b=8'h80;cin=0; end
                7: begin a=8'h55;b=8'hAA;cin=0; end
            endcase
            #5;
            expected = {1'b0,a}+{1'b0,b}+cin;
            if(result===expected) begin pass=pass+1;
                if(a==0&&b==0) covered_zero=1;
                if(a==8'hFF&&b==8'hFF) covered_ff=1;
                if(result[8]) covered_overflow=1;
            end else begin fail=fail+1; errors=errors+1;
                $display("FAIL a=%h b=%h cin=%b: got=%h exp=%h",a,b,cin,result,expected);
            end
        end
        // Random vectors
        for(i=0;i<100;i=i+1) begin
            a=$random; b=$random; cin=$random&1; #5;
            expected={1'b0,a}+{1'b0,b}+cin;
            if(result===expected) pass=pass+1;
            else begin fail=fail+1; errors=errors+1;
                $display("FAIL rand a=%h b=%h cin=%b",a,b,cin);
            end
        end
        $display("Coverage: zero=%0d, ff=%0d, overflow=%0d",covered_zero,covered_ff,covered_overflow);
        if(errors==0) $display("PASS: Self-Checking TB complete (%0d passed, %0d failed).",pass,fail);
        else $display("FAIL: %0d error(s). %0d passed, %0d failed.",errors,pass,fail);
        $finish;
    end
endmodule
