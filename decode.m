function [signalkind,signalvalue] = decode(signal_bin)
%DECODE 此处显示有关此函数的摘要
%   解码器
signalkind = [];
signalvalue = [];
% disp("??");
% disp(signal_bin);
for i = 1 : length(signal_bin)
    switch strlength(signal_bin(i))
        case 4
            signalkind(i) = 3;
            signalvalue(i) = 0;
        case 18
            signalkind(i) = 4;
            signalvalue(i) = bitand(bin2dec(char(signal_bin(i))),2^16-1);
        case 22
            signalkind(i) = 1;
            signalvalue(i) = bitand(bin2dec(char(signal_bin(i))),2^4-1);
        case 9
            signalkind(i) = 2;
            signalvalue(i) = bitand(bin2dec(char(signal_bin(i))),2^4-1);
        case 21
            signalkind(i) = 7;
            signalvalue(i) = bin2dec(signal_bin(i));
        case 16
            signalkind(i) = 6;
            signalvalue(i) = bin2dec(signal_bin(i));
    end
end
end
