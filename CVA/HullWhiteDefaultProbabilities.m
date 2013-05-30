function [ h,dp ] = HullWhiteDefaultProbabilities( ExpectedExposures, Tvals, bFactor, Spread, Rate)

syms x;

[nExposures,len] = size(ExpectedExposures);
[~,ts] = size(Tvals);

assert(len == ts,'EE length and Tvals len must be the same');
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

        
            for i = 1:ts

              a = (sum(h(j,1:(i))));
              b =  mean(a);
              meanHazardRate = b/(i);

              d1 =  exp(-meanHazardRate*Tvals(i));
              defProb = 1 - d1;

              dp(j,i) = defProb;

            end

        end

end


