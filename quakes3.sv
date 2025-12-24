`timescale 1ns/1ps

module fast_inv_sqrt_sim (x_bits, y_bits);
     input  [63:0] x_bits;
     output [63:0] y_bits;

    // Internal variables
    real x;
    real x2;
    real y0;
    real y;

    // 64-bit version of the bit-hack for double-precision (real) simulation.
    // Reference constant often used for a double analogue of the Quake trick.
    // Note: This remains a simulation trick; not synthesizable.
    reg [63:0] i64;
    localparam [63:0] MAGIC64 = 64'h5fe6eb50c7b537a9;

    always @(*) begin
        x = $bitstoreal(x_bits);

        // Step 1: Initial approximation
        x2 = x * 0.5;
        y0 = x;

        // Step 2: Bit-level hack on double
        i64 = $realtobits(y0);
        i64 = MAGIC64 - (i64 >> 1);
        y0  = $bitstoreal(i64);

        // Step 3: Newton-Raphson iterations (2 improves accuracy)
        y = y0 * (1.5 - (x2 * y0 * y0));
        y = y  * (1.5 - (x2 * y  * y ));
    end

    assign y_bits = $realtobits(y);

endmodule
