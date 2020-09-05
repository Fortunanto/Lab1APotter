//
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 
// generating a number bitmap 



module sixDigitsDisplay	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] pixelX,
					input 	logic	[10:0] pixelY,					
					input 	logic	[0:23] digits, // digits to display
					
					output logic [10:0] offsetX,
					output logic [10:0] offsetY,
					output logic	drawingRequest,
					output logic [0:3] digitToDraw
					 
);
// generating a smily bitmap 

parameter  logic	[7:0] digit_color = 8'hff ; //set the color of the digit 

parameter int TLX=10;
parameter int TLY=10;

const shortint DIGIT_WIDTH=16;
const shortint DIGIT_HEIGHT=32;

logic [0:5] drawReqMap;

shortint rightMost;
assign rightMost = TLX+6*DIGIT_WIDTH;

shortint downMost;
assign downMost = TLY+DIGIT_HEIGHT;

logic [0:2] digitId;
assign digitId = (rightMost - pixelX)/DIGIT_WIDTH; 

assign drawingRequest = (pixelX>=TLX) && (pixelX<rightMost) && (pixelY>=TLY) && (pixelY<downMost);

assign offsetY = pixelY - TLY;
assign offsetX = (pixelX - TLX)%DIGIT_WIDTH;

always_comb begin
	case (digitId)
		 0: digitToDraw = digits[0:3];
		 1: digitToDraw = digits[4:7];
		 2: digitToDraw = digits[8:11];
		 3: digitToDraw = digits[12:15];
		 4: digitToDraw = digits[16:19];
		 5: digitToDraw = digits[20:23];	
		 default: digitToDraw = 0;
	endcase 
end

//
//always_ff@(posedge clk or negedge resetN)
//begin
//	if(!resetN) begin
//		drawingRequest <=	1'b0;
//	end
//	else begin
//			//drawingRequest <= (number_bitmap[digit][offsetY][offsetX]) && (InsideRectangle == 1'b1 );	//get value from bitmap  
//			
//	end 
//end
//
//assign RGBout = digit_color ; // this is a fixed color 

endmodule