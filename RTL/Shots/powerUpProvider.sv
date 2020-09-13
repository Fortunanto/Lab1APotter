module powerUpProvider(
	input logic clk,
	input logic resetN,
	input logic startOfFrame,
	input logic [2:0] shotDragonCollision,

	output logic providePowerUp
);
parameter int powerUpLen=2400;
int delay;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		providePowerUp<=0;
		delay<=0;
	end
	else begin
		providePowerUp <= 1;
		if(shotDragonCollision !=0) delay<=powerUpLen; // if the shot collided with a dragon provide powerup
		if(startOfFrame && delay!=0) delay<=delay-1; // decrease timer
		else if(delay==0) providePowerUp <= 0;
	end
end

endmodule