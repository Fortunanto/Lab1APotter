// Copyright (C) 2017  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Intel and sold by Intel or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 17.0.0 Build 595 04/25/2017 SJ Lite Edition"
// CREATED		"Thu Aug 27 13:12:12 2020"

module TOP_VGA_DEMO_WITH_MSS_ALL(
	AUD_ADCDAT,
	resetN,
	CLOCK_50,
	pin_name1,
	KEY,
	SW,
	VGA_VS,
	VGA_HS,
	VGA_CLK,
	VGA_BLANK_N,
	VGA_SYNC_N,
	AUD_DACDAT,
	AUD_XCK,
	AUD_I2C_SCLK,
	MICROPHON_LED,
	AUD_BCLK,
	AUD_DACLRCK,
	AUD_I2C_SDAT,
	AUD_ADCLRCK,
	HEX0,
	VGA_B,
	VGA_G,
	VGA_R
);


input wire	AUD_ADCDAT;
input wire	resetN;
input wire	CLOCK_50;
input wire	pin_name1;
input wire	[2:1] KEY;
input wire	[3:0] SW;
output wire	VGA_VS;
output wire	VGA_HS;
output wire	VGA_CLK;
output wire	VGA_BLANK_N;
output wire	VGA_SYNC_N;
output wire	AUD_DACDAT;
output wire	AUD_XCK;
output wire	AUD_I2C_SCLK;
output wire	MICROPHON_LED;
inout wire	AUD_BCLK;
inout wire	AUD_DACLRCK;
inout wire	AUD_I2C_SDAT;
inout wire	AUD_ADCLRCK;
output wire	[6:0] HEX0;
output wire	[7:0] VGA_B;
output wire	[7:0] VGA_G;
output wire	[7:0] VGA_R;

wire	[7:0] backGroundRGB;
wire	boarders_Drawing_Request;
wire	[10:0] box_offX;
wire	[10:0] box_offY;
wire	box_req;
wire	[7:0] boxRGB;
wire	clk;
wire	collision;
wire	edgeCollide;
wire	[3:0] HitEdgeCode;
wire	[7:0] iBlue;
wire	[7:0] iGreen;
wire	[7:0] iRed;
wire	moveLeft;
wire	moveRight;
wire	[7:0] num_RGB;
wire	numberDrawingRequest;
wire	[10:0] pixelX;
wire	[10:0] pixelY;
wire	singleHit;
wire	smiley_req;
wire	[7:0] SMILEY_VGA;
wire	[10:0] smileyOffsetX;
wire	[10:0] smileyOffsety;
wire	smileyRecDR;
wire	[10:0] SmileyTLX;
wire	[10:0] SmileyTLY;
wire	[10:0] SQR_topLeftX;
wire	Start_of_frame;
wire	[7:0] VgaB;
wire	vgaBlinkN;
wire	vgaClk;
wire	[7:0] VgaG;
wire	VgaHS;
wire	[7:0] VgaR;
wire	VgaSyncN;
wire	VgaVS;
wire	SYNTHESIZED_WIRE_0;
wire	[9:0] SYNTHESIZED_WIRE_1;





VGA_Controller	b2v_inst(
	.clk(clk),
	.resetN(resetN),
	.Blue(iBlue),
	.Green(iGreen),
	.Red(iRed),
	.StartOfFrame(Start_of_frame),
	.oVGA_HS(VgaHS),
	.oVGA_VS(VgaVS),
	.oVGA_SYNC(VgaSyncN),
	.oVGA_BLANK(vgaBlinkN),
	.oVGA_CLOCK(vgaClk),
	.oVGA_B(VgaB),
	.oVGA_G(VgaG),
	.oVGA_R(VgaR),
	.PixelX(pixelX),
	.PixelY(pixelY));


player_moveCollision	b2v_inst1(
	.clk(clk),
	.resetN(resetN),
	.startOfFrame(Start_of_frame),
	.moveLeft(moveLeft),
	.moveRight(moveRight),
	.collision(collision),
	.HitEdgeCode(HitEdgeCode),
	.topLeftX(SmileyTLX),
	.topLeftY(SmileyTLY));
	defparam	b2v_inst1.INITIAL_X = 350;
	defparam	b2v_inst1.INITIAL_X_SPEED = 180;
	defparam	b2v_inst1.INITIAL_Y = 440;


SEG7	b2v_inst10(
	.iDIG(SW),
	.oSEG(HEX0));


game_controller	b2v_inst12(
	.clk(clk),
	.resetN(resetN),
	.startOfFrame(Start_of_frame),
	.drawing_request_Ball(smiley_req),
	.drawing_request_1(boarders_Drawing_Request),
	.drawing_request_box(box_req),
	.collision(collision)
	);


back_ground_drawSquare	b2v_inst13(
	.clk(clk),
	.resetN(resetN),
	.pixelX(pixelX),
	.pixelY(pixelY),
	.boardersDrawReq(boarders_Drawing_Request),
	.BG_RGB(backGroundRGB));


NumbersBitMap	b2v_inst15(
	.clk(clk),
	.resetN(resetN),
	.InsideRectangle(box_req),
	.digit(SW),
	.offsetX(box_offX),
	.offsetY(box_offY),
	.drawingRequest(numberDrawingRequest),
	.RGBout(num_RGB));
	defparam	b2v_inst15.digit_color = 8'b11111111;


inverseSmileyBitMap	b2v_inst17(
	.clk(clk),
	.resetN(resetN),
	.InsideRectangle(smileyRecDR),
	.offsetX(smileyOffsetX),
	.offsetY(smileyOffsety),
	.drawingRequest(smiley_req),
	.HitEdgeCode(HitEdgeCode),
	.RGBout(SMILEY_VGA));


random	b2v_inst20(
	.clk(clk),
	.resetN(resetN),
	.rise(SYNTHESIZED_WIRE_0),
	.dout(SQR_topLeftX));
	defparam	b2v_inst20.MAX_VAL = 479;
	defparam	b2v_inst20.MIN_VAL = 0;
	defparam	b2v_inst20.SIZE_BITS = 11;


objects_mux_all	b2v_inst21(
	.clk(clk),
	.resetN(resetN),
	.smileyDrawingRequest(smiley_req),
	.boxDrawingRequest(box_req),
	.numberDrawingRequest(numberDrawingRequest),
	.backGroundRGB(backGroundRGB),
	.boxRGB(boxRGB),
	.numRGB(num_RGB),
	.smileyRGB(SMILEY_VGA),
	.blueOut(iBlue),
	.greenOut(iGreen),
	.redOut(iRed));


square_tree_object	b2v_inst28(
	.clk(clk),
	.resetN(resetN),
	.startOfFrame(Start_of_frame),
	.pixelX(pixelX),
	.pixelY(pixelY),
	.topLeftX(SQR_topLeftX),
	
	.drawingRequest(box_req),
	.offsetX(box_offX),
	.offsetY(box_offY),
	.RGBout(boxRGB));
	defparam	b2v_inst28.OBJECT_COLOR = 8'b01011011;
	defparam	b2v_inst28.OBJECT_HEIGHT_Y = 100;
	defparam	b2v_inst28.OBJECT_WIDTH_X = 100;


ToneDecoder	b2v_inst3(
	.tone(SW),
	.preScaleValue(SYNTHESIZED_WIRE_1));


square_object	b2v_inst6(
	.clk(clk),
	.resetN(resetN),
	.pixelX(pixelX),
	.pixelY(pixelY),
	.topLeftX(SmileyTLX),
	.topLeftY(SmileyTLY),
	.drawingRequest(smileyRecDR),
	.offsetX(smileyOffsetX),
	.offsetY(smileyOffsety)
	);
	defparam	b2v_inst6.OBJECT_COLOR = 8'b01011011;
	defparam	b2v_inst6.OBJECT_HEIGHT_Y = 32;
	defparam	b2v_inst6.OBJECT_WIDTH_X = 64;
	defparam	b2v_inst6.Y_Speed = 1'b0;

assign	SYNTHESIZED_WIRE_0 = ~(moveRight & moveLeft);


TOP_MSS_DEMO	b2v_inst9(
	.AUD_ADCDAT(AUD_ADCDAT),
	.CLOCK_50(clk),
	.resetN(resetN),
	
	.AUD_ADCLRCK(AUD_ADCLRCK),
	.AUD_BCLK(AUD_BCLK),
	.AUD_DACLRCK(AUD_DACLRCK),
	.AUD_I2C_SDAT(AUD_I2C_SDAT),
	.freq(SYNTHESIZED_WIRE_1),
	.MICROPHON_LED(MICROPHON_LED),
	.AUD_DACDAT(AUD_DACDAT),
	.AUD_XCK(AUD_XCK),
	.AUD_I2C_SCLK(AUD_I2C_SCLK)
	
	
	
	);

assign	VGA_VS = VgaVS;
assign	clk = CLOCK_50;
assign	moveLeft = KEY[2];
assign	VGA_HS = VgaHS;
assign	VGA_CLK = vgaClk;
assign	VGA_BLANK_N = vgaBlinkN;
assign	VGA_SYNC_N = VgaSyncN;
assign	VGA_B = VgaB;
assign	VGA_G = VgaG;
assign	VGA_R = VgaR;
assign	moveLeft = KEY[2];
assign	moveRight = KEY[1];

endmodule
