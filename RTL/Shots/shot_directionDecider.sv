module shot_directionDecider (	
	input logic moveLeft,
	input logic moveRight,
	output logic [2:0] shotDirection
 
);
logic right,left;
assign right=!moveRight && moveLeft;
assign left=!moveLeft && moveRight;
always_comb begin
	if(left) shotDirection=3'b100;
	else if(right) shotDirection=3'b001;
	else shotDirection=3'b010;
end

endmodule