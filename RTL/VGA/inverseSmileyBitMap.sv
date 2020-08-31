//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// New bitmap dudy February 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 



module	inverseSmileyBitMap	(	
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

// this is the devider used to acess the right pixel 
//localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
//localparam  int OBJECT_NUMBER_OF_X_BITS = 6;  // 2^6 = 64 


//localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
//localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

localparam int OBJECT_HEIGHT_Y = 48;
localparam int OBJECT_WIDTH_X = 11;

// this is the devider used to acess the right pixel 
//localparam  int OBJECT_HEIGHT_Y_DIVIDER = OBJECT_NUMBER_OF_Y_BITS - 2; //how many pixel bits are in every collision pixel
//localparam  int OBJECT_WIDTH_X_DIVIDER =  OBJECT_NUMBER_OF_X_BITS - 2;

// generating a smiley bitmap

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hC8, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hC8, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFA, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFA, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFA, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h24, 8'h24, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h24, 8'h24, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h24, 8'h24, 8'hFA, 8'h24, 8'h24, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h24, 8'h24, 8'hD6, 8'hD6, 8'hD6, 8'h24, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h24, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'h24, 8'hFF, 8'hFF },
{8'hFF, 8'h24, 8'h24, 8'hD6, 8'hFA, 8'hFA, 8'hFA, 8'hDA, 8'h24, 8'h24, 8'hFF },
{8'hFF, 8'h24, 8'h24, 8'h91, 8'h91, 8'h91, 8'h91, 8'h91, 8'h24, 8'h24, 8'hFF },
{8'h24, 8'h24, 8'h24, 8'h91, 8'h91, 8'h91, 8'h91, 8'h8D, 8'h24, 8'h24, 8'h24 },
{8'h45, 8'h45, 8'h45, 8'h45, 8'h6D, 8'h6D, 8'h6D, 8'h45, 8'h45, 8'h45, 8'h45 },
{8'h45, 8'h45, 8'h45, 8'h45, 8'h45, 8'h45, 8'h45, 8'h45, 8'h45, 8'h45, 8'h45 },
{8'h24, 8'h45, 8'h45, 8'hC8, 8'hC8, 8'hC8, 8'hC8, 8'hC8, 8'h45, 8'h45, 8'h24 },
{8'hFF, 8'h24, 8'h45, 8'h24, 8'hC8, 8'h91, 8'hC8, 8'h24, 8'h45, 8'h24, 8'hFF },
{8'hFF, 8'h24, 8'h45, 8'h24, 8'hC8, 8'h91, 8'hC8, 8'h24, 8'h45, 8'h24, 8'hFF },
{8'hFF, 8'h24, 8'h45, 8'h45, 8'h24, 8'hC8, 8'h24, 8'h45, 8'h45, 8'h24, 8'hFF },
{8'hFF, 8'hFF, 8'h24, 8'h45, 8'h45, 8'h45, 8'h45, 8'h45, 8'h24, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h24, 8'h24, 8'h24, 8'h64, 8'h24, 8'h24, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h24, 8'h64, 8'h64, 8'h24, 8'h64, 8'h24, 8'h24, 8'hFF },
{8'hFF, 8'hFF, 8'h24, 8'h24, 8'h24, 8'h24, 8'h64, 8'h64, 8'h64, 8'h24, 8'hFF },
{8'hFF, 8'hFF, 8'h24, 8'h64, 8'h64, 8'h64, 8'h64, 8'h24, 8'h64, 8'h24, 8'hFF },
{8'hFF, 8'h24, 8'h24, 8'h64, 8'h24, 8'h24, 8'h24, 8'h64, 8'h64, 8'h24, 8'hFF },
{8'hFF, 8'h24, 8'h24, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h24, 8'hFF },
{8'hFF, 8'h24, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h24, 8'h24, 8'hFF, 8'hFF },
{8'hFF, 8'h24, 8'h64, 8'h64, 8'h24, 8'h24, 8'h24, 8'h64, 8'h64, 8'h24, 8'hFF },
{8'hFF, 8'h24, 8'h24, 8'h24, 8'h64, 8'h64, 8'h64, 8'h24, 8'h24, 8'hFF, 8'hFF },
{8'hFF, 8'h24, 8'hFF, 8'hFF, 8'h00, 8'hC8, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hC8, 8'hC8, 8'hC8, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hC8, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hC8, 8'hC8, 8'hC8, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h00, 8'hC8, 8'hC8, 8'hFA, 8'hC8, 8'hC8, 8'h00, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h00, 8'hFA, 8'hC8, 8'hFA, 8'hFA, 8'hFA, 8'h00, 8'hFF, 8'hFF },
{8'hFF, 8'h00, 8'hC8, 8'hFA, 8'hC8, 8'hFA, 8'hFA, 8'hFA, 8'hC8, 8'h00, 8'hFF },
{8'hFF, 8'h00, 8'hC8, 8'hC8, 8'hC8, 8'hFA, 8'hFA, 8'hFA, 8'hC8, 8'h00, 8'hFF },
{8'hFF, 8'h00, 8'hC8, 8'h00, 8'hC8, 8'hFA, 8'hFA, 8'hFA, 8'hC8, 8'h00, 8'hFF },
{8'hFF, 8'h00, 8'hC8, 8'h00, 8'hC8, 8'hC8, 8'hFA, 8'h00, 8'hC8, 8'h00, 8'hFF },
{8'hFF, 8'h00, 8'h00, 8'h00, 8'hC8, 8'h00, 8'hC8, 8'h00, 8'h00, 8'h00, 8'hFF },
{8'hFF, 8'h00, 8'hFF, 8'h00, 8'hC8, 8'h00, 8'hC8, 8'h00, 8'hFF, 8'h00, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};

//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}	
//there is one bit per edge, in the corner two bits are set  


//logic [0:3] [0:3] [3:0] hit_colors = 
//{16'hC446,     
// 16'h8C62,    
// 16'h8932,
// 16'h9113};

 

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
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule