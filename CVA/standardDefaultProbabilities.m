function [ dp ] = standardDefaultProbabilities( RecoveryRate, Spread, Tvals )

        dp = [];
         
        [~,Points] = size(Tvals);
        
        dp(1) = 0;
        
        for i = 2:(Points)        
            
            
            dp(i) = exp(-((Spread*Tvals(i-1))/(1-RecoveryRate)))- ...
                exp(-((Spread*Tvals(i))/(1-RecoveryRate)));
        
        end
        
end

