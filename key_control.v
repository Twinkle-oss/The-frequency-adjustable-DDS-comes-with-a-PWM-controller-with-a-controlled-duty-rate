`timescale  1ns/1ns


module  key_control
(
    input   wire            sys_clk     ,   //系统时钟,50MHz
    input   wire            sys_rst_n   ,   //复位信号,低电平有效
    input   wire    [3:0]   key         ,   //输入4位按键

    output  reg     [3:0]   wave_select     //输出波形选择
);

//********************************************************************//
//****************** Parameter and Internal Signal *******************//
//********************************************************************//
//parameter define
parameter   sin_wave    =   4'b0001,    //正弦波
            squ_wave    =   4'b0010,    //方波
            tri_wave    =   4'b0100,    //三角波
            saw_wave    =   4'b1000;    //锯齿波

parameter   CNT_MAX =   20'd100;    //计数器计数最大值
//parameter   CNT_MAX =   20'd999_999;    //计数器计数最大值

//wire  define
wire            key3    ;   //按键3
wire            key2    ;   //按键2
wire            key1    ;   //按键1
wire            key0    ;   //按键0

//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//
//wave:按键状态对应波形
always@(posedge sys_clk or negedge sys_rst_n)   
    if(sys_rst_n == 1'b0)
        wave_select   <=  4'b0000;
    else    if(key0 == 1'b1)
        wave_select   <=  sin_wave;
    else    if(key1 == 1'b1)
        wave_select   <=  squ_wave;
    else    if(key2 == 1'b1)
        wave_select   <=  tri_wave;
    else    if(key3 == 1'b1)
        wave_select   <=  saw_wave;
    else
        wave_select   <=  wave_select;



key_filter 
#(
    .CNT_MAX      (CNT_MAX  )       //计数器计数最大值
)
key_filter_inst3
(
    .sys_clk      (sys_clk  )   ,   //系统时钟50Mhz
    .sys_rst_n    (sys_rst_n)   ,   //全局复位
    .key_in       (key[3]   )   ,   //按键输入信号

    .key_flag     (key3     )       //按键消抖后标志信号
);

//------------- key_fifter_inst2 --------------
key_filter 
#(
    .CNT_MAX      (CNT_MAX  )       //计数器计数最大值
)
key_filter_inst2
(
    .sys_clk      (sys_clk  )   ,   //系统时钟50Mhz
    .sys_rst_n    (sys_rst_n)   ,   //全局复位
    .key_in       (key[2]   )   ,   //按键输入信号

    .key_flag     (key2     )       //按键消抖后标志信号
);

//------------- key_fifter_inst1 --------------
key_filter 
#(
    .CNT_MAX      (CNT_MAX  )       //计数器计数最大值
)
key_filter_inst1
(
    .sys_clk      (sys_clk  )   ,   //系统时钟50Mhz
    .sys_rst_n    (sys_rst_n)   ,   //全局复位
    .key_in       (key[1]   )   ,   //按键输入信号

    .key_flag     (key1     )       //按键消抖后标志信号
);

//------------- key_fifter_inst0 --------------
key_filter 
#(
    .CNT_MAX      (CNT_MAX  )       //计数器计数最大值
)
key_filter_inst0
(
    .sys_clk      (sys_clk  )   ,   //系统时钟50Mhz
    .sys_rst_n    (sys_rst_n)   ,   //全局复位
    .key_in       (key[0]   )   ,   //按键输入信号

    .key_flag     (key0     )       //按键消抖后标志信号
);

endmodule
