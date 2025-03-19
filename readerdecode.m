function [signalkind,signalvalue] = readerdecode(signal_bin)
% DECODE 此处显示有关此函数的摘要
%   阅读器解码器
signalkind = [];
signalvalue = [];
% disp("??");
disp(strlength(signal_bin));
switch strlength(signal_bin)
    case 4
        signalkind(1) = 3;
        signalvalue(1) = 0;
    case 18
        signalkind(1) = 4;
        signalvalue(1) = bitand(bin2dec(char(signal_bin)),2^16-1);
    case 22
        signalkind(1) = 1;
        signalvalue(1) = bitand(bin2dec(char(signal_bin)),2^4-1);
    case 9
        signalkind(1) = 2;
        signalvalue(1) = bitand(bin2dec(char(signal_bin)),2^4-1);
    otherwise
        signalkind = [];
        signalvalue = [];

end
end