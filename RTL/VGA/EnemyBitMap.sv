//
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 
// generating a number bitmap 



module EnemyBitMap	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] offsetX,// offset from top left  position 
					input 	logic	[10:0] offsetY,
					input		logic	InsideRectangle, //input that the pixel is within a bracket 
										
					output	logic				drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0]		RGBout
);
// generating a smily bitmap 

logic [1:0][7:0] colors = 16'b11001010_00110101;
// TODO: put here bitmap of tower

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		drawingRequest <=	1'b0;
	end
	else begin
			drawingRequest <= InsideRectangle;	//get value from bitmap  
	end 
end

assign RGBout = colors[0] ; // this is a fixed color 

endmodule