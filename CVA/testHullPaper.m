

syms x;

ExpectedExposures = [100 100;200 300;300 400];
Tvals = [0.5 1];
bFactor = 0.01;
Rate = 0;
Spread = 0.01;
[nExposures,~] = size(ExpectedExposures);
[~,ts] = size(Tvals);

%hazard rates matrix for assets 
h = zeros(nExposures,ts);
dt = Tvals(2) - Tvals(1);

%finding a term and hazard rates for each path
    for i = 1:ts
        
       eq = 0;

       term = exp(-(Spread*Tvals(i)/(1-Rate)));

       for j=1:nExposures    
            eq = eq + exp(-1*exp(x+bFactor*ExpectedExposures(j,i))*dt);
       end

       ai = solve(eq == nExposures*term,x);
       ai = double(ai);

       for j=1:nExposures  

            hji = exp(ai + bFactor*ExpectedExposures(j,i));
            h(j,i+1) = hji;

       end

    end
    
    
    dp = zeros(nExposures,ts);
    
        for j=1:nExposures

        dp(j,1) = 0;
        
            for i = 2:ts

              a = (sum(h(j,1:(i-1))));
              b =  mean(a);
              meanHazardRate = b/(i-1);

              d1 =  exp(-meanHazardRate*Tvals(i));
              d2 =  exp(-meanHazardRate*Tvals(i-1));
              defProb = d2 - d1 ;

              dp(j,i) = defProb;

            end

        end
        
        dp
        
        h
        
   
    