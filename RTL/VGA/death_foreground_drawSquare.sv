//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	death_foreground_drawSquare	(	

					input	logic	clk,
					input	logic	resetN,
					input logic startOfFrame,
					input logic	[10:0]	pixelX,
					input logic	[10:0]	pixelY,
					input logic enable_death,
					output	logic	[7:0]	FG_RGB,
					output	logic		deathForeground_dr 
);

const int TIMING_DELAY=60;
const int	xFrameSize	=	639;
const int	yFrameSize	=	479;
const int	bracketOffset =	30;

logic [2:0] redBits;
logic [2:0] greenBits;
logic [1:0] blueBits;

localparam logic [2:0] DARK_COLOR = 3'b111 ;// bitmap of a dark color
localparam logic [2:0] LIGHT_COLOR = 3'b000 ;// bitmap of a light color

logic flag;
int delay;

assign FG_RGB =  {redBits , greenBits , blueBits} ; //collect color nibbles to an 8 bit word 
assign deathForeground_dr = enable_death;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
				redBits <= DARK_COLOR ;	
				greenBits <= DARK_COLOR  ;	
				blueBits <= DARK_COLOR ;	 
				delay <= TIMING_DELAY ;
	end 
	else begin
	if(flag) begin
	// defaults 
		greenBits <= 3'b000 ; 
		redBits <= 3'b111 ;
		blueBits <= 2'b00;
	end
	else begin
		greenBits <= 3'b000 ; 
		redBits <= 3'b000 ;
		blueBits <= 2'b11;
	end; 	
	if(startOfFrame) begin
		delay<=delay-1;
		if(delay==0) begin 
			flag=~flag; 
			delay <= TIMING_DELAY;
		end
	end
	
	end
end 
endmodule

