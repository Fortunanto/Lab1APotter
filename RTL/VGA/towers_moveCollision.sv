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
shortint towerTimer=TOWERS_WAIT;

int towersTLX_FIXED_POINT [31:0];
int towersTLY_FIXED_POINT [31:0];

shortint towersTLX [31:0];
shortint towersTLY [31:0];

bit alreadyDrawing;

shortint offsetXsigned;
shortint offsetYsigned;

assign offsetX = offsetXsigned;
assign offsetY = offsetYsigned;
 
int Y_Speed=FALL_SPEED;

const int FIXED_POINT_MULTIPLIER=64;

logic [9:0][10:0] randoms = {11'd6,11'd500,11'd80,11'd100,11'd140,11'd18,11'd44,11'd340,11'd210,11'd277};
byte rndIndex=0;

genvar i;
generate
	for (i=0;i<20;i++) begin: assLoop
		assign towersTLX[i] = towersTLX_FIXED_POINT[i]/FIXED_POINT_MULTIPLIER;
		assign towersTLY[i] = towersTLY_FIXED_POINT[i]/FIXED_POINT_MULTIPLIER;
	end
endgenerate

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
		offsetXsigned	<= 0; //no offset
		offsetYsigned	<= 0; //no offset
		
		alreadyDrawing=0;
	
		for (towerIndex=0;towerIndex<20;towerIndex++) begin
		
			if (towerIndex<currTowersAmount) begin
		
				if(startOfFrame) begin				
					if(towersTLY[towerIndex]>480) begin 				
						towersTLY_FIXED_POINT[towerIndex] <= (OBJECT_HEIGHT_Y)*FIXED_POINT_MULTIPLIER*(-1);
						//towersTLY_FIXED_POINT[towerIndex] <= 0;
						towersTLX_FIXED_POINT[towerIndex] <= (spawnX+randoms[rndIndex])*FIXED_POINT_MULTIPLIER;
						rndIndex<=rndIndex+1;
						if (rndIndex>10) rndIndex <= 0;
					end
					else
						towersTLY_FIXED_POINT[towerIndex]<=towersTLY_FIXED_POINT[towerIndex]+Y_Speed;
						
					if (towersTLX[towerIndex]>640) towersTLX_FIXED_POINT[towerIndex]<=towersTLX_FIXED_POINT[towerIndex]-(640*FIXED_POINT_MULTIPLIER);	
				end
		
				if ((towersTLX[towerIndex]<=$signed(pixelX)) &&
					 (towersTLX[towerIndex]+OBJECT_WIDTH_X>$signed(pixelX)) &&
					 (towersTLY[towerIndex]<=$signed(pixelY)) &&
					 (towersTLY[towerIndex]+OBJECT_HEIGHT_Y>$signed(pixelY))) begin
					 if (alreadyDrawing) begin
							towersTLX_FIXED_POINT[towerIndex]<=towersTLX_FIXED_POINT[towerIndex]+(OBJECT_WIDTH_X+20)*FIXED_POINT_MULTIPLIER;
							towersTLY_FIXED_POINT[towerIndex]<=towersTLY_FIXED_POINT[towerIndex]-(OBJECT_HEIGHT_Y+77)*FIXED_POINT_MULTIPLIER;
					 end
					 else begin
							drawingRequest <= 1'b1 ;
							offsetXsigned	<= (pixelX - towersTLX[towerIndex]);
							offsetYsigned	<= (pixelY - towersTLY[towerIndex]);
							alreadyDrawing = 1;
					 end
				end				
			end				
		end
	end

end 
endmodule 