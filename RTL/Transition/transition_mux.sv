//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	transition_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		
		// harry 
					input logic harryDrawReq,
					input logic [7:0] harryRGB,
					
		// NextLevel					
					input logic nextLevelDrawReq,
					input logic [7:0] nextLevelRGB,
					
					output logic [7:0] transitionRGB
);


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		transitionRGB	<= 8'b0;
	end
	else begin
		if (harryDrawReq) transitionRGB <= harryRGB;
		else if (nextLevelDrawReq) transitionRGB <= nextLevelRGB;		
		else transitionRGB <= 8'hEB; // last priority 
	end 	
end

endmodule


