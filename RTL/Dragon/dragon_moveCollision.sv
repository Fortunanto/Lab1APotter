module dragon_moveCollision(			
	input		logic	clk,
	input		logic	resetN,
	input    logic startOfFrame,		
	input    logic pause,
	input 	logic [10:0] RNG,
	input  	logic [2:0]shotDragonCollision,
	output	logic signed [10:0] topLeftX,
	output	logic signed [10:0]	topLeftY			
);
	logic collision;
	
	const int START_TLX = 680;
	const int START_TLY = 60;
	
	parameter int X_SPEED = -120;
	parameter int Y_SPEED = 70;
	
	parameter  int OBJECT_WIDTH_X = 11;
	parameter  int OBJECT_HEIGHT_Y = 48;
	
	int TLX_FIXED_POINT;
	int TLY_FIXED_POINT;	
	
	shortint currYSpeed=Y_SPEED;
	shortint currXSpeed=X_SPEED;
	
	const int FIXED_POINT_MULTIPLIER=64;
   const int SIGNED_DIVIDER = 6;
	const int UNLEASH_TIMER=100;
	const int OFF_SCREEN = 60_000;
	const int TOP_EDGE = 20;
	const int BOTTOM_EDGE = 180;
	const int HIGH_LIMIT_RANDOM=600;
	const int LOW_LIMIT_RANDOM=300;
	const int LEFT_EDGE = -50;
	
	assign topLeftX=TLX_FIXED_POINT>>>SIGNED_DIVIDER; // signed division
	assign topLeftY=TLY_FIXED_POINT>>>SIGNED_DIVIDER;	
	assign collision=shotDragonCollision!=0;
	
	logic [9:0][10:0] randoms = {11'd6,11'd501,11'd80,11'd100,11'd140,11'd18,11'd44,11'd340,11'd210,11'd277}; //predetermined random locations
	byte rndIndex=0;	
	
	// 0 - while dragon is not unleashed, 1 - when unleashed
	logic dragonUnleashed;
	
	// a timer that store random values, when it gets to zero the dragon is unleashed
	int unleashTimer;

	initial begin
		TLX_FIXED_POINT = START_TLX;
		TLY_FIXED_POINT = START_TLY;
		unleashTimer = UNLEASH_TIMER;
	end
	
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin	
		dragonUnleashed<=0;
		unleashTimer<=UNLEASH_TIMER;
	end
	else begin
		if(collision) begin
			dragonUnleashed<=0;
			currXSpeed<=0;
			currYSpeed<=0;
			TLX_FIXED_POINT<=OFF_SCREEN;
			TLY_FIXED_POINT<=OFF_SCREEN;
		end
		
		if(startOfFrame) begin	
		
			rndIndex<=rndIndex+1;
			if (rndIndex>10) rndIndex<=0;
		
			// if the dragon is ubleashed move it accurding to given speed
			if (dragonUnleashed) begin
				
				currYSpeed<=Y_SPEED;
				currXSpeed<=X_SPEED;
				
				// make sure the dragon doesnt get too high or too low on the screen
				if (topLeftY < TOP_EDGE) currYSpeed<=Y_SPEED;
				else if (topLeftY > BOTTOM_EDGE) currYSpeed<=-1*Y_SPEED;
				
				// change the dragon vertical direction randomly
				else if ((RNG + randoms[rndIndex])>LOW_LIMIT_RANDOM && (RNG + randoms[rndIndex])<HIGH_LIMIT_RANDOM) currYSpeed<=(-1)*currYSpeed;
				
				if (pause) begin
					currXSpeed<=0;
					currYSpeed<=0;
				end
				
				TLX_FIXED_POINT<=TLX_FIXED_POINT+currXSpeed;
				TLY_FIXED_POINT<=TLY_FIXED_POINT+currYSpeed;
				
				if (topLeftX<=LEFT_EDGE) dragonUnleashed<=0;
			end
			else begin // if the dragon is not unleashed stay off-screen and wait for timer
				currXSpeed<=0;
				currYSpeed<=0;
				TLX_FIXED_POINT<=START_TLX*FIXED_POINT_MULTIPLIER;
				TLY_FIXED_POINT<=START_TLY*FIXED_POINT_MULTIPLIER;	
				
				if (unleashTimer == 0) begin
					dragonUnleashed<=1;
					unleashTimer<=(RNG + randoms[rndIndex])*2;				
				end
				else unleashTimer <= unleashTimer - 1;
			end
			
		end
	end

end 
				
endmodule