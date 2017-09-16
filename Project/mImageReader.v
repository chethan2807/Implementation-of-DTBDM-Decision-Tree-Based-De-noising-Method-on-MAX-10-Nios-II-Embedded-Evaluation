//******************************************************************************************************//
//This module generates 800x480 RGB color pattern for VGA display 



module mImageReader 
	#(	parameter TOTAL_COLS  = 800, 
		parameter TOTAL_ROWS  = 525,
		parameter ACTIVE_COLS = 640, 
		parameter ACTIVE_ROWS = 480
	)
	(	input 	wire 		iClk,
		input 	wire 		iRst_L,
		input 	wire 		iEn, // Enable pattern generation
		output 	wire 		oHsync,
		output 	wire 		oVsync,
		output 	wire [7:0] 	oRed,
		output 	wire [7:0] 	oGreen,
		output 	wire [7:0] 	oBlue
	);

//800x480 for LCD
	
// parameter H_VISIBLE = 800,
// parameter H_FRONT_PORCH = 210,
// parameter H_SYNC = 30,
// parameter H_BACK_PORCH = 16,

// // Vertical timing parameters
// parameter V_VISIBLE = 480,
// parameter V_FRONT_PORCH = 22,
// parameter V_SYNC = 13,
// parameter V_BACK_PORCH = 10
//Horizontal timings	
localparam	pHFPorchCnt		= 210;	
localparam	pHBPorchCnt		= 16;	
localparam	pHSyncPulse		= 30;

//Vertical timings
localparam	pVFPorchCnt		= 22;	
localparam	pVBPorchCnt		= 10;	
localparam	pVSyncPulse		= 13;

localparam	pPorchData		= 8'd0;
localparam	pSyncPulseData	= 8'd0;

	
//640x480
//Horizontal timings	
// localparam	pHFPorchCnt		= 16;	
// localparam	pHBPorchCnt		= 48;	
// localparam	pHSyncPulse		= 96;

// //Vertical timings
// localparam	pVFPorchCnt		= 10;	
// localparam	pVBPorchCnt		= 33;	
// localparam	pVSyncPulse		= 2;

// localparam	pPorchData		= 8'd16;
// localparam	pSyncPulseData	= 8'd0;

//Signal declaration
reg [10:0]	rv10Hcount;
reg [10:0]	rv10Vcount;
wire		wBlueOn;
wire		wRedOn;
wire		wGreenOn;
wire		wDrvZero;
wire		wDrvBlank;
reg [13:0] 	rv14InPixelCnt;


// assign	oHsync		= (rv10Hcount < pHSyncPulse ) ? 1'b0 : 1'b1;
// assign	oVsync		= (rv10Vcount < pVSyncPulse ) ? 1'b0 : 1'b1;

assign	wDrvZero	= (rv10Vcount <= 190 ) | (rv10Vcount >= 319 ) | (rv10Hcount <= 591 ) | (rv10Hcount >= 720) ; // Drive zero during Vertical and Horizontal front and back porch
//assign	wDrvBlank	= (!oHsync | !oVsync); // Drive blanking data during horizontal and vertical blanking period

// assign	oRed		= wDrvZero ?  8'd0 : ImageInRam[rv14InPixelCnt] ;
// assign	oBlue		= wDrvZero ?  8'd0 : ImageInRam[rv14InPixelCnt] ; 
// assign	oGreen		= wDrvZero ?  8'd0 : ImageInRam[rv14InPixelCnt] ;
 
assign	oRed		= wDrvZero ?  8'd0 : ImageReadData ;
assign	oBlue		= wDrvZero ?  8'd0 : ImageReadData ; 
assign	oGreen		= wDrvZero ?  8'd0 : ImageReadData ;


//assign	wBlueOn		= 	!wDrvZero;
						
						
//assign	wRedOn		= 	!wDrvZero;
			
						
						
//assign	wGreenOn	=  !wDrvZero ;
						

always @ (posedge iClk or negedge iRst_L or negedge iEn)
begin
	if((iRst_L == 1'b0) | (iEn == 1'b0))
	begin
		rv10Hcount		<= 10'd0;
	end
	else
	begin
		if(rv10Hcount == (TOTAL_COLS -1) )
			rv10Hcount		<= 10'd0;
		else
			rv10Hcount		<= rv10Hcount + 1'd1;
	end
end
	
always @ (posedge iClk or negedge iRst_L or negedge iEn )
begin
	if((iRst_L == 1'b0) | (iEn == 1'b0))
	begin
		rv10Vcount		<= 10'd0;
	end
	else
	begin
		if ( (rv10Vcount == (TOTAL_ROWS -1)) && (rv10Hcount == (TOTAL_COLS -1)) )
			rv10Vcount		<= 10'd0;
			
		else if(rv10Hcount == (TOTAL_COLS -1) )
			rv10Vcount		<= rv10Vcount + 1'd1; 
	end
end	

always @ (posedge iClk or negedge iRst_L or negedge iEn )
begin
	if((iRst_L == 1'b0) | (iEn == 1'b0))
	begin
		rv14InPixelCnt			<= 14'd0;
	end
	else
	begin
		if ( rv10Vcount == (TOTAL_ROWS -1))
				rv14InPixelCnt	<= 14'd0;
			
		else if ( !wDrvZero )
			rv14InPixelCnt		<= rv14InPixelCnt + 1'd1;
	end
end	

//Image Ram
//reg [7:0] ImageInRam  [0:16383];
wire [7:0] ImageReadData;

	
ImageInRam  uImageInRam(
	.address(rv14InPixelCnt),
	.clock(iClk),
	.q(ImageReadData)
	);
	

// initial
// $readmemh("lena128_Salthex_Pepper.hex", ImageInRam);


endmodule