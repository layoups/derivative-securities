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

%% Heston Parameters
level = ones(num(1), 1);
speed = ones(num(1), 1);
volvol = 0.2;

%% Heston Model
% Heston = heston(mean_returns, speed, level, volvol, ...
%     'correlation', corr_returns, ...    
%     'StartState', start);

%% Heston sim
% heston_stocks = simulate(Heston, nobs, ...
%  'DeltaTime', DeltaTime, ...
%  'nTrials', nTrials);
% 
% aapl_Heston_sim = squeeze(Heston_stocks(:, 1, :));
% jpm_Heston_sim = squeeze(Heston_stocks(:, 2, :));
% pfe_Heston_sim = squeeze(Heston_stocks(:, 3, :));
% tsla_Heston_sim = squeeze(Heston_stocks(:, 4, :));
% cvx_Heston_sim = squeeze(Heston_stocks(:, 5, :));
% dal_Heston_sim = squeeze(Heston_stocks(:, 6, :));

%% pricing parameters
rate = 0.04;
T = 1;


%% call options
[aapl_gbm_call_price, aapl_strikes] = price_call(aapl_gbm_sim, 5, 90, 130, nTrials, rate, T);
aapl_merton_call_price = price_call(aapl_merton_sim, 5, 90, 130, nTrials, rate, T);
aapl_cev_call_price = price_call(aapl_CEV_sim, 5, 90, 130, nTrials, rate, T);

[jpm_gbm_call_price, jpm_strikes] = price_call(jpm_gbm_sim, 5, 90, 130, nTrials, rate, T);
jpm_merton_call_price = price_call(jpm_merton_sim, 5, 90, 130, nTrials, rate, T);
jpm_cev_call_price = price_call(jpm_CEV_sim, 5, 90, 130, nTrials, rate, T);

[pfe_gbm_call_price, pfe_strikes] = price_call(pfe_gbm_sim, 5, 90, 130, nTrials, rate, T);
pfe_merton_call_price = price_call(pfe_merton_sim, 5, 90, 130, nTrials, rate, T);
pfe_cev_call_price = price_call(pfe_CEV_sim, 5, 90, 130, nTrials, rate, T);

[tsla_gbm_call_price, tsla_strikes] = price_call(tsla_gbm_sim, 5, 90, 130, nTrials, rate, T);
tsla_merton_call_price = price_call(tsla_merton_sim, 5, 90, 130, nTrials, rate, T);
tsla_cev_call_price = price_call(tsla_CEV_sim, 5, 90, 130, nTrials, rate, T);

[cvx_gbm_call_price, cvx_strikes] = price_call(cvx_gbm_sim, 5, 90, 130, nTrials, rate, T);
cvx_merton_call_price = price_call(cvx_merton_sim, 5, 90, 130, nTrials, rate, T);
cvx_cev_call_price = price_call(cvx_CEV_sim, 5, 90, 130, nTrials, rate, T);

[dal_gbm_call_price, dal_strikes] = price_call(dal_gbm_sim, 5, 90, 130, nTrials, rate, T);
dal_merton_call_price = price_call(dal_merton_sim, 5, 90, 130, nTrials, rate, T);
dal_cev_call_price = price_call(dal_CEV_sim, 5, 90, 130, nTrials, rate, T);

%% put options
[aapl_gbm_put_price, aapl_strikes] = price_put(aapl_gbm_sim, 5, 90, 130, nTrials, rate, T);
aapl_merton_put_price = price_put(aapl_merton_sim, 5, 90, 130, nTrials, rate, T);
aapl_cev_put_price = price_put(aapl_CEV_sim, 5, 90, 130, nTrials, rate, T);

[jpm_gbm_put_price, jpm_strikes] = price_put(jpm_gbm_sim, 5, 90, 130, nTrials, rate, T);
jpm_merton_put_price = price_put(jpm_merton_sim, 5, 90, 130, nTrials, rate, T);
jpm_cev_put_price = price_put(jpm_CEV_sim, 5, 90, 130, nTrials, rate, T);

[pfe_gbm_put_price, pfe_strikes] = price_put(pfe_gbm_sim, 5, 90, 130, nTrials, rate, T);
pfe_merton_put_price = price_put(pfe_merton_sim, 5, 90, 130, nTrials, rate, T);
pfe_cev_put_price = price_put(pfe_CEV_sim, 5, 90, 130, nTrials, rate, T);

[tsla_gbm_put_price, tsla_strikes] = price_put(tsla_gbm_sim, 5, 90, 130, nTrials, rate, T);
tsla_merton_put_price = price_put(tsla_merton_sim, 5, 90, 130, nTrials, rate, T);
tsla_cev_put_price = price_put(tsla_CEV_sim, 5, 90, 130, nTrials, rate, T);

[cvx_gbm_put_price, cvx_strikes] = price_put(cvx_gbm_sim, 5, 90, 130, nTrials, rate, T);
cvx_merton_put_price = price_put(cvx_merton_sim, 5, 90, 130, nTrials, rate, T);
cvx_cev_put_price = price_put(cvx_CEV_sim, 5, 90, 130, nTrials, rate, T);

[dal_gbm_put_price, dal_strikes] = price_put(dal_gbm_sim, 5, 90, 130, nTrials, rate, T);
dal_merton_put_price = price_put(dal_merton_sim, 5, 90, 130, nTrials, rate, T);
dal_cev_put_price = price_put(dal_CEV_sim, 5, 90, 130, nTrials, rate, T);


%% Amp options
aapl_gbm_amp_price = price_lookback(aapl_gbm_sim, rate, T, @amplitude_payoff);
aapl_cev_amp_price = price_lookback(aapl_CEV_sim, rate, T, @amplitude_payoff);
aapl_merton_amp_price = price_lookback(aapl_merton_sim, rate, T, @amplitude_payoff);

jpm_gbm_amp_price = price_lookback(jpm_gbm_sim, rate, T, @amplitude_payoff);
jpm_cev_amp_price = price_lookback(jpm_CEV_sim, rate, T, @amplitude_payoff);
jpm_merton_amp_price = price_lookback(jpm_merton_sim, rate, T, @amplitude_payoff);

pfe_gbm_amp_price = price_lookback(pfe_gbm_sim, rate, T, @amplitude_payoff);
pfe_cev_amp_price = price_lookback(pfe_CEV_sim, rate, T, @amplitude_payoff);
pfe_merton_amp_price = price_lookback(pfe_merton_sim, rate, T, @amplitude_payoff);

tsla_gbm_amp_price = price_lookback(tsla_gbm_sim, rate, T, @amplitude_payoff);
tsla_cev_amp_price = price_lookback(tsla_CEV_sim, rate, T, @amplitude_payoff);
tsla_merton_amp_price = price_lookback(tsla_merton_sim, rate, T, @amplitude_payoff);

cvx_gbm_amp_price = price_lookback(cvx_gbm_sim, rate, T, @amplitude_payoff);
cvx_cev_amp_price = price_lookback(cvx_CEV_sim, rate, T, @amplitude_payoff);
cvx_merton_amp_price = price_lookback(cvx_merton_sim, rate, T, @amplitude_payoff);

dal_gbm_amp_price = price_lookback(dal_gbm_sim, rate, T, @amplitude_payoff);
dal_cev_amp_price = price_lookback(dal_CEV_sim, rate, T, @amplitude_payoff);
dal_merton_amp_price = price_lookback(dal_merton_sim, rate, T, @amplitude_payoff);

%% final max options
aapl_gbm_max_price = price_lookback(aapl_gbm_sim, rate, T, @final_max_payoff);
aapl_cev_max_price = price_lookback(aapl_CEV_sim, rate, T, @final_max_payoff);
aapl_merton_max_price = price_lookback(aapl_merton_sim, rate, T, @final_max_payoff);

jpm_gbm_max_price = price_lookback(jpm_gbm_sim, rate, T, @final_max_payoff);
jpm_cev_max_price = price_lookback(jpm_CEV_sim, rate, T, @final_max_payoff);
jpm_merton_max_price = price_lookback(jpm_merton_sim, rate, T, @final_max_payoff);

pfe_gbm_max_price = price_lookback(pfe_gbm_sim, rate, T, @final_max_payoff);
pfe_cev_max_price = price_lookback(pfe_CEV_sim, rate, T, @final_max_payoff);
pfe_merton_max_price = price_lookback(pfe_merton_sim, rate, T, @final_max_payoff);

tsla_gbm_max_price = price_lookback(tsla_gbm_sim, rate, T, @final_max_payoff);
tsla_cev_max_price = price_lookback(tsla_CEV_sim, rate, T, @final_max_payoff);
tsla_merton_max_price = price_lookback(tsla_merton_sim, rate, T, @final_max_payoff);

cvx_gbm_max_price = price_lookback(cvx_gbm_sim, rate, T, @final_max_payoff);
cvx_cev_max_price = price_lookback(cvx_CEV_sim, rate, T, @final_max_payoff);
cvx_merton_max_price = price_lookback(cvx_merton_sim, rate, T, @final_max_payoff);

dal_gbm_max_price = price_lookback(dal_gbm_sim, rate, T, @final_max_payoff);
dal_cev_max_price = price_lookback(dal_CEV_sim, rate, T, @final_max_payoff);
dal_merton_max_price = price_lookback(dal_merton_sim, rate, T, @final_max_payoff);

%% min final options
aapl_gbm_min_price = price_lookback(aapl_gbm_sim, rate, T, @min_final_payoff);
aapl_cev_min_price = price_lookback(aapl_CEV_sim, rate, T, @min_final_payoff);
aapl_merton_min_price = price_lookback(aapl_merton_sim, rate, T, @min_final_payoff);

jpm_gbm_min_price = price_lookback(jpm_gbm_sim, rate, T, @min_final_payoff);
jpm_cev_min_price = price_lookback(jpm_CEV_sim, rate, T, @min_final_payoff);
jpm_merton_min_price = price_lookback(jpm_merton_sim, rate, T, @min_final_payoff);

pfe_gbm_min_price = price_lookback(pfe_gbm_sim, rate, T, @min_final_payoff);
pfe_cev_min_price = price_lookback(pfe_CEV_sim, rate, T, @min_final_payoff);
pfe_merton_min_price = price_lookback(pfe_merton_sim, rate, T, @min_final_payoff);

tsla_gbm_min_price = price_lookback(tsla_gbm_sim, rate, T, @min_final_payoff);
tsla_cev_min_price = price_lookback(tsla_CEV_sim, rate, T, @min_final_payoff);
tsla_merton_min_price = price_lookback(tsla_merton_sim, rate, T, @min_final_payoff);

cvx_gbm_min_price = price_lookback(cvx_gbm_sim, rate, T, @min_final_payoff);
cvx_cev_min_price = price_lookback(cvx_CEV_sim, rate, T, @min_final_payoff);
cvx_merton_min_price = price_lookback(cvx_merton_sim, rate, T, @min_final_payoff);

dal_gbm_min_price = price_lookback(dal_gbm_sim, rate, T, @min_final_payoff);
dal_cev_min_price = price_lookback(dal_CEV_sim, rate, T, @min_final_payoff);
dal_merton_min_price = price_lookback(dal_merton_sim, rate, T, @min_final_payoff);
