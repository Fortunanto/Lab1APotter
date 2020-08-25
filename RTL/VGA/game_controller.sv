
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 


module	game_controller	(	
			input		logic	clk,
			input		logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_Ball,
			input	logic	drawing_request_1,
			input logic drawing_request_box,
			
			output logic collision, // active in case of collision between two objects
			output logic SingleHitPulse // critical code, generating A single pulse in a frame 
);

logic box_smiley_collision,box_edge_collision, edge_smiley_collision;
assign box_smiley_collision = (drawing_request_Ball && drawing_request_box) ; 
assign box_edge_collision = (drawing_request_box&&  drawing_request_1);
assign edge_smiley_collision = (drawing_request_Ball && drawing_request_1);
assign collision = (edge_smiley_collision || box_smiley_collision);
logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ; 
	end 
	else begin 

			SingleHitPulse <= 1'b0 ; // default 
			if(startOfFrame) 
				flag = 1'b0 ; // reset for next time 	
			if ( ( box_edge_collision || box_smiley_collision ) && (flag == 1'b0)) begin 
				flag	<= 1'b1; // to enter only once 
				SingleHitPulse <= 1'b1;
			end ; 
		
	end 
end

endmodule
