function [Values] = getExposureForInterestRateSwaps( Start,Maturity,RateSpec, LegRate,Principal, CouponFrequency )

Values= [];

    for i = Start: (Maturity-1)
        
        if (isbusday(i))
            if(Maturity < i || i == Maturity)
                a=0;
            end
            Price = swapbyzero(RateSpec, LegRate, i, Maturity, 'Principal', Principal, 'LegReset' ,CouponFrequency);
            Values = [Values ; Price];
        end

    end

end

