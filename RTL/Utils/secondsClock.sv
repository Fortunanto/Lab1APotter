module secondsClock(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic startOfFrame,
					input    logic pause,
					
					output logic secPassed
);

const logic [0:8] FPS = 60;

logic [0:8] count;


always_ff@(posedge clk or negedge resetN)
begin
	if (!resetN) begin
		count <= 0;
	end
	else begin
		secPassed<=0;
		if (startOfFrame) begin
			if(!pause)
				count<=count+1;
			if (count==FPS) begin
				count<=0;
				secPassed<=1;
			end
		end
	end
end

endmodule