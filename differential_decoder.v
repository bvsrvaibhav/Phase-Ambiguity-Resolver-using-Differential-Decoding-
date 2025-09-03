`timescale 1 ns/ 1 ps

module differential_decoder (
    input wire clk,
    input wire rst,
    input wire delta_k,
    input wire delta_k_plus1,
    output reg b2k,
    output reg b2k_plus1
);

    // Shift registers for delta history
    reg [1:0] delta_current;  // {?2k, ?2k+1}
    reg [1:0] delta_prev1;    // {?2k-1, ?2k}
    reg [1:0] delta_prev2;    // {?2k-2, ?2k-1}

    wire [3:0] state;
    assign state = {delta_prev2, delta_prev1};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            delta_current <= 2'b00;
            delta_prev1 <= 2'b00;
            delta_prev2 <= 2'b00;
            b2k <= 0;
            b2k_plus1 <= 0;
        end else begin
            // Shift previous values
            delta_prev2 <= delta_prev1;
            delta_prev1 <= delta_current;
            delta_current <= {delta_k, delta_k_plus1};

            // Lookup table based on 4-bit state {?2k-2, ?2k-1, ?2k, ?2k+1}
            case (state)
                4'b0000: {b2k, b2k_plus1} <= 2'b00;
                4'b0001: {b2k, b2k_plus1} <= 2'b01;
                4'b0010: {b2k, b2k_plus1} <= 2'b10;
                4'b0011: {b2k, b2k_plus1} <= 2'b11;
                4'b0100: {b2k, b2k_plus1} <= 2'b10;
                4'b0101: {b2k, b2k_plus1} <= 2'b00;
                4'b0110: {b2k, b2k_plus1} <= 2'b11;
                4'b0111: {b2k, b2k_plus1} <= 2'b01;
                4'b1000: {b2k, b2k_plus1} <= 2'b01;
                4'b1001: {b2k, b2k_plus1} <= 2'b11;
                4'b1010: {b2k, b2k_plus1} <= 2'b00;
                4'b1011: {b2k, b2k_plus1} <= 2'b10;
                4'b1100: {b2k, b2k_plus1} <= 2'b11;
                4'b1101: {b2k, b2k_plus1} <= 2'b10;
                4'b1110: {b2k, b2k_plus1} <= 2'b01;
                4'b1111: {b2k, b2k_plus1} <= 2'b00;
                default: {b2k, b2k_plus1} <= 2'b00;
            endcase
        end
    end

endmodule
