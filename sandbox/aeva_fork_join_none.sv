// Code your testbench here
// or browse Examples


// 1-bit toggle
// addr[0] = 'h0001
// addr[1] = 'h8000
module top;
  timeunit 1ns;
  timeprecision 1ns;

  initial begin
	  t1(10);   
	  t1(20);
    #40 $finish;
  end 

  task automatic t1(input int a);
    fork : sub_thread1
        $display("I am inside thread1 at time %t\n", $time);
    join_none 
    disable fork;
    $display("Out of thread1 at time %t\n", $time);
   
    fork : sub_thread2
        $display("I am inside thread2 at time %t\n", $time);
        #(a) $display("I am inside thread2 after %d\n", a);
    join_none
    $display("Out of thread2 at time %t\n", $time);
  endtask: t1

endmodule
