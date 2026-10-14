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
endmodule


             
                        
     
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
