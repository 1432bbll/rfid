% classdef tag
%     properties
%         num
%         name
%         state       %1:ready 2：arbitrate 3:reply 4:acknowledged 5:open 6:secured 7:killed
%         RN16_1
%         RN16_2
%         slot_counter
%         PC
%         EPC
%         CRC_16  
%         % inventoried_flag % 库存：A/B
%         % session         % 会话
%         % killpassword
%         % accesspassword
%         %RNG
%     end
% 
%     methods
%         %就绪状态 标签应实现就绪状态。就绪可以被视为既没有被杀死也没有当前参与库存循环的通电标签的“保持状态”。
%         %进入激励射频场后，未被杀死的标签应进入就绪状态。
%         %标签应保持就绪状态，直到它收到查询命令，其库存参数（针对查询中指定的会话）和 sel 参数与其当前标志值匹配。
%         %匹配标签应从其 RNG 中抽取一个 Q 位数字，将该数字加载到其时隙计数器中，如果数字非零，则转换到仲裁状态，如果数字为零，则转换到应答状态。
%         %如果处于除被杀死之外的任何状态的标签失去电源，则在重新获得电源后应返回就绪状态。
% 
%         %仲裁状态 标签应实现仲裁状态。
%         %仲裁可以被视为参与当前盘存回合但其槽计数器保持非零值的标签的“保持状态”。
%         %仲裁中的标签应在每次收到 QueryRep 命令时递减其时隙计数器，该命令的会话参数与当前正在进行的盘点轮次的会话相匹配，并且当其时隙计数器达到 0000h。
%         %返回到仲裁（例如，从答复状态）且槽值为 0000h 的标签应在下一个 QueryRep（具有匹配会话）时将其槽计数器从 0000h 递减至 7FFFh，并且由于其槽值现在非零，因此应保持不变在仲裁中。
% 
%         %回复状态 标签应实现回复状态。
%         %输入回复后，标签应反向散射 RN16。如果标签收到有效的确认，它应转换到确认状态，反向散射其 PC、EPC 和 CRC-16。
%         %如果标签未能接收到 ACK，或接收到无效的 ACK，则应返回仲裁。标签和询问器应满足表 6.13 中规定的所有时序要求。
% 
%         %确认状态 标签应实现确认状态。
%         %处于已确认状态的标签可以转换为除已杀死之外的任何状态，具体取决于收到的命令。
%         %标签和询问器应满足表 6.13 中规定的所有时序要求。      
% 
%         function obj = tag(new_name,epc,i)
%             %对标签命名
%             obj.name = new_name;
%             obj.EPC = epc;
%             obj.num = i;
%             obj.state = tagstate.ready;
%         end
% 
%         function [obj,signalkind,signalvalue,newsignalkind,newsignalvalue] = listen(obj,signalkind,signalvalue,newsignalkind,newsignalvalue)
%             %收听信号
%             disp(1);
% 
%             if isempty(signalkind)==0
%                 disp(obj.name + " reflect " + signalkind+" slot:"+num2str(obj.slot_counter)+" state:"+ string(obj.state));
%                 switch obj.state
%                     case tagstate.ready
%                         switch signalkind(1)
%                             case 1
%                                 obj.RN16_1 = randi(2^16)-1;
%                                 obj.RN16_2 = dec2bin(obj.RN16_1,16);
%                                 obj.slot_counter = randi(2^signalvalue(1))-1;
%                                 if obj.slot_counter == 0
%                                     %backscatter new RN16
% 
%                                     newsignalkind(length(newsignalkind)+1) = 6;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.RN16_1*10 + obj.num;
%                                     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                     obj.state = tagstate.reply;
%                                     disp(obj.name + " change state to reply");
%                                 elseif obj.slot_counter > 0 
%                                     obj.state = tagstate.arbitrate;
%                                     disp(obj.name + " change state to arbitrate");
%                                 end
%                         end
%                     case tagstate.arbitrate
%                         switch signalkind(1)
%                             case 1
%                                 obj.slot_counter = randi(2^signalvalue(1))-1;
%                                 obj.RN16_1 = randi(2^16)-1;
%                                 obj.RN16_2 = dec2bin(obj.RN16_1,16);
%                                 if obj.slot_counter == 0
%                                     %backscatter new RN16
% 
%                                     newsignalkind(length(newsignalkind)+1) = 6;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.RN16_1*10 + obj.num;
%                                     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                     obj.state = tagstate.reply;
%                                     disp(obj.name + " change state to reply");
%                                 elseif obj.slot_counter > 0 
%                                     obj.state = tagstate.arbitrate;
%                                     disp(obj.name + " slot_counter : " + obj.slot_counter)
%                                 else 
%                                     obj.state = tagstate.ready;
%                                     disp(obj.name + " change state to ready");
%                                 end
%                             case 3
%                                 %obj.slot_counter = randi(2^signalvalue(1))-1;
%                                 obj.slot_counter = obj.slot_counter - 1;
%                                 if obj.slot_counter == 0
%                                     %backscatter new RN16
%                                     newsignalkind(length(newsignalkind)+1) = 6;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.RN16_1*10 + obj.num;
%                                     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                     obj.state = tagstate.reply;
%                                     disp(obj.name + " change state to reply");
%                                 elseif obj.slot_counter > 0 
% 
%                                     obj.state = tagstate.arbitrate;
%                                     disp(obj.name + " slot_counter : " + obj.slot_counter)
%                                 end
%                             case 2  
%                                 obj.slot_counter = randi(2^signalvalue(1)+1)-1;
%                                 if obj.slot_counter == 0
%                                     %backscatter new RN16
%                                     newsignalkind(length(newsignalkind)+1) = 6;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.RN16_1*10 + obj.num;
%                                     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                     obj.state = tagstate.reply;
%                                     disp(obj.name + " change state to reply");
%                                 elseif obj.slot_counter > 0 
%                                     obj.state = tagstate.arbitrate;
%                                     disp(obj.name + " slot_counter : " + obj.slot_counter)
%                                 end
%                         end 
%                     case tagstate.reply
%                         switch signalkind(1)
%                             case 1
%                                 obj.slot_counter = randi(2^signalvalue(1)+1)-1;
%                                 if obj.slot_counter == 0
%                                     %backscatter new RN16
%                                     obj.RN16_1 = randi(2^16)-1;
%                                     obj.RN16_2 = dec2bin(obj.RN16_1,16);
%                                     newsignalkind(length(newsignalkind)+1) = 6;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.RN16_1*10 + obj.num;
%                                     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                     obj.state = tagstate.reply;
%                                 elseif obj.slot_counter > 0 
%                                     obj.state = tagstate.arbitrate;
%                                     disp(obj.name + " slot_counter : " + obj.slot_counter)
%                                 else 
%                                     obj.state = tagstate.ready;
%                                 end
%                             case 2
%                                 obj.slot_counter = randi(signalvalue(1)+1)-1;
%                                 if obj.slot_counter == 0
%                                     %backscatter new RN16
%                                     newsignalkind(length(newsignalkind)+1) = 6;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.RN16_1*10 + obj.num;
%                                     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                     obj.state = tagstate.reply;
%                                 elseif obj.slot_counter > 0 
%                                     obj.state = tagstate.arbitrate;
%                                 end
%                             case 3
%                                     obj.state = tagstate.arbitrate;
%                             case 4
%                                 if obj.RN16_1 * 10 +obj.num == signalvalue(1)
% 
%                                     newsignalkind(length(newsignalkind)+1) = 7;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.EPC * 10 +obj.num;
%                                     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                     obj.state = tagstate.acknowledged;
%                                 else 
%                                     obj.state = tagstate.arbitrate;
%                                 end
%                             case 5
%                                 obj.state = tagstate.arbitrate;
%                         end
%                     case tagstate.acknowledged
%                         switch signalkind(1)
%                             case 1
%                                 % obj.slot_counter = randi(signalvalue(1)+1)-1;
%                                 % if obj.slot_counter == 0
%                                 %     %backscatter new RN16
%                                 %     obj.RN16_1 = randi(1000000);
%                                 %     newsignalkind(length(newsignalkind)+1) = 1;
%                                 %     newsignalvalue(length(newsignalvalue)+1) = obj.RN16_1;
%                                 %     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                 %     obj.state = tagstate.reply;
%                                 % elseif obj.slot_counter > 0 
%                                 %     obj.state = tagstate.arbitrate;
%                                 % end
%                                 obj.state = tagstate.acknowledged;
%                             case 3
%                                 obj.state = tagstate.acknowledged;
%                             case 2
%                                 obj.state = tagstate.acknowledged;
%                             case 4
%                                 if obj.RN16_1 * 10 +obj.num == signalvalue(1)
%                                     newsignalkind(length(newsignalkind)+1) = 7;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.EPC * 10 + obj.num;
%                                     obj.state = tagstate.acknowledged;
%                                 elseif obj.RN16_1 * 10 +obj.num ~= signalvalue(1) 
%                                     %obj.state = tagstate.arbitrate;
%                                 end
%                             case 5
%                                 obj.state = tagstate.arbitrate;
%                         end
%                     % case open
%                     % 
%                     % case secured
%                     % 
%                     % case killed
% 
%                 end
%             end
%         end       
%     end
% end

% classdef tag
%     properties
%         x_tag
%         y_tag
%         z_tag
%         x_reader
%         y_reader
%         z_reader
%         num
%         name
%         state       %1:ready 2：arbitrate 3:reply 4:acknowledged 5:open 6:secured 7:killed
%         RN16_1
%         RN16_2
%         slot_counter
%         PC
%         EPC
%         CRC_16  
%         % inventoried_flag % 库存：A/B
%         % session         % 会话
%         % killpassword
%         % accesspassword
%         %RNG
%     end
% 
%     methods      
% 
%         function obj = tag(new_name,epc,i)
%             %对标签命名
%             obj.name = new_name;
%             obj.EPC = epc;
%             obj.num = i;
%             obj.state = tagstate.ready;
%         end
% 
%         function [obj,readerbin,tagbin] = listen(obj,readerbin,tmptagbin)
%             %收听信号
% 
%             [signalkind,signalvalue] = decode(readerbin);
%             % disp("55");
%             [newsignalkind,newsignalvalue] = decode(tmptagbin);
%             % disp("66");
%             tagbin = tmptagbin;
%             disp(obj.name + " reflect " + signalkind+" slot:"+num2str(obj.slot_counter)+" state:"+ string(obj.state));
%             if isempty(signalkind)==0
%                 switch obj.state
%                     case tagstate.ready
%                         switch signalkind(1)
%                             case 1
%                                 obj.RN16_1 = randi(2^12)-1;
%                                 obj.RN16_2 = dec2bin(obj.RN16_1,16);
%                                 obj.slot_counter = randi(2^signalvalue(1))-1;
%                                 if obj.slot_counter == 0
%                                     %backscatter new RN16
% 
%                                     newsignalkind(length(newsignalkind)+1) = 6;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.RN16_1*10 + obj.num;
%                                     tagbin = encode(newsignalkind,newsignalvalue);
%                                     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                     obj.state = tagstate.reply;
%                                     disp(obj.name + " change state to reply");
%                                 elseif obj.slot_counter > 0 
%                                     obj.state = tagstate.arbitrate;
%                                     disp(obj.name + " change state to arbitrate");
%                                 end
%                         end
%                     case tagstate.arbitrate
%                         switch signalkind(1)
%                             case 1
%                                 obj.slot_counter = randi(2^signalvalue(1))-1;
%                                 obj.RN16_1 = randi(2^12)-1;
%                                 obj.RN16_2 = dec2bin(obj.RN16_1,16);
%                                 if obj.slot_counter == 0
%                                     %backscatter new RN16
% 
%                                     newsignalkind(length(newsignalkind)+1) = 6;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.RN16_1*10 + obj.num;
%                                     tagbin = encode(newsignalkind,newsignalvalue);
%                                     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                     obj.state = tagstate.reply;
%                                     disp(obj.name + " change state to reply");
%                                 elseif obj.slot_counter > 0 
%                                     obj.state = tagstate.arbitrate;
%                                     disp(obj.name + " slot_counter : " + obj.slot_counter)
%                                 else 
%                                     obj.state = tagstate.ready;
%                                     disp(obj.name + " change state to ready");
%                                 end
%                             case 3
%                                 %obj.slot_counter = randi(2^signalvalue(1))-1;
%                                 obj.slot_counter = obj.slot_counter - 1;
%                                 if obj.slot_counter == 0
%                                     %backscatter new RN16
%                                     newsignalkind(length(newsignalkind)+1) = 6;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.RN16_1*10 + obj.num;
%                                     tagbin = encode(newsignalkind,newsignalvalue);
%                                     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                     obj.state = tagstate.reply;
%                                     disp(obj.name + " change state to reply");
%                                 elseif obj.slot_counter > 0 
% 
%                                     obj.state = tagstate.arbitrate;
%                                     disp(obj.name + " slot_counter : " + obj.slot_counter)
%                                 end
%                             case 2  
%                                 obj.slot_counter = randi(2^signalvalue(1)+1)-1;
%                                 if obj.slot_counter == 0
%                                     %backscatter new RN16
%                                     newsignalkind(length(newsignalkind)+1) = 6;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.RN16_1*10 + obj.num;
%                                     tagbin = encode(newsignalkind,newsignalvalue);
%                                     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                     obj.state = tagstate.reply;
%                                     disp(obj.name + " change state to reply");
%                                 elseif obj.slot_counter > 0 
%                                     obj.state = tagstate.arbitrate;
%                                     disp(obj.name + " slot_counter : " + obj.slot_counter)
%                                 end
%                         end 
%                     case tagstate.reply
%                         switch signalkind(1)
%                             case 1
%                                 obj.slot_counter = randi(2^signalvalue(1)+1)-1;
%                                 if obj.slot_counter == 0
%                                     %backscatter new RN16
%                                     obj.RN16_1 = randi(2^16)-1;
%                                     obj.RN16_2 = dec2bin(obj.RN16_1,16);
%                                     newsignalkind(length(newsignalkind)+1) = 6;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.RN16_1*10 + obj.num;
%                                     tagbin = encode(newsignalkind,newsignalvalue);
%                                     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                     obj.state = tagstate.reply;
%                                 elseif obj.slot_counter > 0 
%                                     obj.state = tagstate.arbitrate;
%                                     disp(obj.name + " slot_counter : " + obj.slot_counter)
%                                 else 
%                                     obj.state = tagstate.ready;
%                                 end
%                             case 2
%                                 obj.slot_counter = randi(signalvalue(1)+1)-1;
%                                 if obj.slot_counter == 0
%                                     %backscatter new RN16
%                                     newsignalkind(length(newsignalkind)+1) = 6;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.RN16_1*10 + obj.num;
%                                     tagbin = encode(newsignalkind,newsignalvalue);
%                                     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                     obj.state = tagstate.reply;
%                                 elseif obj.slot_counter > 0 
%                                     obj.state = tagstate.arbitrate;
%                                 end
%                             case 3
%                                     obj.state = tagstate.arbitrate;
%                             case 4
%                                 if obj.RN16_1 * 10 +obj.num == signalvalue(1)
% 
%                                     newsignalkind(length(newsignalkind)+1) = 7;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.EPC;
%                                     tagbin = encode(newsignalkind,newsignalvalue);
%                                     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                     obj.state = tagstate.acknowledged;
%                                 else 
%                                     obj.state = tagstate.arbitrate;
%                                 end
%                             case 5
%                                 obj.state = tagstate.arbitrate;
%                         end
%                     case tagstate.acknowledged
%                         switch signalkind(1)
%                             case 1
%                                 % obj.slot_counter = randi(signalvalue(1)+1)-1;
%                                 % if obj.slot_counter == 0
%                                 %     %backscatter new RN16
%                                 %     obj.RN16_1 = randi(1000000);
%                                 %     newsignalkind(length(newsignalkind)+1) = 1;
%                                 %     newsignalvalue(length(newsignalvalue)+1) = obj.RN16_1;
%                                 %     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
%                                 %     obj.state = tagstate.reply;
%                                 % elseif obj.slot_counter > 0 
%                                 %     obj.state = tagstate.arbitrate;
%                                 % end
%                                 obj.state = tagstate.acknowledged;
%                             case 3
%                                 obj.state = tagstate.acknowledged;
%                             case 2
%                                 obj.state = tagstate.acknowledged;
%                             case 4
%                                 if obj.RN16_1 * 10 +obj.num == signalvalue(1)
%                                     newsignalkind(length(newsignalkind)+1) = 7;
%                                     newsignalvalue(length(newsignalvalue)+1) = obj.EPC;
%                                     tagbin = encode(newsignalkind,newsignalvalue);
%                                     obj.state = tagstate.acknowledged;
%                                 elseif obj.RN16_1 * 10 +obj.num ~= signalvalue(1) 
%                                     %obj.state = tagstate.arbitrate;
%                                 end
%                             case 5
%                                 obj.state = tagstate.arbitrate;
%                         end
%                     % case open
%                     % 
%                     % case secured
%                     % 
%                     % case killed
% 
%                 end
%             end
%         end       
%     end
% end

classdef tag
    properties
        x_tag
        y_tag
        z_tag
        x_reader
        y_reader
        z_reader
        num
        name
        state       %1:ready 2：arbitrate 3:reply 4:acknowledged 5:open 6:secured 7:killed
        RN16_1
        RN16_2
        slot_counter
        PC
        EPC
        CRC_16  
        fig_handle
        routes
        % inventoried_flag % 库存：A/B
        % session         % 会话
        % killpassword
        % accesspassword
        %RNG
    end

    methods      

        function obj = tag(new_name,epc,i,fig,route)
            %对标签命名
            obj.name = new_name;
            obj.EPC = epc;
            obj.num = i;
            obj.state = tagstate.ready;
            obj.fig_handle = fig;
            obj.routes = route;
        end
        
        function obj = set_routes(obj,route)
            obj.routes = route;
        end

        function [obj,readerbin,tagbin,command_time] = listen(obj,readerbin,tmptagbin,starttime)
            %收听信号
            command_time = 0;
            disp(strlength(readerbin));
            disp("55");
            [signalkind,signalvalue] = readerdecode(readerbin);
            disp("66");
            tagbin = tmptagbin;
            disp(obj.name + " reflect " + signalkind+" slot:"+num2str(obj.slot_counter)+" state:"+ string(obj.state));
            if isempty(signalkind)==0
                switch obj.state
                    case tagstate.ready
                        switch signalkind(1)
                            case 1
                                obj.RN16_1 = randi(2^12)-1;
                                obj.RN16_2 = dec2bin(obj.RN16_1,16);
                                obj.slot_counter = randi(2^signalvalue(1))-1;
                                if obj.slot_counter == 0
                                    %backscatter new RN16

                                    newsignalkind = 6;
                                    newsignalvalue = obj.RN16_1;
                                    tagbin = tagencode(newsignalkind,newsignalvalue,tagbin);
                                    power = obj.routes.rssi_cal() - 5;
                                    obj.routes.send(power,2);
                                    tagdraw_time(starttime,starttime+4.7,obj.num,obj.RN16_1,obj.fig_handle,6,obj.routes.rssi_cal(),obj.routes.phase_cal());
                                    command_time = 4.7+3.3;
                                    disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
                                    obj.state = tagstate.reply;
                                    disp(obj.name + " change state to reply");
                                elseif obj.slot_counter > 0 
                                    obj.state = tagstate.arbitrate;
                                    disp(obj.name + " change state to arbitrate");
                                end
                        end
                    case tagstate.arbitrate
                        switch signalkind(1)
                            case 1
                                obj.slot_counter = randi(2^signalvalue(1))-1;
                                obj.RN16_1 = randi(2^12)-1;
                                obj.RN16_2 = dec2bin(obj.RN16_1,16);
                                if obj.slot_counter == 0
                                    %backscatter new RN16

                                    newsignalkind = 6;
                                    newsignalvalue = obj.RN16_1;
                                    tagbin = tagencode(newsignalkind,newsignalvalue,tagbin);
                                    power = obj.routes.rssi_cal() - 5;
                                    obj.routes.send(power,2);
                                    tagdraw_time(starttime,starttime+4.7,obj.num,obj.RN16_1,obj.fig_handle,6,obj.routes.rssi_cal(),obj.routes.phase_cal());
                                    command_time = 4.7+3.3;
                                    disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
                                    obj.state = tagstate.reply;
                                    disp(obj.name + " change state to reply");
                                elseif obj.slot_counter > 0 
                                    obj.state = tagstate.arbitrate;
                                    disp(obj.name + " slot_counter : " + obj.slot_counter)
                                else 
                                    obj.state = tagstate.ready;
                                    disp(obj.name + " change state to ready");
                                end
                            case 3
                                %obj.slot_counter = randi(2^signalvalue(1))-1;
                                obj.slot_counter = obj.slot_counter - 1;
                                if obj.slot_counter == 0
                                    %backscatter new RN16
                                    newsignalkind = 6;
                                    newsignalvalue = obj.RN16_1;
                                    tagbin = tagencode(newsignalkind,newsignalvalue,tagbin);
                                    power = obj.routes.rssi_cal() - 5;
                                    obj.routes.send(power,2);
                                    tagdraw_time(starttime,starttime+4.7,obj.num,obj.RN16_1,obj.fig_handle,6,obj.routes.rssi_cal(),obj.routes.phase_cal());
                                    command_time = 4.7+3.3;
                                    disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
                                    obj.state = tagstate.reply;
                                    disp(obj.name + " change state to reply");
                                elseif obj.slot_counter > 0 

                                    obj.state = tagstate.arbitrate;
                                    disp(obj.name + " slot_counter : " + obj.slot_counter)
                                end
                            case 2  
                                obj.slot_counter = randi(2^signalvalue(1)+1)-1;
                                if obj.slot_counter == 0
                                    %backscatter new RN16
                                    newsignalkind = 6;
                                    newsignalvalue = obj.RN16_1;
                                    tagbin = tagencode(newsignalkind,newsignalvalue,tagbin);
                                    power = obj.routes.rssi_cal() - 5;
                                    obj.routes.send(power,2);
                                    tagdraw_time(starttime,starttime+4.7,obj.num,obj.RN16_1,obj.fig_handle,6,obj.routes.rssi_cal(),obj.routes.phase_cal());
                                    command_time = 4.7+3.3;
                                    disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
                                    obj.state = tagstate.reply;
                                    disp(obj.name + " change state to reply");
                                elseif obj.slot_counter > 0 
                                    obj.state = tagstate.arbitrate;
                                    disp(obj.name + " slot_counter : " + obj.slot_counter)
                                end
                        end 
                    case tagstate.reply
                        switch signalkind(1)
                            case 1
                                obj.slot_counter = randi(2^signalvalue(1)+1)-1;
                                if obj.slot_counter == 0
                                    %backscatter new RN16
                                    obj.RN16_1 = randi(2^16)-1;
                                    obj.RN16_2 = dec2bin(obj.RN16_1,16);
                                    newsignalkind = 6;
                                    newsignalvalue = obj.RN16_1;
                                    tagbin = tagencode(newsignalkind,newsignalvalue,tagbin);
                                    power = obj.routes.rssi_cal() - 5;
                                    obj.routes.send(power,2);
                                    tagdraw_time(starttime,starttime+4.7,obj.num,obj.RN16_1,obj.fig_handle,6,obj.routes.rssi_cal(),obj.routes.phase_cal());
                                    command_time = 4.7+3.3;
                                    disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
                                    obj.state = tagstate.reply;
                                elseif obj.slot_counter > 0 
                                    obj.state = tagstate.arbitrate;
                                    disp(obj.name + " slot_counter : " + obj.slot_counter)
                                else 
                                    obj.state = tagstate.ready;
                                end
                            case 2
                                obj.slot_counter = randi(signalvalue(1)+1)-1;
                                if obj.slot_counter == 0
                                    %backscatter new RN16
                                    newsignalkind = 6;
                                    newsignalvalue = obj.RN16_1;
                                    tagbin = tagencode(newsignalkind,newsignalvalue,tagbin);
                                    power = obj.routes.rssi_cal() - 5;
                                    obj.routes.send(power,2);
                                    tagdraw_time(starttime,starttime+4.7,obj.num,obj.RN16_1,obj.fig_handle,6,obj.routes.rssi_cal(),obj.routes.phase_cal());
                                    command_time = 4.7+3.3;
                                    disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
                                    obj.state = tagstate.reply;
                                elseif obj.slot_counter > 0 
                                    obj.state = tagstate.arbitrate;
                                end
                            case 3
                                    obj.state = tagstate.arbitrate;
                            case 4
                                if obj.RN16_1 == signalvalue(1)

                                    newsignalkind = 7;
                                    newsignalvalue = obj.EPC;
                                    tagbin = tagencode(newsignalkind,newsignalvalue,tagbin);
                                    power = obj.routes.rssi_cal() - 5;
                                    obj.routes.send(power,2);
                                    tagdraw_time(starttime,starttime+26.7,obj.num,obj.EPC,obj.fig_handle,7,obj.routes.rssi_cal(),obj.routes.phase_cal());
                                    command_time = 26.7+3.3;
                                    disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
                                    obj.state = tagstate.acknowledged;
                                else 
                                    obj.state = tagstate.arbitrate;
                                end
                            case 5
                                obj.state = tagstate.arbitrate;
                        end
                    case tagstate.acknowledged
                        switch signalkind(1)
                            case 1
                                % obj.slot_counter = randi(signalvalue(1)+1)-1;
                                % if obj.slot_counter == 0
                                %     %backscatter new RN16
                                %     obj.RN16_1 = randi(1000000);
                                %     newsignalkind(length(newsignalkind)+1) = 1;
                                %     newsignalvalue(length(newsignalvalue)+1) = obj.RN16_1;
                                %     disp(obj.name + " backscatter RN16 : "+ num2str(obj.RN16_1));
                                %     obj.state = tagstate.reply;
                                % elseif obj.slot_counter > 0 
                                %     obj.state = tagstate.arbitrate;
                                % end
                                obj.state = tagstate.acknowledged;
                            case 3
                                obj.state = tagstate.acknowledged;
                            case 2
                                obj.state = tagstate.acknowledged;
                            case 4
                                if obj.RN16_1 * 10 +obj.num == signalvalue(1)
                                    newsignalkind = 7;
                                    newsignalvalue = obj.EPC;
                                    tagbin = tagencode(newsignalkind,newsignalvalue,tagbin);
                                    power = obj.routes.rssi_cal() - 5;
                                    obj.routes.send(power,2);
                                    tagdraw_time(starttime,starttime+26.7,obj.num,obj.EPC,obj.fig_handle,7,obj.routes.rssi_cal(),obj.routes.phase_cal());
                                    command_time = 26.7+3.3;
                                    obj.state = tagstate.acknowledged;
                                elseif obj.RN16_1 * 10 +obj.num ~= signalvalue(1) 
                                    %obj.state = tagstate.arbitrate;
                                end
                            case 5
                                obj.state = tagstate.arbitrate;
                        end
                    % case open
                    % 
                    % case secured
                    % 
                    % case killed

                end
            end
        end       
    end
end