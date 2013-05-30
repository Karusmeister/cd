function [ OptionsValues ] = getExposureForOption(Assets,TradingDays,MaturityDate,Rate,Strike,Volatility)


TimeInYears = yearfrac(TradingDays(1,1),busdate(MaturityDate));


optionVals = [];
[nTrials,l] = size(Assets);

dt = TimeInYears/l;
for j=1:nTrials
    
    tempOptionVals = [];
    tempVals = Assets(j,:);
    index = 1;
    Time = TimeInYears;
    
        for i = dt:dt:TimeInYears
            
            AssetValue = tempVals(index);

            Time = Time - dt;
                if (Time<0)
                    Time=0;
                end   

            [Call, Put] = blsprice(AssetValue, Strike, Rate, Time, Volatility);
           
            tempOptionVals = [tempOptionVals Call];

            index = index + 1;
        end
    
    optionVals = [optionVals; tempOptionVals];
    
end

OptionsValues = optionVals;

% tvals = [0:dt:TimeInYears];
% 
% [~,cols] = size(tvals);
% 
% plot(tvals,Assets(:,1:cols));
% title('Option Values paths')
% xlabel('t'), ylabel('AssetValue(t)');
% figure();
% 
% plot(tvals,optionVals);
% title('Option Values paths')
% xlabel('t'), ylabel('OptionValue(t)');
% 
% ExpectedExposure = mean(optionVals);


end

