// Code your testbench here
// or browse Examples

module top();
  real CLKSEL_global = 500;
  reg clk, clk1, clk2, data_valid;
  reg reset_n;

  bit [9:0] random_vector;
  reg [9:0] data;
  reg [9:0] data_out;

  task automatic task_CLOCK (input real clk_freq, input real duty_cycle, ref clk);
    real clkper_local = 1/clk_freq;
    
    forever
      #(clkper_local/2) clk = ~clk;
  endtask
  
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
            data <= random_vector;
            data_valid <= 1;
          end
          @(posedge clk)
            data_valid <= 0;

      end
  
  // output generation
  always begin
    repeat ($urandom_range(1,3)) @(posedge clk); 
    data_out <= data;
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
    
    #10us;
    $finish ;
  end

  property checkData;
      int LData;
      @(posedge clk) disable iff (!reset_n)
      (
        ($rose(data_valid), LData = data) |-> ##[1:3] (data_out == LData)
      );
  
  endproperty

  assert property (checkData)
  else $error("Error");

endmodule

