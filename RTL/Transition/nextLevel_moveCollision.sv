module nextLevel_moveCollision(			
	input		logic	clk,
	input		logic	resetN,
	input    logic startOfFrame,		
	
	output	logic signed [10:0] topLeftX,
	output	logic signed [10:0]	topLeftY			
);
	
parameter int TLX = 100;
parameter int TLY = 100;

parameter  int OBJECT_WIDTH_X = 152;
parameter  int OBJECT_HEIGHT_Y = 112;

assign topLeftX = TLX;
assign topLeftY = TLY;
	
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin			
	end
	else begin
	end
end 
				
endmodule