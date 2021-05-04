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

aapl_CEV_sim = squeeze(CEV_stocks(:, 1, :));
jpm_CEV_sim = squeeze(CEV_stocks(:, 2, :));
pfe_CEV_sim = squeeze(CEV_stocks(:, 3, :));
tsla_CEV_sim = squeeze(CEV_stocks(:, 4, :));
cvx_CEV_sim = squeeze(CEV_stocks(:, 5, :));
dal_CEV_sim = squeeze(CEV_stocks(:, 6, :));

%% call options
[aapl_CEV_call_price, aapl_strikes] = price_call(aapl_CEV_sim, 5, 90, 130, nTrials, rate, T);

[jpm_CEV_call_price, jpm_strikes] = price_call(jpm_CEV_sim, 5, 90, 130, nTrials, rate, T);

[pfe_CEV_call_price, pfe_strikes] = price_call(pfe_CEV_sim, 5, 90, 130, nTrials, rate, T);

[tsla_CEV_call_price, tsla_strikes] = price_call(tsla_CEV_sim, 5, 90, 130, nTrials, rate, T);

[cvx_CEV_call_price, cvx_strikes] = price_call(cvx_CEV_sim, 5, 90, 130, nTrials, rate, T);

[dal_CEV_call_price, dal_strikes] = price_call(dal_CEV_sim, 5, 90, 130, nTrials, rate, T);

%% put options
[aapl_CEV_put_price, aapl_strikes] = price_put(aapl_CEV_sim, 5, 90, 130, nTrials, rate, T);

[jpm_CEV_put_price, jpm_strikes] = price_put(jpm_CEV_sim, 5, 90, 130, nTrials, rate, T);

[pfe_CEV_put_price, pfe_strikes] = price_put(pfe_CEV_sim, 5, 90, 130, nTrials, rate, T);

[tsla_CEV_put_price, tsla_strikes] = price_put(tsla_CEV_sim, 5, 90, 130, nTrials, rate, T);

[cvx_CEV_put_price, cvx_strikes] = price_put(cvx_CEV_sim, 5, 90, 130, nTrials, rate, T);

[dal_CEV_put_price, dal_strikes] = price_put(dal_CEV_sim, 5, 90, 130, nTrials, rate, T);

%% Amp options
aapl_CEV_amp_price = price_lookback(aapl_CEV_sim, rate, T, @amplitude_payoff);

jpm_CEV_amp_price = price_lookback(jpm_CEV_sim, rate, T, @amplitude_payoff);

pfe_CEV_amp_price = price_lookback(pfe_CEV_sim, rate, T, @amplitude_payoff);

tsla_CEV_amp_price = price_lookback(tsla_CEV_sim, rate, T, @amplitude_payoff);

cvx_CEV_amp_price = price_lookback(cvx_CEV_sim, rate, T, @amplitude_payoff);

dal_CEV_amp_price = price_lookback(dal_CEV_sim, rate, T, @amplitude_payoff);

%% final max options
aapl_CEV_max_price = price_lookback(aapl_CEV_sim, rate, T, @final_max_payoff);

jpm_CEV_max_price = price_lookback(jpm_CEV_sim, rate, T, @final_max_payoff);

pfe_CEV_max_price = price_lookback(pfe_CEV_sim, rate, T, @final_max_payoff);

tsla_CEV_max_price = price_lookback(tsla_CEV_sim, rate, T, @final_max_payoff);

cvx_CEV_max_price = price_lookback(cvx_CEV_sim, rate, T, @final_max_payoff);

dal_CEV_max_price = price_lookback(dal_CEV_sim, rate, T, @final_max_payoff);

%% min final options
aapl_CEV_min_price = price_lookback(aapl_CEV_sim, rate, T, @min_final_payoff);

jpm_CEV_min_price = price_lookback(jpm_CEV_sim, rate, T, @min_final_payoff);

pfe_CEV_min_price = price_lookback(pfe_CEV_sim, rate, T, @min_final_payoff);

tsla_CEV_min_price = price_lookback(tsla_CEV_sim, rate, T, @min_final_payoff);

cvx_CEV_min_price = price_lookback(cvx_CEV_sim, rate, T, @min_final_payoff);

dal_CEV_min_price = price_lookback(dal_CEV_sim, rate, T, @min_final_payoff);