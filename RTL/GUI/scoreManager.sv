//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	scoreManager(	
					input		logic	clk,
					input		logic	resetN,					
					
					input logic enableAdd,	
					input logic enableRemove,
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


always_ff@(posedge clk or negedge resetN)
begin
	if (!resetN) begin
		result <= 0;
	end
	else begin
		if (enableAdd) result <= newResultAdd;
	end
end

endmodule