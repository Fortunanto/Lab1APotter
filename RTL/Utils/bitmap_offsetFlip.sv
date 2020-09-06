//
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 
// generating a number bitmap 



module bitmap_offsetFlip	(	
					input		logic	clk,		
					input		logic	resetN,				
					input 	logic	[10:0] offsetX,// offset from top left  position 
					input 	logic	[10:0] offsetY,	
					input logic slowClk,
					input logic pause,
					output logic requestSlowClk,
					output logic [10:0] slowClkTime,
					
					output logic [10:0] newOffsetX,
					output logic [10:0] newOffsetY		
);

parameter shortint OBJECT_WIDTH_X = 11;

parameter int FLIP_TIME = 5;
logic flip;
logic flag;
 
initial begin
	flip = 0;
	flag = 1;
end

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		flip <= 0;
		flag <= 1;
	end
	else begin
		if(flag) begin  
			requestSlowClk<=1;
			slowClkTime<=FLIP_TIME;
			flag<=0;
		end
		else begin
			requestSlowClk<=0;
			slowClkTime<=0;
		end
		if(slowClk) begin 
			flip=~flip;
			flag<=1;
		end
		if(pause) newOffsetX <= offsetX;	
		else begin
			if (flip)  newOffsetX <= offsetX;	
			else newOffsetX <= OBJECT_WIDTH_X-offsetX-1;	
		end
		newOffsetY <= offsetY;	
	end
end

endmodule