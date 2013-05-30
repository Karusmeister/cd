
RecoveryRate = 0.35;

graphSwitch = true;

PortfolioStruc = port;

yearTime =  yearfrac(PortfolioStruc.StartPoint,PortfolioStruc.EndPoint);


[~,cols] = size(PortfolioStruc.data);

EEs = [];

    for n=1:cols
        products = PortfolioStruc.data{n};
        e = calculateExpectedExposure(products);
        EEs = [EEs ; e];
    end
    
[~,ees] = size(EEs);

dt = yearTime/ ees;

tvals = [dt:dt:yearTime]; 

%makePlot2(tvals, Values,Title,Xlabel,Ylabel,graphSwitch,savePath)

makePlot2( tvals, standardDP,'Default Probabilities implied by term structure','Time [Years]','Probability',graphSwitch,'stdDP');


makePlot2(tvals, hwDP,'Default Probabilities implied by term structure','Time [Years]','Probability',graphSwitch,'hwDP');

standardCVA = calculateCVA( EEs, RecoveryRate,standardDP);
makePlot2(tvals, cumsum(standardCVA),'Default Probabilities implied by term structure','Time [Years]','Probability',graphSwitch,'standardCVA');

hwCVA = calculateCVA( EEs, RecoveryRate,hwDP);
makePlot2(tvals, cumsum(hwCVA),'Default Probabilities implied by term structure','Time [Years]','Probability',graphSwitch,'hwCVA');


makePlot2(tvals, cumsum(mean(standardCVA)),'Default Probabilities implied by term structure', ...
    'Time [Years]','Probability',graphSwitch,'standardCVACumsum');
makePlot2(tvals, cumsum(mean(hwCVA)),'Default Probabilities implied by term structure', ...
    'Time [Years]','Probability',graphSwitch,'hwCVACumsum');