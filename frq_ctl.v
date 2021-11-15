

//`define TEST
module frq_ctl (
   input clk,rstn,
   input sw1,sw2,sw3,sw4,sw_ok,duty_sel,
   output [19:0] duty_cnt,
   output [31:0] frq_pwm,
   output [31:0] frq_cnt,
   output ready);

`ifdef TEST
parameter   CNT_MAX =   20'd100;  
`else
parameter   CNT_MAX =   20'd50_000;    //clk_frq_cycyle * CNT_MAX = 20ms  

`endif

parameter   CLK_FRQ =   50_000_000; //clk frquency  
//       frq_cnt                                         pur_frq      clk_frq
//assign data11 = $unsigned($unsigned($unsigned(2^32) * 10000000) /100000000);
//wire  unsigned  [64:0]da1,da2,da3,da4;
//assign da1 = $unsigned(40'h1_0000_0000 * 64'd2_500_000);
//assign da2 = $unsigned(da1 / 32'd500_000_000);



reg [6:0] frq_cnt1,frq_cnt2,frq_cnt3,frq_cnt4;
reg  [19:0] duty1;
reg  [31:0] frq1;
wire key1,key2,key3,key4;
assign frq_pwm = frq1;
wire [63:0] frq_cnt_tmp = $unsigned($unsigned(64'h1_0000_0000 * frq1) /CLK_FRQ);
assign duty_cnt = duty1;
assign frq_cnt  = frq_cnt_tmp[31:0];
wire [19:0] tmp_duty = $unsigned( 10*frq_cnt2) + frq_cnt1;
always @(posedge clk or negedge rstn)
   if(!rstn)
       duty1 <= 20'd50;
   else if ( duty_sel && ready )
       duty1 <=  tmp_duty;

wire [31:0] tmp_frq = $unsigned( 100000*frq_cnt4) + $unsigned( 1000*frq_cnt3) +  $unsigned( 100*frq_cnt2) + $unsigned(frq_cnt1*10);
always @(posedge clk or negedge rstn)
   if(!rstn)
       frq1 <= 32'd100000;
   else if ( !duty_sel && ready )
       frq1 <=  tmp_frq;


always @(posedge clk or negedge rstn)
   if(!rstn)
       frq_cnt1 <= 7'b0;
   else if ( key1 )
       frq_cnt1 <= frq_cnt1 + 1'b1;
   
always @(posedge clk or negedge rstn)
   if(!rstn)
       frq_cnt2 <= 7'b0;
   else if ( key2 )
       frq_cnt2 <= frq_cnt2 + 1'b1;
   
always @(posedge clk or negedge rstn)
   if(!rstn)
       frq_cnt3 <= 7'b0;
   else if ( key3 )
       frq_cnt3 <= frq_cnt3 + 1'b1;

always @(posedge clk or negedge rstn)
   if(!rstn)
       frq_cnt4 <= 7'b0;
   else if ( key4 )
       frq_cnt4 <= frq_cnt4 + 1'b1;

 key_filter
 #(
     .CNT_MAX      (CNT_MAX  )       
 )
 u_ready
 (
     .sys_clk      (clk  )   ,   
     .sys_rst_n    (rstn)   ,   
     .key_in       (sw_ok   )   ,   
     .key_flag     (ready     )       
 );
 key_filter
 #(
     .CNT_MAX      (CNT_MAX  )       
 )
 u_sw1
 (
     .sys_clk      (clk  )   ,   
     .sys_rst_n    (rstn)   ,   
     .key_in       (sw1   )   ,   
     .key_flag     (key1     )       
 );

 key_filter
 #(
     .CNT_MAX      (CNT_MAX  )       
 )
 u_sw2
 (
     .sys_clk      (clk  )   ,   
     .sys_rst_n    (rstn)   ,   
     .key_in       (sw2   )   ,   
     .key_flag     (key2     )       
 );

 key_filter
 #(
     .CNT_MAX      (CNT_MAX  )       
 )
 u_sw3
 (
     .sys_clk      (clk  )   ,   
     .sys_rst_n    (rstn)   ,   
     .key_in       (sw3   )   ,   
     .key_flag     (key3     )       
 );

 key_filter
 #(
     .CNT_MAX      (CNT_MAX  )       
 )
 u_sw4
 (
     .sys_clk      (clk  )   ,   
     .sys_rst_n    (rstn)   ,   
     .key_in       (sw4   )   ,   
     .key_flag     (key4     )       
 );



endmodule
