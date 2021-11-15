`timescale  1ns/1ns

////////////////////////////////////////////////////////////////////////

module  dds
(
    input   wire            sys_clk     ,   //系统时钟,50MHz
    input   wire            sys_rst_n   ,   //复位信号,低电平有效
    input   wire    [3:0]   wave_select ,   //输出波形选择
    input   wire    [31:0]  data_frq,
    output  wire    [7:0]   data_out        //波形输出
);

//********************************************************************//
//****************** Parameter and Internal Signal *******************//
//********************************************************************//
//parameter define
parameter   sin_wave    =   4'b0001     ,   //正弦波
            squ_wave    =   4'b0010     ,   //方波
            tri_wave    =   4'b0100     ,   //三角波
            saw_wave    =   4'b1000     ;   //锯齿波
parameter   FREQ_CTRL   =   32'd2000   ,   //相位累加器单次累加值
            PHASE_CTRL  =   12'd1000    ;   //相位偏移量

//reg   define
reg     [31:0]  fre_add     ;   //相位累加器
reg     [11:0]  rom_addr_reg;   //相位调制后的相位码
reg     [13:0]  rom_addr    ;   //ROM读地址

//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//
//fre_add:相位累加器
//
//
wire [31:0] freq = data_frq;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        fre_add <=  32'd0;
    else
        fre_add <=  fre_add + freq;   // change 20210722

//rom_addr:ROM读地址
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        begin
            rom_addr        <=  14'd0;
            rom_addr_reg    <=  11'd0;
        end
    else
    case(wave_select)
        sin_wave:
            begin
                rom_addr_reg    <=  fre_add[31:20] + PHASE_CTRL;
                rom_addr        <=  rom_addr_reg;
            end     //正弦波
        squ_wave:
            begin
                rom_addr_reg    <=  fre_add[31:20] + PHASE_CTRL;
                rom_addr        <=  rom_addr_reg + 14'd4096;
            end     //方波
        tri_wave:
            begin
                rom_addr_reg    <=  fre_add[31:20] + PHASE_CTRL;
                rom_addr        <=  rom_addr_reg + 14'd8192;
            end     //三角波
        saw_wave:
        begin
                rom_addr_reg    <=  fre_add[31:20] + PHASE_CTRL;
                rom_addr        <=  rom_addr_reg + 14'd12288;
            end     //锯齿波
        default:
            begin
                rom_addr_reg    <=  fre_add[31:20] + PHASE_CTRL;
                rom_addr        <=  rom_addr_reg;
            end     //正弦波
    endcase


rom_wave    rom_wave_inst
(
    .address    (rom_addr   ),  //ROM读地址
    .clock      (sys_clk    ),  //读时钟

    .q          (data_out   )   //读出波形数据
);



////      always@(posedge sys_clk or negedge sys_rst_n)
////          if(sys_rst_n == 1'b0)
////              fre_add <=  32'd0;
////          else
////              fre_add <=  fre_add + FREQ_CTRL;
////      
////      //rom_addr:ROM读地址
////      always@(posedge sys_clk or negedge sys_rst_n)
////          if(sys_rst_n == 1'b0)
////              begin
////                  rom_addr        <=  14'd0;
////                  rom_addr_reg    <=  11'd0;
////              end
////          else
////          case(wave_select)
////              sin_wave:
////                  begin
////                      rom_addr_reg    <=  fre_add[31:20] + PHASE_CTRL;
////                      rom_addr        <=  rom_addr_reg;
////                  end     //正弦波
////              squ_wave:
////                  begin
////                      rom_addr_reg    <=  fre_add[31:20] + PHASE_CTRL;
////                      rom_addr        <=  rom_addr_reg + 14'd4096;
////                  end     //方波
////              tri_wave:
////                  begin
////                      rom_addr_reg    <=  fre_add[31:20] + PHASE_CTRL;
////                      rom_addr        <=  rom_addr_reg + 14'd8192;
////                  end     //三角波
////              saw_wave:
////              begin
////                      rom_addr_reg    <=  fre_add[31:20] + PHASE_CTRL;
////                      rom_addr        <=  rom_addr_reg + 14'd12288;
////                  end     //锯齿波
////              default:
////                  begin
////                      rom_addr_reg    <=  fre_add[31:20] + PHASE_CTRL;
////                      rom_addr        <=  rom_addr_reg;
////                  end     //正弦波
////          endcase
////      
////      
////      rom_wave    rom_wave_inst
////      (
////          .address    (rom_addr   ),  //ROM读地址
////          .clock      (sys_clk    ),  //读时钟
////      
////          .q          (data_out   )   //读出波形数据
////      );

endmodule
