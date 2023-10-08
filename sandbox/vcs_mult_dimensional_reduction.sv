class total;
  rand bit [7:0] a [0:2][0:2];
  rand bit[7:0] s[3]; // 3 is the number of rows
  constraint c1 {
    foreach (a[i]) {
        a[i].sum with(item>0?item:0)== s[i]; 
    }
    s.sum with (item > 0 ?item:0) == 9;
    unique{s};
  }

  function void display ();
                 foreach(a[i,j])
                 begin $write("%0d ",a[i][j]);if(j==2)$display();end
  endfunction
endclass

module top;
  total m1;
  initial begin
    m1=new ();
    m1.randomize();
    m1.display();
  end
endmodule