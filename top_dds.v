`timescale  1ns/1ns



module  top_dds
 #(
parameter   FREQ_CTRL   =   32'd2000  )
(
    input   wire            sys_clk     ,   
    input   wire            sys_rst_n   ,   
    input   wire    [3:0]   key         ,   
    input   wire    [31:0]  data_frq,
    output  wire            dac_clk     ,   
    output  wire    [7:0]   dac_data        
);


//parameter   FREQ_CTRL   =   32'd2000 ;



wire    [3:0]   wave_select ;   


assign  dac_clk  = ~sys_clk;



dds
 #(
    .FREQ_CTRL      (FREQ_CTRL  )
)
     dds_inst
(
    .sys_clk        (sys_clk    ),   
    .sys_rst_n      (sys_rst_n  ),   
    .wave_select    (wave_select),   
    .data_frq       ( data_frq),
    .data_out       (dac_data   )    
);



key_control key_control_inst
(
    .sys_clk        (sys_clk    ),   
    .sys_rst_n      (sys_rst_n  ),   
    .key            (key        ),   

    .wave_select    (wave_select)    
 );

endmodule
