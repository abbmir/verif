// Code your testbench here
// or browse Examples

// Example of requirements 
//In the event of a cache read miss, 
//the read request for the same address must be forwarded to the main memory within five clocks.

module top();

  timeunit 1ns;
  timeprecision 1ns;
  logic clk, cache_mem, cache_miss, main_mem_rd, cache_rd, reset_n;
  int   rd_addr, main_mem_rd_addr;
  
  int random_vector;

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
    #100ns;
    reset_n <= 1;
  end

  // stimulus generation
  initial 
      forever begin
          std::randomize(random_vector) with {
            random_vector inside {[0:100]};
            //random_vector.size() == 10;
            //foreach (random_vector[i]) {
            //  random_vector[i] inside {[0:100]};
            //}
          };
          @(posedge clk) begin
            rd_addr <= random_vector;
            cache_rd <= 1;
            cache_miss <= $random;
          end
          @(posedge clk) begin
            cache_rd <= 0;
            cache_miss <= 0;
          end

      end

 // stimulus generation
 initial 
     forever begin
        repeat ($urandom_range(1,6)) @(posedge clk);
        main_mem_rd <= 1;
        @(posedge clk) 
          main_mem_rd <= 0;
     end
  
  // output generation
  always begin
    repeat ($urandom_range(1,3)) @(posedge clk); 
    main_mem_rd_addr <= rd_addr;
  end
   
  initial begin
    #10us;
    $finish ;
  end

  property p_cache_miss_2_main_mem_xfer (
      cache_read,           // read from cache control
      cache_miss,           // miss control from cache controller 
      rd_addr,              // desired data address [x]
      main_mem_rd,          // main memory read control 
      main_mem_rd_addr,     // main memory read address [x]
      reset_n);             // active low reset 
      int v_rd_addr_at_cache; // assertion variable to record and test  the read address

      disable iff (!reset_n)   // abort if reset_n==0
      ((cache_read && cache_miss), v_rd_addr_at_cache =rd_addr) |=>                      
      ##[0:5] main_mem_rd && (main_mem_rd_addr == v_rd_addr_at_cache);

  endproperty :  p_cache_miss_2_main_mem_xfer


  default clocking @(negedge clk); 
  endclocking

  ap_cache_miss_2_main_mem_xfer : assert property  // property instantiation
      (@(posedge clk)  p_cache_miss_2_main_mem_xfer ( cache_rd, cache_miss, 
                                   rd_addr,     main_mem_rd, main_mem_rd_addr, reset_n))
  else $error("Error");

  /*
  property checkData;
      int LData;
      @(posedge clk) disable iff (!reset_n)
      (
        ($rose(data_valid), LData = data) |-> ##[1:3] (data_out == LData)
      );
  
  endproperty

  assert property (checkData)
  else $error("Error");
  */

endmodule  