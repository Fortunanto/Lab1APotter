module powerUpProvider(
	input logic clk,
	input logic resetN,
	input logic startOfFrame,
	input logic dragonDead,

	output logic providePowerUp
);
parameter int powerUpLen=2400;
int delay;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		providePowerUp<=0;
		delay<=powerUpLen;
	end
	else begin
		providePowerUp <= 1;
		if(dragonDead) delay<=powerUpLen;
		if(delay!=0) delay<=delay-1;
		if(delay==0) providePowerUp <= 0;
	end
end

endmodule