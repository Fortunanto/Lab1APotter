module hoop__moveCollision(			
	input		logic	clk,
	input		logic	resetN,
	input    logic startOfFrame,
	input 	logic [10:0] spawnX, //position on the screen 
	input    logic towerHoopCollision,
	input    logic pause,
	
	output	 logic signed [10:0]  		topLeftX,// output the top left corner 
	output	 logic signed [10:0]	topLeftY			
);
					
					
	parameter int FALL_SPEED=100;
	parameter  int OBJECT_WIDTH_X = 28;
	parameter  int OBJECT_HEIGHT_Y = 58;
	
	shortint topLeftXSigned,topLeftYSigned;
	int hoopTLX_FIXED_POINT;
	int hoopTLY_FIXED_POINT;
	
	
	int Y_Speed=FALL_SPEED;
	
	const int FIXED_POINT_MULTIPLIER=64;
	
	logic [9:0][10:0] randoms = {11'd6,11'd500,11'd80,11'd100,11'd140,11'd18,11'd44,11'd340,11'd210,11'd277};
	byte rndIndex=0;
	
	assign topLeftXSigned = $signed(hoopTLX_FIXED_POINT)/$signed(FIXED_POINT_MULTIPLIER);
	assign topLeftYSigned = $signed(hoopTLY_FIXED_POINT)/$signed(FIXED_POINT_MULTIPLIER);
	assign topLeftX=hoopTLX_FIXED_POINT>>>6; // divide by 64, signed
	assign topLeftY=hoopTLY_FIXED_POINT>>>6; // divide by 64, signed

	initial begin
		hoopTLX_FIXED_POINT = 0; 
		hoopTLY_FIXED_POINT = $signed((OBJECT_HEIGHT_Y))*$signed(FIXED_POINT_MULTIPLIER)*4*$signed((-1)); // place the hoop in its initial position

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
				hoopTLY_FIXED_POINT <= $signed((OBJECT_HEIGHT_Y))*$signed(FIXED_POINT_MULTIPLIER)*4*$signed((-1)); // move the hoop offscreen
				hoopTLX_FIXED_POINT <= (spawnX+randoms[rndIndex])*FIXED_POINT_MULTIPLIER; // choose a new random x position
				rndIndex<=rndIndex+1;
				if (rndIndex>10) rndIndex <= 0;
			end
			else
				hoopTLY_FIXED_POINT<=hoopTLY_FIXED_POINT+Y_Speed;
						
			if (topLeftX>640) begin
				hoopTLX_FIXED_POINT<=hoopTLX_FIXED_POINT-(640*FIXED_POINT_MULTIPLIER);	
			end
			 
		end
		if (towerHoopCollision) 
					hoopTLX_FIXED_POINT<=hoopTLX_FIXED_POINT+(OBJECT_WIDTH_X+30)*FIXED_POINT_MULTIPLIER; //move the hoop from the tower it hit.
	end

end 
				
endmodule