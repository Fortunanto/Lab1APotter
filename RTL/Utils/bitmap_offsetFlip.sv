//
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 
// generating a number bitmap 



module bitmap_offsetFlip	(	
					input		logic	clk,				
					input 	logic	[10:0] offsetX,// offset from top left  position 
					input 	logic	[10:0] offsetY,	
					input logic startOfFrame,
					
					output logic [10:0] newOffsetX,
					output logic [10:0] newOffsetY		
);

parameter shortint OBJECT_WIDTH_X = 5;


parameter int FLIP_TIME = 5;
int flipTimer;
logic flip;
 
 
initial begin
	flip = 0;
	flipTimer = FLIP_TIME;
end

always_ff@(posedge clk)
begin
	if (startOfFrame) begin
		if (flipTimer>0) flipTimer <= flipTimer - 1;
		else begin
			flipTimer <= 5;
			flip <= !flip;
		end
	end
	
	if (flip) newOffsetX <= offsetX;	
	else newOffsetX <= OBJECT_WIDTH_X-offsetX-1;	
	
	newOffsetY <= offsetY;	
end

endmodule