// Code your testbench here
// or browse Examples

// For example, in a write-back policy-based cache coherency controller, 
// once a write request to an address is found in the cache (i.e. a write hit), 
// the following sequences of events should occur (possibly at varied time intervals):
// •   The line is marked as “dirty”.
// •   Any other caches having a copy of this address shall mark their copies as invalid.
// •   Eventually, the dirty line shall be cleaned – i.e. modified data shall be written back to main memory.

module top();

  `define DIRTY 1'b0
  `define INVALIDATE 1'b0
  bit clk, reset_n, bus_req, ack, cache_hit, wr;
  typedef bit[15:0] data_t; 
  bit[9:0] addr_write; 
  data_t wr_data; 
  data_t[0:1023] cache, remote_cache; 
  
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
          std::randomize(random_vector) with {
            wr_data inside {[0:100]};
            //random_vector.size() == 10;
            //foreach (random_vector[i]) {
            //  random_vector[i] inside {[0:100]};
            //}
          };
          @(posedge clk) begin
            addr_write <= random_vector;
            wr <= 1;
            cache_hit <= $random;
          end
          @(posedge clk) begin
            wr <= 0;
            cache_hit <= 0;
          end

      end

 // stimulus generation
 initial 
     forever begin
        repeat ($urandom_range(1,6)) @(posedge clk);
        bus_req <= 1;
        @(posedge clk) 
          bus_req <= 0;
     end
  
  // output generation
  always begin
    repeat ($urandom_range(1,3)) @(posedge clk); 
    cache[addr_write] <= wr_datadata;
    repeat ($urandom_range(1,3)) @(posedge clk); 
    remote_cache[addr_write] <= wr_data;
  end
   
  initial begin
    #10us;
    $finish ;
  end

  default clocking cb_clk @ (posedge clk);
  endclocking 

  sequence q_wr_hit;
      @ (posedge clk) first_match(wr ##[1:2] cache_hit);
  endsequence : q_wr_hit

  sequence q_invalidate;
      bus_req ##[1:2] ack ##1 remote_cache[addr_write]== `INVALIDATE; 
  endsequence : q_invalidate

  ap_wr_hit: assert property(
      q_wr_hit.triggered |=> 
          first_match(cache[addr_write] == `DIRTY ##1 q_invalidate
                      ##[1:$] cache[addr_write]==wr_data) |-> 
                                      remote_cache[addr_write]==wr_data 
      )
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