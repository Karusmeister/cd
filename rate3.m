Settle = '01-Jan-2000';
Maturity = '01-Jan-2003';
Basis = 0; 
Principal = 100;
LegRate = [0.06 20]; % [CouponRate Spread] 
LegType = [1 0]; % [Fixed Float] 
LegReset = [1 1]; % Payments once per year 

Price = swapbyzero(0.02, LegRate, Settle, Maturity,... 
LegReset, Basis, Principal, LegType)