// Code your testbench here
// or browse Examples

module top();
  reg clk;
  reg reset_n;

  reg       REQ;
  reg       GNT;
  reg       got_req;
  // clock generation
  initial begin
    #1ns;
    clk = 1'b0;
    forever begin
      #(500.0ns/1) clk = ~clk;
      //#((500.0ns/CLKSEL_global) -1ns) clk = ~clk;
    end
  end

  // reset generation
  initial begin
    reset_n <= 0;
    #1000ns;
    reset_n <= 1;
  end

  // stimulus REQ generation
  initial begin
      wait(reset_n);
      forever begin
          std::randomize(REQ) with {
            REQ inside {[0:100]};
            //REQ.size() == 10;
            //foreach (REQ[i]) {
            //  REQ[i] inside {[0:100]};
            //}
          };
          @(posedge clk);
            

      end
  end
  
  // output GNT generation
  always begin
    wait(reset_n);
    repeat ($urandom_range(1,3)) @(posedge clk); 
    GNT <= 1;
    @(posedge clk); 
    GNT <=0;
  end
   
  initial begin
    //$dumpfile("dump.vcd"); $dumpvars;
    //CLKSEL_global = 1;
    //task_CLOCK(100, 50, clk1);
    //repeat(2)
    //  @(posedge clk);
    //
    //task_CLOCK(200, 50, clk2);
    //repeat(2)
    //  @(posedge clk);
    
    #100us;
    $finish ;
  end

  property checkREQ;
      int LCounter = 0;
      @(posedge clk) disable iff (!reset_n)
      (
        //REQ |-> (REQ & !GNT, LCounter = LCounter + 1) [*1:$] ##1 ((GNT) && (LCounter < 4 ),$display("LCounter: %0d Maxcount: %0d", LCounter, 4))
        (REQ & !GNT, LCounter = LCounter + 1) |-> s_eventually ((GNT) && (LCounter < 4 ),$display("LCounter: %0d Maxcount: %0d", LCounter, 4))
      );
  
  endproperty

  //assert property (checkREQ)
  //else $error("Error");

  //// If anytime before GNT you get a REQ 
  //always_ff @(posedge clk) begin // supporting logic 
  //    if(REQ) got_req <= 1'b1; 
  //    if(GNT) got_req <= 1'b0;
  //end
  //ap_grant2: assert property(@ (posedge clk) 
  //       GNT |-> got_req); 

endmodule

