
module	Shot_MoveCollision	(	
 
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
					input 	 logic pause,
					output    logic enable,
					output	 logic signed 	[10:0]	topLeftX,// output the top left corner 
					output	 logic signed	[10:0]	topLeftY,
					
					output    logic[2:0] draw_shot_dir
);

logic triggerShot_d /* synthesis keep = 1 */;
logic collision;

assign collision = shotBoxCollision || shotEnemyCollision;

parameter int NO_ANGLE_SPEED = 100;
parameter int LATERAL_SPEED = 30;
parameter int ANGLED_FORWARD_SPEED = 70;
const int	FIXED_POINT_MULTIPLIER	=	64;
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		Xspeed <= 0;
		Yspeed <= 0;
		topLeftX_FixedPoint <= 50_000;
		topLeftY_FixedPoint <= 50_000;
		enable <= 1;
	end
	else begin
		enable <= enable;
		if(collision) begin
			Xspeed <= 0;
			Yspeed <= 0;
			topLeftX_FixedPoint <= 50_000;
			topLeftY_FixedPoint <= 50_000;
			enable <= 1;
		end
		if(triggerShot && enable) begin
			topLeftX_FixedPoint <= player_topLeftX*FIXED_POINT_MULTIPLIER;
			topLeftY_FixedPoint <= player_topLeftY*FIXED_POINT_MULTIPLIER;
			case (shotDirection) 
				3'b001:
					begin
						Xspeed<=LATERAL_SPEED;
						Yspeed<=ANGLED_FORWARD_SPEED;
					end
				3'b010:
					begin 
						Xspeed<=0;
						Yspeed<=NO_ANGLE_SPEED;
					end
				3'b100:
					begin
						Xspeed<=-1*LATERAL_SPEED;
						Yspeed<=ANGLED_FORWARD_SPEED;
					end
			default:
					begin
						Xspeed<=0;
						Yspeed<=NO_ANGLE_SPEED;
					end
			endcase 
			draw_shot_dir<= shotDirection;
			enable <= 0;
			
		end
		else	
			if(startOfFrame) begin
				topLeftY_FixedPoint <= topLeftY_FixedPoint - Yspeed;
				topLeftX_FixedPoint <= topLeftX_FixedPoint + Xspeed;
				if(topLeftY_FixedPoint -Yspeed <100 || topLeftX_FixedPoint+Xspeed<40 || topLeftX_FixedPoint+Xspeed>40_900) begin
					Xspeed <= 0;
					Yspeed <= 0;
					topLeftX_FixedPoint <= 50_000;
					topLeftY_FixedPoint <= 50_000;
					enable <=1;
					draw_shot_dir<=0;
				end			
			end
		if(pause) begin 
			topLeftY_FixedPoint <= topLeftY_FixedPoint;
			topLeftX_FixedPoint <= topLeftX_FixedPoint;

		end
	end
end

assign topLeftX = topLeftX_FixedPoint/FIXED_POINT_MULTIPLIER;
assign topLeftY = topLeftY_FixedPoint/FIXED_POINT_MULTIPLIER;


endmodule