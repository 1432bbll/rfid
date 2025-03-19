function [signalkind,signalvalue] = tagdecode(signal_bin)
% DECODE 此处显示有关此函数的摘要
%   标签解码器
signalkind = [];
signalvalue = [];
% disp("??");
% disp(signal_bin);
switch strlength(signal_bin)
    case 0
        signalkind = [];
        signalvalue = [];
    case 21
        signalkind(1) = 7;
        signalvalue(1) = bin2dec(signal_bin);
    case 16
        signalkind(1) = 6;
        signalvalue(1) = bin2dec(signal_bin);
    otherwise
         signalkind(1) = 8;
         signalvalue(1) = 0;
end
