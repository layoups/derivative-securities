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
[gbm_call_returns, gbm_call_prices, gbm_call_strikes, gbm_call_stds] = ... 
    all_eu(gbm_stocks, num_options, @price_call, @call_returns, ...
    rate, T, nTrials);

%% put options
[gbm_put_returns, gbm_put_prices, gbm_put_strikes, gbm_put_stds] = ... 
    all_eu(gbm_stocks, num_options, @price_put, @put_returns, ...
    rate, T, nTrials);

%% Amp options
[gbm_amp_returns, gbm_amp_prices, gbm_amp_stds] = all_lookbacks(gbm_stocks, ...
    rate, T, @price_lookback, @amplitude_payoff);

%% final max options
[gbm_max_returns, gbm_max_prices, gbm_max_stds] = all_lookbacks(gbm_stocks, ...
    rate, T, @price_lookback, @final_max_payoff);

%% min final options
[gbm_min_returns, gbm_min_prices, gbm_min_stds] = all_lookbacks(gbm_stocks, ...
    rate, T, @price_lookback, @min_final_payoff);

%% optimize with options

A = [start' gbm_call_prices(1,:) gbm_call_prices(2,:) ...
    gbm_call_prices(3,:) gbm_call_prices(4,:)...
    gbm_call_prices(5,:) gbm_call_prices(6,:) gbm_call_prices(7,:) ...
    gbm_call_prices(8,:)];
B = [100000];
lb = [zeros(1,6) -8*ones(1,48)];
ub = [100*ones(1,6) 8*ones(1,48)];
[x fval]= linprog(f, A, B, [], [],lb, ub);
expected_profit = -f*x
% P = [start'; gbm_call_prices(1,:); gbm_call_prices(2,:); ...
%     gbm_call_prices(3,:); gbm_call_prices(4,:);...
%     gbm_call_prices(5,:); gbm_call_prices(6,:);gbm_call_prices(7,:)...
%     gbm_call_prices(8,:)];
cost = x'* A'
%%
Q = [(aapl_gbm_sim(:,end)') (jpm_gbm_sim(:,end)')...   
     (pfe_gbm_sim(:,end)') (tsla_gbm_sim(:,end)')...
     (cvx_gbm_sim(:,end)') (dal_gbm_sim(:,end)')...
     gbm_call_prices(1,:) gbm_call_prices(2,:) ...
     gbm_call_prices(3,:) gbm_call_prices(4,:)...
     gbm_call_prices(5,:) gbm_call_prices(6,:) gbm_call_prices(7,:) ...
     gbm_call_prices(8,:)];
portfolio_prices_future = x'*Q'
portfolio_returns = (portfolio_prices_future- cost)/cost;
mu = mean(portfolio_returns);
%mu = (expected_profit)/cost
%sigma2 = std(A);
sharpe = mu/sigma2;
%sharpe_ratio = expected_profit/cost   
