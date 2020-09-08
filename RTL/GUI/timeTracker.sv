module timeTracker(	
					input		logic	clk,
					input		logic	resetN,
					input logic secPassed,
					
					
					output logic enableAdd,
					output logic enableRemove,
					output logic[0:23] amount
);


parameter logic [0:23] START_TIME = 24'b0000_0000_0010_0000_0000_0000; // 200 seconds

logic timeIsSet;

always_ff@(posedge clk or negedge resetN)
begin
	if (!resetN) begin
		amount<=START_TIME;
		enableAdd<=1;
		timeIsSet<=1;
	end
	else begin
	
		enableRemove<=0;
		enableAdd<=0;
	
		if (timeIsSet==0) begin
			amount<=START_TIME;
			enableAdd<=1;
			timeIsSet<=1;
		end
		else begin
			if (secPassed) begin
				amount<=24'b0001_0000_0000_0000_0000_0000; // one second
				enableRemove<=1;
			end
		end
	end
end

endmodule