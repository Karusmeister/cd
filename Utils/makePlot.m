function [] = makePlot( T, dt, Values,Title,Xlabel,Ylabel,graphSwitch,savePath )

h=figure('visible','off');

    if (graphSwitch)

        tvals = [0:dt:T];
        [~,cols1] = size(tvals);
        [~,cols2] = size(Values);

        dim = min(cols1,cols2);

        plot(tvals(:,1:dim), Values(:,1:dim))
        title(Title)
        xlabel(Xlabel)
        ylabel(Ylabel)
        
       saveas(h,strcat(savePath,'.jpg'))
    end
end

