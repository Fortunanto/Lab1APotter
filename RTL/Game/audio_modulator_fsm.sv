module audio_modulator_fsm(
input logic clk,
input logic resetN,
input logic slowClk,
input logic shotFired,
input logic [2:0] enemyDead,
input logic playerDead,
output logic [3:0] sound_key,
output logic request_time,
output logic [10:0] time_amount

);

enum logic [2:0] {Sidle, Sshot,SHit, SEnemyDead,Send} prState, nxtState;
logic [10:0] delay,nxt_delay;
const int SOUND_LENGTH=5;



always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN ) begin  // Asynchronic reset
		prState <= Sidle;
	end
   else 	begin	// Synchronic logic FSM
		prState <= nxtState;
	end
end // always

always_comb
begin
	case (prState)
		Sidle: begin
			time_amount=5;
			request_time=1;
			if(shotFired) nxtState = Sshot;
			else if(enemyDead!=0) nxtState = SEnemyDead;
			else if(playerDead) nxtState = SHit;
			else 
				begin
					nxtState=Sidle;
					time_amount=0;
					request_time=0;
				end
		end
		Sshot: begin
			time_amount=5;
			request_time=1;
			if(slowClk) nxtState = Sidle;
			else if(enemyDead!=0) nxtState = SEnemyDead;
			else if(playerDead) nxtState=SHit;
			else begin
				nxtState=Sshot;
				time_amount=0;
				request_time=0;
			end
		end
		SHit: begin
			time_amount=5;
			request_time=1;
			if(slowClk) nxtState = Sidle;
			else begin
				nxtState=SHit;
				time_amount=0;
				request_time=0;
			end
		end
		SEnemyDead: begin
			time_amount=5;
			request_time=1;
			if(slowClk) nxtState = Sidle;
			else if(Sshot) nxtState = Sshot;
			else if(playerDead) nxtState=SHit;
			else begin
				nxtState=SEnemyDead;
				time_amount=0;
				request_time=0;
			end
		end
		Send: begin
			nxtState=Send;
			time_amount=0;
			request_time=0;
		end
		endcase
end

always_comb
begin

	case (prState)
		Sshot: begin
			sound_key=1;
		end
		SHit: begin
			sound_key=2;
		end
		SEnemyDead: begin
			sound_key=3;
		end
		default: begin
			sound_key=15;
		end
	endcase
end

endmodule