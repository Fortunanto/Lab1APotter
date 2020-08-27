//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	towers_moveCollision	(	
					input		logic	clk,
					input		logic	resetN,
					input    logic startOfFrame,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					input 	logic signed	[10:0] spawnX, //position on the screen 
				
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,					
					
					output   logic edgeCollide,
					output	logic	drawingRequest // indicates pixel inside the bracket				
);

parameter  int OBJECT_WIDTH_X = 20;
parameter  int OBJECT_HEIGHT_Y = 20;
parameter  logic [7:0] OBJECT_COLOR = 8'h5b ; 
int Y_Speed=100;
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
 
int topLeftX;
int topLeftY;
int rightX ; //coordinates of the sides  
int bottomY ;

logic insideBracket;
int topLeftX_FixedPoint; // local parameters 
int topLeftY_FixedPoint;

const int FIXED_POINT_MULTIPLIER=64;
//////////--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries

assign topLeftX=topLeftX_FixedPoint/FIXED_POINT_MULTIPLIER;
assign topLeftY=topLeftY_FixedPoint/FIXED_POINT_MULTIPLIER;

assign rightX	= (topLeftX + OBJECT_WIDTH_X);
assign bottomY	= (topLeftY + OBJECT_HEIGHT_Y);

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		edgeCollide <= 1'b0;
		drawingRequest	<=	1'b0;
		
	end
	else begin 
		topLeftY_FixedPoint <= topLeftY_FixedPoint;
		topLeftX_FixedPoint <= topLeftX_FixedPoint;
		edgeCollide <= 1'b0;

		//this is an example of using blocking sentence inside an always_ff block, 
		//and not waiting a clock to use the result  
		insideBracket  = 	 ( (pixelX  >= topLeftX) &&  (pixelX < rightX) // ----- LEGAL BLOCKING ASSINGMENT in ALWAYS_FF CODE 
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY) )  ; 
		
		if (insideBracket ) // test if it is inside the rectangle 
		begin 
			drawingRequest <= 1'b1 ;
			offsetX	<= (pixelX - topLeftX_FixedPoint/FIXED_POINT_MULTIPLIER); //calculate relative offsets from top left corner
			offsetY	<= (pixelY - topLeftY);
		end 
		
		else begin  
			drawingRequest <= 1'b0 ;// transparent color 
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
		end 
		if(startOfFrame) begin
			if(topLeftY_FixedPoint>480*FIXED_POINT_MULTIPLIER) begin 
				edgeCollide<=1'b1;
				topLeftY_FixedPoint <= 0;
				topLeftX_FixedPoint <= spawnX*FIXED_POINT_MULTIPLIER;
			end
			else
				topLeftY_FixedPoint<=topLeftY_FixedPoint+Y_Speed;
		end
	end
end 
endmodule 