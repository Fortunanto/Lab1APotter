
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 


module	game_controller	(	
			input		logic	clk,
			input		logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_Ball,
			input logic drawing_request_enemy_HU,
			input logic drawing_request_enemy_HD,
			input logic drawing_request_enemy,
			input logic drawing_request_tower,
			input logic [2:0] drawing_request_shot,

			output logic[2:0] ShotBoxCollision,
			output logic TowerEnemyHUCollision,
			output logic ShotHeadsDownCollision,
			output logic[2:0] ShotEnemyCollision,
			output logic towerPlayerCollision,
			
			output logic [0:23] scoreAmount,
			output logic enableAddScore,
			output logic enableRemoveScore
);

logic box_smiley_collision,box_edge_collision, edge_smiley_collision;

assign ShotBoxCollision = (drawing_request_shot!=0 && drawing_request_tower)? drawing_request_shot:0;
assign TowerEnemyHUCollision = (drawing_request_enemy_HU && drawing_request_tower);
assign ShotEnemyCollision = (drawing_request_shot!=0 && drawing_request_enemy)? drawing_request_shot:0;
assign towerPlayerCollision = (drawing_request_Ball && drawing_request_tower);
assign ShotHeadsDownCollision = (drawing_request_shot!=0 && drawing_request_enemy_HD);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		enableAddScore<=0;
		enableRemoveScore<=0;
		scoreAmount<=0;
	end 
	else begin 
	
		enableAddScore<=0;
		enableRemoveScore<=0;
		scoreAmount<=0;
	
		if (ShotEnemyCollision!=0) begin
			enableAddScore<=1;
			scoreAmount <= 24'b0000_0100_0000_0000_0000_0000; //50
		end
	end 
end

endmodule
