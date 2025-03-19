% function [signal_bin] = encode(signalkind,signalvalue)
% %ENCODE 此处显示有关此函数的摘要
% %   编码器
% signal_bin = string([]);
% for i = 1 : length(signalkind)
%     switch signalkind(i)
%         case 1
% 
%             a = "100010001000100011";
%             b = dec2bin(signalvalue(i),4);
%             signal_bin(i) = a + b;
%         case 2
%             a = "10010";
%             b = dec2bin(signalvalue(i),4);
%             signal_bin(i) = a + b;
% 
%         case 3
%             signal_bin(i) = "0000";
%         case 4
%             a = "01";
%             b = dec2bin(signalvalue(i),16);
%             signal_bin(i) = a + b;
%         case 6
%             signal_bin(i) = dec2bin(signalvalue(i),16);
%         case 7
%             signal_bin(i) = dec2bin(signalvalue(i),21);
%     end
% end
% end

% function [signal_bin] = encode(signalkind,signalvalue)
% %ENCODE 此处显示有关此函数的摘要
% %   编码器
% % 初始化 signal_bin 为单元数组
% signal_bin = cell(1, length(signalkind));
% for i = 1 : length(signalkind)
%     switch signalkind(i)
%         case 1
%             a = '100010001000100011';
%             b = dec2bin(signalvalue(i),4);
%             % 使用花括号进行单元数组赋值
%             signal_bin{i} = [a b];
%         case 2
%             signal_bin{i} = '100100000';
%         case 3
%             signal_bin{i} = '0000';
%         case 4
%             a = '01';
%             b = dec2bin(signalvalue(i),16);
%             signal_bin{i} = [a b];
%         case 6
%             signal_bin{i} = dec2bin(signalvalue(i),16);
%         case 7
%             signal_bin{i} = dec2bin(signalvalue(i),21);
%     end
% end
% end

function [signal_bin] = encode(signalkind,signalvalue)
%ENCODE 此处显示有关此函数的摘要
%   阅读器编码器

switch signalkind(1)
    case 1

        a = "100010001000100011";
        b = dec2bin(signalvalue(1),4);
        signal_bin = a + b;
    case 2
        a = "10010";
        b = dec2bin(signalvalue(1),4);
        signal_bin = a + b;

    case 3
        signal_bin = "0000";
    case 4
        a = "01";
        b = dec2bin(signalvalue(1),16);
        signal_bin = a + b;

end

end
