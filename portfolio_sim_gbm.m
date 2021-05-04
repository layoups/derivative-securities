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
nTrials = 1;

num = size(sigma);

rate = 0.04;
T = 1;

%% multi gbm
gbm = gbm(mean_returns, sigma, ...
    'StartState', start, ...
    'correlation', corr_returns);

%% multi gbm simulation
gbm_stocks = simulate(gbm, nobs, ...    
    'DeltaTime', DeltaTime,...    
    'nTrials', nTrials);

aapl_gbm_sim = squeeze(gbm_stocks(:, 1, :));
jpm_gbm_sim = squeeze(gbm_stocks(:, 2, :));
pfe_gbm_sim = squeeze(gbm_stocks(:, 3, :));
tsla_gbm_sim = squeeze(gbm_stocks(:, 4, :));
cvx_gbm_sim = squeeze(gbm_stocks(:, 5, :));
dal_gbm_sim = squeeze(gbm_stocks(:, 6, :));

%% call options
[aapl_gbm_call_price, aapl_strikes] = price_call(aapl_gbm_sim, 5, round(aapl_gbm_sim(end) * (0.85)), round(aapl_gbm_sim(end) * (1.15)), nTrials, rate, T);

[jpm_gbm_call_price, jpm_strikes] = price_call(jpm_gbm_sim, 5, round(jpm_gbm_sim(end) * (0.85)), round(jpm_gbm_sim(end) * (1.15)), nTrials, rate, T);

[pfe_gbm_call_price, pfe_strikes] = price_call(pfe_gbm_sim, 5, round(pfe_gbm_sim(end) * (0.85)), round(pfe_gbm_sim(end) * (1.15)), nTrials, rate, T);

[tsla_gbm_call_price, tsla_strikes] = price_call(tsla_gbm_sim, 5, round(tsla_gbm_sim(end) * (0.85)), round(tsla_gbm_sim(end) * (1.15)), nTrials, rate, T);

[cvx_gbm_call_price, cvx_strikes] = price_call(cvx_gbm_sim, 5, round(cvx_gbm_sim(end) * (0.85)), round(cvx_gbm_sim(end) * (1.15)), nTrials, rate, T);

[dal_gbm_call_price, dal_strikes] = price_call(dal_gbm_sim, 5, round(dal_gbm_sim(end) * (0.85)), round(dal_gbm_sim(end) * (1.15)), nTrials, rate, T);

%% put options
[aapl_gbm_put_price, aapl_strikes] = price_put(aapl_gbm_sim, 5, round(aapl_gbm_sim(end) * (0.85)), round(aapl_gbm_sim(end) * (1.15)), nTrials, rate, T);

[jpm_gbm_put_price, jpm_strikes] = price_put(jpm_gbm_sim, 5, round(jpm_gbm_sim(end) * (0.85)), round(jpm_gbm_sim(end) * (1.15)), nTrials, rate, T);

[pfe_gbm_put_price, pfe_strikes] = price_put(pfe_gbm_sim, 5, round(pfe_gbm_sim(end) * (0.85)), round(pfe_gbm_sim(end) * (1.15)), nTrials, rate, T);

[tsla_gbm_put_price, tsla_strikes] = price_put(tsla_gbm_sim, 5, round(tsla_gbm_sim(end) * (0.85)), round(tsla_gbm_sim(end) * (1.15)), nTrials, rate, T);

[cvx_gbm_put_price, cvx_strikes] = price_put(cvx_gbm_sim, 5, round(cvx_gbm_sim(end) * (0.85)), round(cvx_gbm_sim(end) * (1.15)), nTrials, rate, T);

[dal_gbm_put_price, dal_strikes] = price_put(dal_gbm_sim, 5, round(dal_gbm_sim(end) * (0.85)), round(dal_gbm_sim(end) * (1.15)), nTrials, rate, T);

%% Amp options
aapl_gbm_amp_price = price_lookback(aapl_gbm_sim, rate, T, @amplitude_payoff);

jpm_gbm_amp_price = price_lookback(jpm_gbm_sim, rate, T, @amplitude_payoff);

pfe_gbm_amp_price = price_lookback(pfe_gbm_sim, rate, T, @amplitude_payoff);

tsla_gbm_amp_price = price_lookback(tsla_gbm_sim, rate, T, @amplitude_payoff);

cvx_gbm_amp_price = price_lookback(cvx_gbm_sim, rate, T, @amplitude_payoff);

dal_gbm_amp_price = price_lookback(dal_gbm_sim, rate, T, @amplitude_payoff);

%% final max options
aapl_gbm_max_price = price_lookback(aapl_gbm_sim, rate, T, @final_max_payoff);

jpm_gbm_max_price = price_lookback(jpm_gbm_sim, rate, T, @final_max_payoff);

pfe_gbm_max_price = price_lookback(pfe_gbm_sim, rate, T, @final_max_payoff);

tsla_gbm_max_price = price_lookback(tsla_gbm_sim, rate, T, @final_max_payoff);

cvx_gbm_max_price = price_lookback(cvx_gbm_sim, rate, T, @final_max_payoff);

dal_gbm_max_price = price_lookback(dal_gbm_sim, rate, T, @final_max_payoff);

%% min final options
aapl_gbm_min_price = price_lookback(aapl_gbm_sim, rate, T, @min_final_payoff);

jpm_gbm_min_price = price_lookback(jpm_gbm_sim, rate, T, @min_final_payoff);

pfe_gbm_min_price = price_lookback(pfe_gbm_sim, rate, T, @min_final_payoff);

tsla_gbm_min_price = price_lookback(tsla_gbm_sim, rate, T, @min_final_payoff);

cvx_gbm_min_price = price_lookback(cvx_gbm_sim, rate, T, @min_final_payoff);

dal_gbm_min_price = price_lookback(dal_gbm_sim, rate, T, @min_final_payoff);