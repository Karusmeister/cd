function [ CVAs ] = calculateCVA( ExpectedExposures, RecoveryRate, DP)


[nEE,vals] = size (ExpectedExposures);

    for i=1:nEE
        CVA(i,1) = (1-RecoveryRate)* DP(1)*(0 + ExpectedExposures(i,1))/2;
        
        for j=2:vals
            if (DP(j)<0.995)
                CVAs(i,j) = (1-RecoveryRate)* DP(j)*(ExpectedExposures(i,j)+ ExpectedExposures(i,j-1))/2;
            else
                CVAs(i,j) = 0.0;
            end
        end
    end


end

