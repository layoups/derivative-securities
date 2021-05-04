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

aapl_merton_sim = squeeze(merton_stocks(:, 1, :));
jpm_merton_sim = squeeze(merton_stocks(:, 2, :));
pfe_merton_sim = squeeze(merton_stocks(:, 3, :));
tsla_merton_sim = squeeze(merton_stocks(:, 4, :));
cvx_merton_sim = squeeze(merton_stocks(:, 5, :));
dal_merton_sim = squeeze(merton_stocks(:, 6, :));

%% call options
[aapl_merton_call_price, aapl_strikes] = price_call(aapl_merton_sim, 5, 90, 130, nTrials, rate, T);

[jpm_merton_call_price, jpm_strikes] = price_call(jpm_merton_sim, 5, 90, 130, nTrials, rate, T);

[pfe_merton_call_price, pfe_strikes] = price_call(pfe_merton_sim, 5, 90, 130, nTrials, rate, T);

[tsla_merton_call_price, tsla_strikes] = price_call(tsla_merton_sim, 5, 90, 130, nTrials, rate, T);

[cvx_merton_call_price, cvx_strikes] = price_call(cvx_merton_sim, 5, 90, 130, nTrials, rate, T);

[dal_merton_call_price, dal_strikes] = price_call(dal_merton_sim, 5, 90, 130, nTrials, rate, T);

%% put options
[aapl_merton_put_price, aapl_strikes] = price_put(aapl_merton_sim, 5, 90, 130, nTrials, rate, T);

[jpm_merton_put_price, jpm_strikes] = price_put(jpm_merton_sim, 5, 90, 130, nTrials, rate, T);

[pfe_merton_put_price, pfe_strikes] = price_put(pfe_merton_sim, 5, 90, 130, nTrials, rate, T);

[tsla_merton_put_price, tsla_strikes] = price_put(tsla_merton_sim, 5, 90, 130, nTrials, rate, T);

[cvx_merton_put_price, cvx_strikes] = price_put(cvx_merton_sim, 5, 90, 130, nTrials, rate, T);

[dal_merton_put_price, dal_strikes] = price_put(dal_merton_sim, 5, 90, 130, nTrials, rate, T);

%% Amp options
aapl_merton_amp_price = price_lookback(aapl_merton_sim, rate, T, @amplitude_payoff);

jpm_merton_amp_price = price_lookback(jpm_merton_sim, rate, T, @amplitude_payoff);

pfe_merton_amp_price = price_lookback(pfe_merton_sim, rate, T, @amplitude_payoff);

tsla_merton_amp_price = price_lookback(tsla_merton_sim, rate, T, @amplitude_payoff);

cvx_merton_amp_price = price_lookback(cvx_merton_sim, rate, T, @amplitude_payoff);

dal_merton_amp_price = price_lookback(dal_merton_sim, rate, T, @amplitude_payoff);

%% final max options
aapl_merton_max_price = price_lookback(aapl_merton_sim, rate, T, @final_max_payoff);

jpm_merton_max_price = price_lookback(jpm_merton_sim, rate, T, @final_max_payoff);

pfe_merton_max_price = price_lookback(pfe_merton_sim, rate, T, @final_max_payoff);

tsla_merton_max_price = price_lookback(tsla_merton_sim, rate, T, @final_max_payoff);

cvx_merton_max_price = price_lookback(cvx_merton_sim, rate, T, @final_max_payoff);

dal_merton_max_price = price_lookback(dal_merton_sim, rate, T, @final_max_payoff);

%% min final options
aapl_merton_min_price = price_lookback(aapl_merton_sim, rate, T, @min_final_payoff);

jpm_merton_min_price = price_lookback(jpm_merton_sim, rate, T, @min_final_payoff);

pfe_merton_min_price = price_lookback(pfe_merton_sim, rate, T, @min_final_payoff);

tsla_merton_min_price = price_lookback(tsla_merton_sim, rate, T, @min_final_payoff);

cvx_merton_min_price = price_lookback(cvx_merton_sim, rate, T, @min_final_payoff);

dal_merton_min_price = price_lookback(dal_merton_sim, rate, T, @min_final_payoff);