//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module decimalSubtractor(	
					input logic [0:3] val1,
					input logic [0:3] val2,
					input logic carryIn,
					
					output logic carryOut,		
					output logic [0:3] out			
);

shortint sub;
assign sub = val2 - val1 - carryIn;
assign carryOut = sub<0;
assign out = carryOut?(10+sub):sub; 

endmodule