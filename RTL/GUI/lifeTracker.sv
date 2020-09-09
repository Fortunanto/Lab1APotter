module lifeTracker(	
					input		logic	clk,
					input		logic	resetN,
					
					input logic [2:0] amount,
					input logic enableSetLife,
					input logic enableAddLife,
					input logic enableRemoveLife,
		
					output logic [2:0] currLife
);


parameter logic [2:0] START_LIFE = 3;


initial begin
	currLife = START_LIFE;
end

always_ff@(posedge clk or negedge resetN)
begin
	if (!resetN) begin
		currLife<=START_LIFE;
	end
	else begin	
		if (enableSetLife) currLife<=amount;
		if (enableAddLife) currLife<=currLife+amount;
		if (enableRemoveLife) begin
			if (amount>currLife) currLife<=0;
			else currLife<=currLife-amount;
		end
	end
end

endmodule