`timescale 1ns/1ns

module rom_wave (
         address,
         clock,
         q);
 
         input   [13:0]  address;
         input     clock;
         output  [7:0]  q;



rom_16384x8 your_instance_name (
  .clka(clock),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(address),  // input wire [13 : 0] addra
  .douta(q)  // output wire [7 : 0] douta
);





/*
integer hand,hand_i,j,i;
integer data_i[18192:0];
reg [7:0] mem [0:16384];
assign q = mem[address];
initial begin
 #10;
    $readmemh("./t1_hex.txt",mem);
    hand=$fopen("./t1.txt","r");
    hand_i=$fopen("./t1_hex.txt","rw");
//     for(j=0;j<16384;j=j+1)begin
//          #1;
//      $display("data_i[%0d] = %0d",j,mem[j]);
// end
//  $finish;
end
*/



endmodule
