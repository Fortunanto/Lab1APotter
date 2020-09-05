//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	objects_mux_all	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,

		// smiley 
					input		logic	smileyDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] smileyRGB, 
		// towers
					input logic towersDrawingRequest,
					input logic [7:0] towersRGB,
					
		// enemies
					input logic enemiesDrawingRequest,
					input logic [7:0] enemiesRGB,
					
		// enemiesHeadsUp
					input logic enemisHeadsUpDrawingRequest,
		
		// enemiesHeadsDown
		
					input logic enemiesHeadsDownDrawingRequest,
		
					
		// add the number here 
					input    logic anyBulletDrawingRequest,
					input    logic [7:0] bulletRGB,	
		// background 
					input		logic	[7:0] backGroundRGB, 
		// death
					input		logic	deathForeground_dr, 
					input    logic [7:0] deathForegroundRGB,	
					
		// score
		
					input logic scoreDrawReq,
					input logic [7:0] scoreRGB,


					output	logic	[7:0] redOut, // full 24 bits color output
					output	logic	[7:0] greenOut, 
					output	logic	[7:0] blueOut 
					
);

logic [7:0] tmpRGB;



assign redOut	  = {tmpRGB[7:5], {5{tmpRGB[5]}}}; //--  extend LSB to create 10 bits per color  
assign greenOut  = {tmpRGB[4:2], {5{tmpRGB[2]}}};
assign blueOut	  = {tmpRGB[1:0], {6{tmpRGB[0]}}};

//
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (deathForeground_dr) tmpRGB <= deathForegroundRGB;
		else if (scoreDrawReq) tmpRGB <= scoreRGB;
		else if (smileyDrawingRequest)   tmpRGB <= smileyRGB;  
	   else if (towersDrawingRequest) tmpRGB <= towersRGB;
		else if (enemiesDrawingRequest) tmpRGB <= enemiesRGB;
      //else if (enemiesHeadsDownDrawingRequest) tmpRGB <= 8'b11100100; // for headsDown debug
		//else if (enemisHeadsUpDrawingRequest) tmpRGB <= 8'b00101111; //for headsUp debug
		else if (anyBulletDrawingRequest) tmpRGB <= bulletRGB;
		else tmpRGB <= backGroundRGB ; // last priority 
		end ; 
	end

endmodule


