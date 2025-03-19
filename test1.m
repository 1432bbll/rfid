% 从工作区获取图形句柄
fig = evalin('base', 'fig_handle');

% 激活该图形窗口
figure(fig);

% 在同一图形窗口中继续绘制其他图形
x = linspace(0, 2*pi, 100);
y = cos(x);
hold on; % 保持当前图形，以便后续绘图不会覆盖之前的图形
plot(x, y, 'r', 'DisplayName', 'cos(x)');
hold off;
legend;