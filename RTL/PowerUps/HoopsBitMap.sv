module HoopsBitMap (
	input		logic	clk,
	input		logic	resetN,
	input 	logic	[10:0] offsetX,// offset from top left  position 
	input 	logic	[10:0] offsetY,
	input		logic	InsideRectangle, //input that the pixel is within a bracket 			
	output	logic				topDrawingRequest, //output that the pixel should be dispalyed 
	output	logic				bottomDrawingRequest, //output that the pixel should be dispalyed 
	output	logic	[7:0]		RGBout
);
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

localparam  int OBJECT_HEIGHT_Y = 12;
localparam  int OBJECT_WIDTH_X = 24;
const int MID_HOOP=23;
int inverted;

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h04, 8'h04, 8'h04, 8'h04, 8'h04, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h04, 8'h04, 8'hF9, 8'h88, 8'h88, 8'h88, 8'h88, 8'hF9, 8'h04, 8'h04, 8'h04, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h04, 8'hF9, 8'hF9, 8'h88, 8'h88, 8'h04, 8'h04, 8'h04, 8'h04, 8'h88, 8'h88, 8'hF9, 8'hF9, 8'h04, 8'h04, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h88, 8'h88, 8'h88, 8'h04, 8'h04, 8'h04, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h04, 8'h04, 8'h88, 8'h88, 8'h88, 8'h04, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h04, 8'h88, 8'hF9, 8'h04, 8'h04, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h04, 8'hF9, 8'h88, 8'h04, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h04, 8'h88, 8'h04, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h88, 8'h04, 8'hFF, 8'hFF },
{8'hFF, 8'h04, 8'hF9, 8'hF9, 8'h04, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'hF9, 8'hF9, 8'h04, 8'hFF },
{8'hFF, 8'h04, 8'hF9, 8'h04, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'hF9, 8'h04, 8'hFF },
{8'hFF, 8'h04, 8'hF9, 8'h04, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'hF9, 8'h04, 8'hFF },
{8'h04, 8'hF9, 8'hF9, 8'h04, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'hF9, 8'hF9, 8'h04 },
{8'h04, 8'hF9, 8'h04, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'hF9, 8'h04 },
{8'h04, 8'hF9, 8'h04, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'hF9, 8'h04 }
};


assign inverted = 2*OBJECT_HEIGHT_Y-(offsetY/2);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin

		
		if (InsideRectangle == 1'b1 ) begin  // inside an external bracket 
			if(offsetY<=MID_HOOP)
				RGBout <= object_colors[offsetY/2][offsetX/2];
			else
				RGBout <= object_colors[inverted-1][offsetX/2];
		end
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign topDrawingRequest = ((RGBout != TRANSPARENT_ENCODING ) &&  offsetY<=MID_HOOP  && InsideRectangle)? 1'b1 : 1'b0 ; // get optional transparent command from the bitmap  - top of it
assign bottomDrawingRequest = ((RGBout != TRANSPARENT_ENCODING ) &&  offsetY>MID_HOOP && InsideRectangle )? 1'b1 : 1'b0 ; // get optional transparent command from the bitmap    - bottom of it


endmodule