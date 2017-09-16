module LCD_Controller

(
	input logic MAX10_CLK1_50,
	input logic [4:0] KEY,
	inout logic MTL2_BL_ON_n,
	output logic [7:0]  MTL2_B,
	output logic MTL2_DCLK,
	output logic [7:0] MTL2_G,
	output logic MTL2_HSD,
	output logic [7:0] MTL2_R,
	output logic MTL2_VSD
);
	
	logic clk, blank_n, red_btn, green_btn, blue_btn;
    
	assign MTL2_BL_ON_n = 1'b0;     // Enable the backlight
	
	// PLL 50MHz to 33MHz
    sys_pll	sys_pll_inst (
        .inclk0 ( MAX10_CLK1_50 ),
        .c0 ( clk )
    );
	
    // Connect the LCD's pixel clock to the PLL's 33MHz clock
	assign MTL2_DCLK = clk;
	
	// Generate the synchronization signals
	sync_gen sync (
        .clk(clk),
        .rst_n(KEY[4]),
        .hsync(MTL2_HSD),
        .vsync(MTL2_VSD),
        .blank_n(blank_n)
    );
 
/* 
    // Edge detectors for all of the buttons (only change color on button press-down)
    edge_detect redbtn (
        .clk(clk),
        .rst_n(KEY[4]),
        .sig_in(KEY[0]),
        .sig_out(red_btn)
    );
    
    edge_detect greenbtn (
        .clk(clk),
        .rst_n(KEY[4]),
        .sig_in(KEY[1]),
        .sig_out(green_btn)
    );
    
    edge_detect bluebtn (
        .clk(clk),
        .rst_n(KEY[4]),
        .sig_in(KEY[2]),
        .sig_out(blue_btn)
    );
*/
    
	// Generate color values based on button presses
    color_gen color (
        .clk(clk),
        .rst_n(KEY[4]),
        .red_btn(red_btn),
        .green_btn(green_btn),
        .blue_btn(blue_btn),
        .blank_n(blank_n),
        .red(MTL2_R),
        .green(MTL2_G),
        .blue(MTL2_B)
    );
 
endmodule
