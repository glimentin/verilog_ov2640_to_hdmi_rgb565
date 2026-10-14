// ============================================================
//  red_filter.v
//  Фильтр красного цвета в пространстве HSV.
//
//  Структура тракта:  RGB -> HSV -> red_filter -> HDMI (HSV + filter)
//
//  Входы HSV (уже готовые сигналы из вашего HSV-модуля):
//    h_data [7:0] - тон (Hue), 0..255  =>  0..360 градусов
//    s_data [7:0] - насыщенность (Saturation), 0..255
//    v_data [5:0] - яркость (Value), 0..63
//
//  Красный цвет в HSV:
//    Hue ~ 0   (например 0..20)  ИЛИ  Hue ~ 255 (например 235..255)
//          (из-за того что цветовой круг закольцован, красный "с двух сторон")
//    Sat высокая (> S_MIN)  - иначе это белый / серый / бледный
//    Val высокая (> V_MIN)  - иначе это чёрный
// ============================================================

module red_filter #(
    parameter [7:0] H_LOW_MAX  = 8'd20,   // верхняя граница "низкого" красного Hue
    parameter [7:0] H_HIGH_MIN = 8'd235,  // нижняя граница "высокого" красного Hue
    parameter [7:0] S_MIN      = 8'd100,  // минимальная насыщенность
    parameter [5:0] V_MIN      = 6'd30    // минимальная яркость
)(
    input  wire       clk,      // пиксельный клок
    input  wire       rst_n,    // асинхронный сброс (активный 0)
    input  wire       de,       // data enable, синхронен с пикселем
    input  wire [7:0] h_data,
    input  wire [7:0] s_data,
    input  wire [5:0] v_data,

    output reg        red,      // 1 - пиксель красный, 0 - нет
    output reg        red_de    // data enable, задержанный на 1 такт (синхронно с red)
);

    // ---- Комбинационная логика определения красного ----
    wire hue_low_red  = (h_data <= H_LOW_MAX);   // красный у 0 градусов
    wire hue_high_red = (h_data >= H_HIGH_MIN);  // красный у 360 градусов
    wire hue_red      = hue_low_red | hue_high_red;

    wire sat_ok       = (s_data >= S_MIN);       // достаточно насыщенный
    wire val_ok       = (v_data >= V_MIN);       // достаточно яркий

    wire red_comb     = hue_red & sat_ok & val_ok;

    // ---- Регистровый выход (чтобы не нарушать тайминги HDMI) ----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            red_de <= 1'b0;
        end else begin
            red    <= red_comb;
            red_de <= de;
        end
    end

endmodule
