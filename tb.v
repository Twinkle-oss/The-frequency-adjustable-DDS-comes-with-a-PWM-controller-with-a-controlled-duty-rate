`timescale 1ns/1ps


module tb;

reg clk,rstn;

reg [4:0] key;
reg [3:0] sw;
reg sw_ok,duty_sel;

top u_top(
    .clk        ( clk      ),//  input
    .rstn        ( rstn      ),//  input
    .sw12        ( !sw[0]      ),//  input
//    .sw2        ( !sw[1]       ),//
    .sw34        ( !sw[1]       ),//
//    .sw4        ( !sw[3]       ),//
    .sel_high   ( 1'b1       ),
    .sw_ok      ( !sw_ok      ),//
    .duty_sel   ( duty_sel      ),//
    .key        ( key      ),//  input [4:0]
    .dclk       (  ),
    .dac_data        (               ) //  output [7:0]
);



always #10 clk = !clk;
initial begin
  #1;
   clk=1'b0;
   rstn = 1'b0;
   sw=4'b0;
   key = 5'b0;
   duty_sel = 1'b0;
   sw_ok = 1'b0;
  #100;
   rstn = 1'b1;
  #100;
   key = 5'h1;
  #10000;
   key = 5'b0;
  #100000;
  #100;
   key = 5'h2;
  #10000;
   key = 5'b0;
  #100000;
  #100;
   key = 5'h4;
  #10000;
   key = 5'b0;
  #100000;
  #100;
   key = 5'h8;
  #10000;
   key = 5'b0;
  #100000;
   sw=4'b1;
  #10000;
   sw=4'b0;
  #10000;
   sw=4'h2;
  #10000;
   sw=4'b0;
  #10000;
   sw=4'h2;
  #10000;
   sw=4'b0;
  #10000;
   sw=4'h2;
  #10000;
   sw=4'b0;
  #10000;
    sw_ok = 1'b1;
  #10000;
    sw_ok = 1'b0;
 #100000;
  key = 5'h10;
  #1000;
  key = 5'b0;
  #1000;
#10000;
#10000;
   duty_sel=1'b1;
   sw=4'h2;
  #10000;
   sw=4'b0;
#10000;
   sw_ok = 1'b1;
#1000;
   sw_ok=1'b0;
 #100000;
  #100000;
  #100;
   key = 5'h2;
  #10000;
   key = 5'b0;
  #100000;
  #100;
   key = 5'h4;
  #10000;
   key = 5'b0;
  #100000;
  #100;
   key = 5'h8;
  #10000;
   key = 5'b0;
  

 #1000000;
  #1000;
  $finish;
end



initial begin
   $fsdbDumpfile("Tb.fsdb");
   $fsdbDumpvars;
end


endmodule
