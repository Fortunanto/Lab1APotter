module hoop__moveCollision(			
	input		logic	clk,
	input		logic	resetN,
	input    logic startOfFrame,
	input 	logic signed	[10:0] spawnX, //position on the screen 
	input    logic towerHoopCollision,
	input    logic pause,
	
	output	 logic signed 	[10:0]	topLeftX,// output the top left corner 
	output	 logic signed	[10:0]	topLeftY			
);
					
					
	parameter int FALL_SPEED=100;
	parameter  int OBJECT_WIDTH_X = 28;
	parameter  int OBJECT_HEIGHT_Y = 58;
	
	
	int hoopTLX_FIXED_POINT;
	int hoopTLY_FIXED_POINT;
	
	
	int Y_Speed=FALL_SPEED;
	
	const int FIXED_POINT_MULTIPLIER=64;
	
	logic [9:0][10:0] randoms = {11'd6,11'd500,11'd80,11'd100,11'd140,11'd18,11'd44,11'd340,11'd210,11'd277};
	byte rndIndex=0;
	
	assign topLeftX = hoopTLX_FIXED_POINT/FIXED_POINT_MULTIPLIER;
	assign topLeftY = hoopTLY_FIXED_POINT/FIXED_POINT_MULTIPLIER;
	
	
	initial begin
		hoopTLY_FIXED_POINT = 0;
		hoopTLY_FIXED_POINT = 0;

	end
	
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
	
	end
	else begin
		if (pause) Y_Speed=0;
		else Y_Speed=FALL_SPEED;
		
		if(startOfFrame) begin				
			if(topLeftY>480) begin 				
				hoopTLY_FIXED_POINT <= (OBJECT_HEIGHT_Y)*FIXED_POINT_MULTIPLIER*(-1);
				hoopTLX_FIXED_POINT <= (spawnX+randoms[rndIndex])*FIXED_POINT_MULTIPLIER;
				rndIndex<=rndIndex+1;
				if (rndIndex>10) rndIndex <= 0;
			end
			else
				hoopTLY_FIXED_POINT<=hoopTLY_FIXED_POINT+Y_Speed;
						
			if (topLeftX>640) begin
				hoopTLX_FIXED_POINT<=hoopTLX_FIXED_POINT-(640*FIXED_POINT_MULTIPLIER);	
			end
		end
	end

end 
				
endmodule