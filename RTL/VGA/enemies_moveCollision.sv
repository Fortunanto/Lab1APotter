//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	enemies_moveCollision	(	
					input		logic	clk,
					input		logic	resetN,
					input    logic startOfFrame,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					
					input logic changeDirection,
					input logic dodgeBullet,
					input logic[2:0] shotCollision,
					input logic pause,
					output logic  [10:0] topLeftX,
					output logic  [10:0] topLeftY,
					
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,					
					output	logic	drawingRequest // indicates pixel inside the bracket				
										
);
logic collide;
parameter int INITIAL_X=240;
parameter int INITIAL_Y=200;

parameter int OBJECT_WIDTH_X=30;
parameter int OBJECT_HEIGHT_Y=30;

parameter int X_SPEED=120;

parameter int dodgeBulletWait = 35;

parameter  logic [7:0] OBJECT_COLOR = 8'h5b ; 

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
 
int rightX ; //coordinates of the sides  
int bottomY ;


int direction = 1;

const int directionChangeWait = 35;

int directionChangeTimer=0;
int dodgeBulletTimer=0;


logic insideBracket ;

int topLeftX_FixedPoint;
int topLeftY_FixedPoint;

int pixelX_FixedPoint,rightX_FixedPoint;
int xSpeed_Cur;

const int FIXED_POINT_MULTIPLIER=64;
//////////--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries
assign collide = shotCollision!=0;

assign rightX	= (topLeftX_FixedPoint/FIXED_POINT_MULTIPLIER + OBJECT_WIDTH_X);
assign bottomY	= (topLeftY + OBJECT_HEIGHT_Y);


assign topLeftX=topLeftX_FixedPoint/FIXED_POINT_MULTIPLIER;
assign topLeftY=topLeftY_FixedPoint/FIXED_POINT_MULTIPLIER;

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		drawingRequest	<=	1'b0;
		topLeftX_FixedPoint <= INITIAL_X*FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint <= INITIAL_Y*FIXED_POINT_MULTIPLIER;		
		xSpeed_Cur <= X_SPEED;
	end
	else begin 
	
		topLeftY_FixedPoint <= topLeftY_FixedPoint;
		topLeftX_FixedPoint <= topLeftX_FixedPoint;
	

		//this is an example of using blocking sentence inside an always_ff block, 
		//and not waiting a clock to use the result  
		insideBracket  = 	 ( (pixelX  >= topLeftX) &&  (pixelX < rightX) // ----- LEGAL BLOCKING ASSINGMENT in ALWAYS_FF CODE 
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY) )  ; 
		
		if (insideBracket) begin 
			drawingRequest <= 1'b1 ;
			offsetX	<= (pixelX - topLeftX); //calculate relative offsets from top left corner
			offsetY	<= (pixelY - topLeftY);
		end 		
		else begin  
			drawingRequest <= 1'b0 ;// transparent color 
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
		end 
		
		if (changeDirection==1 && directionChangeTimer==0) begin
				direction<=-1*direction;
				directionChangeTimer <= directionChangeWait;
		end
		
		if (dodgeBullet && dodgeBulletTimer==0) begin
			direction<=-1*direction;
			dodgeBulletTimer<=dodgeBulletWait;
		end
		
		if (collide) begin
				topLeftY_FixedPoint <= 50_000;
				topLeftX_FixedPoint <= 50_000;
				xSpeed_Cur <= 0;
		end
		
		else
			if(startOfFrame) begin
				if(topLeftX_FixedPoint<0) begin 
					direction <= 1; // move right
				end
				else if (topLeftX_FixedPoint > (640-OBJECT_WIDTH_X)*FIXED_POINT_MULTIPLIER) begin
					direction <= -1; // move left
				end			
				
				topLeftX_FixedPoint <= topLeftX_FixedPoint + direction*xSpeed_Cur;
				if (directionChangeTimer > 0) directionChangeTimer<=directionChangeTimer-1;
				if (dodgeBulletTimer > 0) dodgeBulletTimer<=dodgeBulletTimer-1;
			end	
		if (pause) topLeftX_FixedPoint <= topLeftX_FixedPoint;

		
	end
end 
endmodule 