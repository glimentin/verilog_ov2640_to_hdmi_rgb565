module cmos_8_16bit
(
	input 		      	rst		,
	input 		      	pclk	,
	input 		[7:0] 	pdata_i	,
	input 		      	de_i	,
	output reg	[15:0]	pdata_o	,
	output reg		    de_o
);

reg	[7:0] pdata_i_d0;
reg		  de_d1;
reg hcnt;

always@(posedge pclk)	//Latch
begin
	pdata_i_d0 <= pdata_i;
	de_d1 <= de_i;
end

always@(posedge pclk)	//
begin
	if(de_i & !de_d1)
		hcnt <= 1;
	else
		hcnt <= ~hcnt ;

end

always@(posedge pclk or posedge rst)
begin
	if(rst)
		de_o <= 1'b0;
	else if(de_i && de_d1 && hcnt)//(de_i && hcnt)
		de_o <= 1'b1;
	else
		de_o <= 1'b0;
end

always@(posedge pclk or posedge rst)
begin
	if(rst)
		pdata_o <= 16'd0;
	else if(de_i && de_d1 && hcnt)//(de_i && hcnt)
		pdata_o <= { pdata_i_d0, pdata_i};
	else
		pdata_o <= pdata_o;
end

endmodule 