matlabpool open local 4

L = log4m.getLogger('logfile.txt');
L.setCommandWindowLevel(L.ALL); 
trials = 3;

Portfolio3FullSim = {};
states = [100,101,102];
genStates= [63348,63349,63350];

StartPoint = '02-January-2013';
EndPoint = '02-January-2018';

nTrials = 5;

 parfor t=1:trials
     
    L.info('Build Portfolio One ', strcat('Trial ',num2str(t),' has started.'));
     
    StartPoint = '02-January-2013';
    EndPoint = '02-January-2018';
    
    graphSwitch  = and(true,globalGraphSwitch);
    nfig = 1;

    TradingDays = busdays(StartPoint,EndPoint);
    StartPoint = datenum(StartPoint);
    EndPoint = datenum(EndPoint);
    %nDays = busdate(EndPoint) - busdate(StartPoint);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    initialAssetValue = 100; mu = 0.1; sigma = 0.2; 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Strike = 120; Rate = 0.05; Volatility = sigma;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %simulateAssetsPaths(nTrials,days,StartValue,sigma,mu)

    Assets = simulateAssetsPaths(nTrials,yearfrac(StartPoint,EndPoint), ...
    yearfrac(StartPoint,EndPoint)/(busdate(EndPoint)- busdate(StartPoint)),initialAssetValue,sigma,mu,states(t));
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,EndPoint),yearfrac(StartPoint,EndPoint)/(busdate(EndPoint)- busdate(StartPoint)),Assets, ...
        strcat('Simulated Asset Paths, Trial ',num2str(t)), 'Time [Years]','Value [€]',graphSwitch,savePath );
    nfig= nfig + 1;


    MaturityDate = '02-January-2016';
    OptionsValues1 = getExposureForOption(Assets,TradingDays,MaturityDate,Rate,Strike,Volatility);
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,MaturityDate),yearfrac(StartPoint,MaturityDate)/(busdate(MaturityDate)- busdate(StartPoint)),OptionsValues1, ...
        strcat('Option with Maturity ',MaturityDate, ' Strike=', num2str(Strike),', Trial ', num2str(t))  , 'Time [Years]','Value [€]', graphSwitch,savePath);
    mOptionsValues1 = mean(OptionsValues1);
    nfig= nfig + 1;
    
    MaturityDate = '02-January-2017';
    OptionsValues2 = getExposureForOption(Assets,TradingDays,MaturityDate,Rate,Strike,Volatility);
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,MaturityDate),yearfrac(StartPoint,MaturityDate)/(busdate(MaturityDate)- busdate(StartPoint)),OptionsValues2 , ...
        strcat('Option Paths with Maturity ',MaturityDate, ' Strike=', num2str(Strike),', Trial ',num2str(t))  , 'Time [Years]','Value [€]', graphSwitch,savePath );
    mOptionsValues2 = mean(OptionsValues2);
    nfig= nfig + 1;
    
    MaturityDate = '02-January-2018';
    OptionsValues3 = getExposureForOption(Assets,TradingDays,MaturityDate,Rate,Strike,Volatility);
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,MaturityDate),yearfrac(StartPoint,MaturityDate)/(busdate(MaturityDate)- busdate(StartPoint)),OptionsValues3, ...
        strcat('Option Paths with Maturity ',MaturityDate, 'Strike=', num2str(Strike),', Trial ', num2str(t))  , 'Time [Years]','Value [€]', graphSwitch,savePath );
    mOptionsValues3= mean(OptionsValues3);
    nfig= nfig + 1;

    mProducts = {mOptionsValues1,mOptionsValues2,mOptionsValues3};

    ExpectedExposure = calculateExpectedExposure(mProducts);
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,EndPoint),yearfrac(StartPoint,EndPoint)/(busdate(EndPoint)- busdate(StartPoint)), ...
        ExpectedExposure, strcat('Expected Exposure For Portfolio 3',', Trial', num2str(t)),'Time[Years]','Value [%]',graphSwitch,savePath);
    nfig= nfig + 1;
    
    Products = {OptionsValues1,OptionsValues2,OptionsValues3 };
    
    Portfolio3FullSim{t} = Products;
    
 end   
 
    Portfolio3 = struct;
    Portfolio3.StartPoint = '02-January-2013';
    Portfolio3.EndPoint = '02-January-2018';
    Portfolio3.data = Portfolio3FullSim;
    
    save('portfolio3','Portfolio3');

    matlabpool close