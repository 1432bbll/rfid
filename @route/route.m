classdef route
    %ROUTE 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        x_startpoint
        y_startpoint
        z_startpoint
        x_endpoint
        y_endpoint
        z_endpoint
        time

    end
    
    methods
        function obj = route(x1,y1,z1,x2,y2,z2)
            %ROUTE 构造此类的实例
            %   此处显示详细说明
            obj.x_startpoint = x1;
            obj.y_startpoint = y1;
            obj.z_startpoint = z1;
            obj.x_endpoint = x2;
            obj.y_endpoint = y2;
            obj.z_endpoint = z2;
        end
        
        function [rssi,angle] = show(obj)
            %   求解强度和相位
            l = norm([obj.x_startpoint,obj.y_startpoint,obj.z_startpoint]-[obj.x_endpoint,obj.y_endpoint,obj.z_endpoint]);
            angle = mod(l,0.33)/0.33*360;
            rssi = 
        end
    end
end

