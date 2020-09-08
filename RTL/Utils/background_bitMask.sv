module background_bitMask(
	input logic clk,
	input logic resetN,
	input logic [7:0] RGB,
	input logic [2:0] currentGameState,
	
	
	output logic [7:0] NewRGB
);

always_ff@(posedge clk or negedge resetN) 
begin
	if(!resetN) begin
		NewRGB <= RGB;
	end 
	else begin
		case (currentGameState)
			0: NewRGB<=RGB | 8'b10000001;
			1: NewRGB<=RGB;
			2: NewRGB<=RGB | 8'b10100101;
			3: NewRGB<=RGB | 8'b10011001;
			4: NewRGB<=RGB | 8'b10011001;
			5: NewRGB<=RGB | 8'b10100101;
		endcase 
	end
end


endmodule