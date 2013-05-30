StartPoint = '02-January-2013';
EndPoint = '02-January-2023';

TradingDays = busdays(StartPoint,EndPoint);

StartPoint = busdate(StartPoint);

% params for interest rate model
% params in % - nedd to bi
speed = 0.005;
level = 2;
sigma = 0.005;
startState = 1;

[days, values] = size(TradingDays);

rates = simulateInterestRates(days,speed,level,sigma,startState);
%adjusting to foramt reuired by RateSpec
rates = rates/100;
StartDates = '02-January-2012';

RateSpec = intenvset('Rates', rates, 'StartDates',StartDates,...
 'EndDates', TradingDays, 'Compounding', 1);


Maturity = TradingDays(100,1);

LegRate = [0.03 10]; 
Principal = [100];  % Three notional amounts

values = getExposureForInterestRateSwaps(StartPoint,Maturity,RateSpec,LegRate,Principal );
[n,~] = size(values);

makePlot(TimeLength/year,TimeLength/(n*year),values',strcat('Interest Swap Values with Maturity ',datestr(Maturity)),'Time[Years]','Value [€]',true);


