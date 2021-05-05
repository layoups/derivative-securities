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
nTrials = 5;

num = size(sigma);

rate = 0.04;
T = 1;

num_options = 7;

%% multi gbm
gbm = gbm(mean_returns, sigma, ...
    'StartState', start, ...
    'correlation', corr_returns);

%% multi gbm simulation
gbm_stocks = simulate(gbm, nobs, ...    
    'DeltaTime', DeltaTime,...    
    'nTrials', nTrials);

gbm_returns = all_stock_returns(gbm_stocks, @stock_returns);
%% call options
[gbm_call_returns, gbm_call_prices, gbm_call_strikes] = ... 
    all_eu(gbm_stocks, num_options, @price_call, @call_returns, ...
    rate, T, nTrials);

%% put options
[gbm_put_returns, gbm_put_prices, gbm_put_strikes] = ... 
    all_eu(gbm_stocks, num_options, @price_put, @put_returns, ...
    rate, T, nTrials);

%% Amp options
[gbm_amp_returns, gbm_amp_prices] = all_lookbacks(gbm_stocks, ...
    rate, T, @price_lookback, @amplitude_payoff);

%% final max options
[gbm_max_returns, gbm_max_prices] = all_lookbacks(gbm_stocks, ...
    rate, T, @price_lookback, @final_max_payoff);

%% min final options
[gbm_min_returns, gbm_min_prices] = all_lookbacks(gbm_stocks, ...
    rate, T, @price_lookback, @min_final_payoff);
