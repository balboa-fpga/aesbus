// aes_bus.v Andy Isaacson <adi@hexapodia.org>
// GPLv3

`include "timescale.v"

module aes_bus(clk, rst, wr, addr, eim_in, eim_out);
input	clk, rst, wr;
input	[15:0] addr;
input	[15:0] eim_in;
output	[15:0] eim_out;

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
