clc
clear all


%% simulation parameters
returns_mat = table_to_list("Returns Data.csv", 0);
prices_mat = table_to_list("Stock Data.csv", 0);

corr_returns = corrcoef(returns_mat);
corr_prices = corrcoef(prices_mat);

mean_returns = diag(mean(returns_mat));
sigma = diag(std(returns_mat));
start = prices_mat(end, :)';

DeltaTime = 1/360;
nobs = 360;
nTrials = 100;

num = size(sigma);

rate = 0.04;
T = 1;
num_options = 7;

%% CEV parameters
alphas = table_to_list("stock_gammas.csv", 0)';

%% CEV model
CEV = cev(mean_returns, alphas, sigma, ...
    'StartState', start, ...
    'correlation', corr_returns);

%% CEV sim
CEV_stocks = simulate(CEV, nobs, ...
 'DeltaTime', DeltaTime, ...
 'nTrials', nTrials);

[CEV_returns, CEV_pffs] = all_stock_returns(CEV_stocks, @stock_returns);
%% call options
[CEV_call_returns, CEV_call_prices, CEV_call_strikes, CEV_call_pffs] = ... 
    all_eu(CEV_stocks, num_options, @price_call, @call_returns, ...
    rate, T, nTrials);

%% put options
[CEV_put_returns, CEV_put_prices, CEV_put_strikes, CEV_put_pffs] = ... 
    all_eu(CEV_stocks, num_options, @price_put, @put_returns, ...
    rate, T, nTrials);

%% Amp options
[CEV_amp_returns, CEV_amp_prices, CEV_amp_pffs] = all_lookbacks(CEV_stocks, ...
    rate, T, @price_lookback, @amplitude_payoff, nTrials);

%% final max options
[CEV_max_returns, CEV_max_prices, CEV_max_pffs] = all_lookbacks(CEV_stocks, ...
    rate, T, @price_lookback, @final_max_payoff, nTrials);

%% min final options
[CEV_min_returns, CEV_min_prices, CEV_min_pffs] = all_lookbacks(CEV_stocks, ...
    rate, T, @price_lookback, @min_final_payoff, nTrials);

%% options

[x, fval, sharpe, rt, mu, sig] = opti(start, CEV_returns, CEV_pffs, ...
    CEV_call_prices, CEV_call_returns, CEV_call_pffs, ...
    CEV_put_prices, CEV_put_returns, CEV_put_pffs, ...
    CEV_amp_prices, CEV_amp_returns, CEV_amp_pffs, ...
    CEV_max_prices, CEV_max_returns, CEV_max_pffs, ...
    CEV_min_prices, CEV_min_returns, CEV_min_pffs);
