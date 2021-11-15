


module top (
  input clk,
  input rstn,
  input sw12,sw34,sw_ok,duty_sel,sel_high,
  input [4:0] key,
  output  dclk,
  output [7:0] dac_data );


parameter   CNT_MAX =   20'd100;
wire [7:0] dds_out;
wire pwm_out;
wire [31:0] frq_cnt,frq_pwm;
wire [19:0] duty_cnt;
wire sw1,sw2,sw3,sw4;
assign sw1 = ( sel_high ) ? 1'b1 : sw12;//10
assign sw2 = ( !sel_high ) ? 1'b1 : sw12;//100

assign sw3 = ( sel_high ) ? 1'b1 : sw34;//1000
assign sw4 = ( !sel_high ) ? 1'b1 : sw34;//100000


wire pwm_sel,ready;
reg  pwm_out_en;
wire [7:0] pwm_data;
assign dclk = clk;
assign dac_data = (pwm_out_en) ? pwm_data : dds_out;
assign pwm_data = ( pwm_out ) ? 8'hff:8'b0;
pwm u_p (
    .clk        ( clk      ),//    input
    .rstn       ( rstn      ),//    input
    .sw_ok      ( ready      ),//    input 
//    .sel        ( key[4]      ),//    input
    .frq_data   ( frq_pwm      ),//    input wire  [31:0]
    .duty_data  ( duty_cnt      ),//    input wire  19:0]
    .pwm_out    ( pwm_out      )//    output reg
);



top_dds u_dds(
    .sys_clk        ( clk      ),//    input   wire              
    .sys_rst_n        ( rstn      ),//    input   wire              
    .key            ( key[3:0]      ),//    input   wire    [3:0]     
    .data_frq        ( frq_cnt      ),//    input   wire    [31:0] 
    .dac_clk        ( dac_clk      ),//    output  wire              
    .dac_data        ( dds_out      ) //    output  wire    [7:0]          
);

frq_ctl u_frq_ctl (
    .clk        ( clk      ),//   input
    .rstn        ( rstn      ),//    input
    .sw1        (  sw1      ),//   input
    .sw2        (  sw2      ),//input
    .sw3        (  sw3      ),//input
    .sw4        (  sw4      ),//input
    .sw_ok      (  sw_ok      ),//input
    .duty_sel   ( duty_sel      ),//input
    .duty_cnt        ( duty_cnt      ),//   output [19:0]
    .frq_pwm     ( frq_pwm),
    .frq_cnt        ( frq_cnt      ),//   output [31:0]
    .ready        ( ready      ) //   output
);


 key_filter
 #(
     .CNT_MAX      (CNT_MAX  )       
 )
 u_key5
 (
     .sys_clk      (clk  )   ,   
     .sys_rst_n    (rstn)   ,   
     .key_in       (key[4]   )   ,   
     .key_flag     (pwm_sel     )       
 );
always @(posedge clk or negedge rstn)
   if(!rstn)
       pwm_out_en <= 1'b0;
   else if ( !(&key[3:0] ))
       pwm_out_en <= 1'b0;
   else if (pwm_sel )
       pwm_out_en <= 1'b1;    

endmodule
