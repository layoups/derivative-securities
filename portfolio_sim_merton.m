clc
clear all


%% simulation parameters
returns_mat = table_to_list("Returns Data.csv", 0);
prices_mat = table_to_list("Stock Data.csv", 0);

corr_returns = corrcoef(returns_mat);
corr_prices = corrcoef(prices_mat);

mean_returns = 360 * diag(mean(returns_mat));
sigma = sqrt(360) * diag(std(returns_mat));
start = prices_mat(end, :)';

DeltaTime = 1/360;
nobs = 360;
nTrials = 5;

num = size(sigma);

rate = 0.04;
T = 1;
num_options = 7;

%% multi jump 
JumpMean = table_to_list("jumps.csv", 2)';
JumpVol = table_to_list("jumps.csv", 3)';
JumpFreq = 252/10;

mert = merton(mean_returns, sigma, ...
    JumpFreq, JumpMean, JumpVol, ...
    'StartState', start, ...
    'correlation', corr_returns);

%% jump sim
merton_stocks = simulate(mert, nobs, ...
 'DeltaTime', DeltaTime, ...
 'nTrials', nTrials);

[merton_returns, merton_pffs] = all_stock_returns(merton_stocks, @stock_returns);
%% call options
[merton_call_returns, merton_call_prices, merton_call_strikes, merton_call_pffs] = ... 
    all_eu(merton_stocks, num_options, @price_call, @call_returns, ...
    rate, T, nTrials);

%% put options
[merton_put_returns, merton_put_prices, merton_put_strikes, merton_put_pffs] = ... 
    all_eu(merton_stocks, num_options, @price_put, @put_returns, ...
    rate, T, nTrials);

%% Amp options
[merton_amp_returns, merton_amp_prices, merton_amp_pffs] = all_lookbacks(merton_stocks, ...
    rate, T, @price_lookback, @amplitude_payoff, nTrials);

%% final max options
[merton_max_returns, merton_max_prices, merton_max_pffs] = all_lookbacks(merton_stocks, ...
    rate, T, @price_lookback, @final_max_payoff, nTrials);

%% min final options
[merton_min_returns, merton_min_prices, merton_min_pffs] = all_lookbacks(merton_stocks, ...
    rate, T, @price_lookback, @min_final_payoff, nTrials);

%% optimize
[x, fval, sharpe, rt, mu, sig] = opti(start, merton_returns, merton_pffs, ...
    merton_call_prices, merton_call_returns, merton_call_pffs, ...
    merton_put_prices, merton_put_returns, merton_put_pffs, ...
    merton_amp_prices, merton_amp_returns, merton_amp_pffs, ...
    merton_max_prices, merton_max_returns, merton_max_pffs, ...
    merton_min_prices, merton_min_returns, merton_min_pffs);
