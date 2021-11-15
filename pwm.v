`timescale 1ns/1ns



module pwm (
    input clk,
    input rstn,
    input  sw_ok,
    input wire  [31:0] frq_data,
    input wire  [19:0] duty_data,
    output reg pwm_out);
  
wire sw_ok1;
reg [19:0] frq_cnt,duty_cnt;
reg ok_md_dly0,ok_md_dly1,ok_md_dly2;

always @(posedge clk or negedge rstn )
    if( ~rstn) begin
        ok_md_dly0 <= 1'b0;
        ok_md_dly1 <= 1'b0;
        ok_md_dly2 <= 1'b0;
     end
     else begin
        ok_md_dly0 <= sw_ok;
        ok_md_dly1 <= ok_md_dly0;
        ok_md_dly2 <= ok_md_dly1;
     end
assign sw_ok1 = !ok_md_dly2 && ok_md_dly1;

always @(posedge clk or negedge rstn )
    if( ~rstn) begin
         duty_cnt <=  20'd50;
         frq_cnt <=32'd200000;
    end
    else if ( sw_ok1 )begin
         duty_cnt <=  duty_data;
         frq_cnt <= frq_data;
    end

//                                               clk_frq
wire [31:0] max_cnt = $unsigned($unsigned(32'd1000_000_000/frq_cnt)/10);  //frequency cnt
wire [31:0] max_high = $unsigned($unsigned(max_cnt*duty_cnt)/100);         //empty cnt

reg [31:0] cnt11;
always @(posedge clk or negedge rstn )
    if( ~rstn) begin
       pwm_out <= 1'b0;
       cnt11 <= 32'b0;end
    else if ( cnt11 == max_cnt -1 )begin
       pwm_out <= 1'b0;
       cnt11 <= 32'b0;end
    else if ( cnt11 < max_high)begin
       pwm_out <= 1'b1;
       cnt11 <= cnt11+1'b1;end
    else begin
       pwm_out <= 1'b0;
       cnt11 <= cnt11+1'b1;end
      

endmodule
