// I2C Master (simplified, single-byte write)
// Generates START, address+W, data byte, STOP
module i2c_master (
    input        clk,
    input        rst_n,
    input        start,
    input  [6:0] addr,
    input  [7:0] data,
    output reg   scl,
    output reg   sda,
    output reg   done
);
    localparam IDLE=0,START_BIT=1,ADDR=2,ACK1=3,DATA=4,ACK2=5,STOP=6;
    reg [2:0] state;
    reg [3:0] bit_cnt;
    reg [7:0] shift;
    reg [1:0] phase;  // 0=SCL low, 1=SCL rising, 2=SCL high, 3=SCL falling

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scl<=1; sda<=1; done<=0; state<=IDLE; bit_cnt<=0; phase<=0;
        end else begin
            done <= 0;
            case (state)
                IDLE: if (start) begin sda<=0; state<=START_BIT; phase<=0; end
                START_BIT: begin
                    scl<=0; state<=ADDR; bit_cnt<=7;
                    shift<={addr, 1'b0};  // R/W=0 (write)
                end
                ADDR: begin
                    sda <= shift[7]; shift <= {shift[6:0],1'b0};
                    scl  <= ~scl;
                    if (scl && bit_cnt==0) begin state<=ACK1; scl<=0; end
                    else if (!scl) bit_cnt <= bit_cnt - 1'b1;
                end
                ACK1: begin scl<=1; state<=DATA; bit_cnt<=7; shift<=data; end
                DATA: begin
                    sda <= shift[7]; shift <= {shift[6:0],1'b0};
                    scl  <= ~scl;
                    if (scl && bit_cnt==0) begin state<=ACK2; scl<=0; end
                    else if (!scl) bit_cnt <= bit_cnt - 1'b1;
                end
                ACK2: begin scl<=1; state<=STOP; sda<=0; end
                STOP: begin sda<=1; done<=1; state<=IDLE; end
            endcase
        end
    end
endmodule
