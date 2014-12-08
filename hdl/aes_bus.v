// aes_bus.v Andy Isaacson <adi@hexapodia.org>
// GPLv3

`include "timescale.v"

module aes_bus(
    output wire APOPTOSIS,
    input wire CLK2_N,
    input wire CLK2_P,
    output wire FPGA_LED2,
    output wire ECSPI3_MISO,
    output wire FPGA_HSWAPEN,

    input wire EIM_BCLK,
    input wire [1:0] EIM_CS,
    inout wire [15:0] EIM_DA,
    input wire [18:16] EIM_A,
    input wire EIM_LBA,
    input wire EIM_OE,
    input wire EIM_RW,
    input wire EIM_WAIT,

    input wire RESETBMCU
    );

reg  [127:0] text_in;
wire [127:0] text_out;
reg  [127:0] key;
reg ready;
wire done, good;
wire [15:0] eim_out;

initial begin
	key = 0;
	text_in = 0;
	ready = 0;
end

always @(posedge clk)
	if(rst) begin
		text_in	<= 128'h0;
		key	<= 128'h593847fb7c86cf74a3e54bd76988a510;
	end else ready <= 1;

assign good = done && &text_out; // XXX wrong test on text_out, just gathering

assign eim_out = good ? 16'hffff : 16'h0000;

aes_cipher_top enc(
	.clk(		clk	),
	.rst(		rst	),
	.ld(		ready	),
	.done(		done	),
	.key(		key	),
	.text_in(	text_in	),
	.text_out(	text_out));

endmodule
