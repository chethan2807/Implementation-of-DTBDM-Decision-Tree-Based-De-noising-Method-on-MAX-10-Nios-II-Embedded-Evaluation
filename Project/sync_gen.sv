module sync_gen
#(
    // Width of counters
    parameter WIDTH = 11,
    
    // Horizontal timing parameters
    parameter H_VISIBLE = 800,
    parameter H_FRONT_PORCH = 210,
    parameter H_SYNC = 30,
    parameter H_BACK_PORCH = 16,

    // Vertical timing parameters
    parameter V_VISIBLE = 480,
    parameter V_FRONT_PORCH = 22,
    parameter V_SYNC = 13,
    parameter V_BACK_PORCH = 10
)
(
    input logic clk, rst_n,
    output logic hsync, vsync,
    output logic blank_n
);

    // Parameters that determine the maximum line and frame sizes
    localparam [WIDTH-1:0] H_WHOLE_LINE = H_VISIBLE + H_FRONT_PORCH + H_SYNC + H_BACK_PORCH;
    localparam [WIDTH-1:0] V_WHOLE_FRAME = V_VISIBLE + V_FRONT_PORCH + V_SYNC + V_BACK_PORCH;

    logic hblank, vblank;
    
    // The counters used to determine when to pulse the sync signals
    logic [WIDTH-1:0] hcount, vcount;

    // Determines when to turn on sync (active low) and blank signals
    assign hsync = !(hcount >= (H_VISIBLE + H_FRONT_PORCH) && hcount < (H_VISIBLE + H_FRONT_PORCH + H_SYNC));
    assign vsync = !(vcount >= (V_VISIBLE + V_FRONT_PORCH) && vcount < (V_VISIBLE + V_FRONT_PORCH + V_SYNC));
    
    assign hblank = (hcount >= (H_VISIBLE) && hcount < (H_WHOLE_LINE));
    assign vblank = (vcount >= (V_VISIBLE) && vcount < (V_WHOLE_FRAME));

    // Output a single blanking signal when any blanking is happening
    assign blank_n = ~(hblank | vblank);
    
    // Increment the counters
    always_ff @(posedge clk) begin
        begin
            if(!rst_n) begin
                hcount <= '0;
                vcount <= '0;
            end else if (hcount < H_WHOLE_LINE - 1) begin   // End of pixel, go to next pixel
                hcount <= hcount + 1'b1;
                vcount <= vcount;           
            end else begin  // End of line, go to next line
                hcount <= '0;
                if(vcount < V_WHOLE_FRAME - 1)
                    vcount <= vcount + 1'b1;
                else    // End of frame, go back to top
                    vcount <= '0;
            end
        end
    end

    endmodule
