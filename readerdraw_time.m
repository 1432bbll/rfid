function readerdraw_time(starttime,endtime,kind,fig)
%DRAW_TIME 此处显示有关此函数的摘要
%   此处显示详细说明
figure(fig);
hold on;
% 绘制水平线段
switch kind
    case 1
        line([starttime,endtime], [0, 0], 'Color', 'b', 'LineWidth', 5);
    case 2
        line([starttime,endtime], [0, 0], 'Color', 'y', 'LineWidth', 5);
    case 3
        line([starttime,endtime], [0, 0], 'Color', 'm', 'LineWidth', 5);
    case 4
        line([starttime,endtime], [0, 0], 'Color', 'c', 'LineWidth', 5);
    case 5
        line([starttime,endtime], [0, 0], 'Color', 'r', 'LineWidth', 5);
end
% 计算线段中点位置
mid_x = mean([starttime,endtime]);
mid_y = 0;

% 添加标注，这里以显示y值为例
switch kind
    case 1
        text(mid_x, mid_y, "Query", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    case 2
        text(mid_x, mid_y, "QueryAdjust", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    case 3
        text(mid_x, mid_y, "Rep", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    case 4
        text(mid_x, mid_y, "ACK", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    case 5
        text(mid_x, mid_y, "NAK", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
hold on;
end