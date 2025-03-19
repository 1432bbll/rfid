% % 初始化动画
% figure;
% h = animatedline('Color', 'r', 'LineWidth', 2);
% axis([0 10 -1 1]);
% xlabel('时间');
% ylabel('位置');
% title('对象实时运动轨迹');
% 
% % 模拟数据更新
% for t = 0:0.1:10
%     y = sin(t); % 对象位置
%     addpoints(h, t, y);
%     drawnow;
%     pause(0.05); % 控制动画速度
% end

% % 示例数据
% x = 1:10;
% y = [1 3 2 4 3 5 4 6 5 7];
% 
% % 循环绘制每一段水平线段并添加标注
% hold on;
% for i = 1:length(x) - 1
%     % 绘制水平线段
%     line([x(i), x(i + 1)], [y(i), y(i)], 'Color', 'b', 'LineWidth', 3);
% 
%     % 计算线段中点位置
%     mid_x = mean([x(i), x(i + 1)]);
%     mid_y = y(i);
% 
%     % 添加标注，这里以显示y值为例
%     text(mid_x, mid_y, num2str(y(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
% end
% 
% % 设置图形属性
% title('隐藏竖线的阶梯图并添加标注');
% xlabel('X轴');
% ylabel('Y轴');
% grid on;
% hold off;



% % 第一次绘图：绘制折线图
% x1 = 1:10;
% y1 = sin(x1);
% plot(x1, y1, 'b-', 'LineWidth', 2); % 绘制蓝色折线
% 
% % 保持当前图形，以便后续绘图不覆盖
% hold on;
% 
% % 第二次绘图：绘制散点图
% x2 = 1:0.5:10;
% y2 = cos(x2);
% scatter(x2, y2, 'r', 'filled'); % 绘制红色实心散点
% 
% % 设置图形属性
% title('分两次绘制的组合图');
% xlabel('X轴');
% ylabel('Y轴');
% legend('正弦曲线', '余弦散点');
% grid on;
% 
% % 关闭图形保持模式
% hold off;



% % 创建一个图形窗口，并记录其句柄
% fig = figure;
% 
% % 绘制一些初始图形
% xlabel('x');
% ylabel('y');
% title('Combined Plot');
% legend;
% 
% % 保存图形句柄到工作区，以便第二个文件可以使用
% assignin('base', 'fig_handle', fig);

% 创建图形窗口并获取句柄
fig = figure;

% 在主脚本中进行初始绘制
% x = linspace(0, 2*pi, 100);
% y = sin(x);
% plot(x, y, 'b', 'DisplayName', 'sin(x)');
xlabel('x');
ylabel('y');
title('Combined Plot');
legend;


% 调用类方法进行额外绘制
plot_obj = PlotClass(fig);
plot_obj.add_plot();

