%%
clear;
clc;

%%
%环境初始化
readerPosition = [2 2 1.5];
numTags = 6;
TagPositions = [9 7 1; ...
    4 4 1; ...
    1 1 1; ...
    3 3 1; ...
    4 2 1];    
global readerkind;
global readervalue;
global tagkind;
global tagvalue;
global R1;
global T;
global mytime;
global tagbin;
global readerbin;

mytime = 0;
readerkind = [];
readervalue = [];
tagkind = [];
tagvalue = [];
readerbin =string([]);
tagbin = string([]);
%%

%阅读器和标签初始化
R1 = reader("reader");
for i = 1:numTags
    G(i)=tag("tag"+num2str(i),1000+i,i);
end
T=G;
%定时器初始化
t = timer;
t.TimerFcn = {@slotted_aloha};
t.Period = 0.1;
t.StartDelay = 1; 
t.TasksToExecute = 50;
t.ExecutionMode = 'fixedRate';
% global a;
% a=1;
% disp("!!!");


% function [readerkind,readervalue] = slotted_aloha(~,~)
%     %signal = zeros(5);
%     global readerkind;
%     global readervalue;
%     global tagkind;
%     global tagvalue;
%     global R1;
%     global T;
%     global mytime;
%     global tagbin;
%     global readerbin;
%     tagsignalkind = [];
%     tagsignalvalue = [];
%     tagsignalnum = [];
%     readersignalkind = readerkind;
%     readersignalvalue = readervalue;
%     % disp("::readersignal");
%     % disp(readerkind);
%     % disp(readervalue);
%     % disp("::");
%     for i = 1:length(T)
%         [T(i),readerkind,readervalue,tagkind,tagvalue]=T(i).listen(readersignalkind,readersignalvalue,tagsignalkind,tagsignalvalue);
%         tagsignalkind =tagkind;
%         tagsignalvalue = tagvalue;
%     end
%     % % % 绘制水平线段
%     % hold on;
%     % for i = 1:length(tagkind)
%     %     %disp(2)
%     %     mid_y = 0;
%     %     switch mod(tagvalue(i),10)
%     % 
%     %         case 1
%     %             line([mytime, mytime+1], [1, 1], 'Color', 'r', 'LineWidth', 5);
%     % 
%     %             % 计算线段中点位置
%     %             mid_x = mean([mytime, mytime+1]);
%     %             mid_y = 1;
%     %         case 2
%     %             line([mytime, mytime+1], [2, 2], 'Color', 'g', 'LineWidth', 5);
%     % 
%     %             % 计算线段中点位置
%     %             mid_x = mean([mytime, mytime+1]);
%     %             mid_y = 2;
%     %         case 3
%     %             line([mytime, mytime+1], [3, 3], 'Color', 'y', 'LineWidth', 5);
%     % 
%     %             % 计算线段中点位置
%     %             mid_x = mean([mytime, mytime+1]);
%     %             mid_y = 3;
%     %         case 4
%     %             line([mytime, mytime+1], [4, 4], 'Color', 'k', 'LineWidth', 5);
%     % 
%     %             % 计算线段中点位置
%     %             mid_x = mean([mytime, mytime+1]);
%     %             mid_y = 4;
%     %         case 5
%     %             line([mytime, mytime+1], [5, 5], 'Color', 'c', 'LineWidth', 5);
%     % 
%     %             % 计算线段中点位置
%     %             mid_x = mean([mytime, mytime+1]);
%     %             mid_y = 5;
%     %         case 6
%     %             line([mytime, mytime+1], [6, 6], 'Color', 'm', 'LineWidth', 5);
%     % 
%     %             % 计算线段中点位置
%     %             mid_x = mean([mytime, mytime+1]);
%     %             mid_y = 6;
%     % 
%     %     end
%     %     text(mid_x, mid_y, num2str(tagkind(i))+":"+num2str(tagvalue(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
%     %     hold on;
%     % end
%     mytime = mytime + 1;
%     % disp("!!tagsignal");
%     % disp(tagkind);
%     % disp(tagvalue);
%     % disp("!!");
%     tagsignalkind =tagkind;
%     tagsignalvalue = tagvalue;
%     readersignalkind = [];
%     readersignalvalue = [];
%     [R1,tagkind,tagvalue,readerkind,readervalue]=R1.listen(tagsignalkind,tagsignalvalue,readersignalkind,readersignalvalue);
%     % for tag = Ts
%     %     tag.sent(signal);
%     % end
%     % disp(mytime);
%     % 
%     % 
%     % % % 绘制水平线段
%     % line([mytime, mytime+1], [0, 0], 'Color', 'b', 'LineWidth', 5);
%     % 
%     % % 计算线段中点位置
%     % mid_x = mean([mytime, mytime+1]);
%     % mid_y = 0;
%     % 
%     % % 添加标注，这里以显示y值为例
%     % switch readerkind(1)
%     %     case 1
%     %         text(mid_x, mid_y, "Query", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
%     %     case 2
%     %         text(mid_x, mid_y, "QueryAdjust", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
%     %     case 3
%     %         text(mid_x, mid_y, "Rep", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
%     %     case 4
%     %         text(mid_x, mid_y, "ACK", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
%     %     case 5
%     %         text(mid_x, mid_y, "NAK", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
%     % end
%     % hold on;
%     mytime = mytime + 1;
% 
% end

function [readerbin] = slotted_aloha(~,~)
    %signal = zeros(5);
    disp(1);
    global readerkind;
    global readervalue;
    global tagkind;
    global tagvalue;
    global R1;
    global T;
    global mytime;
    global tagbin;
    global readerbin;
    % tagsignalkind = [];
    % tagsignalvalue = [];
    % tagsignalnum = [];
    % readersignalkind = readerkind;
    % readersignalvalue = readervalue;
    % disp("::readersignal");
    % disp(readerkind);
    % disp(readervalue);
    % disp("::");
    % for i = 1:length(T)
    %     [T(i),readerkind,readervalue,tagkind,tagvalue]=T(i).listen(readersignalkind,readersignalvalue,tagsignalkind,tagsignalvalue);
    %     tagsignalkind =tagkind;
    %     tagsignalvalue = tagvalue;
    % end
    tmptagbin = string([]);
    disp(readerbin);
    for i = 1:length(T)
        [T(i),readerbin,tagbin]=T(i).listen(readerbin,tmptagbin);
        tmptagbin =tagbin;
    end
    disp("::::");
    hold on;
    [tagkind,tagvalue] = decode(tagbin);
    for i = 1:length(tagkind)
        %disp(2)
        mid_y = 0;
        switch mod(tagvalue(i),10)

            case 1
                line([mytime, mytime+1], [1, 1], 'Color', 'r', 'LineWidth', 5);

                % 计算线段中点位置
                mid_x = mean([mytime, mytime+1]);
                mid_y = 1;
            case 2
                line([mytime, mytime+1], [2, 2], 'Color', 'g', 'LineWidth', 5);

                % 计算线段中点位置
                mid_x = mean([mytime, mytime+1]);
                mid_y = 2;
            case 3
                line([mytime, mytime+1], [3, 3], 'Color', 'y', 'LineWidth', 5);

                % 计算线段中点位置
                mid_x = mean([mytime, mytime+1]);
                mid_y = 3;
            case 4
                line([mytime, mytime+1], [4, 4], 'Color', 'k', 'LineWidth', 5);

                % 计算线段中点位置
                mid_x = mean([mytime, mytime+1]);
                mid_y = 4;
            case 5
                line([mytime, mytime+1], [5, 5], 'Color', 'c', 'LineWidth', 5);

                % 计算线段中点位置
                mid_x = mean([mytime, mytime+1]);
                mid_y = 5;
            case 6
                line([mytime, mytime+1], [6, 6], 'Color', 'm', 'LineWidth', 5);

                % 计算线段中点位置
                mid_x = mean([mytime, mytime+1]);
                mid_y = 6;

        end
        text(mid_x, mid_y, num2str(tagkind(i))+":"+num2str(tagvalue(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        hold on;
    end
    mytime = mytime + 1;
    % disp("!!tagsignal");
    % disp(tagkind);
    % disp(tagvalue);
    % disp("!!");
    % tagsignalkind =tagkind;
    % tagsignalvalue = tagvalue;
    % readersignalkind = [];
    % readersignalvalue = [];
    % [R1,tagkind,tagvalue,readerkind,readervalue]=R1.listen(tagsignalkind,tagsignalvalue,readersignalkind,readersignalvalue);
    tmpreaderbin = string([]);
    [R1,tagbin,readerbin]=R1.listen(tagbin,tmpreaderbin);
    % for tag = Ts
    %     tag.sent(signal);
    % end
    disp(mytime);
    disp(readerbin);
    disp("!!!!");
    disp(length(readerbin));
    disp(strlength(readerbin(1)));
    [readerkind,readervalue] = decode(readerbin);
    disp("1254");
    disp(readerkind);
    disp(readervalue);

    % % 绘制水平线段
    % line([mytime, mytime+1], [0, 0], 'Color', 'b', 'LineWidth', 5);
    switch readerkind(1)
        case 1
            line([mytime, mytime+1], [0, 0], 'Color', 'b', 'LineWidth', 5);
        case 2
            line([mytime, mytime+1], [0, 0], 'Color', 'y', 'LineWidth', 5);
        case 3
            line([mytime, mytime+1], [0, 0], 'Color', 'm', 'LineWidth', 5);
        case 4
            line([mytime, mytime+1], [0, 0], 'Color', 'c', 'LineWidth', 5);
        case 5
            line([mytime, mytime+1], [0, 0], 'Color', 'r', 'LineWidth', 5);
    end
    % 计算线段中点位置
    mid_x = mean([mytime, mytime+1]);
    mid_y = 0;

    % 添加标注，这里以显示y值为例
    switch readerkind(1)
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
    mytime = mytime + 1;
    disp("jjjj");
end
start(t);

% stop(t);
title('时序图');
xlabel('X轴');
ylabel('Y轴');
set(gca,"YTick",0:1:7)
yticklabels(["reader","tag1","tag2","tag3","tag4","tag5","tag6"]);
grid on;
hold off;

%stop(t);
% disp("5548");
% disp(R1.num);