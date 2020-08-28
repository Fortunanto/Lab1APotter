module shots_array	
 ( 
	input	logic	clk,
	input	logic	resetN,
	input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
	input	logic	triggerShot,  
	input	logic [2:0] shotDirection, 
	input logic shotBoxCollision,  //collision if smiley hits an object
	input logic shotEnemyCollision,
	input	logic	[3:0] HitEdgeCode, //one bit per edge 
	
	input     logic signed  [10:0]   player_topLeftX,
	input     logic signed  [10:0]   player_topLeftY,
	
	output	 logic signed 	[10:0]	topLeftX,// output the top left corner 
	output	 logic signed	[10:0]	topLeftY
	);

	
	
	logic [3:0] muxi; // Holds the intermediate results	
	
	// fill your code here 
	
//	mux_4to1_case mux0 (.datain(datain[3:0]),.select(select[1:0]),.outd(muxi[0]));
//	mux_4to1_case mux1 (.datain(datain[7:4]),.select(select[1:0]),.outd(muxi[1]));
//	mux_4to1_case mux2 (.datain(datain[11:8]),.select(select[1:0]),.outd(muxi[2]));
//	mux_4to1_case mux3 (.datain(datain[15:12]),.select(select[1:0]),.outd(muxi[3]));
//	
//	mux_4to1_case muxall (.datain(muxi),.select(select[3:2]),.outd(outd));
	
	
endmodule
