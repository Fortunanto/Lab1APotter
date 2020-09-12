//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	enemies_moveCollision	(	
					input		logic	clk,
					input		logic	resetN,
					input    logic startOfFrame,
									
					input logic changeDirection,					
					input logic dodgeBullet,
					input logic[2:0] shotCollision,
					input logic pause,
					input logic restart_loc,
					input logic[10:0] enemySpeed,
					input logic [10:0] RNG,
					
					output logic  [10:0] topLeftX,
					output logic  [10:0] topLeftY
						
										
);
logic collide;
parameter int INITIAL_X=240;
parameter int INITIAL_Y=210;

parameter int RIGHT_EDGE=500;
parameter int LEFT_EDGE =50;

parameter int dodgeBulletWait = 35;

logic [9:0][10:0] randoms = {11'd60,11'd500,11'd80,11'd100,11'd140,11'd438,11'd44,11'd340,11'd210,11'd277};
byte rndIndex=0;

 
int rightX ; //coordinates of the sides  
int bottomY ;

logic dodging;
logic dodgingAgg;

logic dodgingShot;
logic dodgingShotAgg;

int direction = 1;

//int dodgeBulletTimer=0;


logic insideBracket ;

int changeDirTimer;

int topLeftX_FixedPoint;
int topLeftY_FixedPoint;

int pixelX_FixedPoint,rightX_FixedPoint;
int xSpeed_Cur=80;

const int FIXED_POINT_MULTIPLIER=64;
//////////--------------------------------------------------------------------------------------------------------------=

assign collide = shotCollision!=0;



assign topLeftX=topLeftX_FixedPoint/FIXED_POINT_MULTIPLIER;
assign topLeftY=topLeftY_FixedPoint/FIXED_POINT_MULTIPLIER;

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		topLeftX_FixedPoint <= INITIAL_X*FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint <= INITIAL_Y*FIXED_POINT_MULTIPLIER;		
		xSpeed_Cur <= enemySpeed;
		dodging<=0;
		dodgingShot<=0;
		changeDirTimer<=INITIAL_X;
	end
	else begin 
		xSpeed_Cur <= enemySpeed;
		topLeftY_FixedPoint <= topLeftY_FixedPoint;
		topLeftX_FixedPoint <= topLeftX_FixedPoint;
		if (changeDirection) dodgingAgg <= 1;
		if (dodgeBullet) dodgingShotAgg <= 1;
		
		if (changeDirection && dodging==0) begin // when hitting a tower
			direction<=-1*direction;
			dodging <=1;			
		end
		
		if (dodgeBullet && dodgingShot==0) begin
			direction<=-1*direction;
			dodgingShot <=1;			
		end
		if (restart_loc) begin
		      topLeftX_FixedPoint <= INITIAL_X*FIXED_POINT_MULTIPLIER;
				topLeftY_FixedPoint <= INITIAL_Y*FIXED_POINT_MULTIPLIER;		
				xSpeed_Cur <= enemySpeed;
				dodging<=0;
				dodgingShot<=0;
		end
		if (collide) begin
				topLeftY_FixedPoint <= 50_000;
				topLeftX_FixedPoint <= 50_000;
				xSpeed_Cur <= 0;
		end
		
		else
			if(startOfFrame) begin
				if(topLeftX<LEFT_EDGE) begin 
					direction <= 1; // move right
				end
				else if (topLeftX > RIGHT_EDGE) begin
					direction <= -1; // move left
				end			
				
				topLeftX_FixedPoint <= topLeftX_FixedPoint + direction*xSpeed_Cur;
				
				if (dodgingAgg==0) begin // after dodged a tower				   
					dodging <= 0;
				end
				dodgingAgg<=0;
				
				if (dodgingShotAgg==0) begin // after dodged a bullet				  
					dodgingShot <= 0;
				end
				dodgingShotAgg<=0;
				
				if (changeDirTimer == 0) begin // randomly change direction!!!!!
					direction <= -1*direction;
					changeDirTimer <= RNG + randoms[rndIndex];
					rndIndex<=rndIndex+1;
					if (rndIndex>10) rndIndex <= 0;
				end
				else changeDirTimer<= changeDirTimer-1;
				
				//if (dodgeBulletTimer > 0) dodgeBulletTimer<=dodgeBulletTimer-1;
			end	
		if (pause) topLeftX_FixedPoint <= topLeftX_FixedPoint;

		
	end
end 
endmodule 