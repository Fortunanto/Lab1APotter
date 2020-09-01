// collider that follows an object and notify when collision happen

module object_collider	(	
					input		logic	clk,
					input		logic	resetN,
					//input    logic startOfFrame,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					
					input logic [10:0] topLeftXinput,
					input logic [10:0] topLeftYinput,
										
					output logic [7:0] RGBout,
					
					output	logic	drawingRequest // indicates pixel inside the bracket				
);

parameter  int OBJECT_WIDTH_X = 20; // width of followed object
parameter  int OBJECT_HEIGHT_Y = 20; // height of followed object

parameter int MARGIN_TOP=80;
parameter int MARGIN_BOT=80;
parameter int MARGIN_LEFT=8;
parameter int MARGIN_RIGHT=8;


parameter  logic [7:0] OBJECT_COLOR = 8'h5b; // for debug
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
 
int topLeftX;
int topLeftY;
int rightX ; //coordinates of the sides  
int bottomY ;


logic insideBracket;


//////////--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries

always_comb
RGBout = OBJECT_COLOR;

assign topLeftX = topLeftXinput - MARGIN_LEFT;
assign topLeftY = topLeftYinput - MARGIN_TOP;

assign rightX	= topLeftXinput + OBJECT_WIDTH_X + MARGIN_RIGHT;
assign bottomY	= topLeftYinput + OBJECT_HEIGHT_Y + MARGIN_BOT;

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin		
		drawingRequest	<=	1'b0;		
	end
	else begin 	

		//this is an example of using blocking sentence inside an always_ff block, 
		//and not waiting a clock to use the result  
		insideBracket  = 	 ((pixelX  >= topLeftX) &&  (pixelX < rightX) // ----- LEGAL BLOCKING ASSINGMENT in ALWAYS_FF CODE 
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY))  ; 
		
		if (insideBracket ) // test if it is inside the rectangle 
		begin 
			drawingRequest <= 1'b1 ;			
		end 
		
		else begin  
			drawingRequest <= 1'b0 ;// transparent color 			
		end 
		
	end
end 
endmodule 