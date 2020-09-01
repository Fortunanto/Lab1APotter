module audio_modulator_fsm(
input logic clk;
input logic resetN;
input logic startOfFrame;
input logic shotFired;
input logic enemyDead;
output logic sound_key
);

enum logic [2:0] {Sidle, Sshot} prState, nxtState;
logic [4:0] delay;

always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		prState <= SgameScreen;
   else 		// Synchronic logic FSM
		prState <= nxtState;
		if(startOfFrame && delay!=0) delay<=delay-1;
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

endmodule