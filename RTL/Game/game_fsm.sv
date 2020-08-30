module game_fsm (
	input logic clk, 
	input logic resetN,
	input logic startGame,
	input logic playerDead,
	input logic[2:0] shotEnemyCollision,
	
	output logic pause,
	output logic[3:0] tree_count,
	output logic death_screen,
	output logic start_screen
);

parameter int ENEMY_COUNT=2;
parameter int LEVEL_1_TREE_COUNT=8;
parameter int LEVEL_2_TREE_COUNT=8;
int cur_level;

logic enemyDead;
logic [2:0] currentGameState;
assign enemyDead = shotEnemyCollision!=0; 

enum logic [2:0] {SgameScreen, SlevelOne_Two_Enemies, SlevelOne_One_Enemy,SlevelTwo_Two_Enemies, SlevelTwo_One_Enemy,SvictoryScreen, SDeath} prState, nxtState;

 	
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		prState <= SgameScreen;
   else 		// Synchronic logic FSM
		prState <= nxtState;
	end // always

always_comb
begin
	case (prState)
		SgameScreen: begin
			if(startGame) nxtState = SlevelOne_Two_Enemies;
			else nxtState=SgameScreen;
		end
		SlevelOne_Two_Enemies: begin
			if(enemyDead) nxtState = SlevelOne_One_Enemy;
			else if(playerDead) nxtState=SDeath;
			else nxtState=SlevelOne_Two_Enemies;
		end
		SlevelOne_One_Enemy: begin
			if(enemyDead) nxtState = SlevelTwo_Two_Enemies;
			else if(playerDead) nxtState=SDeath;
			else nxtState=SlevelOne_One_Enemy;
		end
		SlevelTwo_Two_Enemies: begin
			if(enemyDead) nxtState = SlevelTwo_One_Enemy;
			else if(playerDead) nxtState=SDeath;
			else nxtState=SlevelTwo_Two_Enemies;
		end
		SlevelTwo_One_Enemy: begin
			if(enemyDead) nxtState = SvictoryScreen;
			else if(playerDead) nxtState=SDeath;
			else nxtState=SlevelTwo_One_Enemy;
		end
		SvictoryScreen: begin
			nxtState=SlevelOne_Two_Enemies;
		end
		SDeath: begin
			nxtState=SDeath;
		end
		endcase
end

always_comb
begin
	pause=0;
	tree_count=0;
	case (prState)
		SgameScreen: begin
			pause=1;
			currentGameState=0;
		end
		SlevelOne_Two_Enemies: begin
			currentGameState=1;
			tree_count=6;
		end
		SlevelOne_One_Enemy: begin
			currentGameState=1;
			tree_count=6;
		end
		SlevelTwo_Two_Enemies: begin
			currentGameState=2;
			tree_count=8;
		end
		SlevelTwo_One_Enemy: begin
			currentGameState=2;
			tree_count=8;
		end
		SvictoryScreen: begin
			pause=1;
			currentGameState=3;
		end
		SDeath: begin
			pause=1;
			currentGameState=4;
		end
		endcase
end
always @ (*)
  MUX : begin
     case (currentGameState) 
		0:begin 
					death_screen=0;
					start_screen=1;
				 end 
		1:begin 
					death_screen=0;
					start_screen=0;
				 end 
		2:begin 
					death_screen=0;
					start_screen=0;

				 end 
		3:begin 
					death_screen=0;
					start_screen=0;
				 end 
		4:begin 
					death_screen=1;
					start_screen=0;

				 end 
		default:begin
					death_screen=0;
					start_screen=0;
					end
	  endcase 
 end 
endmodule