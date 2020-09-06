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
					//input logic startOfFrame,
		
		
					output	logic				drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0]		RGBout
);
// generating a smily bitmap 

localparam OBJECT_WIDTH_X=11;
localparam OBJECT_HEIGHT_Y=48;

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;
localparam logic [7:0] DEBUG_COLOR = 8'hAA;

logic [7:0] outColor;

// comment for PROD
//assign outColor = DEBUG_COLOR;

// comment for DEBUG
logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h38, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h38, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hBE, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hBE, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hBE, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h04, 8'h04, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h04, 8'h04, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h04, 8'h04, 8'h04, 8'h04, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h04, 8'hDE, 8'h04, 8'h04, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h04, 8'h04, 8'h9A, 8'h9A, 8'h9A, 8'h04, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h04, 8'h9E, 8'h9E, 8'hBE, 8'h9E, 8'hBE, 8'h04, 8'hFF, 8'hFF },
{8'hFF, 8'h04, 8'h04, 8'h9A, 8'hBE, 8'hBE, 8'hBE, 8'h9A, 8'h04, 8'h04, 8'hFF },
{8'hFF, 8'h04, 8'h04, 8'h71, 8'h71, 8'h71, 8'h71, 8'h71, 8'h04, 8'h04, 8'hFF },
{8'h04, 8'h04, 8'h04, 8'h71, 8'h71, 8'h71, 8'h71, 8'h51, 8'h04, 8'h04, 8'h04 },
{8'h49, 8'h49, 8'h49, 8'h49, 8'h4D, 8'h4D, 8'h4D, 8'h49, 8'h49, 8'h49, 8'h49 },
{8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49 },
{8'h04, 8'h49, 8'h49, 8'h38, 8'h38, 8'h38, 8'h38, 8'h38, 8'h49, 8'h49, 8'h04 },
{8'hFF, 8'h04, 8'h49, 8'h04, 8'h38, 8'h71, 8'h38, 8'h04, 8'h49, 8'h04, 8'hFF },
{8'hFF, 8'h04, 8'h49, 8'h04, 8'h38, 8'h71, 8'h38, 8'h04, 8'h49, 8'h04, 8'hFF },
{8'hFF, 8'h04, 8'h49, 8'h49, 8'h04, 8'h38, 8'h04, 8'h49, 8'h49, 8'h04, 8'hFF },
{8'hFF, 8'hFF, 8'h04, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h04, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h04, 8'h04, 8'h04, 8'h04, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h04, 8'h04, 8'h2C, 8'h04, 8'h04, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h2C, 8'h2C, 8'h04, 8'h2C, 8'h04, 8'h04, 8'hFF },
{8'hFF, 8'hFF, 8'h04, 8'h04, 8'h04, 8'h04, 8'h2C, 8'h2C, 8'h2C, 8'h04, 8'hFF },
{8'hFF, 8'hFF, 8'h04, 8'h2C, 8'h2C, 8'h2C, 8'h2C, 8'h04, 8'h2C, 8'h04, 8'hFF },
{8'hFF, 8'h04, 8'h04, 8'h2C, 8'h04, 8'h04, 8'h04, 8'h2C, 8'h2C, 8'h04, 8'hFF },
{8'hFF, 8'h04, 8'h04, 8'h2C, 8'h2C, 8'h2C, 8'h2C, 8'h2C, 8'h2C, 8'h04, 8'hFF },
{8'hFF, 8'h04, 8'h2C, 8'h2C, 8'h2C, 8'h2C, 8'h2C, 8'h04, 8'h04, 8'hFF, 8'hFF },
{8'hFF, 8'h04, 8'h2C, 8'h2C, 8'h04, 8'h04, 8'h04, 8'h2C, 8'h2C, 8'h04, 8'hFF },
{8'hFF, 8'h04, 8'h04, 8'h04, 8'h2C, 8'h2C, 8'h2C, 8'h04, 8'h04, 8'hFF, 8'hFF },
{8'hFF, 8'h04, 8'hFF, 8'hFF, 8'h00, 8'hD4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hD4, 8'hD4, 8'hD4, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hD4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hD4, 8'hD4, 8'hD4, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h00, 8'hD4, 8'hD4, 8'hDE, 8'hD4, 8'hD4, 8'h00, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h00, 8'hDE, 8'hD4, 8'hDE, 8'hDE, 8'hDE, 8'h00, 8'hFF, 8'hFF },
{8'hFF, 8'h00, 8'hD4, 8'hDE, 8'hD4, 8'hDE, 8'hDE, 8'hDE, 8'hD4, 8'h00, 8'hFF },
{8'hFF, 8'h00, 8'hD4, 8'hD4, 8'hD4, 8'hDE, 8'hDE, 8'hDE, 8'hD4, 8'h00, 8'hFF },
{8'hFF, 8'h00, 8'hD4, 8'h00, 8'hD4, 8'hDE, 8'hDE, 8'hDE, 8'hD4, 8'h00, 8'hFF },
{8'hFF, 8'h00, 8'hD4, 8'h00, 8'hD4, 8'hD4, 8'hDE, 8'h00, 8'hD4, 8'h00, 8'hFF },
{8'hFF, 8'h00, 8'h00, 8'h00, 8'hD4, 8'h00, 8'hD4, 8'h00, 8'h00, 8'h00, 8'hFF },
{8'hFF, 8'h00, 8'hFF, 8'h00, 8'hD4, 8'h00, 8'hD4, 8'h00, 8'hFF, 8'h00, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};
assign outColor = object_colors[offsetY][offsetX];
	 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		
		if (InsideRectangle == 1'b1 ) begin  // inside an external bracket 	
			RGBout <= outColor;
		end
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   


endmodule