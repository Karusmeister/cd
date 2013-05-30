function [ AssetsPaths ] = simulateAssetsPaths(nTrials,years,dt,StartValue,sigma,mu,state)

%simulating daily values
% !!!consider changing to more frequent value
randn('state',state)
clf

T = round(years/dt);

AssetsPaths = StartValue*cumprod(exp((mu-0.5*sigma^2)*dt + sigma*sqrt(dt)*randn(nTrials,T)),2);
AssetsPaths = [StartValue*ones(nTrials,1) AssetsPaths];  


% plot(tvals,AssetsPaths)
% title('50 asset paths')
% xlabel('t'), ylabel('S(t)')
% figure();

end

