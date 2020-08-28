
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 


module	game_controller	(	
			input		logic	clk,
			input		logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_Ball,
			input logic drawing_request_enemy_HU,
			input logic drawing_request_enemy,
			input logic drawing_request_tower,
			input logic [2:0] drawing_request_shot,

			output logic[2:0] ShotBoxCollision,
			output logic TowerEnemyHUCollision,
			output logic[2:0] ShotEnemyCollision
);

logic box_smiley_collision,box_edge_collision, edge_smiley_collision;

assign ShotBoxCollision = (drawing_request_shot!=0 && drawing_request_tower)? drawing_request_shot:0;
assign TowerEnemyHUCollision = (drawing_request_enemy_HU && drawing_request_tower);
assign ShotEnemyCollision = (drawing_request_shot!=0 && drawing_request_enemy)? drawing_request_shot:0;

//always_ff@(posedge clk or negedge resetN)
//begin
//	if(!resetN)
//	begin 
//		flag	<= 1'b0;
//	end 
//	else begin 
//
//			SingleHitPulse <= 1'b0 ; // default 
//			if(startOfFrame) 
//				flag = 1'b0 ; // reset for next time 	
//			if ( ( box_edge_collision || box_smiley_collision ) && (flag == 1'b0)) begin 
//				flag	<= 1'b1; // to enter only once 
//				SingleHitPulse <= 1'b1;
//			end ; 
//		
//	end 
//end

endmodule
