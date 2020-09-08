
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 


module	game_controller	(	
			input		logic	clk,
			input		logic	resetN,
			input    logic ghostMode,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_Ball,
			input logic drawing_request_enemy_HU,
			input logic drawing_request_enemy_HD,
			input logic drawing_request_enemy,
			input logic drawing_request_tower,
			input logic [2:0] drawing_request_shot,
			input logic drawing_request_hoop,
			input logic slowClk,
			
			output logic[2:0] ShotBoxCollision,
			output logic TowerEnemyHUCollision,
			output logic ShotHeadsDownCollision,
			output logic[2:0] ShotEnemyCollision,
			output logic towerPlayerCollision,
			output logic hoopTowerCollision,
			output logic [0:23] scoreAmount,
			output logic enableAddScore,
			output logic enableRemoveScore,
			output logic requestTime,
			output logic [0:10] timeLenReq,
			output logic enableAddLife,
			output logic enableRemoveLife,
			output logic [0:2] lifeAmount
);

logic box_smiley_collision,box_edge_collision, edge_smiley_collision;
logic shotCollisionFlag,hoopTransitionFlag,hoopPlayerCollision;

assign ShotBoxCollision = (drawing_request_shot!=0 && drawing_request_tower)? drawing_request_shot:0;
assign TowerEnemyHUCollision = (drawing_request_enemy_HU && drawing_request_tower);
assign towerPlayerCollision = (drawing_request_Ball && drawing_request_tower && !ghostMode);
assign ShotHeadsDownCollision = (drawing_request_shot!=0 && drawing_request_enemy_HD);
assign hoopTowerCollision = (drawing_request_hoop && drawing_request_tower);
assign hoopPlayerCollision = (drawing_request_Ball && drawing_request_hoop);
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		shotCollisionFlag	<= 1'b0;
		enableAddScore<=0;
		enableRemoveScore<=0;
		scoreAmount<=0;
		hoopTransitionFlag<=1;
		enableAddLife<=0;
		enableRemoveLife<=0;
	end 
	else begin 
			ShotEnemyCollision<=0;
			requestTime <= 0;
			timeLenReq <= 0;		
			
			
			// Detect shot - Enemy collision
			if(startOfFrame) 
				shotCollisionFlag = 1'b0 ; // reset for next time 	
			if ( (drawing_request_shot!=0 && drawing_request_enemy) && (shotCollisionFlag == 1'b0)) begin 
				shotCollisionFlag	<= 1'b1; // to enter only once 
				ShotEnemyCollision <= drawing_request_shot;
			end 
			
			
			// Add score on enemy collision
			enableAddScore<=0;
			enableRemoveScore<=0;
			scoreAmount<=0;
			
			enableAddLife<=0;
			enableRemoveLife<=0;
			
			if (ShotEnemyCollision!=0) begin
				enableAddScore<=1;
				scoreAmount <= 24'b0000_0100_0000_0000_0000_0000; //40
			end
			// Add score on hoop moving through
			if(hoopTransitionFlag && hoopPlayerCollision) begin
			
				// TODO:  currently remove life on hoop collision for test, check how to insert to game_fsm
				enableRemoveLife<=1;
				lifeAmount<=1;
			
			
			
			
				enableAddScore<=1;
				scoreAmount <= 24'b0000_1010_0000_0000_0000_0000; //160
				hoopTransitionFlag <= 0;
				requestTime <= 1;
				timeLenReq <= 60;
			end
			if(slowClk) begin
				hoopTransitionFlag <= 1;
			end
	end 
end

endmodule
