//
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 
// generating a number bitmap 



module TowerBitMap	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] offsetX,// offset from top left  position 
					input 	logic	[10:0] offsetY,
					input		logic	InsideRectangle, //input that the pixel is within a bracket 
										
					output	logic				drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0]		RGBout
);

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF;
localparam logic [7:0] DEBUG_COLOR = 8'hFA;

localparam  int OBJECT_HEIGHT_Y = 29;
localparam  int OBJECT_WIDTH_X = 14;

logic [7:0] outColor;

// comment for PROD
//assign outColor = DEBUG_COLOR;

// comment for DEBUG 
logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h05, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h05, 8'h05, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h05, 8'h6E, 8'h4E, 8'h05, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'hFF, 8'h05, 8'h73, 8'h4E, 8'h72, 8'h05, 8'h9A, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hDF, 8'h05, 8'h73, 8'h97, 8'h6E, 8'h4E, 8'h05, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hBB, 8'hFF, 8'h05, 8'h73, 8'h4E, 8'h4E, 8'h4E, 8'h97, 8'h97, 8'h72, 8'hDB, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h05, 8'h73, 8'h97, 8'h97, 8'h4E, 8'h97, 8'h97, 8'h05, 8'h4E, 8'hB7, 8'hFF },
{8'hFF, 8'h05, 8'h05, 8'h73, 8'h97, 8'h97, 8'h4E, 8'h4E, 8'h97, 8'h05, 8'h05, 8'h4E, 8'hFF, 8'hFF },
{8'h05, 8'h72, 8'h73, 8'h97, 8'h97, 8'h4E, 8'h4E, 8'h4E, 8'h97, 8'h05, 8'h05, 8'h4E, 8'h05, 8'h05 },
{8'hFF, 8'h05, 8'h97, 8'h4E, 8'h4E, 8'h4E, 8'h4E, 8'h4E, 8'h4E, 8'h4E, 8'h4E, 8'h97, 8'h97, 8'h05 },
{8'hFF, 8'hFF, 8'h05, 8'h05, 8'h72, 8'h6E, 8'h4E, 8'h4E, 8'h4E, 8'h4E, 8'h97, 8'h05, 8'h05, 8'hFB },
{8'hFF, 8'hFF, 8'h45, 8'h69, 8'h05, 8'h72, 8'h6E, 8'h72, 8'h97, 8'h05, 8'h05, 8'h45, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h45, 8'h6D, 8'h49, 8'h05, 8'h05, 8'h05, 8'h25, 8'h49, 8'h49, 8'h45, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h45, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'hB6, 8'h6D, 8'h45, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h45, 8'h6D, 8'h45, 8'h6D, 8'h6D, 8'hB6, 8'hB6, 8'h45, 8'h6D, 8'h45, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h45, 8'h6D, 8'h45, 8'h45, 8'h45, 8'h45, 8'h6D, 8'h45, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h45, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h45, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h45, 8'h6D, 8'h45, 8'h69, 8'h45, 8'h6D, 8'h45, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h45, 8'h6D, 8'h45, 8'h6D, 8'h45, 8'h6D, 8'h45, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h45, 8'h6D, 8'h6D, 8'h8D, 8'h69, 8'h92, 8'h45, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h45, 8'h6D, 8'h8D, 8'h92, 8'h92, 8'h92, 8'h45, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h45, 8'h6D, 8'h45, 8'hB2, 8'h45, 8'h6D, 8'h45, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h45, 8'h6D, 8'h45, 8'hB2, 8'h45, 8'h6D, 8'h45, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h45, 8'h6D, 8'h6D, 8'hB2, 8'h6D, 8'h6D, 8'h45, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h45, 8'h92, 8'hB6, 8'hB6, 8'hB2, 8'h91, 8'h45, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h45, 8'hB2, 8'hD6, 8'h89, 8'h89, 8'hB2, 8'h45, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h45, 8'hB1, 8'hD1, 8'h89, 8'h89, 8'hB2, 8'h45, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h45, 8'h89, 8'hCD, 8'h89, 8'h89, 8'h91, 8'h45, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'h89, 8'h89, 8'h89, 8'h89, 8'h89, 8'h89, 8'h89, 8'h89, 8'h89, 8'h89, 8'h89, 8'h89, 8'h89, 8'h89 }
};
assign outColor = object_colors[offsetY>>1][offsetX>>1];


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=8'h22;
	end
	else begin
			if (InsideRectangle) begin
				RGBout <= outColor;				
			end
			else RGBout <= TRANSPARENT_ENCODING;
	end 
end

assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ;

endmodule