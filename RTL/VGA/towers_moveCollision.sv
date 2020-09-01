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
					input    logic pause,
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,					
					
					//output   logic edgeCollide,
					output	logic	drawingRequest // indicates pixel inside the bracket				
);
parameter int FALL_SPEED=100;
parameter  int OBJECT_WIDTH_X = 28;
parameter  int OBJECT_HEIGHT_Y = 58;

parameter int MAX_TOWERS_AMOUNT=10;
parameter int TOWERS_WAIT=100;

int currTowersAmount=1;
logic [4:0] towerIndex; // used in for loop
int towerTimer=TOWERS_WAIT;

logic [31:0][31:0] towersTLX_FIXED_POINT;
logic [31:0][31:0] towersTLY_FIXED_POINT;
 
int Y_Speed=FALL_SPEED;

const int FIXED_POINT_MULTIPLIER=64;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		drawingRequest	<=	1'b0;	
		towerTimer<=TOWERS_WAIT;		
	end
	else begin
	
		towerTimer<=towerTimer;
		currTowersAmount<=currTowersAmount;
		if (pause) Y_Speed=0;
		else Y_Speed=FALL_SPEED;
		if (startOfFrame) begin
			if (towerTimer>0) begin
				towerTimer<=towerTimer-1;	
			end
			else begin
				towerTimer<=TOWERS_WAIT;
				if (currTowersAmount<MAX_TOWERS_AMOUNT) currTowersAmount<=currTowersAmount+1;
			end
		end
		
		drawingRequest <= 1'b0 ;// transparent color 
		offsetX	<= 0; //no offset
		offsetY	<= 0; //no offset
		
	
		for (towerIndex=0;towerIndex<20;towerIndex++) begin
		
			if (towerIndex<currTowersAmount) begin
		
				if(startOfFrame) begin				
					if(towersTLY_FIXED_POINT[towerIndex]>480*FIXED_POINT_MULTIPLIER) begin 				
						towersTLY_FIXED_POINT[towerIndex] <= 0;
						towersTLX_FIXED_POINT[towerIndex] <= spawnX*FIXED_POINT_MULTIPLIER;
					end
					else
						towersTLY_FIXED_POINT[towerIndex]<=towersTLY_FIXED_POINT[towerIndex]+Y_Speed;
				end
		
				if ((towersTLX_FIXED_POINT[towerIndex]/FIXED_POINT_MULTIPLIER<=pixelX) &&
					 (towersTLX_FIXED_POINT[towerIndex]/FIXED_POINT_MULTIPLIER+OBJECT_WIDTH_X>pixelX) &&
					 (towersTLY_FIXED_POINT[towerIndex]/FIXED_POINT_MULTIPLIER<=pixelY) &&
					 (towersTLY_FIXED_POINT[towerIndex]/FIXED_POINT_MULTIPLIER+OBJECT_HEIGHT_Y>pixelY)) begin
					drawingRequest <= 1'b1 ;
					offsetX	<= (pixelX - towersTLX_FIXED_POINT[towerIndex]/FIXED_POINT_MULTIPLIER);
					offsetY	<= (pixelY - towersTLY_FIXED_POINT[towerIndex]/FIXED_POINT_MULTIPLIER);
				end	
			
			end				
		end
	end

end 
endmodule 