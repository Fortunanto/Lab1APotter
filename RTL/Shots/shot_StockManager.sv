module shot_StockManager (	
	input  logic clk,
	input  logic resetN,
	input  logic[2:0] shotEnemyCollision,
	input  logic[2:0] shotTowerCollision,
	input  logic [2:0] shotDragonCollision,
	input	 logic [2:0] shotDirection, 
	input  logic trigger,
	input  logic startOfFrame,
	input  logic   [10:0] player_tpX,
	input  logic   [10:0] player_tpY,
	input  logic	[10:0] pixelX,// current VGA pixel 
	input  logic	[10:0] pixelY,
	input  logic          pause,
	input  logic poweredUp,
	
	output logic   [2:0] drawingRequests,
	output logic   [10:0] offsetX,
	output logic   [10:0] offsetY,
	output logic [2:0] draw_shot_dir,
	output logic shot_fired,
	output logic nonAvailable,
	output logic anyDrawRequest
	
);

const int TIMING_DELAY=15;
parameter  int BULLET_WIDTH_X = 100;
parameter  int BULLET_HEIGHT_Y = 100;
parameter  logic [7:0] BULLET_COLOR = 8'h5b ; 
parameter int BULLET_NO_ANGLE_SPEED = 100;
parameter int BULLET_LATERAL_SPEED = 30;
parameter int BULLET_ANGLED_FORWARD_SPEED = 70;
parameter int PU_BULLET_NO_ANGLE_SPEED = 170;
parameter int PU_BULLET_LATERAL_SPEED = 50;
parameter int PU_BULLET_ANGLED_FORWARD_SPEED = 110;

logic [2:0] triggerOut;
logic [2:0][10:0] tpX_bullet;
logic [2:0][10:0] tpY_bullet;
logic [2:0] enable;
logic [2:0][10:0] offsetsX;
logic [2:0][10:0] offsetsY;
logic [2:0][10:0] rgbs_out;
logic [2:0][2:0] draw_shot_dir_bus;
int delay;

assign anyDrawRequest = (drawingRequests!=0);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		triggerOut[0]<=0;
		triggerOut[1]<=0;
		triggerOut[2]<=0;
		shot_fired   <=0;
		nonAvailable <= 0;
		delay<=TIMING_DELAY;
	end
	else begin //Choose the first available shot to fire out
		triggerOut[0]		<= 0;
		triggerOut[1]		<= 0;
		triggerOut[2]		<= 0;
		nonAvailable<= 0;
		if(trigger) begin
			if(delay==0) begin
				shot_fired   <=1;
				case(enable) 
					3'b001,3'b011,3'b101,3'b111  : triggerOut[0]<= 1; // in case the first shot is available
					3'b010,3'b110  : 					 triggerOut[1]<= 1; // in case the second shot is available
					3'b100  : 							 triggerOut[2]<= 1; // in case the third shot is available
					default : begin
						nonAvailable <= 1;
						shot_fired   <=0;
					end
				endcase 
				delay<=TIMING_DELAY;
			end
		end
		else shot_fired   <=0;
		if(startOfFrame && delay>0) delay<=delay-1;
		
		
	end
end

 genvar itr;
  generate
    for (itr = 0 ; itr <= 2; itr = itr+1)
    begin : gen_loop
        Shot_MoveCollision #(.NO_ANGLE_SPEED(BULLET_NO_ANGLE_SPEED),
									  .LATERAL_SPEED(BULLET_LATERAL_SPEED),
									  .ANGLED_FORWARD_SPEED(BULLET_ANGLED_FORWARD_SPEED),
									  .PU_NO_ANGLE_SPEED(PU_BULLET_NO_ANGLE_SPEED),
									  .PU_LATERAL_SPEED(PU_BULLET_LATERAL_SPEED),
									  .PU_ANGLED_FORWARD_SPEED(PU_BULLET_ANGLED_FORWARD_SPEED)) shot(.clk(clk),.resetN(resetN),
										  .startOfFrame(startOfFrame),
										  .triggerShot(triggerOut[itr]),
										  .shotEnemyCollision(shotEnemyCollision[itr]),
										  .shotBoxCollision(shotTowerCollision[itr]),
										  .shotDragonCollision(shotDragonCollision[itr]),
										  .shotDirection(shotDirection),
										  .player_topLeftX(player_tpX),
										  .player_topLeftY(player_tpY),
										  .enable(enable[itr]),
										  .poweredUp(poweredUp),
										  .topLeftX(tpX_bullet[itr]),
										  .topLeftY(tpY_bullet[itr]),
										  .pause(pause),
										  .draw_shot_dir(draw_shot_dir_bus[itr]));
										  
		 square_object #(.OBJECT_WIDTH_X(BULLET_WIDTH_X), .OBJECT_HEIGHT_Y(BULLET_HEIGHT_Y), .OBJECT_COLOR(BULLET_COLOR)) sq(.clk(clk),.resetN(resetN),
								.pixelX(pixelX),.pixelY(pixelY),
								.topLeftX(tpX_bullet[itr]),
								.topLeftY(tpY_bullet[itr]),
								.offsetX(offsetsX[itr]),
								.offsetY(offsetsY[itr]),
								.drawingRequest(drawingRequests[itr]),
								.RGBout(rgbs_out[itr]));

    end
  endgenerate
  // send out the required signal to currently draw.
  always @ (*)
  MUX : begin
     case (drawingRequests) 
		3'b1:begin 
					offsetX = offsetsX[0];
					offsetY = offsetsY[0];
					draw_shot_dir = draw_shot_dir_bus[0];
				 end 
		3'b10:begin 
					offsetX = offsetsX[1];
					offsetY = offsetsY[1];
					draw_shot_dir = draw_shot_dir_bus[1];
				 end 
		3'b100:begin 
					offsetX = offsetsX[2];
					offsetY = offsetsY[2];
					draw_shot_dir = draw_shot_dir_bus[2];

				 end 
		default:begin offsetX = offsetsX[0];
					offsetY = offsetsY[0];
					draw_shot_dir = draw_shot_dir_bus[0];
					end
	  endcase 
 end 

endmodule
