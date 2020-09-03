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
					output logic [10:0] newOffsetY,
		
					output	logic	[7:0]		RGBout
);
// generating a smily bitmap 

localparam OBJECT_WIDTH_X=11;
localparam OBJECT_HEIGHT_Y=48;


parameter int FLIP_TIME = 5;
int flipTimer;
logic flip;
 
 
initial begin
	flip = 0;
	flipTimer = FLIP_TIME;
end
// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk)
begin
	if (startOfFrame) begin
		if (flipTimer>0) flipTimer <= flipTimer - 1;
		else begin
			flipTimer <= 5;
			flip <= !flip;
		end
	end
	
	if (flip) newOffsetY <= offsetY;	
	else newOffsetY <= OBJECT_WIDTH_X-offsetX-1;	
	
	newOffsetX <= offsetX;	
end

endmodule