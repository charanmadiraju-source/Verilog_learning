// Experiment 30: 16-bit Carry Lookahead Adder (Hierarchical)
// Four 4-bit CLA blocks chained together with group propagate/generate.
// Inputs : a[15:0], b[15:0], cin
// Outputs: sum[15:0], cout
module cla_4bit_h (
    input  [3:0] a, b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    wire [3:0] g, p; wire [4:0] c;
    assign g=a&b; assign p=a^b; assign c[0]=cin;
    assign c[1]=g[0]|(p[0]&c[0]);
    assign c[2]=g[1]|(p[1]&g[0])|(p[1]&p[0]&c[0]);
    assign c[3]=g[2]|(p[2]&g[1])|(p[2]&p[1]&g[0])|(p[2]&p[1]&p[0]&c[0]);
    assign c[4]=g[3]|(p[3]&g[2])|(p[3]&p[2]&g[1])|(p[3]&p[2]&p[1]&g[0])|(p[3]&p[2]&p[1]&p[0]&c[0]);
    assign sum=p^c[3:0]; assign cout=c[4];
endmodule

module cla_16bit (
    input  [15:0] a, b,
    input         cin,
    output [15:0] sum,
    output        cout
);
    wire c1,c2,c3;
    cla_4bit_h b0(.a(a[3:0]), .b(b[3:0]), .cin(cin),.sum(sum[3:0]), .cout(c1));
    cla_4bit_h b1(.a(a[7:4]), .b(b[7:4]), .cin(c1), .sum(sum[7:4]), .cout(c2));
    cla_4bit_h b2(.a(a[11:8]),.b(b[11:8]),.cin(c2), .sum(sum[11:8]),.cout(c3));
    cla_4bit_h b3(.a(a[15:12]),.b(b[15:12]),.cin(c3),.sum(sum[15:12]),.cout(cout));
endmodule
