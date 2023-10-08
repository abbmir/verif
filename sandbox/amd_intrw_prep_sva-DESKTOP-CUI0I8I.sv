//Please give me solution the below listed Queries:
//1. sig_a and sig_b are environment signals, which can be given at any time, but should never be given together
/*
property check1;
  @(posedge) disable iff (!rst_n);
    !(sig_a & sigb);
endproperty
*/
//2. Every sig_a must eventually be acknowledged by sig_b, unless sig_c appears.
/*
property check2;

endproperty
*/
//3. if there is a sig_a, followed by 3 consective sig_b, then in each of the 3 cycles the data written(DO) 
//is equal to the data read(DI).
/*
property check3;
   int Ldata;
   @(posedge) disable iff (!rst_n)
     sig_a ##1 sig_b[*3] |-> D0 == mem[DI] && $past(D0,1) == $past(mem[DI], 1) && $past(D0,2) == $past(mem[DI], 2);
endproperty
*/
//4. if the state machine reaches state=ACTIVE1, it will eventually reach state=ACTIVE2
/*
property check4;
   @(posedge) disable iff (!rst_n)
     state==ACTIVE1 |-> s_eventually state==ACTIVE2;
endproperty
*/
//5. if there are two occurences of sig_a rising with state=ACTIVE1, and no sig_b occurs between them, 
//then within 3 cycles of the second rise of sig_a, START must occur.
/*
property check5;
  @(posedge) disable iff (!rst_n)
     $rose(sig_a) && state==ACTIVE1 ##1 $rose(sig_a) && state==ACTIVE1[->1] intersect !b[*1:$] |-> ##[1:3] state=START;

endproperty
*/
//6. show a sequence with 3 transactions (in which sig_a is asserted 3 times).
/*
sequence check6;
  @(posedge) disable iff (!rst_n)
    sig_a[->3]
endsequence
*/
//7. sig_a must not rise if we have seen sig_b and havent seen the next sig_c yet
//(from the cycle after the sig_b until the cycle before the sig_c)
/*
property check7;
  @(posedge) disable iff (!rst_n)
    assert property(@ (posedge clk) not(!$rose(a) && c) ); 
endproperty
*/
//8. if sig_a is down , sig_b may only rise for one cycle before the next time that sig_a is asserted.
/*
assert property(@ (posedge clk) !a |-> strong(b[->1] ##1 1'b1 intersect a[->1] ));  
*/
//9. The Auxiliary signal sig_a indicates that we have seen a sig_b, and havent seen a sig_C since then. it rises one cycle after the sig_b, and falls one cycle after the sig_c.
/*
assert property(@ (posedge clk)  b |=> $rose(a) ##1 c[->1] ##1 $fell(a));  
*/
//A. what is Eventually acknowlegment
//B. what is Environment signals

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
      repeat(2) begin
          std::randomize(REQ) with {
            REQ inside {0};
          };
          @(posedge clk);
          std::randomize(REQ) with {
            REQ inside {1};
          };
          @(posedge clk);
          std::randomize(REQ) with {
            REQ inside {0};
          };
      end
  end
  
  // output GNT generation
/*
  always begin
    wait(reset_n);
    repeat ($urandom_range(1,3)) @(posedge clk); 
    GNT <= 1;
    @(posedge clk); 
    GNT <=0;
  end
*/
  initial begin
      wait(reset_n);
      repeat(1) begin
          std::randomize(GNT) with {
            GNT inside {0};
          };
          repeat(4) @(posedge clk);
          std::randomize(GNT) with {
            GNT inside {1};
          };
          repeat(1) @(posedge clk);
          std::randomize(GNT) with {
            GNT inside {0};
          };
      end
  end

  initial begin
    
    #100us;
    $finish ;
  end
/*
// SVA allows fixed delay, this following code can be used to allow variable delay model
sequence s_check_REQ_cnt_till_GNT_rcvd(REQ_, count_);
  int REQ_count_=0; //Note this is a dynamic variable. For every entry into the sequence it will
                    // create a new instance of REQ_count
  ((REQ_ && !GNT),REQ_count_=REQ_count_+1)[*1:$] ##1 ((GNT && (count_+1) <= REQ_count_),$display("REQ_count_: %0d count_: %0d",REQ_count_,count_));
  // valid_count is incremented unconditionally on each clock
  // Note that REQ_count_ and sequence expression (REQ_ && !GNT) is separated by a comma. 
  // ($rose(GNT) && (count_+1)===REQ_count_)can be true within an extended time window following (REQ_ && !GNT) is triggered
endsequence

//Check GNT goes high after 4 REQ
property p_check_num_REQ_till_GNT_rcvd (clk, reset_n, REQ, GNT, num_tones_=4);
  @(posedge clk) disable iff (!reset_n )
  (REQ) |->  s_check_REQ_cnt_till_GNT_rcvd(REQ,num_tones_);
endproperty

REQ_to_GNT_chk : assert property (p_check_num_REQ_till_GNT_rcvd (clk, reset_n, REQ, GNT,4)) 
                                                                                 else 
                                                                                       $error ("REQ_to_GNT_checker","GNT asserted before 4 REQ received");

*/
  //// If anytime before GNT you get a REQ 
  //always_ff @(posedge clk) begin // supporting logic 
  //    if(REQ) got_req <= 1'b1; 
  //    if(GNT) got_req <= 1'b0;
  //end
  //ap_grant2: assert property(@ (posedge clk) 
  //       GNT |-> got_req); 

//(i) A machine takes an input argument REQ and generates a GNT after two or more clock cycles; 
  /*
  a_req_followed_by_gnt_2_or_more_cyc : assume property p_req_followed_by_gnt_2_or_more_cyc;
    @(posedge clk) disable iff (!reset_n )
    REQ |-> ##[2:$] GNT;
  endproperty
  */
//(ii) There cannot be a GNT with in two clock cycles of REQ; 
  /*
  property p_req_followed_no_gnt_in_2_cyc;
    @(posedge clk) disable iff (!reset_n )
    REQ |-> not(##[1:2]GNT);  // False FAIL due to range problem
  endproperty
  a_req_followed_no_gnt_in_2_cyc : assert property (p_req_followed_no_gnt_in_2_cyc)
                                      $display("REQ_to_GNT_checker ","PASS");
                                   else 
                                      $error ("REQ_to_GNT_checker ","FAIL");
  */
//(iii) There cannot be a new REQ to machine until GNT occurred; 
  property p_req_followed_no_req_until_gnt;
    @(posedge clk) disable iff (!reset_n )
    REQ |-> not(GNT[->1] ##1 1'b1 intersect REQ[->1]);
  endproperty
  a_req_followed_no_gnt_in_2_cyc : assert property (p_req_followed_no_req_until_gnt)
                                      $display("REQ_to_GNT_checker ","PASS");
                                   else 
                                      $error ("REQ_to_GNT_checker ","FAIL");

endmodule

