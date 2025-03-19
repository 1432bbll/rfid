function tagdraw_time(starttime,endtime,num,value,fig,kind)
%DRAW_TIME 此处显示有关此函数的摘要
%   此处显示详细说明
figure(fig);
hold on;
mid_x = 0;
mid_y = 0;
switch num

    case 1
        line([starttime, endtime], [1, 1], 'Color', 'r', 'LineWidth', 5);

        % 计算线段中点位置
        mid_x = mean([starttime, endtime]);
        mid_y = 1;
    case 2
        line([starttime, endtime], [2, 2], 'Color', 'g', 'LineWidth', 5);

        % 计算线段中点位置
        mid_x = mean([starttime, endtime]);
        mid_y = 2;
    case 3
        line([starttime, endtime], [3, 3], 'Color', 'y', 'LineWidth', 5);

        % 计算线段中点位置
        mid_x = mean([starttime, endtime]);
        mid_y = 3;
    case 4
        line([starttime, endtime], [4, 4], 'Color', 'k', 'LineWidth', 5);

        % 计算线段中点位置
        mid_x = mean([starttime, endtime]);
        mid_y = 4;
    case 5
        line([starttime, endtime], [5, 5], 'Color', 'c', 'LineWidth', 5);

        % 计算线段中点位置
        mid_x = mean([starttime, endtime]);
        mid_y = 5;
    case 6
        line([starttime, endtime], [6, 6], 'Color', 'm', 'LineWidth', 5);

        % 计算线段中点位置
        mid_x = mean([starttime, endtime]);
        mid_y = 6;

end
switch kind
    case 6
        text(mid_x, mid_y, "RN16:"+num2str(value), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    case 7
        text(mid_x, mid_y, "EPC:"+num2str(value), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
hold on;
end

