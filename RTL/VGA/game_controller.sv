
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
			input logic drawing_request_shot,

			output logic ShotBoxCollision,
			output logic TowerEnemyHUCollision
);

logic box_smiley_collision,box_edge_collision, edge_smiley_collision;

assign ShotBoxCollision = (drawing_request_shot && drawing_request_tower);
assign TowerEnemyHUCollision = (drawing_request_enemy_HU && drawing_request_tower);


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
