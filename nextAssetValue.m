function nextValue = nextAssetValue( currentValue, mu, sigma, dt)

% number of vectors return by copularnd
N = 1;
% rho is a scalar correlation coefficient, copularnd generates U from a bivariate Gaussian copula.

% standartdeviation of credit default 
creditVariance = 0.01;

SIGMA = [ sigma*sigma creditVariance*sigma; creditVariance*sigma sigma*sigma];
MU = [ 0,0];

tau = -0.99;

rho = copulaparam('gaussian',tau);

% Generate dependent beta random values using that copula
U = copularnd('gaussian',rho,1);


nextValue = currentValue*(exp((mu-0.5*sigma^2)*dt + sigma*sqrt(dt)*randn(1)));

end

