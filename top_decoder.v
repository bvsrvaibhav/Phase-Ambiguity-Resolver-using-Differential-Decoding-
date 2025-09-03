module top_decoder (
    input wire clk,
    input wire rst,
    output wire [1:0] out  // {b2k, b2k_plus1}
);

    // Address counter
    reg [2:0] addr;

    // Output from BRAM
    wire [7:0] douta;  // BRAM data output
    wire delta_k;
    wire delta_k_plus1;

    // Decoder outputs
    wire b2k;
    wire b2k_plus1;

    // Assign only lower 2 bits of douta to delta_k and delta_k_plus1
    assign delta_k       = douta[1];  // MSB of the 2-bit input
    assign delta_k_plus1 = douta[0];  // LSB
    assign out = {b2k, b2k_plus1};

    // Instantiate BRAM IP
    blk_mem_gen_0 your_instance_name (
        .clka(clk),        // input wire clka
        .ena(1'b1),        // always enabled
        .wea(1'b0),        // no write, read-only mode
        .addra(addr),      // address input
        .dina(8'b0),       // not used (no write)
        .douta(douta)      // output data
    );

    // Increment address every clock
    always @(posedge clk or posedge rst) begin
        if (rst)
            addr <= 0;
        else if (addr < 7)
            addr <= addr + 1;
    end

    // Instantiate the decoder
    differential_decoder decoder_inst (
        .clk(clk),
        .rst(rst),
        .delta_k(delta_k),
        .delta_k_plus1(delta_k_plus1),
        .b2k(b2k),
        .b2k_plus1(b2k_plus1)
    );

endmodule