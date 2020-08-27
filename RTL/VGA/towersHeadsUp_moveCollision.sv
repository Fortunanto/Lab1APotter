//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


 // ~~~~~~~~~~~~~~~~~~~~ not needed ~~~~~~~~~~~~~~~~~~~~~`
 
/*
module	towersHeadsUp_moveCollision	(	
					input		logic	clk,
					input		logic	resetN,
					input    logic startOfFrame,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					
					input logic [10:0] topLeftXinput,
					input logic [10:0] topLeftYinput,
					
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,
					
					output logic [7:0] RGBout,
					
					output	logic	drawingRequest // indicates pixel inside the bracket				
);

parameter  int OBJECT_WIDTH_X = 20;
parameter  int OBJECT_HEIGHT_Y = 20;
parameter  logic [7:0] OBJECT_COLOR = 8'h5b; // for debug
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
 
int rightX ; //coordinates of the sides  
int bottomY ;
logic insideBracket;

int pixelX_FixedPoint,rightX_FixedPoint;


const int FIXED_POINT_MULTIPLIER=64;
//////////--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries
always_comb
RGBout = OBJECT_COLOR;

assign rightX	= (topLeftXinput + OBJECT_WIDTH_X);
assign bottomY	= (topLeftYinput + OBJECT_HEIGHT_Y);

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin		
		drawingRequest	<=	1'b0;		
	end
	else begin 	

		//this is an example of using blocking sentence inside an always_ff block, 
		//and not waiting a clock to use the result  
		insideBracket  = 	 ((pixelX  >= topLeftXinput) &&  (pixelX < rightX) // ----- LEGAL BLOCKING ASSINGMENT in ALWAYS_FF CODE 
						   && (pixelY  >= topLeftYinput) &&  (pixelY < bottomY))  ; 
		
		if (insideBracket ) // test if it is inside the rectangle 
		begin 
			drawingRequest <= 1'b1 ;			
		end 
		
		else begin  
			drawingRequest <= 1'b0 ;// transparent color 			
		end 
		
	end
end 
endmodule */