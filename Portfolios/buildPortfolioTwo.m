matlabpool open local 4

L = log4m.getLogger('logfile.txt');
L.setCommandWindowLevel(L.ALL); 
trials = 3;


Portfolio2FullSim = {};

states = [99,100,101];
genStates= [63348,63349,63350];
nTrials = 5;

    StartPoint = '02-January-2013';
    EndPoint = '02-January-2015';
   

 parfor t=1:trials
     
    L.info('Build Portfolio Two ', strcat('Trial ',num2str(t),' has started.'));
    
    StartPoint = '02-January-2013';
    EndPoint = '02-January-2015';

    graphSwitch  = and(true,globalGraphSwitch);
    nfig = 1;

    TradingDays = busdays(StartPoint,EndPoint);
    StartPoint = datenum(StartPoint);
    EndPoint = datenum(EndPoint);
    %nDays = busdate(EndPoint) - busdate(StartPoint);  

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Adding interest rate swaps to portfolio %%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    StartPoint = busdate(StartPoint);

    %%%%%%%%%%%%%%%%%%%%%%%%%% params for interest rate model%%%%%%%%%%%%%%

    % params in % - nedd to bi
    speed = 0.009;
    level = 5;
    sigma = 0.025;
    startState = 2;

    IRstart = '02-January-2013';

    modelLength= busdays(IRstart ,EndPoint);
    [rows,~] = size(modelLength);

    CouponFrequency = [1 1];

    
    rates = simulateInterestRates(rows,speed,level,sigma,startState,nTrials,genStates(t));
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,EndPoint),yearfrac(StartPoint,EndPoint)/(busdate(EndPoint)- busdate(StartPoint)), ...
        rates', strcat('Interest Rate Paths, Trial ', num2str(t)),'Time[Years]','Value [%]',graphSwitch, savePath);
    nfig= nfig + 1;
    
    %adjusting to foramt reuired by RateSpec
    rates = rates/100;
    StartDates = '02-January-2012';

    % model output
    RateSpec = intenvset('Rates', rates(2:end,:), 'StartDates',StartDates,...
     'EndDates', TradingDays(2:end,:), 'Compounding', -1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % common values for swap
    LegRate = [0.04 5]; 
    Principal = [100];  % Three notional amounts
    Period = 2;
    %%% 1st swap 
    Maturity = busdate('02-January-2014');

    Swap1 = getExposureForInterestRateSwaps(StartPoint,Maturity,RateSpec,LegRate,Principal,CouponFrequency );
    [n,~] = size(Swap1);
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    
    makePlot(yearfrac(StartPoint,Maturity),yearfrac(StartPoint,Maturity)/n,Swap1', ...
        strcat('Interest Rate Swap with Maturity ',datestr(Maturity), ...
        ' Coupon ', LegRate(1,1),' and ', LegRate(1,2), ' bp',', Trial', num2str(t)),'Time[Years]',strcat('Value [',char(8364),']'),graphSwitch,savePath);
    nfig= nfig + 1;
    Swap1 = Swap1';
    mSwap1 = mean(Swap1);

    %%%% 2nd swap
    Maturity = busdate('02-January-2015');

    Swap2 = getExposureForInterestRateSwaps(StartPoint,Maturity,RateSpec,LegRate,Principal,CouponFrequency );
    [n,~] = size(Swap2);
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,Maturity),yearfrac(StartPoint,Maturity)/n,Swap2', ...
        strcat('Interest Swap Values with Maturity ',datestr(Maturity), ...
        ' Coupon ', LegRate(1,1),' and ', LegRate(1,2), ' bp',', Trial', num2str(t)),'Time[Years]',strcat('Value [',char(8364),']'),graphSwitch,savePath);
    nfig= nfig + 1;
    Swap2= Swap2';
    mSwap2 = mean(Swap2);

    
        %%%% 3nd swap
        
    Maturity = busdate('02-January-2016');
    CouponFrequency = [2 2];
    
    Swap3 = getExposureForInterestRateSwaps(StartPoint,Maturity,RateSpec,LegRate,Principal,CouponFrequency );
    [n,~] = size(Swap3);
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,Maturity),yearfrac(StartPoint,Maturity)/n,Swap3', ...
        strcat('Interest Swap Values with Maturity ',datestr(Maturity), ...
        ' Coupon ', LegRate(1,1),' and ', LegRate(1,2), ' bp',', Trial', num2str(t)),'Time[Years]',strcat('Value [',char(8364),']'),graphSwitch,savePath);
    nfig= nfig + 1;
    Swap3 = Swap3';
    mSwap3 = mean(Swap3);

    mProducts = {mSwap1,mSwap2,mSwap3};

    ExpectedExposure = calculateExpectedExposure(mProducts);
    savePath = strcat('fig',num2str(nfig),'t',num2str(t));
    makePlot(yearfrac(StartPoint,EndPoint),yearfrac(StartPoint,EndPoint)/(busdate(EndPoint)- busdate(StartPoint)), ...
        ExpectedExposure, strcat('Expected Exposure For Portfolio 1',', Trial', num2str(t)),'Time[Years]',strcat('Value [',char(8364),']'),graphSwitch,savePath);
    nfig= nfig + 1;
    
    Products = {};
    Products = {Swap1,Swap2,Swap3};
    
    Portfolio2FullSim{t} = Products;

    
 end   

    Portfolio2 = struct;
    Portfolio2.StartPoint = '02-January-2013';
    Portfolio2.EndPoint = '02-January-2017';
    Portfolio2.data = Portfolio2FullSim;
    
 save('portfolio2','Portfolio2');

 matlabpool close