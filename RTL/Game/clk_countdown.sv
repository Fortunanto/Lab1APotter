module clk_countdown(
input logic clk,
input logic resetN,
input startOfFrame,
input request_start,
input [3:0] requested_time,
output slowclk
);
logic [3:0] delay;
logic flag;
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		flag <= 0;
		delay <= 0;
		slowclk<=0;
	end
	else begin
		slowclk<=0;
		if(request_start) begin 
			flag <= 1;
			delay<=requested_time;
		end;
		if(delay!=0 && flag && startOfFrame) delay<=delay-1; 
		else if(delay==0 && flag) begin 
			slowclk<=1;
			flag<=0;
		end
	end
end
	
endmodule