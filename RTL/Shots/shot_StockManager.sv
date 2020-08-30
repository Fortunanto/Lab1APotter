module shot_StockManager (	
	input  logic clk,
	input  logic resetN,
	input  logic[2:0] shotEnemyCollision,
	input  logic[2:0] shotTowerCollision,
	input  logic trigger,
	input  logic startOfFrame,
	input  logic   [10:0] player_tpX,
	input  logic   [10:0] player_tpY,
	input  logic	[10:0] pixelX,// current VGA pixel 
	input  logic	[10:0] pixelY,
	input  logic          pause,
	output logic   [2:0] drawingRequests,
	output logic   [10:0] offsetX,
	output logic   [10:0] offsetY,
	output logic   [7:0] RGB_OUT,
	output logic nonAvailable
	
);

const int TIMING_DELAY=15;
parameter  int BULLET_WIDTH_X = 100;
parameter  int BULLET_HEIGHT_Y = 100;
parameter  logic [7:0] BULLET_COLOR = 8'h5b ; 
parameter  int BULLET_SPEED = 100;

logic [2:0] triggerOut;
logic [2:0][10:0] tpX_bullet;
logic [2:0][10:0] tpY_bullet;
logic [2:0] enable;
logic [2:0][10:0] offsetsX;
logic [2:0][10:0] offsetsY;
logic [2:0][10:0] rgbs_out;

int delay;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		triggerOut[0]<=0;
		triggerOut[1]<=0;
		triggerOut[2]<=0;
		nonAvailable <= 0;
		delay<=TIMING_DELAY;
	end
	else begin
		triggerOut[0]		<= 0;
		triggerOut[1]		<= 0;
		triggerOut[2]		<= 0;
		nonAvailable<= 0;
		if(trigger) begin
			if(delay==0) begin
				case(enable) 
					3'b001,3'b011,3'b101,3'b111  : triggerOut[0]<= 1;
					3'b010,3'b110  : 					 triggerOut[1]<= 1;
					3'b100  : 							 triggerOut[2]<= 1;
					default : 							 nonAvailable <= 1;
				endcase 
				delay<=TIMING_DELAY;
			end
		end
		if(startOfFrame && delay>0) delay<=delay-1;
		
		
	end
end

 genvar itr;
  generate
    for (itr = 0 ; itr <= 2; itr = itr+1)
    begin : gen_loop
        Shot_MoveCollision #(.SPEED(BULLET_SPEED)) shot(.clk(clk),.resetN(resetN),
										  .startOfFrame(startOfFrame),
										  .triggerShot(triggerOut[itr]),
										  .shotEnemyCollision(shotEnemyCollision[itr]),
										  .shotBoxCollision(shotTowerCollision[itr]),
										  .player_topLeftX(player_tpX),
										  .player_topLeftY(player_tpY),
										  .enable(enable[itr]),
										  .topLeftX(tpX_bullet[itr]),
										  .topLeftY(tpY_bullet[itr]),
										  .pause(pause));
										  
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
  always @ (*)
  MUX : begin
     case (drawingRequests) 
		3'b1:begin 
					offsetX = offsetsX[0];
					offsetY = offsetsY[0];
					RGB_OUT = rgbs_out[0];
				 end 
		3'b10:begin 
					offsetX = offsetsX[1];
					offsetY = offsetsY[1];
					RGB_OUT = rgbs_out[1];
				 end 
		3'b100:begin 
					offsetX = offsetsX[2];
					offsetY = offsetsY[2];
					RGB_OUT = rgbs_out[2];

				 end 
		default:begin offsetX = offsetsX[0];
					offsetY = offsetsY[0];
					RGB_OUT = rgbs_out[0];
					end
	  endcase 
 end 

endmodule
