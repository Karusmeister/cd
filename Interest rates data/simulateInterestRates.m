function [ rates ] = simulateInterestRates( days, speed, level, sigma, startState,nTrials,genState)
% days - number of trading days 
% speed - 
% level -
% sigma
% startState

obj = hwv(speed, level, sigma, 'StartState',startState);
%Trading days
A = nextpow2(days);
T      = 2^A;
times  = (1:T)';
t      = NaN(length(times) + 1, 1);
t(1)   = obj.StartTime;
t(2)   = T;
delta  = T;
jMax   = 1;
iCount = 3;

for k = 1:log2(T)
    i = delta / 2;
    for j = 1:jMax
        t(iCount) = times(i);
        i         = i + delta;
        iCount    = iCount + 1;
    end
    jMax  = 2 * jMax;
    delta =delta / 2;
end

average = obj.StartState * exp(-speed * T) + level *(1 - exp(-speed * T));
X       = [obj.StartState ; average];


rng(genState,'twister')
Y = obj.interpolate(t, X(:,:,ones(nTrials,1)),'Times',[obj.StartTime  T], 'Refine', true);

[t,i] = sort(t);
Y     = squeeze(Y);
Y     = Y(i,:);

rates = Y(1:days,:);

% plot(t,Y), hold('on')
% plot(t([1 end]), Y([1 end],1),'. black','MarkerSize',20)
% xlabel('Interpolation Time (Days into the Future)')
% ylabel('Yield (%)'), hold('off')
% title ('Euribor Yields from Brownian Bridge Interpolation')

end

