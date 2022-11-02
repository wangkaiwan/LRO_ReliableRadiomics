function delta_T = fun_TimeMinus(RST,ST,AcquisitionDate)

secondT = datenum(2007,11,16,05,21,01)-datenum(2007,11,16,05,21,00);

YY = str2num(AcquisitionDate(1:4));
MM = str2num(AcquisitionDate(5:6));
DD = str2num(AcquisitionDate(7:8));

H_rst = str2num(RST(1:2));
M_rst = str2num(RST(3:4));
S_rst = str2num(RST(5:6));

H_st = str2num(ST(1:2));
M_st = str2num(ST(3:4));
S_st = str2num(ST(5:6));

delta_T = (datenum(YY,MM,DD,H_st,M_st,S_st)-datenum(YY,MM,DD,H_rst,M_rst,S_rst))/secondT;

