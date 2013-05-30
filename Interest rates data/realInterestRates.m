readInHistData

plot(ratesContainer(:,1), ratesContainer(:,2));
datetick('x'), xlabel('Date'), ylabel('Daily Yield (%)')
title('3-Month Euribor as a Daily Effective Yield')

yields     = ratesContainer(:,2);

regressors = [ones(length(yields) - 1, 1) yields(1:end-1)];
[coefficients, intervals, residuals] = ...
   regress(diff(yields), regressors);
dt    = 1;  % time increment = 1 day
speed = -coefficients(2)/dt;
level = -coefficients(1)/coefficients(2);
sigma =  std(residuals)/sqrt(dt);

obj = hwv(speed, level, sigma, 'StartState', yields(end))

%Trading days
T      = 2048;
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
    delta = delta / 2;
end

average = obj.StartState * exp(-speed * T) + level *(1 - exp(-speed * T));
X       = [obj.StartState ; average];


nTrials = 10;
rng(63349,'twister')
Y = obj.interpolate(t, X(:,:,ones(nTrials,1)),'Times',[obj.StartTime  T], 'Refine', true);

[t,i] = sort(t);
Y     = squeeze(Y);
Y     = Y(i,:);

A = transpose(Y);
A = sum(A);
Y  = A/nTrials;


plot(t,Y), hold('on')
plot(t([1 end]), Y([1 end],1),'. black','MarkerSize',20)
xlabel('Interpolation Time (Days into the Future)')
ylabel('Yield (%)'), hold('off')
title ('Euribor Yields')
saveas(h,strcat('interestRatesExample','.jpg'))
