module shot_bitMask(
	input logic clk,
	input logic resetN,
	input logic [7:0] RGB,
	input logic poweredUp,
	
	
	output logic [7:0] NewRGB
);

always_ff@(posedge clk or negedge resetN) 
begin
	if(!resetN) begin
		NewRGB <= RGB;
	end 
	else begin
		if(!poweredUp) NewRGB<=RGB;
		else NewRGB<=RGB ^ 8'b11100011;
	end
end


endmodule