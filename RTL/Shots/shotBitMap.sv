//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// New bitmap dudy February 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 



module	shotBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic startOfFrame,
					
					
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout,  //rgb value from the bitmap 
					output	logic	[3:0] HitEdgeCode //one bit per edge 
 ) ;

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

localparam  int OBJECT_HEIGHT_Y = 16;
localparam  int OBJECT_WIDTH_X = 16;

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'h01, 8'h01, 8'h01, 8'h01, 8'h05, 8'h05, 8'h05, 8'h01, 8'h01, 8'h01, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'h01, 8'h01, 8'h05, 8'h06, 8'h06, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h06, 8'h05, 8'h01, 8'h01, 8'hFF },
{8'hFF, 8'h01, 8'h06, 8'h0A, 8'h0F, 8'h0F, 8'h0F, 8'h13, 8'h13, 8'h0F, 8'h0F, 8'h0F, 8'h0A, 8'h06, 8'h01, 8'hFF },
{8'h01, 8'h05, 8'h0A, 8'h0F, 8'h13, 8'h13, 8'h17, 8'h37, 8'h37, 8'h17, 8'h13, 8'h13, 8'h0F, 8'h0A, 8'h06, 8'h01 },
{8'h01, 8'h06, 8'h0B, 8'h0F, 8'h17, 8'h3B, 8'h5B, 8'h5B, 8'h5B, 8'h5B, 8'h3B, 8'h17, 8'h13, 8'h0F, 8'h06, 8'h01 },
{8'h01, 8'h06, 8'h0F, 8'h13, 8'h3B, 8'h7F, 8'h9F, 8'hBF, 8'hBF, 8'hBF, 8'h7F, 8'h5B, 8'h17, 8'h0F, 8'h0A, 8'h01 },
{8'h01, 8'h06, 8'h0F, 8'h13, 8'h5B, 8'h7F, 8'h9F, 8'h7F, 8'h7F, 8'h7F, 8'h9F, 8'h5B, 8'h17, 8'h0F, 8'h0A, 8'h05 },
{8'h01, 8'h0A, 8'h0F, 8'h17, 8'h5B, 8'h9F, 8'h7F, 8'h7F, 8'h7F, 8'h7F, 8'h9F, 8'h7B, 8'h37, 8'h13, 8'h0A, 8'h06 },
{8'h01, 8'h0A, 8'h0F, 8'h17, 8'h5B, 8'h9F, 8'h7F, 8'h7F, 8'h7F, 8'h7F, 8'h9F, 8'h7B, 8'h37, 8'h13, 8'h0A, 8'h06 },
{8'h01, 8'h06, 8'h0F, 8'h13, 8'h5B, 8'h7F, 8'h7F, 8'h7F, 8'h7F, 8'h9F, 8'h9F, 8'h5B, 8'h17, 8'h0F, 8'h0A, 8'h05 },
{8'h01, 8'h06, 8'h0F, 8'h13, 8'h3B, 8'h7F, 8'h9F, 8'h9F, 8'h9F, 8'h9F, 8'h7F, 8'h5B, 8'h17, 8'h0F, 8'h0A, 8'h01 },
{8'h01, 8'h06, 8'h0B, 8'h13, 8'h17, 8'h3B, 8'h5B, 8'h7F, 8'h7F, 8'h5B, 8'h5B, 8'h37, 8'h13, 8'h0F, 8'h06, 8'h01 },
{8'h01, 8'h05, 8'h0A, 8'h0F, 8'h13, 8'h17, 8'h37, 8'h37, 8'h37, 8'h37, 8'h17, 8'h13, 8'h0F, 8'h0B, 8'h06, 8'h01 },
{8'hFF, 8'h01, 8'h06, 8'h0A, 8'h0F, 8'h0F, 8'h13, 8'h13, 8'h13, 8'h13, 8'h0F, 8'h0F, 8'h0B, 8'h06, 8'h01, 8'h01 },
{8'hFF, 8'h01, 8'h01, 8'h06, 8'h06, 8'h0A, 8'h0A, 8'h0B, 8'h0B, 8'h0B, 8'h0A, 8'h06, 8'h06, 8'h01, 8'h01, 8'hFF },
{8'hFF, 8'hFF, 8'h00, 8'h01, 8'h01, 8'h05, 8'h06, 8'h06, 8'h06, 8'h06, 8'h05, 8'h01, 8'h01, 8'h00, 8'hFF, 8'hFF }
};



parameter int FLIP_TIME = 5;
int flipTimer;
logic flip;
 
 
initial begin
	flip = 0;
	flipTimer = FLIP_TIME;
end
// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		//HitEdgeCode <= hit_colors[offsetY >> OBJECT_HEIGHT_Y_DIVIDER][offsetX >> OBJECT_WIDTH_X_DIVIDER];	//get hitting edge from the colors table  

		
		if (startOfFrame) begin
			if (flipTimer>0) flipTimer <= flipTimer - 1;
			else begin
				flipTimer <= 5;
				flip <= !flip;
			end
		end
		
		if (InsideRectangle == 1'b1 ) begin  // inside an external bracket 
			if (flip) 	RGBout <= object_colors[offsetY][offsetX];	
			else RGBout <= object_colors[offsetY][OBJECT_WIDTH_X-offsetX-1];
		end
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING && InsideRectangle ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule