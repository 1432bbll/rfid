% classdef reader
%     properties
%         name
%         mytime
%         p
%         Q
%         framesize
%         tmpframe
%         RN16
%         NAK
%         num
%     end
% 
%     methods
%         function obj = reader(new_name)
%             %对阅读器命名
%             obj.name = new_name;
%             obj.p = 0.9;
%             obj.Q = 2;
%             obj.tmpframe = 4;
%             obj.NAK = 1;
%             obj.mytime = 0;
%             obj.num =0;
%         end
% 
%         %command
% 
%         %Select 包含参数 Target、Action、MemBank、Pointer、Length、Mask 和 Truncate。
% 
%         %清点命令集包括Query、QueryAdjust、QueryRep、ACK 和NAK。
%         %Query
%         function [obj,signalkind,signalvalue] = Query(obj)
% 
%             signalkind(1) =1;
%             signalvalue(1) = obj.Q;
%             % disp(isempty(signal));
%             %disp(signalkind);
% 
%         end
%         %QueryAdjust
%         function [obj,signalkind,signalvalue] = QueryAdjust(obj)
%             signalkind(1) =2;
%             signalvalue(1) = obj.Q;
%         end
%         %QueryRep
%         function [obj,signalkind,signalvalue] = QueryRep(obj)
%             signalkind(1) =3;
%             signalvalue(1) = 0;
% 
%         end
%         %ACK
%         function [obj,signalkind,signalvalue] = R_ACK(obj,RN16)
%             signalkind(1) =4;
%             signalvalue(1) = RN16;
%         end
%         %NAK
%         function [obj,signalkind,signalvalue] = R_NAK(obj)
%             signalkind(1) =5;
%             signalvalue(1) = 0;
%         end
% 
%         function [obj,signalkind,signalvalue,newsignalkind,newsignalvalue] = listen(obj,signalkind,signalvalue,newsignalkind,newsignalvalue)
%             %收听信号
% 
%             disp(obj.name + " listen");
%             %Query(obj,newsignalkind,newsignalvalue);
%             if isempty(signalkind) == 1
%                 if obj.NAK == 1
%                     [obj,newsignalkind,newsignalvalue] = Query(obj);
%                     obj.NAK = 0;
%                 else
%                     [obj,newsignalkind,newsignalvalue] = QueryRep(obj);
%                 end
%             elseif length(signalkind) > 1
%                 f = 0;
%                 for i = 1:length(signalkind)
%                     if signalkind(i) == 7
%                         [obj,newsignalkind,newsignalvalue] = R_NAK(obj);
%                         obj.NAK= 1;
%                         f= 1;
%                         break;
%                     end
%                 end
%                 if f == 0
%                     obj.Q = obj.Q+1;
%                     if obj.Q > 15
%                         obj.Q = 15;
%                     end
%                     [obj,newsignalkind,newsignalvalue] = QueryAdjust(obj);
%                 end
%             elseif signalkind(1) == 6
%                 obj.RN16 = signalvalue(1);
%                 [obj,newsignalkind,newsignalvalue] = R_ACK(obj,obj.RN16);
%             elseif signalkind(1) == 7
%                 disp(obj.name + " listen epc : "+ num2str(signalvalue(1)));
%                 fprintf(2,'红颜色\n');
%                 obj.num = obj.num + 1;
%                 [obj,newsignalkind,newsignalvalue] = QueryRep(obj);
%             end
%         end
%     end
% end

% classdef reader
%     properties
%         name
%         mytime
%         p
%         Q
%         framesize
%         tmpframe
%         RN16
%         NAK
%     end
% 
%     methods
%         function obj = reader(new_name)
%             %对阅读器命名
%             obj.name = new_name;
%             obj.p = 0.9;
%             obj.Q = 2;
%             obj.tmpframe = 4;
%             obj.NAK = 1;
%             obj.mytime = 0;
%         end
% 
%         %command
% 
%         %Select 包含参数 Target、Action、MemBank、Pointer、Length、Mask 和 Truncate。
% 
%         %清点命令集包括Query、QueryAdjust、QueryRep、ACK 和NAK。
%         %Query
%         function [obj,signalkind,signalvalue] = Query(obj)
% 
%             signalkind(1) =1;
%             signalvalue(1) = obj.Q;
%             % disp(isempty(signal));
%             %disp(signalkind);
% 
%         end
%         %QueryAdjust
%         function [obj,signalkind,signalvalue] = QueryAdjust(obj)
%             signalkind(1) =2;
%             signalvalue(1) = obj.Q;
%         end
%         %QueryRep
%         function [obj,signalkind,signalvalue] = QueryRep(obj)
%             signalkind(1) =3;
%             signalvalue(1) = 0;
% 
%         end
%         %ACK
%         function [obj,signalkind,signalvalue] = R_ACK(obj,RN16)
%             signalkind(1) =4;
%             signalvalue(1) = RN16;
%         end
%         %NAK
%         function [obj,signalkind,signalvalue] = R_NAK(obj)
%             signalkind(1) =5;
%             signalvalue(1) = 0;
%         end
% 
%         function [obj,tagbin,readerbin] = listen(obj,tagbin,tmpreaderbin)
%             %收听信号
%             readerbin = string([]);
%             disp(obj.name + " listen");
%             %Query(obj,newsignalkind,newsignalvalue);
%             [signalkind,signalvalue] = decode(tagbin);
%             disp("555");
%             if isempty(signalkind) == 1
%                 if obj.NAK == 1
%                     [obj,newsignalkind,newsignalvalue] = Query(obj);
%                     readerdraw_time(,,1);
%                     readerbin = encode(newsignalkind,newsignalvalue);
%                     disp("666");
%                     obj.NAK = 0;
%                 else
%                     [obj,newsignalkind,newsignalvalue] = QueryRep(obj);
%                     readerdraw_time(,,3);
%                     readerbin = encode(newsignalkind,newsignalvalue);
%                 end
%             elseif length(signalkind) > 1
%                 f = 0;
%                 for i = 1:length(signalkind)
%                     if signalkind(i) == 7
%                         % [obj,newsignalkind,newsignalvalue] = R_NAK(obj);
%                         disp("!!!!error!!!!");
%                         obj.NAK= 1;
%                         f= 1;
%                         break;
%                     end
%                 end
%                 if f == 0
%                     obj.Q = obj.Q+1;
%                     [obj,newsignalkind,newsignalvalue] = QueryAdjust(obj);
%                     readerdraw_time(,,2);
%                     readerbin = encode(newsignalkind,newsignalvalue);
%                 end
%             elseif signalkind(1) == 6
%                 obj.RN16 = signalvalue(1);
%                 [obj,newsignalkind,newsignalvalue] = R_ACK(obj,obj.RN16);
%                 readerdraw_time(,,4);
%                 readerbin = encode(newsignalkind,newsignalvalue);
%             elseif signalkind(1) == 7
%                 disp(obj.name + " listen epc : "+ num2str(signalvalue(1)));
%                 fprintf(2,'红颜色\n');
%                 [obj,newsignalkind,newsignalvalue] = QueryRep(obj);
%                 readerdraw_time(,,3);
%                 readerbin = encode(newsignalkind,newsignalvalue);
%             end
%         end
%     end
% end


classdef reader
    properties
        name
        mytime
        p
        Q
        framesize
        tmpframe
        RN16
        NAK
        fig_handle
        routes
    end

    methods
        function obj = reader(new_name,fig,route)
            %对阅读器命名
            obj.name = new_name;
            obj.p = 0.9;
            obj.Q = 2;
            obj.tmpframe = 4;
            obj.NAK = 1;
            obj.mytime = 0;
            obj.fig_handle = fig;
            obj.routes = route;
        end
        
        function obj = set_route(obj,route)
            obj.routes = route;
        end
        %command

        %Select 包含参数 Target、Action、MemBank、Pointer、Length、Mask 和 Truncate。

        %清点命令集包括Query、QueryAdjust、QueryRep、ACK 和NAK。
        %Query
        function [obj,signalkind,signalvalue] = Query(obj)

            signalkind(1) =1;
            signalvalue(1) = obj.Q;
            % disp(isempty(signal));
            %disp(signalkind);

        end
        %QueryAdjust
        function [obj,signalkind,signalvalue] = QueryAdjust(obj)
            signalkind(1) =2;
            signalvalue(1) = obj.Q;
        end
        %QueryRep
        function [obj,signalkind,signalvalue] = QueryRep(obj)
            signalkind(1) =3;
            signalvalue(1) = 0;

        end
        %ACK
        function [obj,signalkind,signalvalue] = R_ACK(obj,RN16)
            signalkind(1) =4;
            signalvalue(1) = RN16;
        end
        %NAK
        function [obj,signalkind,signalvalue] = R_NAK(obj)
            signalkind(1) =5;
            signalvalue(1) = 0;
        end

        function [obj,tagbin,readerbin,commandtime] = listen(obj,tagbin,tmpreaderbin,starttime)
            %收听信号
            commandtime = 0;
            readerbin = "";
            disp(obj.name + " listen");
            %Query(obj,newsignalkind,newsignalvalue);
            [signalkind,signalvalue] = tagdecode(tagbin);
            disp("555");
            disp(isempty(signalkind));
            if isempty(signalkind) == 1
                if obj.NAK == 1
                    
                    [obj,newsignalkind,newsignalvalue] = Query(obj);
                    
                    readerdraw_time(starttime,starttime + 5.2,1,obj.fig_handle);
                    readerbin = encode(newsignalkind,newsignalvalue);
                    for j = 1:length(obj.routes)
                        obj.routes(j).send(30,1);
                    end
                    commandtime = 5.2;
                    disp("666");
                    obj.NAK = 0;
                else
                    [obj,newsignalkind,newsignalvalue] = QueryRep(obj);
                    readerdraw_time(starttime,starttime+0.5,3,obj.fig_handle);
                    commandtime = 0.5;
                    readerbin = encode(newsignalkind,newsignalvalue);
                    for j = 1:length(obj.routes)
                        obj.routes(j).send(30,1);
                    end
                end
            elseif signalkind(1) == 8
                f = 0;
                % for i = 1:length(signalkind)
                %     if signalkind(i) == 7
                %         % [obj,newsignalkind,newsignalvalue] = R_NAK(obj);
                %         disp("!!!!error!!!!");
                %         obj.NAK= 1;
                %         f= 1;
                %         break;
                %     end
                % end
                if f == 0
                    obj.Q = obj.Q+1;
                    [obj,newsignalkind,newsignalvalue] = QueryAdjust(obj);
                    readerdraw_time(starttime,starttime + 1,2,obj.fig_handle);
                    commandtime = 1.2;
                    readerbin = encode(newsignalkind,newsignalvalue);
                    for j = 1:length(obj.routes)
                        obj.routes(j).send(30,1);
                    end
                end
            elseif signalkind(1) == 6
                obj.RN16 = signalvalue(1);
                [obj,newsignalkind,newsignalvalue] = R_ACK(obj,obj.RN16);
                readerdraw_time(starttime,starttime + 6.6,4,obj.fig_handle);
                commandtime = 6.6;
                readerbin = encode(newsignalkind,newsignalvalue);
                for j = 1:length(obj.routes)
                    obj.routes(j).send(30,2);
                end
            elseif signalkind(1) == 7
                disp(obj.name + " listen epc : "+ num2str(signalvalue(1)));
                fprintf(2,'红颜色\n');
                [obj,newsignalkind,newsignalvalue] = QueryRep(obj);
                readerdraw_time(starttime,starttime+0.5,3,obj.fig_handle);
                commandtime = 0.5;
                readerbin = encode(newsignalkind,newsignalvalue);
                for j = 1:length(obj.routes)
                    obj.routes(j).send(30,1);
                end
            end
        end
    end
end