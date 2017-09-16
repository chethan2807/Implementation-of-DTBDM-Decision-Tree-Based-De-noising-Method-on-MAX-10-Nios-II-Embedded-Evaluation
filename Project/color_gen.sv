module color_gen
(
    input logic clk, rst_n,
    input logic blank_n,
   // input logic red_btn, green_btn, blue_btn,
    output logic [7:0] red, green, blue
);
logic [1:0] red_cnt, green_cnt, blue_cnt;
wire [7:0] wv8red, wv8green, wv8blue;

// The bottom six bits will always be high
// assign red = (blank_n) 		? {red_cnt, 6'b111111} : 8'b0;
// assign green = (blank_n) 	? {green_cnt, 6'b111111} : 8'b0;
// assign blue = (blank_n) 	? {blue_cnt, 6'b111111} : 8'b0;

assign red = (blank_n) 		? wv8red : 8'b0;
assign green = (blank_n) 	? wv8green : 8'b0; 
assign blue = (blank_n) 	? wv8blue : 8'b0;



// assign red = (blank_n) 		? 8'd180 : 8'b0;
// assign green = (blank_n) 	? 8'b0 : 8'b0; 
// assign blue = (blank_n) 	? 8'b0 : 8'b0;

/*
always_ff @(posedge clk)
begin
    if(!rst_n) begin
        red_cnt <= 2'b0;
        green_cnt <= 2'b0;
        blue_cnt <= 2'b0;
    end else begin
        // Increment each color if the respective button is being pressed
        if(red_btn)
            red_cnt += 1'b1;
            
        if(green_btn)
            green_cnt += 1'b1;
            
        if(blue_btn)
            blue_cnt += 1'b1;
    end
end
*/

mImageReader  
	#(	.TOTAL_COLS  (1056), //(800),  640x480 & 800x480
		.TOTAL_ROWS  (525), //(525),
		.ACTIVE_COLS (800), //(640), 
		.ACTIVE_ROWS (480) //(480)
	) uImageReader
	(	.iClk(clk),
		.iRst_L(rst_n),
		.iEn(1'b1), // Enable pattern generation
		.oHsync(),
		.oVsync(),
		.oRed(wv8red),
		.oGreen(wv8green),
		.oBlue(wv8blue)
	);

endmodule

   // parameter H_VISIBLE = 800,
    // parameter H_FRONT_PORCH = 210,
    // parameter H_SYNC = 30,
    // parameter H_BACK_PORCH = 16,

    // // Vertical timing parameters
    // parameter V_VISIBLE = 480,
    // parameter V_FRONT_PORCH = 22,
    // parameter V_SYNC = 13,
    // parameter V_BACK_PORCH = 10