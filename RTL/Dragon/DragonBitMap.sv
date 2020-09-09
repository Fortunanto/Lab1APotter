//
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 
// generating a number bitmap 



module DragonBitMap	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] offsetX,// offset from top left  position 
					input 	logic	[10:0] offsetY,
					input		logic	InsideRectangle, //input that the pixel is within a bracket 
					//input logic startOfFrame,
		
		
					output	logic				drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0]		RGBout
);
// generating a smily bitmap 


localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;

localparam  int OBJECT_HEIGHT_Y = 32;
localparam  int OBJECT_WIDTH_X = 31;

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'hF4, 8'hF4, 8'h00, 8'h00, 8'h00, 8'hFF },
{8'h00, 8'hF4, 8'hF4, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'hF4, 8'hF4, 8'hF4, 8'h00, 8'h00, 8'hFF, 8'hFF },
{8'hFF, 8'h00, 8'hF4, 8'hF4, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'hB0, 8'hF4, 8'hF4, 8'hB4, 8'hF8, 8'h90, 8'h00, 8'h00, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h00, 8'h00, 8'hF4, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'hB0, 8'hF4, 8'hDC, 8'hDC, 8'hBC, 8'hDC, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h44, 8'h00, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hBC, 8'hBC, 8'hBC, 8'hDC, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h88, 8'hF4, 8'h88, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'hF4, 8'hF4, 8'hF4, 8'hDC, 8'hBC, 8'hBC, 8'hBC, 8'hBC, 8'hBC, 8'h70, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h74, 8'h00, 8'h00, 8'h88, 8'hF4, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'h00, 8'hB0, 8'hF4, 8'hF4, 8'h00, 8'h44, 8'h44, 8'h44, 8'h44, 8'hB0, 8'hB0, 8'hBC, 8'hBC, 8'hBC, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'h00, 8'h88, 8'hD0, 8'hF4, 8'h00, 8'h00, 8'h44, 8'h44, 8'h68, 8'h44, 8'h8C, 8'h44, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'h44, 8'hB0, 8'hB0, 8'h68, 8'h00, 8'h00, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hB0, 8'h8C, 8'hF4, 8'hF4, 8'h24, 8'hFF, 8'hFF, 8'h44, 8'hF4, 8'h68, 8'hF4, 8'h70, 8'h98, 8'hBC, 8'hBC, 8'hBC, 8'hDC, 8'hDC, 8'hDC, 8'hF8, 8'hB0, 8'h00, 8'h00, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h44, 8'hF4, 8'hF4, 8'hF4, 8'h00, 8'hFF, 8'h00, 8'hF4, 8'h88, 8'hBC, 8'hF4, 8'hB0, 8'hBC, 8'hBC, 8'hBC, 8'hBC, 8'hBC, 8'hBC, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h70, 8'h70, 8'hDC, 8'h00, 8'h88, 8'h88, 8'h00, 8'hF4, 8'h88, 8'h00, 8'hDC, 8'hDC, 8'h88, 8'h74, 8'hBC, 8'hBC, 8'hBC, 8'hDC, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'hDC, 8'hDC, 8'hF4, 8'hF4, 8'hF4, 8'h44, 8'h44, 8'hF4, 8'h88, 8'hDC, 8'h74, 8'hBC, 8'hDC, 8'h88, 8'hBC, 8'hBC, 8'hBC, 8'hDC, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'hDC, 8'hDC, 8'hF4, 8'hF4, 8'h00, 8'hF4, 8'h44, 8'hB0, 8'hF4, 8'hF4, 8'h00, 8'hDC, 8'h4C, 8'hBC, 8'hBC, 8'hDC, 8'hB0, 8'h98, 8'hDC, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'hB4, 8'hF4, 8'hF4, 8'hF4, 8'h8C, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'h44, 8'h70, 8'hBC, 8'h48, 8'hBC, 8'hBC, 8'hBC, 8'hDC, 8'h68, 8'hB8, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h00, 8'h00, 8'hDC, 8'hF4, 8'hF4, 8'hF4, 8'h00, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'h44, 8'h00, 8'hBC, 8'hBC, 8'hDC, 8'h28, 8'hBC, 8'hDC, 8'hDC, 8'hDC, 8'hB0, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'h00, 8'hDC, 8'hDC, 8'hD0, 8'hF4, 8'h88, 8'h44, 8'hB0, 8'h44, 8'h44, 8'hF4, 8'hF4, 8'hF4, 8'hD0, 8'h00, 8'hBC, 8'hBC, 8'hDC, 8'h28, 8'hBC, 8'h90, 8'h48, 8'h48, 8'h68, 8'h00, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'hFF },
{8'hFF, 8'h00, 8'hDC, 8'h8C, 8'h68, 8'h00, 8'h8C, 8'hF4, 8'h00, 8'h70, 8'h94, 8'h24, 8'hB0, 8'hD0, 8'h8C, 8'h00, 8'h74, 8'h74, 8'hDC, 8'h4C, 8'hB4, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'hF4, 8'h00 },
{8'h00, 8'hF4, 8'hF4, 8'h24, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'hDC, 8'h00, 8'hB0, 8'h00, 8'hF4, 8'hF4, 8'h00, 8'hB4, 8'hB4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'h00, 8'hFF },
{8'h00, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'hDC, 8'h28, 8'h8C, 8'hF4, 8'hF4, 8'hF4, 8'h00, 8'hB4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'h00, 8'hFF, 8'hFF },
{8'h00, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h74, 8'hF4, 8'h88, 8'hF4, 8'h44, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'h00, 8'hFF, 8'hFF },
{8'h24, 8'hF4, 8'hF4, 8'h24, 8'h24, 8'hB0, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h24, 8'hF4, 8'hD0, 8'h44, 8'h44, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'h24, 8'hF4, 8'h24, 8'hDB, 8'h24, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'h00, 8'hF4, 8'hF4, 8'h00, 8'h00, 8'hF4, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'h00, 8'h00, 8'hFF, 8'hFF },
{8'hFF, 8'h24, 8'hF4, 8'h24, 8'hF4, 8'hF4, 8'h00, 8'hFF, 8'h00, 8'hFF, 8'h00, 8'h88, 8'hF4, 8'hF4, 8'hF4, 8'h00, 8'hF4, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'h00, 8'hFF, 8'hFF },
{8'hFF, 8'h24, 8'hF4, 8'hD0, 8'hF4, 8'h00, 8'hFF, 8'h00, 8'hFF, 8'h24, 8'h00, 8'hF4, 8'hF4, 8'h44, 8'hF4, 8'hF4, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'h00, 8'hFF, 8'hFF },
{8'hFF, 8'h24, 8'hF4, 8'h44, 8'hC5, 8'hC5, 8'h00, 8'hFF, 8'h00, 8'hF4, 8'hF4, 8'h00, 8'hF4, 8'hB0, 8'hF4, 8'hF4, 8'h88, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'h00, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h24, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'hFF, 8'h44, 8'h24, 8'hF4, 8'hF4, 8'h00, 8'h24, 8'hF4, 8'hF4, 8'h24, 8'hF4, 8'hD0, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h24, 8'h24, 8'hF4, 8'hF4, 8'h24, 8'h00, 8'h48, 8'h24, 8'hDC, 8'hF4, 8'hD0, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hF4, 8'h00, 8'h24, 8'hF4, 8'hF4, 8'h24, 8'h00, 8'h70, 8'hDC, 8'hDC, 8'hF4, 8'hF4, 8'h00, 8'h00, 8'h00, 8'hF4, 8'hF4, 8'h70, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h00, 8'h00, 8'hFF, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hB0, 8'h00, 8'h49, 8'h24, 8'hF4, 8'h24, 8'h00, 8'h00, 8'h70, 8'hD8, 8'hD8, 8'hD8, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'h70, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h00, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'hF4, 8'hF4, 8'h00, 8'hFF, 8'hFF, 8'h24, 8'h24, 8'hFF, 8'hFF, 8'h00, 8'hDC, 8'hDC, 8'hD8, 8'hD8, 8'hD8, 8'h70, 8'h70, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};
//
//parameter int FLIP_TIME = 5;
//int flipTimer;
//logic flip;
// 
// 
//initial begin
//	flip = 0;
//	flipTimer = FLIP_TIME;
//end
// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin

		
		if (InsideRectangle == 1'b1 ) begin  // inside an external bracket 
			RGBout <= object_colors[offsetY/2][offsetX/2];
		end
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   


endmodule