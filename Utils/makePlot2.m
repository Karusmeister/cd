function [] = makePlot2(tvals, Values,Title,Xlabel,Ylabel,graphSwitch,savePath)

h=figure('visible','off');

    if (graphSwitch)


        plot(tvals, Values)
        title(Title)
        xlabel(Xlabel)
        ylabel(Ylabel)
        
       saveas(h,strcat(savePath,'.jpg'))
    end
end
