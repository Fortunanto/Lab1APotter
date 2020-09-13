//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	enemiesHeadsUp_moveCollision	(	
					input		logic	clk,
					input		logic	resetN,
					input    logic startOfFrame,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					
					input logic [10:0] topLeftXinput,
					input logic [10:0] topLeftYinput,
										
					output logic [7:0] RGBout,
					
					output	logic	drawingRequest // indicates pixel inside the bracket				
);

parameter  int OBJECT_WIDTH_X = 20; // width of followed object
parameter  int OBJECT_HEIGHT_Y = 20; // height of followed object
parameter  logic [7:0] OBJECT_COLOR = 8'h5b; // for debug
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
 
parameter int HEADS_UP_HEIGHT = 80;
 
const int OFFSET_X=5;

 
int topLeftX;
int topLeftY;
int rightX ; //coordinates of the sides  
int bottomY ;


logic insideBracket;

int pixelX_FixedPoint,rightX_FixedPoint;


const int FIXED_POINT_MULTIPLIER=64;
//////////--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries

always_comb
RGBout = OBJECT_COLOR;

assign topLeftX = topLeftXinput - OFFSET_X;
assign topLeftY = topLeftYinput - HEADS_UP_HEIGHT;

assign rightX	= (topLeftXinput + OBJECT_WIDTH_X + OFFSET_X);
assign bottomY	= (topLeftYinput + OBJECT_HEIGHT_Y);

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin		
		drawingRequest	<=	1'b0;		
	end
	else begin 	

	
		insideBracket  = 	 ((pixelX  >= topLeftX) &&  (pixelX < rightX) 
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY))  ;  // check to see if inside the bracket
		
		if (insideBracket ) // test if it is inside the rectangle 
		begin 
			drawingRequest <= 1'b1 ;			
		end 
		
		else begin  
			drawingRequest <= 1'b0 ;// transparent color 			
		end 
		
	end
end 
endmodule 