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

logic dodging; // 1 - if the enemy is performing a dodge from a tower, otherwise 0
logic dodgingAgg;// will be 0 if for all the frame no collision with tower was detected, otherwise 1

logic dodgingShot;  // 1 - if the enemy is performing a dodge from a shot, otherwise 0
logic dodgingShotAgg; // will be 0 if for all the frame no collision with shot was detected, otherwise 1

int direction = 1; // [1] - move right, [-1] - move left

logic insideBracket ;

int changeDirTimer;

int topLeftX_FixedPoint;
int topLeftY_FixedPoint;

int pixelX_FixedPoint,rightX_FixedPoint;
int xSpeed_Cur=80;

const int FIXED_POINT_MULTIPLIER=64;
const int OFFSCREEN_LOCATION=50_000;

assign collide = shotCollision!=0;

assign topLeftX=topLeftX_FixedPoint/FIXED_POINT_MULTIPLIER;
assign topLeftY=topLeftY_FixedPoint/FIXED_POINT_MULTIPLIER;


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
		
		// set aggregators values
		if (changeDirection) dodgingAgg <= 1;
		if (dodgeBullet) dodgingShotAgg <= 1;
		
		if (changeDirection && dodging==0) begin // when hitting a tower 
			direction<=-1*direction;
			dodging <=1;			
		end
		
		if (dodgeBullet && dodgingShot==0) begin // when hitting a shot
			direction<=-1*direction;
			dodgingShot <=1;			
		end
		
		
		if (restart_loc) begin // set to restart position
		      topLeftX_FixedPoint <= INITIAL_X*FIXED_POINT_MULTIPLIER;
				topLeftY_FixedPoint <= INITIAL_Y*FIXED_POINT_MULTIPLIER;		
				xSpeed_Cur <= enemySpeed;
				dodging<=0;
				dodgingShot<=0;
		end
		
		if (collide) begin // move offscreen when hit from a shot
				topLeftY_FixedPoint <= OFFSCREEN_LOCATION;
				topLeftX_FixedPoint <= OFFSCREEN_LOCATION;
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
				
				if (changeDirTimer == 0) begin // randomly change direction
					if (dodging==0 && dodgingShot==0) begin
						direction <= -1*direction;
					end
					changeDirTimer <= RNG + randoms[rndIndex];
					rndIndex<=rndIndex+1;
					if (rndIndex>10) rndIndex <= 0;
				end
				else changeDirTimer<= changeDirTimer-1;			
				
			end	
		if (pause) topLeftX_FixedPoint <= topLeftX_FixedPoint;

		
	end
end 
endmodule 