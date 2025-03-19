function [signal_bin] = tagencode(signalkind,signalvalue,tmpsignal_bin)
%ENCODE 此处显示有关此函数的摘要
%   标签编码器
s="";
switch signalkind
    case 6
        signal_bin = s+tmpsignal_bin+dec2bin(signalvalue,16);
    case 7
        signal_bin = s+tmpsignal_bin+dec2bin(signalvalue,21);
end

end