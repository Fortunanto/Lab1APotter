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
		
	assign topLeftX=TLX_FIXED_POINT>>>6;
	assign topLeftY=TLY_FIXED_POINT>>>6;	
	assign collision=shotDragonCollision!=0;
	
	logic [9:0][10:0] randoms = {11'd6,11'd501,11'd80,11'd100,11'd140,11'd18,11'd44,11'd340,11'd210,11'd277};
	byte rndIndex=0;	
	
	logic dragonUnleashed;

	initial begin
		TLX_FIXED_POINT = START_TLX;
		TLY_FIXED_POINT = START_TLY;
	end
	
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin	
		dragonUnleashed<=0;
	end
	else begin
//		if (pause) begin
//			currXSpeed<=0;
//			currYSpeed<=0;
//		end
//		else begin
//			currXSpeed<=X_SPEED;
//			currYSpeed<=Y_SPEED;
//		end
		if(collision) begin
			dragonUnleashed<=0;
			currXSpeed<=0;
			currYSpeed<=0;
			TLX_FIXED_POINT<=60_000;
			TLY_FIXED_POINT<=60_000;
		end
		
		if(startOfFrame) begin	
		
			rndIndex<=rndIndex+1;
			if (rndIndex>10) rndIndex<=0;
		
			if (dragonUnleashed) begin
				
				currYSpeed<=Y_SPEED;
				currXSpeed<=X_SPEED;

				if (topLeftY < 20) currYSpeed<=Y_SPEED;
				else if (topLeftY > 180) currYSpeed<=-1*Y_SPEED;
				else if ((RNG + randoms[rndIndex])>300 && (RNG + randoms[rndIndex])<600) currYSpeed<=(-1)*currYSpeed;
				
				if (pause) begin
					currXSpeed<=0;
					currYSpeed<=0;
				end
				
				TLX_FIXED_POINT<=TLX_FIXED_POINT+currXSpeed;
				TLY_FIXED_POINT<=TLY_FIXED_POINT+currYSpeed;
				
				if (topLeftX<=-50) dragonUnleashed<=0;
			end
			else begin
				currXSpeed<=0;
				currYSpeed<=0;
				TLX_FIXED_POINT<=START_TLX*FIXED_POINT_MULTIPLIER;
				TLY_FIXED_POINT<=START_TLY*FIXED_POINT_MULTIPLIER;	
				
				if ((RNG + randoms[rndIndex])>550 && (RNG + randoms[rndIndex])<605) dragonUnleashed<=1;
			end
			
		end
	end

end 
				
endmodule