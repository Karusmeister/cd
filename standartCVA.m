function [ CVA ] = Untitled4( EcpectedExposures,RecoveryRate,Spread)
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


end

