module eab  (selEAB1, selEAB2, ir, pc, sr1, EABout);
   input selEAB1;
   input [1:0] selEAB2;
   input [15:0] ir, pc, sr1;
   output [15:0] EABout;

   wire [15:0] addr2mux1, addr2mux2;

   assign addr2mux2 =
		     (selEAB2 == 2'b00) ? 16'b0 :
		     (selEAB2 == 2'b01) ? {{10{ir[5]}},ir[5:0]} :
		     (selEAB2 == 2'b10) ? {{7{ir[8]}},ir[8:0]} :
		     {{5{ir[10]}},ir[10:0]};

   assign addr2mux1 = (selEAB1) ? sr1 : pc;

   assign EABout = addr2mux2 + addr2mux1;

endmodule // eab

module pc (EABout, Bus, clk, rst, selPC, ldPC, PCout);
   input [15:0] EABout, Bus;
   input clk, rst, ldPC;
   input [1:0] selPC;
   output reg [15:0] PCout;

   wire [15:0] PCnext;

   always @ (posedge clk)
     begin
	if(rst)
	  begin
	     PCout <= 16'b0;
	  end
	else if(ldPC)
	  begin
	     PCout <= PCnext;
	  end
     end // always @ (posedge clk)

   assign PCnext = (selPC == 2'b00) ? PCout + 16'b1 :
		   (selPC == 2'b01) ? EABout :
		                      bus;

endmodule // pc
