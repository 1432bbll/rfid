%%
clear;
clc;

%%
%环境初始化
readerPosition = [2, 2, 1.5];
numTags = 6;
TagPositions = [9, 7, 1; ...
    4, 4, 1; ...
    1, 1, 1; ...
    3, 3, 1; ...
    4, 2, 1; ...
    6, 7, 1];    
fig = figure;
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
readerbin = "";
tagbin = "";
%阅读器和标签初始化

T = tag.empty(0, numTags);  % Pre-allocate array for tags
routes = route.empty(0, numTags);  % Pre-allocate array for routes

for i = 1:numTags
    routes(i) = route(readerPosition, TagPositions(i,:), 30);
    T(i) = tag("tag"+num2str(i), 1000+i, i, fig,routes(i));
    
    % T(i).set_routes(routes(i));
end
R1 = reader("reader", fig,routes);

%定时器初始化
t = timer;
t.TimerFcn = {@slotted_aloha};
t.Period = 0.1;
t.StartDelay = 1; 
t.TasksToExecute = 15;
t.ExecutionMode = 'fixedRate';
title('时序图');
xlabel('时间');
ylabel('序号');
set(gca,"YTick",0:1:7)
yticklabels(["reader","tag1","tag2","tag3","tag4","tag5","tag6"]);
grid on;
hold on;

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
    tmptagbin = "";
    disp(readerbin);
    tmptime = 0;
    for i = 1:length(T)
        [T(i),readerbin,tagbin,ttime]=T(i).listen(readerbin,tmptagbin,mytime);
        tmptime = max(tmptime,ttime);
        tmptagbin =tagbin;
    end
   
    mytime = mytime + tmptime;

    
    tmpreaderbin = string([]);
    [R1,tagbin,readerbin,rtime]=R1.listen(tagbin,tmpreaderbin,mytime);
    tmptime = 2.5 + rtime;
    
    disp(mytime);
    disp(readerbin);
    disp("!!!!");
    disp(length(readerbin));
    disp("1254");
    mytime = mytime + tmptime;
    disp("jjjj");
end
start(t);

hold off;

