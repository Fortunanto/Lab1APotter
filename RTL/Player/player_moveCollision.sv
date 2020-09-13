//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018


module	player_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	moveLeft,  
					input	logic	moveRight,
					
					// TODO: remove after asking yiftach
					//input logic collision,  //collision if smiley hits an object
					//input	logic	[3:0] HitEdgeCode, //one bit per edge 
					
					
					input logic pause,
					output	 logic signed 	[10:0]	topLeftX,// output the top left corner 
					output	 logic signed	[10:0]	topLeftY
					
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 185;
parameter int INITIAL_X_SPEED = 10;

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 


int Xspeed=INITIAL_X_SPEED, topLeftX_FixedPoint=INITIAL_X * FIXED_POINT_MULTIPLIER; // local parameters 
int  topLeftY_FixedPoint=INITIAL_Y * FIXED_POINT_MULTIPLIER;

//////////--------------------------------------------------------------------------------------------------------------=
// position calculate 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end
	else begin
		if (startOfFrame == 1'b1) begin // perform  position integral only 30 times per second 
			if (moveLeft==1'b0 && moveRight==1'b0)  
				topLeftX_FixedPoint  <= topLeftX_FixedPoint;
			if (moveLeft==1'b0) //  while moving left
				if(topLeftX_FixedPoint-Xspeed < 620) // check to see if we hit the edge of the screen
					topLeftX_FixedPoint  <= 620; 
				else
					topLeftX_FixedPoint  <= topLeftX_FixedPoint - Xspeed; 
			if (moveRight==1'b0)  
				if(topLeftX_FixedPoint+Xspeed > 35600) // check to see if we hit the edge of the screen
					topLeftX_FixedPoint  <= 35600; 
				else
					topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;  // move the player
			end
		if(pause) topLeftX_FixedPoint  <= topLeftX_FixedPoint;
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
