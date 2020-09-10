//
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 
// generating a number bitmap 



module HarryBitMap	(	
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

localparam  int OBJECT_HEIGHT_Y = 19;
localparam  int OBJECT_WIDTH_X = 32;

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h00, 8'h00, 8'hFF, 8'hDB, 8'hFF, 8'hDB, 8'hDB, 8'h07, 8'h07, 8'hDB },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h00, 8'h49, 8'hFF, 8'hFF, 8'hDB, 8'h07, 8'h07, 8'hDB },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'hFA, 8'hFA, 8'h24, 8'h24, 8'h24, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'h24, 8'hDB, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h00, 8'h20, 8'hFA, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h24, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h24, 8'h24, 8'h24, 8'h24, 8'h00, 8'h01, 8'h31, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h24, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'h00, 8'h01, 8'h31, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h24, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h24, 8'hFA, 8'hFA, 8'hFA, 8'h00, 8'h00, 8'hFA, 8'hFA, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h24, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h24, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h24, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'hE4, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFA, 8'h00, 8'h00, 8'h20, 8'h44, 8'h00, 8'hFF, 8'h00, 8'h00, 8'h00, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF4, 8'hE4, 8'hE0, 8'h00, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'hC0, 8'hC0, 8'hC0, 8'hC0, 8'hF4, 8'h00, 8'hD1, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'h00, 8'hFA, 8'hFA, 8'h00, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hF4, 8'hE0, 8'h80, 8'h00, 8'h00, 8'h80, 8'hC0, 8'hC0, 8'hC0, 8'hC0, 8'hC0, 8'hC0, 8'hF4, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hF4, 8'hF4, 8'h00, 8'hFA, 8'hFA, 8'h00, 8'hFF },
{8'hFF, 8'hFF, 8'h00, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'h20, 8'h20, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h00, 8'h20, 8'h00, 8'h44, 8'h00, 8'h00, 8'h00, 8'h00, 8'hD1, 8'hD1, 8'hF4, 8'hF4, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF },
{8'hFF, 8'h00, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'h44, 8'h24, 8'hD1, 8'h00, 8'h80, 8'h80, 8'h80, 8'h00, 8'h00, 8'h92, 8'h92, 8'h92, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hF4, 8'hF4, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF },
{8'h00, 8'h44, 8'hD1, 8'hD1, 8'h44, 8'h44, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'h20, 8'h00, 8'h00, 8'h00, 8'h44, 8'h92, 8'h92, 8'h00, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'h68, 8'hF4, 8'hF4, 8'h00, 8'h68, 8'h68, 8'h68, 8'h00 },
{8'hFF, 8'h00, 8'h44, 8'h44, 8'hD1, 8'hD1, 8'hD1, 8'h44, 8'h44, 8'hD1, 8'hD1, 8'h00, 8'h20, 8'h20, 8'h00, 8'h00, 8'h00, 8'h49, 8'h00, 8'h00, 8'h00, 8'hFA, 8'hFA, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF },
{8'hFF, 8'hFF, 8'h00, 8'h44, 8'h44, 8'h44, 8'h44, 8'hD1, 8'hD1, 8'h44, 8'h44, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h49, 8'h00, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h44, 8'h44, 8'h44, 8'h44, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h44, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};

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
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING && InsideRectangle) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   


endmodule