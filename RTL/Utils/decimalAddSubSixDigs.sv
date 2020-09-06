module decimalAddSubSixDigs(	
					input		logic	clk,
					input		logic	resetN,					
					
					input logic enableAdd,	
					input logic enableSub,
					input logic [0:23] amountIn,
		
					output logic [0:23] resultOut	
					
);

logic [0:5][0:3] result;
logic [0:5][0:3] amount;

genvar i;

generate 
	for (i=0;i<6;i++) begin: genloop
		assign resultOut[(i*4):(i*4)+3] = result[i];
		assign amount[i] = amountIn[(i*4):(i*4)+3];
	end
endgenerate

logic [0:5][0:3] newResultAdd;
logic [0:5] addCarrys;

decimalAdder adder(
							.val1(result[0]),
							.val2(amount[0]),
							.carryIn(0),
							.carryOut(addCarrys[0]),
							.out(newResultAdd[0])
							);

generate
	for (i=1;i<6;i++) begin: addLoop
		decimalAdder adder(
							.val1(result[i]),
							.val2(amount[i]),
							.carryIn(addCarrys[i-1]),
							.carryOut(addCarrys[i]),
							.out(newResultAdd[i])
							);
	end
endgenerate 

logic [0:5][0:3] newResultSub;
logic [0:5] subCarrys;

decimalSubtractor subber(
							.val2(result[0]),
							.val1(amount[0]),
							.carryIn(0),
							.carryOut(subCarrys[0]),
							.out(newResultSub[0])
								);
								
generate
	for (i=1;i<6;i++) begin: subLoop
		decimalSubtractor subber(
							.val2(result[i]),
							.val1(amount[i]),
							.carryIn(subCarrys[i-1]),
							.carryOut(subCarrys[i]),
							.out(newResultSub[i])
								);
	end
endgenerate 


always_ff@(posedge clk or negedge resetN)
begin
	if (!resetN) begin
		result <= 0;
	end
	else begin
		if (enableAdd) result <= newResultAdd;
		else if (enableSub) result <= newResultSub;
	end
end

endmodule