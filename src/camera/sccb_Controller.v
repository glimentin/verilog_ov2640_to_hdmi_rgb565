module sccb_Controller #
(
	parameter HACT,
	parameter VACT,
	parameter HTOL,
	parameter VTOL,
	parameter ADDR_IS2BYTE	= "false" ,//"true":2 bytes; "false":1 byte
	parameter DEV_ADDR		= 8'h60
)
(
	input 	rst			,// Reset signal
    input 	clk			,// 24Mhz clock signal
    output	done		,// Flag to indicate that the configuration is finished
    output	sioc		,// SCCB interface - clock signal
    inout 	siod		,// SCCB interface - data signal
    output	cmos_rstn	,// RESETB signal
    output	cmos_pwdn    // PWDN signal 
);

//======================================================
// Signals for RESET and PWDN 
//                delay_cnt==100_000  ______________________________________________________
//delay_rstn  :______________________|
//                                   delay_cnt==3_000_000  _________________________________
//start_config:___________________________________________|
reg [31:0] 	delay_cnt;
reg			delay_rstn;
reg 		start_config;

always@(posedge clk or posedge rst) //I_clk
begin
	if(rst)
		begin
			delay_cnt <= 32'd0;
			delay_rstn <= 1'b0;
			start_config <= 1'b0;
		end 
	else begin
		if(delay_cnt == 32'd3_000_000)//50MHz~60ms; 24MHz~125ms; 12MHz~250ms 
			begin
				delay_cnt <= delay_cnt;
				delay_rstn <= 1'b1;
				start_config <= 1'b1;
			end 
		else if(delay_cnt == 32'd100_000)//50MHz~2ms; 24MHz~4.17ms; 12MHz~8.34ms 
			begin
				delay_cnt <= delay_cnt + 1'b1;
				delay_rstn <= 1'b1;
				start_config <= 1'b0;
			end 
		else 
			begin
				delay_cnt <= delay_cnt + 1'b1;
				delay_rstn <= delay_rstn;
				start_config <= start_config;
			end
		
	end
end

assign cmos_rstn = delay_rstn;
assign cmos_pwdn = 0;

wire   in_rst;
assign in_rst = ~start_config;

//======================================================
// Internal signals
wire [23:0] command;
wire finished;
wire taken;
reg send = 0;

// Signal for testing
assign done = finished;

// Signal to indicate that the configuration is finshied    
always @ (finished) begin
    send = ~finished;
end

// Create an instance of a LUT table 
sccb_Registers #
(
	.HACT	(HACT ),
	.VACT	(VACT ),
	.HTOL	(HTOL ),
	.VTOL	(VTOL )
)
sccb_Registers_inst
(
	.clk		(clk		),
	.advance	(taken		),// Flag to advance to next register
	.command	(command	),// register value and data 
	.finished	(finished	),// Flag to indicate the configuration is finshed
	.rst		(in_rst		) // Re-configure flag 
);

// Create an instance of a SCCB interface
sccb_Interface #
(
	.ADDR_IS2BYTE	(ADDR_IS2BYTE	),//"true":2 bytes; "false":1 byte
	.SID 			(DEV_ADDR		) 
) 
sccb_Interface_inst 
(
	.rst	(in_rst			),
	.clk	(clk			),// 50Mhz clock signal
	.sioc	(sioc			),// Clock signal for SCCB interface
	.siod	(siod			),// Data signal for SCCB interface 
	.taken	(taken			),// Flag to advance to next register
	.send	(send			),// Continue to configure 
	.regah	(command[23:16]	),// Register address  high 8 bit
	.regal	(command[15: 8]	),// Register address  low 8 bit
	.value	(command[ 7: 0]	) // Data to write into register
);
    
endmodule