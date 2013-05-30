clf

%%%%%%%%%%%%%%%%%%%%% Problem parameters %%%%%%%%%%%%%%%%%%%%%%%
S = 1; mu = 0.05; sigma = 0.5; L = 1e2; T = 1; dt = T/L; M = 50;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp = S;

Svals = [S];

for t=1:100
   
    
    temp =  nextAssetValue(temp, mu, sigma, dt);
    Svals = [Svals temp];
    
end
tvals = [0:dt:T];
plot(tvals,Svals)
title('50 asset paths')
xlabel('t'), ylabel('S(t)')