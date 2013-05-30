function [ ExpectedExposure ] = calculateExpectedExposure( Products )


maxDimension = 0;

[~, nProd] = size(Products);

for i=1:nProd
    
    prod = Products{nProd};
    [~,n] = size(prod);
    maxDimension = max(maxDimension,n);
    
end


ExpectedExposure = zeros(1,maxDimension);

    for j=1:nProd

        prod = Products{j};
        [~,n] = size(prod);

        for i=1:n
            value = prod(1,i);
            if (value>0)
                ExpectedExposure(1,i) = ExpectedExposure(1,i) + value;
            end
        end
    end
end

