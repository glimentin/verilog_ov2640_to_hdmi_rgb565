module rgb_to_hsv(
    input clk,
    input rst,

    input [4:0] r,
    input [5:0] g,
    input [4:0] b,
    output reg [7:0] h,
    output reg [7:0] s,
    output [5:0] v,

    input I_valid,
    output O_valid,

    input I_vsync,
    output O_vsync
   
  );

reg [5:0] r1,g1,b1;
reg [5:0] max, min;
reg [5:0] delta;

reg [13:0] h_tmp;
reg [13:0] h_top_d, h_top_q, s_top_d, s_top_q;
reg [8:0] s_bottom_d, s_bottom_q, h_bottom_d, h_bottom_q;
wire [15:0] h_div, s_div;

reg [1:0] h_add;
wire [1:0] h_add_delay;
reg [7:0] h_add_tmp;

reg h_neg;
wire h_neg_delay;

hsv_div h_divider (
    .clk(clk), // input clk
    .dividend(h_top_q), // input [13 : 0] dividend
    .divisor(h_bottom_q), // input [8 : 0] divisor
    .quotient(h_div), // output [13 : 0] quotient
    .fractional() // output [1 : 0] fractional
);

hsv_div s_divider (
    .clk(clk), // input clk
    .dividend(s_top_q), // input [13 : 0] dividend
    .divisor(s_bottom_q), // input [8 : 0] divisor
    .quotient(s_div), // output [13 : 0] quotient
    .fractional() // output [1 : 0] fractional
);

//=================================================
//delays on 19 tacts
pipeline #(.LENGTH(19), .WIDTH(6+2+1+1)) v_pipe (
    .clk(clk),
    .rst(rst),
    .enable(1'b1),
    .in({max,h_add,h_neg,I_valid}),
    .out({v,h_add_delay,h_neg_delay,O_valid})
);

pipeline #(.LENGTH(19), .WIDTH(1)) vsync_pipe (
    .clk(clk),
    .rst(rst),
    .enable(1'b1),
    .in(I_vsync),
    .out(O_vsync)    
);

  always @* begin
    max = 6'd0;
    h_add = 2'd0;
    h_top_d = h_top_q;
    h_bottom_d = h_bottom_q;
    s_top_d = s_top_q;
    s_bottom_d = s_bottom_q;
    h = 8'bx;
    s = 6'bx;
    h_neg = 1'bx;

    if (I_valid) begin
      r1 = {r,r[4]};
      g1 = g;
      b1 = {b,b[4]};

      max = r1 > g1 ? (b1 > r1 ? b1 : r1) : (b1 > g1 ? b1 : g1);
      min = r1 < g1 ? (b1 < r1 ? b1 : r1) : (b1 < g1 ? b1 : g1);

      delta = max - min;

      s_top_d = {delta, 8'b0} - delta; // x255
      s_bottom_d = max > 0 ? max : 9'd1; 

      h_bottom_d = delta > 6'd0 ? delta * 6'd6 : 9'd6;
      if (r1 == max) begin
        h_tmp = (g1 >= b1 ? (g1 - b1) : (b1 - g1));
        h_neg = g1 >= b1 ? 1'b0 : 1'b1;
        h_add = 2'd0;
      end else if (g1 == max) begin
        h_tmp = (b1 >= r1 ? (b1 - r1) : (r1 - b1));
        h_neg = b1 >= r1 ? 1'b0 : 1'b1;
        h_add = 2'd1;
      end else begin
        h_tmp = (r1 >= g1 ? (r1 - g1) : (g1 - r1));
        h_neg = r1 >= g1 ? 1'b0 : 1'b1;
        h_add = 2'd2;
      end
      h_top_d = {h_tmp, 8'b0} - h_tmp; // x255
    end

    if (O_valid) begin
      h_add_tmp = {h_add_delay, 6'b0} + h_add_delay; // x65
      if (h_neg_delay && h_div > h_add_tmp) begin
        h = 8'd255 - h_div + h_add_tmp;
      end else if (h_neg_delay) begin
        h = h_add_tmp - h_div;
      end else begin
        h = h_div + h_add_tmp;
      end
      s = s_div[7:0];
    end

  end

  always @(posedge clk) begin
    h_top_q <= h_top_d;
    h_bottom_q <= h_bottom_d;
    s_top_q <= s_top_d;
    s_bottom_q <= s_bottom_d;
  end

endmodule

//==========================

module pipeline #(
  parameter LENGTH = 1,
  parameter WIDTH = 1
)(
  input clk,
  input rst,
  input enable,
  input [WIDTH-1:0] in,
  output [WIDTH-1:0] out
);

reg [WIDTH-1:0] pipe_d [LENGTH-1:0];
reg [WIDTH-1:0] pipe_q [LENGTH-1:0];

integer i;

assign out = pipe_q[LENGTH-1];

always @(*) begin
  if (enable)
    pipe_d[0] = in;
  else 
    pipe_d[0] = pipe_q[0];
    
  for (i = 1; i < LENGTH; i = i + 1) begin
    if (enable)
      pipe_d[i] = pipe_q[i-1];
    else
      pipe_d[i] = pipe_q[i];
  end
end

always @(posedge clk) begin
  for (i = 0; i < LENGTH; i = i + 1) begin
    if (rst) 
      pipe_q[i] <= 1'd0;
    else
      pipe_q[i] <= pipe_d[i];
  end
end

endmodule

//=======================================

module hsv_div (
    input  wire        clk,
    input  wire [13:0] dividend,
    input  wire [8:0]  divisor,
    output reg  [13:0] quotient,
    output reg  [1:0]  fractional
);

    wire [15:0] scaled = (divisor == 0) ? 16'd0 : ({dividend, 2'b00} / divisor);
    wire [13:0] q_now  = scaled[15:2];   // целая часть
    wire [1:0]  f_now  = scaled[1:0];    // 2 дробных бита

    reg [13:0] q_pipe [0:16];
    reg [1:0]  f_pipe [0:16];
    integer i;

    always @(posedge clk) begin
        q_pipe[0] <= q_now;
        f_pipe[0] <= f_now;
        for (i = 1; i < 17; i = i + 1) begin
            q_pipe[i] <= q_pipe[i-1];
            f_pipe[i] <= f_pipe[i-1];
        end
        quotient   <= q_pipe[16];
        fractional <= f_pipe[16];
    end
endmodule 