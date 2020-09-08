//
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 
// generating a number bitmap 



module lifeBitMap	(	
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

localparam OBJECT_WIDTH_X=16;
localparam OBJECT_HEIGHT_Y=16;

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF },
{8'hFF, 8'h00, 8'hFE, 8'hC9, 8'hC9, 8'hC9, 8'hE5, 8'h00, 8'h00, 8'hC9, 8'hC9, 8'hC5, 8'hC5, 8'hE5, 8'h00, 8'hFF },
{8'h00, 8'hE5, 8'hFE, 8'hC9, 8'hE5, 8'hE5, 8'hE5, 8'h20, 8'h20, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'h00 },
{8'h00, 8'hE5, 8'hFE, 8'hC9, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'h00 },
{8'h00, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'h00 },
{8'h00, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'h00 },
{8'h00, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'h00 },
{8'h00, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'h00 },
{8'hFF, 8'h00, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'h00, 8'hFF },
{8'hFF, 8'hFF, 8'h00, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'h00, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hE5, 8'hE5, 8'hE5, 8'hE5, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hE5, 8'hE5, 8'h20, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h20, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
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
			RGBout <= object_colors[offsetY][offsetX];
		end
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   


endmodule