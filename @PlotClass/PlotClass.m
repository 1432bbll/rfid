classdef PlotClass
    properties
        fig_handle
    end
    
    methods
        function obj = PlotClass(fig)
            obj.fig_handle = fig;
        end
        
        function add_plot(obj)
            figure(obj.fig_handle);
            hold on;
            x = linspace(0, 2*pi, 100);
            y = tan(x);
            plot(x, y, 'g', 'DisplayName', 'tan(x)');
            hold off;
            legend;
        end
    end
end