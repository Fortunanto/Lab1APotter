module lifeDisplay(	
					input		logic	clk,
					input		logic	resetN,					
					
					input logic [2:0] currLife,
					
					input logic [10:0] pixelX,
					input logic [10:0] pixelY,
					
					
					output logic [10:0] offsetX,
					output logic [10:0] offsetY,
					output logic drawReq
);


parameter logic [10:0] TLX = 10;
parameter logic [10:0] TLY = 40;

parameter shortint LIFE_ICON_WIDTH = 16;
parameter shortint LIFE_ICON_HEIGHT = 16;

logic [10:0] rightMost;
assign rightMost = TLX + (currLife*LIFE_ICON_WIDTH);

logic [10:0] downMost;
assign downMost = TLY + LIFE_ICON_HEIGHT;



always_ff@(posedge clk or negedge resetN)
begin
	if (!resetN) begin		
	end
	else begin	
		drawReq<=0;
		if (pixelX>=TLX && pixelX<rightMost && pixelY>=TLY && pixelY<downMost) begin
			drawReq<=1;
			offsetX<=(pixelX-TLX)%LIFE_ICON_WIDTH;
			offsetY<=pixelY-TLY;
		end
	end
end

endmodule