classdef route < handle
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
        frequency % 工作频率 (Hz)
        tx_power % 发射功率 (dBm)
        rssi_receive
        sender;
    end
    
    methods
        function obj = route(readerposition, tagposition,power)
            %ROUTE 构造此类的实例
            %   此处显示详细说明
            obj.x_startpoint = readerposition(1);
            obj.y_startpoint = readerposition(2);
            obj.z_startpoint = readerposition(3);
            obj.x_endpoint = tagposition(1);
            obj.y_endpoint = tagposition(2);
            obj.z_endpoint = tagposition(3);
            obj.frequency = 925e6; 
            obj.tx_power = power; 
            obj.sender = 1;
            
        end
        
        function [distance] = dis_cal(obj)
            distance = norm([obj.x_startpoint, obj.y_startpoint, obj.z_startpoint]-[obj.x_endpoint, obj.y_endpoint, obj.z_endpoint]);
        end

        function [rssi] = rssi_cal(obj)
            % Friis公式计算路径损耗
            path_loss = 20 * log10(dis_cal(obj)) + 20 * log10(obj.frequency) - 147.55;
            
            % RSSI = 发射功率 - 路径损耗
            rssi = obj.tx_power - path_loss;
            obj.rssi_receive = rssi;
        end
        
        function [phase] = phase_cal(obj)
            c = 3e8; % 光速
            wavelength = c / obj.frequency;
            phase = mod(2 * pi * (dis_cal(obj) / wavelength), 2 * pi);
            phase = rad2deg(phase);
        end
        function set_frequency(obj, freq)
            % 设置工作频率 (Hz)
            obj.frequency = freq;
        end
        
        function obj = send(obj, power,sender)
            % 设置发射功率 (dBm)
            obj.tx_power = power;
            obj.sender = sender;
        end
    end
end

