
randn('state',100)

clf

%%%%%%%%%%%%%%%%%%%%% Problem parameters %%%%%%%%%%%%%%%%%%%%%%%
S = 100; mu = 0.2; sigma = 0.3; L = 1e2; T = 2; dt = T/L; M = 10;
%%%%%%%%%%%%%%%%%% Option contract features %%%%%%%%%%%%%%%%%%%
Strike = 160; Rate = 0.02; Time = T; Volatility = sigma;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tvals = [0:dt:T];
Svals = S*cumprod(exp((mu-0.5*sigma^2)*dt + sigma*sqrt(dt)*randn(M,L)),2);
Svals = [S*ones(M,1) Svals];  % add initial asset price

optionVals = [];



for j=1:M
    
    tempOptionVals = [];
    tempVals = Svals(j,:);
    index = 1;
    
    for i = 0:dt:T
    Price = tempVals(index);

    Time = Time - dt;
    if (Time<0)
        Time=0;
    end   
    
    [Call, Put] = blsprice(Price, Strike, Rate, Time, Volatility);
    tempOptionVals = [tempOptionVals Call];

    index = index + 1;
    end
    
    optionVals = [optionVals; tempOptionVals];
    
end

ExpectedExposure = mean(optionVals);

h = figure;
plot(tvals,optionVals)
title(M + 'call options values on assets')
xlabel('t'), ylabel('Call(t)')
figure();
%saveas(h,'optionValuesSim.jpg');
plot(tvals,Svals)
title('50 asset paths')
xlabel('t'), ylabel('S(t)')
figure();
%saveas(h,'optionValuesSim.jpg');
plot(tvals,ExpectedExposure)
title('Expected exposure for the portfolio')
xlabel('t'), ylabel('EE(t)')


%%%%%%%%%%%%%%%%%%% CVA standart approach %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R = 0.35; s = 0.0125;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

standartCVAvals= [];
[rows,cols] = size(optionVals);

for j=1:M
    
    tempCVA = 0;
    
        for i = 2:cols
    
        v = 0.5*(optionVals(j,i) + optionVals(j,i-1));
        q = exp(-((s*tvals(i-1))/(1-R)))-exp(-((s*tvals(i))/(1-R)));
    
        tempCVA = tempCVA + v*q;
    
        end
        
    tempCVA = (1-R)*tempCVA;
    standartCVAvals = [standartCVAvals; tempCVA];
    
end

%%%%%%%%%%%%%%%%%% Hull way of dealing with WWR%%%%%%%%%%%%%%%%%%%%%%%%%%%%
b = 0.01;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%hazard rates matrix for assets 
h = zeros(M,cols-1);
%finding a term and hazard rates for each path


syms x;

for i = 2:cols
    
   eq = 0;
   
   term = exp(-(s*tvals(i)/(1-R) ));
   
   for j=1:M    
        eq = eq + exp(-1*exp(x+b*optionVals(j,i))*dt);
   end
   
   ai = solve(eq == M*term,x);
   ai = double(ai);
   
   for j=1:M    
        hji = exp(ai + b*optionVals(j,i));
        h(j,i-1) = hji;
   end
    
end

%%%CVA Hull Way


CVAHull = [];

for j=1:M
    cva = 0;
    for i = 2:cols

      a = (sum(h(j,1:(i-1))));
      b =  mean(a);
      meanHazardRate = b/(i-1);
      d1 =  exp(-meanHazardRate*tvals(i));
      d2 =  exp(-meanHazardRate*tvals(i-1));
      defProb = d2 - d1 ;
      cva = cva + ((optionVals(j,i)+optionVals(j,i-1))/2)*defProb;
    end
    
    CVAHull(1,j) = (1-R)*cva;
    
end

IndependendCVA = mean(standartCVAvals)
HullCVA = mean(CVAHull)
lastCol = optionVals(:,101);
esposure = mean(lastCol)

