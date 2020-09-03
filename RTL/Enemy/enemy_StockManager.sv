//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module enemy_StockManager(	
					input		logic	clk,
					input		logic	resetN,
					input    logic startOfFrame,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					
					input logic changeDir,
					input logic dodgeBullet,
					input logic[2:0] shotCollision,
					input logic pause,
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,	
					
					output logic headsUpDrawReq,
					output logic headsDownDrawReq,
					output logic enemyDrawReq,
						
					output logic[3:0] drawingRequestorId
										
);


parameter int AMOUNT_OF_ENEMIES = 2;
parameter int ENEMY_WIDTH = 20;
parameter int ENEMY_HEIGHT = 20;
parameter int HEADS_UP_HEIGHT = 80;
parameter int HEADS_DOWN_HEIGHT = 80;
parameter int ENEMY_INITIAL_SPEED = 120;
parameter int HEADS_SIDE_MARGIN = 8;
parameter int LEFT_EDGE=30;
parameter int RIGHT_EDGE = 580;

parameter  logic [7:0] ENEMY_COLOR = 8'h72 ;

//logic [AMOUNT_OF_ENEMIES-1:0] shotCollisionMap=0;

logic [AMOUNT_OF_ENEMIES-1:0][10:0] enemiesTLX;
logic [AMOUNT_OF_ENEMIES-1:0][10:0] enemiesTLY;

logic [AMOUNT_OF_ENEMIES-1:0][10:0] enemiesOffsetX;
logic [AMOUNT_OF_ENEMIES-1:0][10:0] enemiesOffsetY;

logic [AMOUNT_OF_ENEMIES-1:0] enemiesDrawReqMap;
logic [AMOUNT_OF_ENEMIES-1:0] headsUpDrawReqMap;
logic [AMOUNT_OF_ENEMIES-1:0] headsDownDrawReqMap;


logic [AMOUNT_OF_ENEMIES-1:0][7:0] RGBs;

 genvar i;
 generate
	for (i=0;i<AMOUNT_OF_ENEMIES;i=i+1) begin: gen_loop
		enemies_moveCollision #(
		  .INITIAL_X(100*(i+1)),
		  .INITIAL_Y(100*(i+1)), 
		  .RIGHT_EDGE(RIGHT_EDGE),
		  .LEFT_EDGE(LEFT_EDGE),
		  .X_SPEED(ENEMY_INITIAL_SPEED)) 
		enemy(
			.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),
			.changeDirection((changeDir && (drawingRequestorId==i))),
			.dodgeBullet((dodgeBullet && (drawingRequestorId==i))),
			.shotCollision(shotCollision!=0 && (drawingRequestorId==i)),
			.pause(pause),
			.topLeftX(enemiesTLX[i]),
			.topLeftY(enemiesTLY[i])
		);
		
		square_object #(
		 .OBJECT_WIDTH_X(ENEMY_WIDTH),
		 .OBJECT_HEIGHT_Y(ENEMY_HEIGHT),
		 .OBJECT_COLOR(ENEMY_COLOR)
		 ) sq(
				.clk(clk),
				.resetN(resetN),
				.pixelX(pixelX),
				.pixelY(pixelY),
				.topLeftX(enemiesTLX[i]),
				.topLeftY(enemiesTLY[i]),
				.offsetX(enemiesOffsetX[i]),
				.offsetY(enemiesOffsetY[i]),
				.drawingRequest(enemiesDrawReqMap[i]),
				.RGBout(RGBs[i])
		 );
				
		object_collider#(
		.OBJECT_WIDTH_X(ENEMY_WIDTH),
		.OBJECT_HEIGHT_Y(ENEMY_HEIGHT),
		.MARGIN_TOP(HEADS_UP_HEIGHT),
		.MARGIN_BOT(0),
		.MARGIN_LEFT(HEADS_SIDE_MARGIN),
		.MARGIN_RIGHT(HEADS_SIDE_MARGIN)
		) headsup(
			.clk(clk),
			.resetN(resetN),
			.pixelX(pixelX),
			.pixelY(pixelY),
			.topLeftXinput(enemiesTLX[i]),
			.topLeftYinput(enemiesTLY[i]),
			.RGBout(RGBs[i]),
			.drawingRequest(headsUpDrawReqMap[i])		
		);
		
		object_collider#(
		.OBJECT_WIDTH_X(ENEMY_WIDTH),
		.OBJECT_HEIGHT_Y(ENEMY_HEIGHT),
		.MARGIN_TOP(0),
		.MARGIN_BOT(HEADS_DOWN_HEIGHT),
		.MARGIN_LEFT(HEADS_SIDE_MARGIN+3),
		.MARGIN_RIGHT(HEADS_SIDE_MARGIN+3)
		) headsdown(
			.clk(clk),
			.resetN(resetN),
			.pixelX(pixelX),
			.pixelY(pixelY),
			.topLeftXinput(enemiesTLX[i]),
			.topLeftYinput(enemiesTLY[i]),
			.RGBout(RGBs[i]),
			.drawingRequest(headsDownDrawReqMap[i])		
		);
	end
endgenerate

	
always_comb begin

	enemyDrawReq = 0;
	headsUpDrawReq = 0;
	headsDownDrawReq = 0;
	offsetX =0;
	offsetY=0;
	drawingRequestorId = 0;

	
	for (int headsDownIndex=0;headsDownIndex<AMOUNT_OF_ENEMIES;headsDownIndex++) begin
		if (headsDownDrawReqMap[headsDownIndex]) begin
			headsDownDrawReq = 1;	
			drawingRequestorId = headsDownIndex;
		end
	end
	
	for (int headsUpIndex=0;headsUpIndex<AMOUNT_OF_ENEMIES;headsUpIndex++) begin
		if (headsUpDrawReqMap[headsUpIndex]) begin
			headsUpDrawReq = 1;	
			drawingRequestorId = headsUpIndex;
		end
	end
	
	for (int enemyIndex=0;enemyIndex<AMOUNT_OF_ENEMIES;enemyIndex++) begin
		if (enemiesDrawReqMap[enemyIndex]) begin
			enemyDrawReq= 1;
			headsUpDrawReq=0;
			offsetX = enemiesOffsetX[enemyIndex];
			offsetY = enemiesOffsetY[enemyIndex];
			drawingRequestorId = enemyIndex;
		end
	end
	
end	

endmodule 