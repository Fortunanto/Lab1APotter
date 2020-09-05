//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module decimalAdder(	
					input logic [0:3] val1,
					input logic [0:3] val2,
					input logic carryIn,
					
					output logic carryOut,		
					output logic [0:3] out			
);

logic[0:5] allSum;
assign allSum = val1 + val2 + carryIn;
assign carryOut = allSum > 9;
assign out = carryOut?(allSum-10):allSum; 

endmodule