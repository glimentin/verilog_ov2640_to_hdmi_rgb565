`timescale 1ns / 1ps

module sccb_Registers #
(
    parameter HACT = 12'd640,
    parameter VACT = 12'd480,
    parameter HTOL = 13'd1632,
    parameter VTOL = 13'd1232
)
(
    input             clk,
    input             rst,
    input             advance,
    output     [23:0] command,
    output            finished
);

reg [23:0] sreg;
reg        finished_temp;
reg [9:0]  address = 10'd0;

assign command  = sreg;
assign finished = finished_temp;

// Preserve the original finished signalling behaviour.
always @(sreg) begin
    if (sreg == 24'hFF_FFFF)
        finished_temp <= 1'b1;
    else
        finished_temp <= 1'b0;
end

// Register/value LUT. command[15:8] is the OV2640 register address;
// command[7:0] is its value. command[23:16] remains zero.
always @(posedge clk) begin
    if (rst)
        address <= 10'd0;
    else if (advance)
        address <= address + 1'b1;

    case (address)

        // =============================================================
        // SOFTWARE RESET AND BANK SETUP
        // =============================================================
        10'd0  : sreg <= 24'h00FF_01; // BANK_SEL: select SENSOR register bank
        10'd1  : sreg <= 24'h0012_80; // COM7: software reset
        10'd2  : sreg <= 24'h00FF_00; // BANK_SEL: select DSP register bank
        10'd3  : sreg <= 24'h002C_FF; // Reserved DSP initialization value
        10'd4  : sreg <= 24'h002E_DF; // Reserved DSP initialization value
        10'd5  : sreg <= 24'h00FF_01; // BANK_SEL: select SENSOR register bank

        // =============================================================
        // SENSOR BANK: CLOCK, EXPOSURE AND ANALOG FRONT END
        // =============================================================
        10'd6  : sreg <= 24'h003C_32; // Reserved sensor initialization value
        10'd7  : sreg <= 24'h0011_01; // CLKRC: sensor clock divider
        10'd8  : sreg <= 24'h0009_02; // COM2: output drive capability x2
        10'd9  : sreg <= 24'h0004_20; // REG04: mirror/flip and output control
        10'd10 : sreg <= 24'h0013_E5; // COM8: banding, AGC and AEC controls
        10'd11 : sreg <= 24'h0014_48; // COM9: automatic gain ceiling
        10'd12 : sreg <= 24'h002C_0C; // Reserved sensor timing value
        10'd13 : sreg <= 24'h0033_78; // Reserved sensor initialization value
        10'd14 : sreg <= 24'h003A_33; // Reserved sensor initialization value
        10'd15 : sreg <= 24'h003B_FB; // Reserved sensor initialization value
        10'd16 : sreg <= 24'h003E_00; // Reserved sensor initialization value
        10'd17 : sreg <= 24'h0043_11; // Reserved sensor initialization value
        10'd18 : sreg <= 24'h0016_10; // Reserved sensor initialization value
        10'd19 : sreg <= 24'h0039_92; // Reserved sensor initialization value
        10'd20 : sreg <= 24'h0035_DA; // Reserved sensor initialization value
        10'd21 : sreg <= 24'h0022_1A; // Reserved sensor initialization value
        10'd22 : sreg <= 24'h0037_C3; // Reserved sensor initialization value
        10'd23 : sreg <= 24'h0023_00; // Reserved sensor initialization value
        10'd24 : sreg <= 24'h0034_C0; // ARCOM2: analog control
        10'd25 : sreg <= 24'h0036_1A; // Reserved sensor initialization value
        10'd26 : sreg <= 24'h0006_88; // Reserved sensor initialization value
        10'd27 : sreg <= 24'h0007_C0; // Reserved sensor initialization value
        10'd28 : sreg <= 24'h000D_87; // COM4: PLL/AEC control
        10'd29 : sreg <= 24'h000E_41; // Reserved sensor initialization value
        10'd30 : sreg <= 24'h004C_00; // Reserved sensor initialization value
        10'd31 : sreg <= 24'h0048_00; // Reserved sensor initialization value
        10'd32 : sreg <= 24'h005B_00; // Reserved sensor initialization value
        10'd33 : sreg <= 24'h0042_03; // Reserved sensor initialization value
        10'd34 : sreg <= 24'h004A_81; // Reserved sensor initialization value
        10'd35 : sreg <= 24'h0021_99; // Reserved sensor initialization value
        10'd36 : sreg <= 24'h0024_40; // AEW: AEC/AGC stable-zone upper limit
        10'd37 : sreg <= 24'h0025_38; // AEB: AEC/AGC stable-zone lower limit
        10'd38 : sreg <= 24'h0026_82; // VV: AEC/AGC fast-mode thresholds
        10'd39 : sreg <= 24'h005C_00; // Reserved sensor initialization value
        10'd40 : sreg <= 24'h0063_00; // Reserved sensor initialization value
        10'd41 : sreg <= 24'h0046_00; // Frame-length/timing control
        10'd42 : sreg <= 24'h000C_3C; // COM3: banding and frame controls
        10'd43 : sreg <= 24'h0061_70; // HISTO_LOW: histogram low threshold
        10'd44 : sreg <= 24'h0062_80; // HISTO_HIGH: histogram high threshold
        10'd45 : sreg <= 24'h007C_05; // Reserved sensor initialization value
        10'd46 : sreg <= 24'h0020_80; // Reserved sensor initialization value
        10'd47 : sreg <= 24'h0028_30; // Reserved sensor initialization value
        10'd48 : sreg <= 24'h006C_00; // Reserved sensor initialization value
        10'd49 : sreg <= 24'h006D_80; // Reserved sensor initialization value
        10'd50 : sreg <= 24'h006E_00; // Reserved sensor initialization value
        10'd51 : sreg <= 24'h0070_02; // Reserved sensor initialization value
        10'd52 : sreg <= 24'h0071_94; // Reserved sensor initialization value
        10'd53 : sreg <= 24'h0073_C1; // Reserved sensor initialization value

        // =============================================================
        // SENSOR BANK: SVGA WINDOW AND SENSOR TIMING
        // =============================================================
        10'd54 : sreg <= 24'h0012_42; // COM7: select SVGA sensor mode
        10'd55 : sreg <= 24'h0017_11; // HSTART: horizontal window start
        10'd56 : sreg <= 24'h0018_43; // HSTOP: horizontal window stop
        10'd57 : sreg <= 24'h0019_00; // VSTART: vertical window start
        10'd58 : sreg <= 24'h001A_4B; // VSTOP: vertical window stop
        10'd59 : sreg <= 24'h0032_09; // REG32: window edge low bits
        10'd60 : sreg <= 24'h0037_C0; // Reserved sensor window value
        10'd61 : sreg <= 24'h004F_CA; // BD50: 50 Hz banding step
        10'd62 : sreg <= 24'h0050_A8; // BD60: 60 Hz banding step
        10'd63 : sreg <= 24'h005A_23; // Banding/AEC control
        10'd64 : sreg <= 24'h006D_00; // Reserved sensor window value
        10'd65 : sreg <= 24'h003D_38; // Reserved sensor initialization value

        // =============================================================
        // DSP BANK: CORE INITIALIZATION
        // =============================================================
        10'd66 : sreg <= 24'h00FF_00; // BANK_SEL: select DSP register bank
        10'd67 : sreg <= 24'h00E5_7F; // DSP initialization / internal control
        10'd68 : sreg <= 24'h00F9_C0; // MC_BIST: DSP microcontroller reset/boot control
        10'd69 : sreg <= 24'h0041_24; // DSP module control
        10'd70 : sreg <= 24'h00E0_14; // RESET: reset JPEG and DVP blocks
        10'd71 : sreg <= 24'h0076_FF; // Reserved DSP initialization value
        10'd72 : sreg <= 24'h0033_A0; // Reserved DSP initialization value
        10'd73 : sreg <= 24'h0042_20; // Reserved DSP initialization value
        10'd74 : sreg <= 24'h0043_18; // Reserved DSP initialization value
        10'd75 : sreg <= 24'h004C_00; // Reserved DSP initialization value
        10'd76 : sreg <= 24'h0087_D0; // CTRL3: bad/white-pixel correction controls
        10'd77 : sreg <= 24'h0088_3F; // Reserved DSP initialization value
        10'd78 : sreg <= 24'h00D7_03; // DVP format/control setup
        10'd79 : sreg <= 24'h00D9_10; // Reserved DSP initialization value
        10'd80 : sreg <= 24'h00D3_82; // R_DVP_SP: DVP clock divider
        10'd81 : sreg <= 24'h00C8_08; // Internal DSP control
        10'd82 : sreg <= 24'h00C9_80; // Internal DSP control

        // =============================================================
        // DSP BANK: SPECIAL DIGITAL EFFECT / COLOR PARAMETERS
        // =============================================================
        10'd83 : sreg <= 24'h007C_00; // BPADDR: SDE indirect address = 0
        10'd84 : sreg <= 24'h007D_00; // BPDATA: SDE control data
        10'd85 : sreg <= 24'h007C_03; // BPADDR: SDE indirect address = 3
        10'd86 : sreg <= 24'h007D_48; // BPDATA: color/saturation coefficient
        10'd87 : sreg <= 24'h007D_48; // BPDATA: color/saturation coefficient
        10'd88 : sreg <= 24'h007C_08; // BPADDR: SDE indirect address = 8
        10'd89 : sreg <= 24'h007D_20; // BPDATA: SDE parameter
        10'd90 : sreg <= 24'h007D_10; // BPDATA: SDE parameter
        10'd91 : sreg <= 24'h007D_0E; // BPDATA: SDE parameter

        // =============================================================
        // DSP BANK: GAMMA CURVE
        // =============================================================
        10'd92 : sreg <= 24'h0090_00; // Gamma table address/control
        10'd93 : sreg <= 24'h0091_0E; // Gamma curve data
        10'd94 : sreg <= 24'h0091_1A; // Gamma curve data
        10'd95 : sreg <= 24'h0091_31; // Gamma curve data
        10'd96 : sreg <= 24'h0091_5A; // Gamma curve data
        10'd97 : sreg <= 24'h0091_69; // Gamma curve data
        10'd98 : sreg <= 24'h0091_75; // Gamma curve data
        10'd99 : sreg <= 24'h0091_7E; // Gamma curve data
        10'd100: sreg <= 24'h0091_88; // Gamma curve data
        10'd101: sreg <= 24'h0091_8F; // Gamma curve data
        10'd102: sreg <= 24'h0091_96; // Gamma curve data
        10'd103: sreg <= 24'h0091_A3; // Gamma curve data
        10'd104: sreg <= 24'h0091_AF; // Gamma curve data
        10'd105: sreg <= 24'h0091_C4; // Gamma curve data
        10'd106: sreg <= 24'h0091_D7; // Gamma curve data
        10'd107: sreg <= 24'h0091_E8; // Gamma curve data
        10'd108: sreg <= 24'h0091_20; // Gamma curve data

        // =============================================================
        // DSP BANK: LENS CORRECTION TABLE
        // =============================================================
        10'd109: sreg <= 24'h0092_00; // Lens-correction table address/control
        10'd110: sreg <= 24'h0093_06; // Lens-correction table data
        10'd111: sreg <= 24'h0093_E3; // Lens-correction table data
        10'd112: sreg <= 24'h0093_05; // Lens-correction table data
        10'd113: sreg <= 24'h0093_05; // Lens-correction table data
        10'd114: sreg <= 24'h0093_00; // Lens-correction table data
        10'd115: sreg <= 24'h0093_04; // Lens-correction table data
        10'd116: sreg <= 24'h0093_00; // Lens-correction table data
        10'd117: sreg <= 24'h0093_00; // Lens-correction table data
        10'd118: sreg <= 24'h0093_00; // Lens-correction table data
        10'd119: sreg <= 24'h0093_00; // Lens-correction table data
        10'd120: sreg <= 24'h0093_00; // Lens-correction table data
        10'd121: sreg <= 24'h0093_00; // Lens-correction table data
        10'd122: sreg <= 24'h0093_00; // Lens-correction table data
        10'd123: sreg <= 24'h0096_00; // Lens-correction table address/control
        10'd124: sreg <= 24'h0097_08; // Lens-correction table data
        10'd125: sreg <= 24'h0097_19; // Lens-correction table data
        10'd126: sreg <= 24'h0097_02; // Lens-correction table data
        10'd127: sreg <= 24'h0097_0C; // Lens-correction table data
        10'd128: sreg <= 24'h0097_24; // Lens-correction table data
        10'd129: sreg <= 24'h0097_30; // Lens-correction table data
        10'd130: sreg <= 24'h0097_28; // Lens-correction table data
        10'd131: sreg <= 24'h0097_26; // Lens-correction table data
        10'd132: sreg <= 24'h0097_02; // Lens-correction table data
        10'd133: sreg <= 24'h0097_98; // Lens-correction table data
        10'd134: sreg <= 24'h0097_80; // Lens-correction table data
        10'd135: sreg <= 24'h0097_00; // Lens-correction table data
        10'd136: sreg <= 24'h0097_00; // Lens-correction table data

        // =============================================================
        // DSP BANK: AWB, COLOR MATRIX AND IMAGE PROCESSING
        // =============================================================
        10'd137: sreg <= 24'h00C3_ED; // CTRL1: DSP modules (AWB, gamma, lens, etc.)
        10'd138: sreg <= 24'h00A4_00; // DSP automatic control
        10'd139: sreg <= 24'h00A8_00; // DSP automatic control
        10'd140: sreg <= 24'h00C5_11; // AWB/color-processing parameter
        10'd141: sreg <= 24'h00C6_51; // AWB/color-processing parameter
        10'd142: sreg <= 24'h00BF_80; // AWB/color-processing parameter
        10'd143: sreg <= 24'h00C7_10; // AWB/color-processing parameter
        10'd144: sreg <= 24'h00B6_66; // Color matrix coefficient
        10'd145: sreg <= 24'h00B8_A5; // Color matrix coefficient
        10'd146: sreg <= 24'h00B7_64; // Color matrix coefficient
        10'd147: sreg <= 24'h00B9_7C; // Color matrix coefficient
        10'd148: sreg <= 24'h00B3_AF; // Color matrix coefficient
        10'd149: sreg <= 24'h00B4_97; // Color matrix coefficient
        10'd150: sreg <= 24'h00B5_FF; // Color matrix coefficient
        10'd151: sreg <= 24'h00B0_C5; // Color matrix sign/control
        10'd152: sreg <= 24'h00B1_94; // Color matrix sign/control
        10'd153: sreg <= 24'h00B2_0F; // Color matrix sign/control
        10'd154: sreg <= 24'h00C4_5C; // DSP output processing control

        // =============================================================
        // DSP BANK: INPUT WINDOW, SCALER AND OUTPUT SIZE
        // =============================================================
        10'd155: sreg <= 24'h00C0_64; // HSIZE8: sensor input width [10:3], 800 pixels
        10'd156: sreg <= 24'h00C1_4B; // VSIZE8: sensor input height [10:3], 600 pixels
        10'd157: sreg <= 24'h008C_00; // SIZEL: low bits of sensor input size
        10'd158: sreg <= 24'h0086_3D; // CTRL2: enable DCW/SDE/UV/CMX processing blocks
        10'd159: sreg <= 24'h0050_00; // CTRLI: horizontal/vertical divider control
        10'd160: sreg <= 24'h0051_C8; // HSIZE: DSP input width / 4 = 200
        10'd161: sreg <= 24'h0052_96; // VSIZE: DSP input height / 4 = 150
        10'd162: sreg <= 24'h0053_00; // XOFFL: horizontal input offset
        10'd163: sreg <= 24'h0054_00; // YOFFL: vertical input offset
        10'd164: sreg <= 24'h0055_00; // VHYX: size/offset high bits
        10'd165: sreg <= {16'h005A, HACT[9:2]}; // ZMOW: output width / 4, derived from HACT
        10'd166: sreg <= {16'h005B, VACT[9:2]}; // ZMOH: output height / 4, derived from VACT
        10'd167: sreg <= 24'h005C_00; // ZMHH: output-size high bits and zoom speed
        10'd168: sreg <= 24'h00D3_82; // R_DVP_SP: DVP pixel-clock divider
        10'd169: sreg <= 24'h00C3_FD; // CTRL1: DSP modules (current project value)

        // =============================================================
        // DSP BANK: RGB565 OUTPUT FORMAT
        // =============================================================
        10'd170: sreg <= 24'h007F_00; // Internal DSP output control
        10'd171: sreg <= 24'h00DA_08; // IMAGE_MODE: RGB565, high byte first
        10'd172: sreg <= 24'h00E5_1F; // DSP power/clock control
        10'd173: sreg <= 24'h00E1_67; // DSP clock/control value (current project value)
        10'd174: sreg <= 24'h00E0_00; // RESET: release DSP/DVP reset
        10'd175: sreg <= 24'h00DD_7F; // DSP output/control mask
        10'd176: sreg <= 24'h0005_00; // R_BYPASS: use DSP output path

        default: sreg <= 24'hFF_FFFF; // End of configuration
    endcase
end

// HTOL and VTOL are intentionally retained for interface compatibility.
// They describe external video timing and are not OV2640 SCCB registers.

endmodule



module sccb_Register #
(
	parameter HACT 		= 12'd640 ,
	parameter VACT 		= 12'd480 ,
	parameter HTOL  	= 13'd1632,
	parameter VTOL  	= 13'd1232
)
(
    input 			clk, 
    input 			rst, 
    input 			advance, 
    output [23:0] 	command, 
    output 			finished
);

// Internal signals
reg [23:0] sreg;
reg finished_temp;
reg [9:0] address = 10'd0;

// Assign values to outputs
assign command = sreg; 
assign finished = finished_temp;

// When register and value is FFFF
// a flag is asserted indicating the configuration is finished
always @ (sreg) begin
    if(sreg == 24'hFFFFFF) begin
        finished_temp <= 1'b1;
    end
    else begin
        finished_temp <= 1'b0;
    end
end


// Get value out of the LUT
always @ (posedge clk) begin
    if(rst == 1'b1) begin           // reset the configuration
        address <= 10'd0;
    end
    else if(advance == 1'b1) begin     // Get the next value
        address <= address+1'b1;
    end
    
    case (address) 
		000     : sreg <= 24'h00FF_01; //选择 sensor相关寄存器组
		001     : sreg <= 24'h0012_80;
		002     : sreg <= 24'h00FF_00; //选择 DSP相关寄存器组
		003     : sreg <= 24'h002C_FF; // 0x2c 保留
		004     : sreg <= 24'h002E_DF; // VSYNC脉冲宽MSB 8位 默认每个VSYNC 的脉冲为 4 x T_line ,MSB 每增加 一个计数 VSYNC 活动周期增加 256  x T_line
		005     : sreg <= 24'h00FF_01; //选择 sensor相关寄存器组
		006     : sreg <= 24'h003C_32; // 0x3c 保留
		007     : sreg <= 24'h0011_01;/* Set PCLK divider */
		008     : sreg <= 24'h0009_02;/* Output drive x2 */
		009     : sreg <= 24'h0004_20;
		010     : sreg <= 24'h0013_E5; // 曝光的相干设置 条状过滤器选择，手动/自动 增益控制 ， 曝光控制
		011     : sreg <= 24'h0014_48; // 设置 AGC 增益上限
		012     : sreg <= 24'h002C_0C;//Invert VSYNC
		013     : sreg <= 24'h0033_78;
		014     : sreg <= 24'h003A_33;
		015     : sreg <= 24'h003B_FB;
		016     : sreg <= 24'h003E_00;
		017     : sreg <= 24'h0043_11;
		018     : sreg <= 24'h0016_10;
		019     : sreg <= 24'h0039_92;
		020     : sreg <= 24'h0035_DA;
		021     : sreg <= 24'h0022_1A;
		022     : sreg <= 24'h0037_C3;
		023     : sreg <= 24'h0023_00;
		024     : sreg <= 24'h0034_C0;
		025     : sreg <= 24'h0036_1A; 
		026     : sreg <= 24'h0006_88;
		027     : sreg <= 24'h0007_C0;
		028     : sreg <= 24'h000D_87;
		029     : sreg <= 24'h000E_41;
		030     : sreg <= 24'h004C_00;
		031     : sreg <= 24'h0048_00;
		032     : sreg <= 24'h005B_00;
		033     : sreg <= 24'h0042_03;
		034     : sreg <= 24'h004A_81; 
		035     : sreg <= 24'h0021_99; 
		036     : sreg <= 24'h0024_40; 
		037     : sreg <= 24'h0025_38;
		038     : sreg <= 24'h0026_82;
		039     : sreg <= 24'h005C_00;
		040     : sreg <= 24'h0063_00;
		041     : sreg <= 24'h0046_00;
		042     : sreg <= 24'h000C_3C;
		043     : sreg <= 24'h0061_70;
		044     : sreg <= 24'h0062_80;
		045     : sreg <= 24'h007C_05;
		046     : sreg <= 24'h0020_80;
		047     : sreg <= 24'h0028_30;
		048     : sreg <= 24'h006C_00;
		049     : sreg <= 24'h006D_80;
		050     : sreg <= 24'h006E_00; // 保留
		051     : sreg <= 24'h0070_02; // 保留
		052     : sreg <= 24'h0071_94; // 保留
		053     : sreg <= 24'h0073_C1; // 保留
		054     : sreg <= 24'h0012_40; // 保留
		055     : sreg <= 24'h0017_11; // 保留
		056     : sreg <= 24'h0018_43; // 保留
		057     : sreg <= 24'h0019_00; // 保留
		058     : sreg <= 24'h001A_4B; // 保留
		059     : sreg <= 24'h0032_09; // 保留
		060     : sreg <= 24'h0037_C0; // 保留
		061     : sreg <= 24'h004F_CA;
		062     : sreg <= 24'h0050_A8;
		063     : sreg <= 24'h005a_23; 
		064     : sreg <= 24'h006D_00;
		065     : sreg <= 24'h003D_38;
		066     : sreg <= 24'h00FF_00; //选择 DSP相关寄存器组
		067     : sreg <= 24'h00E5_7F;
		068     : sreg <= 24'h00F9_C0;
		069     : sreg <= 24'h0041_24;
		070     : sreg <= 24'h00E0_14;
		071     : sreg <= 24'h0076_FF;
		072     : sreg <= 24'h0033_A0;
		073     : sreg <= 24'h0042_20;
		074     : sreg <= 24'h0043_18;
		075     : sreg <= 24'h004C_00;
		076     : sreg <= 24'h0087_D0; //from D5 to D0
		077     : sreg <= 24'h0088_3F;
		078     : sreg <= 24'h00D7_03;
		079     : sreg <= 24'h00D9_10;
		080     : sreg <= 24'h00D3_82;////
		081     : sreg <= 24'h00C8_08;
		082     : sreg <= 24'h00C9_80;
		083     : sreg <= 24'h007C_00;
		084     : sreg <= 24'h007D_00;
		085     : sreg <= 24'h007C_03;
		086     : sreg <= 24'h007D_48;
		087     : sreg <= 24'h007D_48;
		088     : sreg <= 24'h007C_08;
		089     : sreg <= 24'h007D_20;////
		090     : sreg <= 24'h007D_10;
		091     : sreg <= 24'h007D_0E;
		092     : sreg <= 24'h0090_00;
		093     : sreg <= 24'h0091_0E;
		094     : sreg <= 24'h0091_1A;
		095     : sreg <= 24'h0091_31;
		096     : sreg <= 24'h0091_5A;
		097     : sreg <= 24'h0091_69;
		098     : sreg <= 24'h0091_75;
		099     : sreg <= 24'h0091_7E;
		100     : sreg <= 24'h0091_88;
		101     : sreg <= 24'h0091_8F;
		102     : sreg <= 24'h0091_96;
		103     : sreg <= 24'h0091_A3;
		104     : sreg <= 24'h0091_AF;
		105     : sreg <= 24'h0091_C4;
		106     : sreg <= 24'h0091_D7;
		107     : sreg <= 24'h0091_E8;////
		108     : sreg <= 24'h0091_20;
		109     : sreg <= 24'h0092_00;
		110     : sreg <= 24'h0093_06;
		111     : sreg <= 24'h0093_E3;
		112     : sreg <= 24'h0093_05;
		113     : sreg <= 24'h0093_05;
		114     : sreg <= 24'h0093_00;
		115     : sreg <= 24'h0093_04;
		116     : sreg <= 24'h0093_00;
		117     : sreg <= 24'h0093_00;
		118     : sreg <= 24'h0093_00;
		119     : sreg <= 24'h0093_00;
		120     : sreg <= 24'h0093_00;////
		121     : sreg <= 24'h0093_00;
		122     : sreg <= 24'h0093_00;
		123     : sreg <= 24'h0096_00;
		124     : sreg <= 24'h0097_08;
		125     : sreg <= 24'h0097_19;
		126     : sreg <= 24'h0097_02;
		127     : sreg <= 24'h0097_0C;
		128     : sreg <= 24'h0097_24;
		129     : sreg <= 24'h0097_30;
		130     : sreg <= 24'h0097_28;
		131     : sreg <= 24'h0097_26;
		132     : sreg <= 24'h0097_02;
		133     : sreg <= 24'h0097_98;
		134     : sreg <= 24'h0097_80;////
		135     : sreg <= 24'h0097_00;
		136     : sreg <= 24'h0097_00;
		137     : sreg <= 24'h00C3_FD; //from ED to FD
		138     : sreg <= 24'h00A4_00;
		139     : sreg <= 24'h00A8_00;
		140     : sreg <= 24'h00C5_11;////
		141     : sreg <= 24'h00C6_51;
		142     : sreg <= 24'h00BF_80;
		143     : sreg <= 24'h00C7_10;
		144     : sreg <= 24'h00B6_66;
		145     : sreg <= 24'h00B8_A5;
		146     : sreg <= 24'h00B7_64;
		147     : sreg <= 24'h00B9_7C;
		148     : sreg <= 24'h00B3_AF;
		149     : sreg <= 24'h00B4_97;
		150     : sreg <= 24'h00B5_FF;////
		151     : sreg <= 24'h00B0_C5;//@
		152     : sreg <= 24'h00B1_94;
		153     : sreg <= 24'h00B2_0F;
		154     : sreg <= 24'h00C4_5C;
		155     : sreg <= 24'h00C0_64; // 图像 水平 大小 [10:3] HSIZE  //11_0010_0000 = 800
		156     : sreg <= 24'h00C1_4B; // 图像 垂直 大小 [10:3] VSIZE  //10_0101_1000 = 600 
		157     : sreg <= 24'h008C_00; // {HSIZE[11], HSIZE[2:0], VSIZE[2:0]}
		158     : sreg <= 24'h0086_3D; //
		159     : sreg <= 24'h0050_00; //H_DIVIDER/V_DIVIDER
		160     : sreg <= 24'h0051_C8; // HSIZE[7:0] (真实值/4) //200
		161     : sreg <= 24'h0052_96; // VSIZE[7:0] (真实值/4) //150
		162     : sreg <= 24'h0053_00; // OFFSET_X[7:0]
		163     : sreg <= 24'h0054_00; // OFFSET_Y[7:0]
		164     : sreg <= 24'h0055_00; // V_SIZE[8]/OFFSET_Y[10:8]/H_SIZE[8]/OFFSET_X[10:8]
		165     : sreg <= {16'h005A,HACT[9:2]}; //(w>>2)&0xFF	//28:w=160 //A0:w=640 //C8:w=800
		166     : sreg <= {16'h005B,VACT[9:2]}; //(h>>2)&0xFF	//1E:h=120 //78:h=480 //96:h=600
		167     : sreg <= 24'h005C_00; //((h>>8)&0x04)|((w>>10)&0x03)
		168     : sreg <= 24'h00D3_82; //DVP prescalar
		169     : sreg <= 24'h00C3_FD; //from ED to FD
		170     : sreg <= 24'h007F_00;
		171     : sreg <= 24'h00DA_08;//08:RGB565  04:RAW10
		172     : sreg <= 24'h00E5_1F;
		173     : sreg <= 24'h00E1_77; // to 77 from 67
		174     : sreg <= 24'h00E0_00;
		175     : sreg <= 24'h00DD_7F; 
		176     : sreg <= 24'h0005_00;         
		default : sreg <= 24'hFFFF_FF;    // End configuration
    endcase              
end 
  
endmodule               
                        
  /*                      
                        
//эквивалент, но 16 бит и C0/C1 = 50/3C (640×480), а не 64/4B (800×600); 
//разрешение жёстко задано через 5A=A0, 5B=78, в то время как sccb_Registers использует HACT и VACT.

module reg_init(
    input clk,
    input rst,
    output reg [15:0]data_out,
    output reg_ok,
    input sccb_ok
);
    parameter num_reg=175+1;
    reg [10:0] count=0;

    always @ (posedge clk)
    begin
        if(rst)
            count<=0;
        else if(reg_ok&&sccb_ok)
            count<=count+1;
    end

    assign reg_ok=count<=num_reg;

    always @ (posedge clk)
    case (count)
    8'h00:
    data_out <= 16'hFF01;
    8'h01 :
    data_out <= 16'h1280;
    8'h02 :
    data_out <= 16'hFF00;
    8'h03 :
    data_out <= 16'h2CFF;
    8'h04 :
    data_out <= 16'h2EDF;
    8'h05 :
    data_out <= 16'hFF01;
    8'h06 :
    data_out <= 16'h3C32;
    8'h07 :
    data_out <= 16'h1101;
    8'h08 :
    data_out <= 16'h0902;
    8'h09 :
    data_out <= 16'h0420;
    8'h0A :
    data_out <= 16'h13E5;
    8'h0B :
    data_out <= 16'h1448;
    8'h0C :
    data_out <= 16'h2C0C;
    8'h0D :
    data_out <= 16'h3378;
    8'h0E :
    data_out <= 16'h3A33;
    8'h0F :
    data_out <= 16'h3BFB;
    8'h10 :
    data_out <= 16'h3E00;
    8'h11 :
    data_out <= 16'h4311;
    8'h12 :
    data_out <= 16'h1610;
    8'h13 :
    data_out <= 16'h3992;
    8'h14 :
    data_out <= 16'h35DA;
    8'h15 :
    data_out <= 16'h221A;
    8'h16 :
    data_out <= 16'h37C3;
    8'h17 :
    data_out <= 16'h2300;
    8'h18 :
    data_out <= 16'h34C0;
    8'h19 :
    data_out <= 16'h361A;
    8'h1A :
    data_out <= 16'h0688;
    8'h1B :
    data_out <= 16'h07C0;
    8'h1C :
    data_out <= 16'h0D87;
    8'h1D :
    data_out <= 16'h0E41;
    8'h1E :
    data_out <= 16'h4C00;
    8'h1F :
    data_out <= 16'h4800;
    8'h20 :
    data_out <= 16'h5B00;
    8'h21 :
    data_out <= 16'h4203;
    8'h22 :
    data_out <= 16'h4A81;
    8'h23 :
    data_out <= 16'h2199;
    8'h24 :
    data_out <= 16'h2440;
    8'h25 :
    data_out <= 16'h2538;
    8'h26 :
    data_out <= 16'h2682;
    8'h27 :
    data_out <= 16'h5C00;
    8'h28 :
    data_out <= 16'h6300;
    8'h29 :
    data_out <= 16'h4600;
    8'h2A :
    data_out <= 16'h0C3C;
    8'h2B :
    data_out <= 16'h6170;
    8'h2C :
    data_out <= 16'h6280;
    8'h2D :
    data_out <= 16'h7C05;
    8'h2E :
    data_out <= 16'h2080;
    8'h2F :
    data_out <= 16'h2830;
    8'h30 :
    data_out <= 16'h6C00;
    8'h31 :
    data_out <= 16'h6D80;
    8'h32 :
    data_out <= 16'h6E00;
    8'h33 :
    data_out <= 16'h7002;
    8'h34 :
    data_out <= 16'h7194;
    8'h35 :
    data_out <= 16'h73C1;
    8'h36 :
    data_out <= 16'h1240;
    8'h37 :
    data_out <= 16'h1711;
    8'h38 :
    data_out <= 16'h1839;
    8'h39 :
    data_out <= 16'h1900;
    8'h3A :
    data_out <= 16'h1A3C;
    8'h3B :
    data_out <= 16'h3209;
    8'h3C :
    data_out <= 16'h37C0;
    8'h3D :
    data_out <= 16'h4FCA;
    8'h3E :
    data_out <= 16'h50A8;
    8'h3F :
    data_out <= 16'h5A23;
    8'h40 :
    data_out <= 16'h6D00;
    8'h41 :
    data_out <= 16'h3D38;
    8'h42 :
    data_out <= 16'hFF00;
    8'h43 :
    data_out <= 16'hE57F;
    8'h44 :
    data_out <= 16'hF9C0;
    8'h45 :
    data_out <= 16'h4124;
    8'h46 :
    data_out <= 16'hE014;
    8'h47 :
    data_out <= 16'h76FF;
    8'h48 :
    data_out <= 16'h33A0;
    8'h49 :
    data_out <= 16'h4220;
    8'h4A :
    data_out <= 16'h4318;
    8'h4B :
    data_out <= 16'h4C00;
    8'h4C :
    data_out <= 16'h87D5; //from D5 to D0
    8'h4D :
    data_out <= 16'h883F;
    8'h4E :
    data_out <= 16'hD703;
    8'h4F :
    data_out <= 16'hD910;
    8'h50 :
    data_out <= 16'hD382;
    8'h51 :
    data_out <= 16'hC808;
    8'h52 :
    data_out <= 16'hC980;
    8'h53 :
    data_out <= 16'h7C00;//////
    8'h54 :
    data_out <= 16'h7D00;///////
    8'h55 :
    data_out <= 16'h7C03;////////
    8'h56 :
    data_out <= 16'h7D48;/////////
    8'h57 :
    data_out <= 16'h7D48;/////////
    8'h58 :
    data_out <= 16'h7C08;////////
    8'h59 :
    data_out <= 16'h7D20;
    8'h5A :
    data_out <= 16'h7D10;
    8'h5B :
    data_out <= 16'h7D0E;
    8'h5C :
    data_out <= 16'h9000;
    8'h5D :
    data_out <= 16'h910E;
    8'h5E :
    data_out <= 16'h911A;
    8'h5F :
    data_out <= 16'h9131;
    8'h60 :
    data_out <= 16'h915A;
    8'h61 :
    data_out <= 16'h9169;
    8'h62 :
    data_out <= 16'h9175;
    8'h63 :
    data_out <= 16'h917E;
    8'h64 :
    data_out <= 16'h9188;
    8'h65 :
    data_out <= 16'h918F;
    8'h66 :
    data_out <= 16'h9196;
    8'h67 :
    data_out <= 16'h91A3;
    8'h68 :
    data_out <= 16'h91AF;
    8'h69 :
    data_out <= 16'h91C4;
    8'h6A :
    data_out <= 16'h91D7;
    8'h6B :
    data_out <= 16'h91E8;
    8'h6C :
    data_out <= 16'h9120;
    8'h6D :
    data_out <= 16'h9200;
    8'h6E :
    data_out <= 16'h9306;
    8'h6F :
    data_out <= 16'h93E3;
    8'h70 :
    data_out <= 16'h9305;
    8'h71 :
    data_out <= 16'h9305;
    8'h72 :
    data_out <= 16'h9300;
    8'h73 :
    data_out <= 16'h9304;
    8'h74 :
    data_out <= 16'h9300;
    8'h75 :
    data_out <= 16'h9300;
    8'h76 :
    data_out <= 16'h9300;
    8'h77 :
    data_out <= 16'h9300;
    8'h78 :
    data_out <= 16'h9300;
    8'h79 :
    data_out <= 16'h9300;
    8'h7A :
    data_out <= 16'h9300;

    8'h7B :
    data_out <= 16'h9600;
    8'h7C :
    data_out <= 16'h9708;
    8'h7D :
    data_out <= 16'h9719;
    8'h7E :
    data_out <= 16'h9702;
    8'h7F :
    data_out <= 16'h970C;
    8'h80 :
    data_out <= 16'h9724;
    8'h81 :
    data_out <= 16'h9730;
    8'h82 :
    data_out <= 16'h9728;
    8'h83 :
    data_out <= 16'h9726;
    8'h84 :
    data_out <= 16'h9702;
    8'h85 :
    data_out <= 16'h9798;
    8'h86 :
    data_out <= 16'h9780;
    8'h87 :
    data_out <= 16'h9700;
    8'h88 :
    data_out <= 16'h9700;
    8'h89 :
    data_out <= 16'hC3FD; // from C3ED to C3FD
    8'h8A :
    data_out <= 16'hA400;
    8'h8B :
    data_out <= 16'hA800;///////
    8'h8C :
    data_out <= 16'hC511;////////
    8'h8D :
    data_out <= 16'hC651;/////////
    8'h8E :
    data_out <= 16'hBF80;/////////
    8'h8F :
    data_out <= 16'hC710;////////
    8'h90 :
    data_out <= 16'hB666;
    8'h91 :
    data_out <= 16'hB8A5;
    8'h92 :
    data_out <= 16'hB764;
    8'h93 :
    data_out <= 16'hB97C;
    8'h94 :
    data_out <= 16'hB3AF;
    8'h95 :
    data_out <= 16'hB497;
    8'h96 :
    data_out <= 16'hB5FF;
    8'h97 :
    data_out <= 16'hB0C5;
    8'h98 :
    data_out <= 16'hB194;
    8'h99 :
    data_out <= 16'hB20F;
    8'h9A :
    data_out <= 16'hC45C;
    8'h9B :
    data_out <= 16'hC050;
    8'h9C :
    data_out <= 16'hC13C;
    8'h9D :
    data_out <= 16'h8C00;
    8'h9E :
    data_out <= 16'h863D;
    8'h9F :
    data_out <= 16'h5000;
    8'hA0 :
    data_out <= 16'h51A0;
    8'hA1 :
    data_out <= 16'h5278;
    8'hA2 :
    data_out <= 16'h5300;
    8'hA3 :
    data_out <= 16'h5400;
    8'hA4 :
    data_out <= 16'h5500;
    8'hA5 :
    data_out <= 16'h5AA0;
    8'hA6 :
    data_out <= 16'h5B78;
    8'hA7 :
    data_out <= 16'h5C00;
    8'hA8 :
    data_out <= 16'hD382;
    8'hA9 :
    data_out <= 16'hC3FD; // from ED to FD
    8'hAA :
    data_out <= 16'h7F00;
    8'hAB :
    data_out <= 16'hDA08;
    8'hAC :
    data_out <= 16'hE51F;
    8'hAD :
    data_out <= 16'hE177; //from 67 to 77
    8'hAE :
    data_out <= 16'hE000;
    8'hAF :
    data_out <= 16'hDD7F;
    8'hB0 :
    data_out <= 16'h0500;
    endcase
endmodule                     
                        
                        
     */                   
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        