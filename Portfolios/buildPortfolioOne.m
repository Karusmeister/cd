matlabpool open local 4

L = log4m.getLogger('logfile.txt');
L.setCommandWindowLevel(L.ALL); 
trials = 3;

Portfolio1FullSim = {};
states = [99,100,101];
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
    initialAssetValue = 100; mu = 0.02; sigma = 0.1; 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Strike = 105; Rate = 0.02; Volatility = sigma;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %simulateAssetsPaths(nTrials,days,StartValue,sigma,mu)

    Assets = simulateAssetsPaths(nTrials,yearfrac(StartPoint,EndPoint), ...
    yearfrac(StartPoint,EndPoint)/(busdate(EndPoint)- busdate(StartPoint)),initialAssetValue,sigma,mu,states(t));
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,EndPoint),yearfrac(StartPoint,EndPoint)/(busdate(EndPoint)- busdate(StartPoint)),Assets, ...
        strcat('Simulated Asset Paths, Trial ',num2str(t)), 'Time [Years]','Value [€]',graphSwitch,savePath );
    nfig= nfig + 1;


    MaturityDate = '02-January-2014';
    OptionsValues1 = getExposureForOption(Assets,TradingDays,MaturityDate,Rate,Strike,Volatility);
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,MaturityDate),yearfrac(StartPoint,MaturityDate)/(busdate(MaturityDate)- busdate(StartPoint)),OptionsValues1, ...
        strcat('Option with Maturity ',MaturityDate, ' Strike=', num2str(Strike),', Trial ', num2str(t))  , 'Time [Years]','Value [€]', graphSwitch,savePath);
    mOptionsValues1 = mean(OptionsValues1);
    nfig= nfig + 1;
    
    MaturityDate = '02-January-2015';
    OptionsValues2 = getExposureForOption(Assets,TradingDays,MaturityDate,Rate,Strike,Volatility);
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,MaturityDate),yearfrac(StartPoint,MaturityDate)/(busdate(MaturityDate)- busdate(StartPoint)),OptionsValues2 , ...
        strcat('Option Paths with Maturity ',MaturityDate, ' Strike=', num2str(Strike),', Trial ',num2str(t))  , 'Time [Years]','Value [€]', graphSwitch,savePath );
    mOptionsValues2 = mean(OptionsValues2);
    nfig= nfig + 1;
    
    MaturityDate = '02-January-2016';
    OptionsValues3 = getExposureForOption(Assets,TradingDays,MaturityDate,Rate,Strike,Volatility);
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,MaturityDate),yearfrac(StartPoint,MaturityDate)/(busdate(MaturityDate)- busdate(StartPoint)),OptionsValues3, ...
        strcat('Option Paths with Maturity ',MaturityDate, 'Strike=', num2str(Strike),', Trial ', num2str(t))  , 'Time [Years]','Value [€]', graphSwitch,savePath );
    mOptionsValues3= mean(OptionsValues3);
    nfig= nfig + 1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Adding interest rate swaps to portfolio %%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    StartPoint = busdate(StartPoint);

    %%%%%%%%%%%%%%%%%%%%%%%%%% params for interest rate model%%%%%%%%%%%%%%

    % params in % - nedd to bi
    speed = 0.005;
    level = 3;
    sigma = 0.0025;
    startState = 1;

    IRstart = '02-January-2013';

    modelLength= busdays(IRstart ,EndPoint);
    [rows,~] = size(modelLength);
    

    rates = simulateInterestRates(rows,speed,level,sigma,startState,nTrials,genStates(t));
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,EndPoint),yearfrac(StartPoint,EndPoint)/(busdate(EndPoint)- busdate(StartPoint)), ...
        rates', strcat('Interest Rate Paths, Trial ', num2str(t)),'Time[Years]','Value [%]',graphSwitch,savePath);
    nfig= nfig + 1;
    
    %adjusting to foramt reuired by RateSpec
    rates = rates/100;
    StartDates = '02-January-2012';

    % model output
    RateSpec = intenvset('Rates', rates, 'StartDates',StartDates,...
     'EndDates', TradingDays, 'Compounding', 1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % common values for swap
    LegRate = [0.03 10]; 
    Principal = [100];  % Three notional amounts
    CouponFrequency = [1 1];

    %%% 1st swap 
    Maturity = busdate('02-January-2017');

    Swap1 = getExposureForInterestRateSwaps(StartPoint,Maturity,RateSpec,LegRate,Principal,CouponFrequency );
    [n,~] = size(Swap1);
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,Maturity),yearfrac(StartPoint,Maturity)/n,Swap1', ...
        strcat('Interest Rate Swap with Maturity ',datestr(Maturity), ...
        ' Coupon 3% and 10 bp',', Trial', num2str(t)),'Time[Years]','Value [€]',graphSwitch,savePath);
    nfig= nfig + 1;
    Swap1 = Swap1';
    mSwap1 = mean(Swap1);

    %%%% 2nd swap
    Maturity = busdate('02-January-2018');

    Swap2 = getExposureForInterestRateSwaps(StartPoint,Maturity,RateSpec,LegRate,Principal,CouponFrequency );
    [n,~] = size(Swap2);
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,Maturity),yearfrac(StartPoint,Maturity)/n,Swap2', ...
        strcat('Interest Swap Values with Maturity ',datestr(Maturity), ...
        ' Coupon 3% and 10 bp',', Trial', num2str(t)),'Time[Years]','Value [€]',graphSwitch,savePath);
    nfig= nfig + 1;
    Swap2= Swap2';
    mSwap2 = mean(Swap2);


    mProducts = {mOptionsValues1,mOptionsValues2,mOptionsValues3,mSwap1,mSwap2};

    ExpectedExposure = calculateExpectedExposure(mProducts);
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,EndPoint),yearfrac(StartPoint,EndPoint)/(busdate(EndPoint)- busdate(StartPoint)), ...
        ExpectedExposure, strcat('Expected Exposure For Portfolio 1',', Trial', num2str(t)),'Time[Years]','Value [%]',graphSwitch,savePath);
    nfig= nfig + 1;
    
    Products = {OptionsValues1,OptionsValues2,OptionsValues3,Swap1,Swap2 };
    
    Portfolio1FullSim{t} = Products;
    
 end   
 
    Portfolio1 = struct;
    Portfolio1.StartPoint = '02-January-2013';
    Portfolio1.EndPoint = '02-January-2018';
    Portfolio1.data = Portfolio1FullSim;
    
    save('portfolio1','Portfolio1');

    matlabpool close