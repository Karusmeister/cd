S = 0.01; mu = 0.01; sigma = 0.3; L = 2* 1e2; T = 2; dt = T/L; M = 10;

tvals = [0:dt:T];
Svals = S*cumprod(exp((mu-0.5*sigma^2)*dt + sigma*sqrt(dt)*randn(M,L)),2);
Svals = [S*ones(M,1) Svals];  % add initial asset price

values = mean(Svals);

[~,cols] = size(Svals);

gaussian = [];
for i=1:cols

   temp = max(0,values(i));
   gaussian = [gaussian temp];
    
end
rates = mean(Svals);
plot(tvals,gaussian)
title('Interest rates over 2 years')
xlabel('t'), ylabel('interest rates %')