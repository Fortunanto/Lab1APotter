module game_fsm (
	input logic clk, 
	input logic resetN,
	input logic [2:0] currLife,
	input logic[2:0] shotEnemyCollision,
	input logic slowClk,
	input logic playerTrigger,
	input logic transitionDone,
	input logic [0:23] currentTime,
		
	output logic pause,
	output logic[3:0] tree_count,
	output logic [10:0] curEnemySpeed,
	output logic death_screen,
	output logic start_screen,
	output logic [2:0] currentGameState,
	output logic newLevel,
	output logic requestTime,
	output logic [10:0] slowClkRequest,
	output logic transition_screen
);

int curEnemyCount=2;
parameter int LEVEL_1_TREE_COUNT=8;
parameter int LEVEL_2_TREE_COUNT=8;
int cur_level;

logic playerDead;
assign playerDead = (currLife == 0) || (currentTime==0); 

logic enemyDead;

assign enemyDead = shotEnemyCollision!=0; 

// all the recorded game states.

enum logic [4:0] {SgameScreen, SlevelOne_Two_Enemies, 
						SlevelOne_One_Enemy,SlevelOneToTwoStart
						,SlevelOneToTwoEnd,SlevelTwo_Two_Enemies, 
						SlevelTwo_One_Enemy,SvictoryScreenStart,SvictoryScreenMid,SvictoryScreenEnd,
																SDeath,SDragonPowerUp,STransitionScreen} prState, nxtState;

 	
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		prState <= SgameScreen;
   else 		// Synchronic logic FSM
		prState <= nxtState;
	end // always

	// state transition always_comb
	
always_comb
begin
	case (prState)
		SgameScreen: begin 
			if(playerTrigger) nxtState = SlevelOne_Two_Enemies;
			else nxtState=SgameScreen;
		end
		SlevelOne_Two_Enemies: begin
			if(enemyDead) nxtState = SlevelOne_One_Enemy;
			else if(playerDead) nxtState=SDeath;
			else nxtState=SlevelOne_Two_Enemies;
		end
		SlevelOne_One_Enemy: begin
			if(enemyDead) nxtState = STransitionScreen;
			else if(playerDead) nxtState=SDeath;
			else nxtState=SlevelOne_One_Enemy;
		end
		SlevelOneToTwoStart: begin
			nxtState=SlevelOneToTwoEnd;
		end
		SlevelOneToTwoEnd: begin
			if(slowClk) nxtState=SlevelTwo_Two_Enemies;
			else nxtState=SlevelOneToTwoEnd;

		end
		SlevelTwo_Two_Enemies: begin
			if(enemyDead) nxtState = SlevelTwo_One_Enemy;
			else if(playerDead) nxtState=SDeath;
			else nxtState=SlevelTwo_Two_Enemies;
		end
		SlevelTwo_One_Enemy: begin
			if(enemyDead) nxtState = SvictoryScreenStart;
			else if(playerDead) nxtState=SDeath;
			else nxtState=SlevelTwo_One_Enemy;
		end
		SvictoryScreenStart: begin
			nxtState=SvictoryScreenMid;
		end
			SvictoryScreenMid: begin
			if(slowClk) nxtState=SvictoryScreenEnd;
			else nxtState=SvictoryScreenMid;
		end
		SvictoryScreenEnd: begin
			if(playerTrigger) nxtState=SgameScreen;
			else nxtState=SvictoryScreenEnd;
		end
		SDeath: begin
			if(playerTrigger) nxtState=SgameScreen;
			else nxtState=SDeath;
		end
		STransitionScreen: begin
			if (transitionDone) nxtState = SlevelOneToTwoStart;
			else nxtState = STransitionScreen;
		end
		endcase
end

// signal output always_comb

always_comb
begin
	newLevel=0;
	requestTime=0;
	slowClkRequest=0;	
	case (prState)
		SgameScreen: begin
			currentGameState=0;
			newLevel=1;

		end
		SlevelOne_Two_Enemies: begin
			currentGameState=1;
		end
		SlevelOne_One_Enemy: begin
			currentGameState=1;
		end
		SlevelOneToTwoStart : begin
			currentGameState=2;
			requestTime=1;
			slowClkRequest=120;
		end
		SlevelOneToTwoEnd : begin
			currentGameState=2;
			newLevel=1;
		end
		SlevelTwo_Two_Enemies: begin
			currentGameState=3;
		end
		SlevelTwo_One_Enemy:begin
			currentGameState=3;
		end
		SvictoryScreenStart: begin
			currentGameState=4;
			requestTime=1;
			slowClkRequest=120;
		end
		SvictoryScreenMid: begin
			currentGameState=4;
		end
		SvictoryScreenEnd: begin
			currentGameState=4;
		end
		SDeath: begin
			currentGameState=5;
		end
		STransitionScreen: begin
			currentGameState=6;
		end
		endcase
end
// game state decision mux
always @ (*)
  MUX : begin
     case (currentGameState) 
		0:begin 
					pause=1;
					transition_screen=0;
					death_screen=0;
					start_screen=1;
					curEnemySpeed=120;
				 end 
		1:begin 
					pause=0;
					transition_screen=0;
					death_screen=0;
					start_screen=0;
					tree_count=LEVEL_1_TREE_COUNT;
					curEnemySpeed=120;
				 end 
		2:begin 
					pause=1;
					transition_screen=0;
					death_screen=0;
					start_screen=0;
					curEnemySpeed=240;
				 end 
		3:begin 
					pause=0;
					transition_screen=0;
					death_screen=0;
					start_screen=0;
					tree_count=LEVEL_2_TREE_COUNT;
					curEnemySpeed=240;

				 end 
		4:begin 
					pause=1;
					transition_screen=0;
					death_screen=0;
					start_screen=0;

				 end 
		5:begin 
					pause=1;
					transition_screen=0;
					death_screen=1;
					start_screen=0;

				 end 
		6:begin 
					pause=1;
					transition_screen=1;
					death_screen=0;
					start_screen=0;
				 end 		 
		default:begin
					pause=1;
					death_screen=0;
					start_screen=0;
					transition_screen=0;
					end
	  endcase 
 end 
endmodule