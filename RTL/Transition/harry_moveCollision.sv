module harry_moveCollision(			
	input		logic	clk,
	input		logic	resetN,
	input    logic startOfFrame,	
	input logic play,

	output logic gotToEdge,
	output	logic signed [10:0] topLeftX,
	output	logic signed [10:0]	topLeftY			
);
		
	parameter int START_TLX = 0;
	parameter int START_TLY = 300;
		
	parameter int X_SPEED = 120;	
	
	parameter int OBJECT_HEIGHT_Y = 38;
	parameter int OBJECT_WIDTH_X = 64;
	
	int TLX_FIXED_POINT;
	int TLY_FIXED_POINT;	
	
	const int FIXED_POINT_MULTIPLIER=64;
		
	assign topLeftX=TLX_FIXED_POINT>>>6; // divide by 64 signed
	assign topLeftY=TLY_FIXED_POINT>>>6; // divide by 64 signed
		

	initial begin
		TLX_FIXED_POINT = START_TLX*FIXED_POINT_MULTIPLIER;
		TLY_FIXED_POINT = START_TLY*FIXED_POINT_MULTIPLIER;
	end
	
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin	
		TLX_FIXED_POINT = START_TLX*FIXED_POINT_MULTIPLIER;
		TLY_FIXED_POINT = START_TLY*FIXED_POINT_MULTIPLIER;
	end
	else begin
		gotToEdge<=0;
		if(startOfFrame) begin
			if (play) begin
				TLX_FIXED_POINT<=TLX_FIXED_POINT+X_SPEED;
				if (topLeftX>=640) gotToEdge<=1;
			end
		end
	end

end 
				
endmodule