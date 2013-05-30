% StartDates = '02-January-2013';
% EndDates = {'02-April-2013'; '02-October-2013'; '02-April-2014'};
% Rates = [0.05;0.06;0.07];
% 
% RateSpec = intenvset('Rates', Rates, 'StartDates',StartDates,...
% 'EndDates', EndDates, 'Compounding', 1);
% 
% Settle = '02-January-2013';
% Maturity = '02-April-2014';
% LegRate = [0.08 0]; 
% Principal = [100];  % Three notional amounts
% 
% Price = swapbyzero(RateSpec, LegRate, Settle, Maturity, 'Principal', Principal)


StartDates = '01-May-2012'; 
EndDates = {'01-May-2013'; '01-May-2014';'01-May-2015';'01-May-2016'};
Rates = [[0.0356;0.041185;0.04489;0.047741],[0.0366;0.04218;0.04589;0.04974]];

RateSpec = intenvset('Rates', Rates, 'StartDates',StartDates,...
'EndDates', a, 'Compounding', 1)

Settle = '01-May-2012';
Maturity = '01-May-2015';
LegRate = [0.06 150]; 
Principal = [100;50;100];  % Three notional amounts

Price = swapbyzero(RateSpec, LegRate, Settle, Maturity, 'Principal', Principal)
