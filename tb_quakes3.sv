`timescale 1ns/1ps

module tb_fast_inv_sqrt_sim;

    real x;
    reg  [63:0] x_bits;
    wire [63:0] y_bits;
    real y;

    fast_inv_sqrt_sim dut (
        .x_bits(x_bits),
        .y_bits(y_bits)
    );

    always @(*) y = $bitstoreal(y_bits);

    initial begin
        $display("Fast Inverse Square Root Simulation");
        $display("----------------------------------");

        x = 4.0;
        x_bits = $realtobits(x);
        #10;
        $display("Input: %f  |  1/sqrt(x) ≈ %f", x, y);

        x = 9.0;
        x_bits = $realtobits(x);
        #10;
        $display("Input: %f  |  1/sqrt(x) ≈ %f", x, y);

        x = 2.0;
        x_bits = $realtobits(x);
        #10;
        $display("Input: %f  |  1/sqrt(x) ≈ %f", x, y);

        x = 0.25;
        x_bits = $realtobits(x);
        #10;
        $display("Input: %f  |  1/sqrt(x) ≈ %f", x, y);

        $finish;
    end

endmodule
