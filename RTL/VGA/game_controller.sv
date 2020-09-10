
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 


module	game_controller	(	
			input		logic	clk,
			input		logic	resetN,
			input    logic ghostMode,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_Player,
			input logic drawing_request_enemy_HU,
			input logic drawing_request_enemy_HD,
			input logic drawing_request_enemy,
			input logic drawing_request_tower,
			input logic [2:0] drawing_request_shot,
			input logic drawing_request_hoop,
			input logic slowClk,
			input logic drawing_request_dragon,
			
			output logic[2:0] ShotTowerCollision,
			output logic TowerEnemyHUCollision,
			output logic ShotHeadsDownCollision,
			output logic[2:0] ShotEnemyCollision,
			output logic hoopTowerCollision,
			output logic [0:23] scoreAmount,
			output logic enableAddScore,
			output logic enableRemoveScore,
			output logic requestTime,
			output logic [0:10] timeLenReq,
			output logic enableAddLife,
			output logic enableRemoveLife,
			output logic [2:0] lifeAmount,
			output logic [2:0] dragonShotCollision

);

parameter int PLAYER_TOWER_TIME_LEN = 200;

logic box_smiley_collision,box_edge_collision, edge_smiley_collision;
logic shotCollisionFlag,hoopTransitionFlag,hoopPlayerCollision;
int playerTowerCollisionDelay;

assign ShotTowerCollision = (drawing_request_shot!=0 && drawing_request_tower)? drawing_request_shot:0;
assign TowerEnemyHUCollision = (drawing_request_enemy_HU && drawing_request_tower);

assign ShotHeadsDownCollision = (drawing_request_shot!=0 && drawing_request_enemy_HD);
assign hoopTowerCollision = (drawing_request_hoop && drawing_request_tower);
assign hoopPlayerCollision = (drawing_request_Player && drawing_request_hoop);
assign dragonShotCollision = (drawing_request_dragon && drawing_request_shot!=0) ? drawing_request_shot:0;

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
			enableAddScore<=0;
			enableRemoveScore<=0;
			scoreAmount<=0;
			enableAddLife<=0;
			enableRemoveLife<=0;
				
		
			// Detect shot - Enemy collision
			if ( (drawing_request_shot!=0 && drawing_request_enemy) && (shotCollisionFlag == 1'b0)) begin 
				shotCollisionFlag	<= 1; // to enter only once 
				ShotEnemyCollision <= drawing_request_shot;
				enableAddScore<=1;
				scoreAmount <= 24'b0000_0100_0000_0000_0000_0000; //40
			end 
			
			// remove life on player-tower collision
			if( drawing_request_Player && drawing_request_tower && (playerTowerCollisionDelay == 0) && !ghostMode) begin
				enableRemoveLife <= 1'b1;
				lifeAmount <= 1;
				playerTowerCollisionDelay<=PLAYER_TOWER_TIME_LEN;
			end

					
			
			// Add score on hoop moving through
			if(hoopTransitionFlag && hoopPlayerCollision) begin
				enableAddScore<=1;
				scoreAmount <= 24'b0000_0000_0001_0000_0000_0000; //100
				hoopTransitionFlag <= 0;
				requestTime <= 1;
				timeLenReq <= 60;
			end
			if(slowClk) begin
				hoopTransitionFlag <= 1;
			
			end
			
			if(startOfFrame) begin
				shotCollisionFlag <= 0 ; // reset for next time 
				if(playerTowerCollisionDelay!= 0) begin
					playerTowerCollisionDelay<=playerTowerCollisionDelay-1;
				end	
			end

	end 
end

endmodule
