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

aapl_gbm_returns = mean(stock_returns(aapl_gbm_sim));
jpm_gbm_returns = mean(stock_returns(jpm_gbm_sim));
pfe_gbm_returns = mean(stock_returns(pfe_gbm_sim));
tsla_gbm_returns = mean(stock_returns(tsla_gbm_sim));
cvx_gbm_returns = mean(stock_returns(cvx_gbm_sim));
dal_gbm_returns = mean(stock_returns(dal_gbm_sim));

% stock returns
gbm_returns = [aapl_gbm_returns jpm_gbm_returns pfe_gbm_returns tsla_gbm_returns cvx_gbm_returns dal_gbm_returns];

%% call options
aapl_min_strike = round(aapl_gbm_sim(end) * (0.80));
aapl_max_strike = round(aapl_gbm_sim(end) * (1.20));
aapl_strike_step = (aapl_max_strike - aapl_min_strike) / 7;
[aapl_gbm_call_price, aapl_strikes] = price_call(aapl_gbm_sim, aapl_strike_step, aapl_min_strike, aapl_max_strike, nTrials, rate, T);
aapl_gbm_call_returns = call_returns(aapl_gbm_sim, aapl_strike_step, aapl_min_strike, aapl_max_strike, nTrials)'; 

jpm_min_strike = round(jpm_gbm_sim(end) * (0.80));
jpm_max_strike = round(jpm_gbm_sim(end) * (1.20));
jpm_strike_step = (jpm_max_strike - jpm_min_strike) / 7;
[jpm_gbm_call_price, jpm_strikes] = price_call(jpm_gbm_sim, jpm_strike_step, jpm_min_strike, jpm_max_strike, nTrials, rate, T);
jpm_gbm_call_returns = call_returns(jpm_gbm_sim, jpm_strike_step, jpm_min_strike, jpm_max_strike, nTrials)'; 

pfe_min_strike = round(pfe_gbm_sim(end) * (0.80));
pfe_max_strike = round(pfe_gbm_sim(end) * (1.20));
pfe_strike_step = (pfe_max_strike - pfe_min_strike) / 7;
[pfe_gbm_call_price, pfe_strikes] = price_call(pfe_gbm_sim, pfe_strike_step, pfe_min_strike, pfe_max_strike, nTrials, rate, T);
pfe_gbm_call_returns = call_returns(pfe_gbm_sim, pfe_strike_step, pfe_min_strike, pfe_max_strike, nTrials)'; 

tsla_min_strike = round(tsla_gbm_sim(end) * (0.80));
tsla_max_strike = round(tsla_gbm_sim(end) * (1.20));
tsla_strike_step = (tsla_max_strike - tsla_min_strike) / 7;
[tsla_gbm_call_price, tsla_strikes] = price_call(tsla_gbm_sim, tsla_strike_step, tsla_min_strike, tsla_max_strike, nTrials, rate, T);
tsla_gbm_call_returns = call_returns(tsla_gbm_sim, tsla_strike_step, tsla_min_strike, tsla_max_strike, nTrials)'; 

cvx_min_strike = round(cvx_gbm_sim(end) * (0.80));
cvx_max_strike = round(cvx_gbm_sim(end) * (1.20));
cvx_strike_step = (cvx_max_strike - cvx_min_strike) / 7;
[cvx_gbm_call_price, cvx_strikes] = price_call(cvx_gbm_sim, cvx_strike_step, cvx_min_strike, cvx_max_strike, nTrials, rate, T);
cvx_gbm_call_returns = call_returns(cvx_gbm_sim, cvx_strike_step, cvx_min_strike, cvx_max_strike, nTrials)'; 

dal_min_strike = round(dal_gbm_sim(end) * (0.80));
dal_max_strike = round(dal_gbm_sim(end) * (1.20));
dal_strike_step = (dal_max_strike - dal_min_strike) / 7;
[dal_gbm_call_price, dal_strikes] = price_call(dal_gbm_sim, dal_strike_step, dal_min_strike, dal_max_strike, nTrials, rate, T);
dal_gbm_call_returns = call_returns(dal_gbm_sim, dal_strike_step, dal_min_strike, dal_max_strike, nTrials)'; 

% call returns
gbm_call_returns = [aapl_gbm_call_returns jpm_gbm_call_returns pfe_gbm_call_returns tsla_gbm_call_returns ...
    cvx_gbm_call_returns dal_gbm_call_returns];

% call strikes
gbm_call_strikes = [aapl_strikes' jpm_strikes' pfe_strikes' tsla_strikes' cvx_strikes' dal_strikes'];

%% put options
aapl_min_strike = round(aapl_gbm_sim(end) * (0.80));
aapl_max_strike = round(aapl_gbm_sim(end) * (1.20));
aapl_strike_step = (aapl_max_strike - aapl_min_strike) / 7;
[aapl_gbm_put_price, aapl_strikes] = price_put(aapl_gbm_sim, aapl_strike_step, aapl_min_strike, aapl_max_strike, nTrials, rate, T);
aapl_gbm_put_returns = put_returns(aapl_gbm_sim, aapl_strike_step, aapl_min_strike, aapl_max_strike, nTrials)'; 

jpm_min_strike = round(jpm_gbm_sim(end) * (0.80));
jpm_max_strike = round(jpm_gbm_sim(end) * (1.20));
jpm_strike_step = (jpm_max_strike - jpm_min_strike) / 7;
[jpm_gbm_put_price, jpm_strikes] = price_put(jpm_gbm_sim, jpm_strike_step, jpm_min_strike, jpm_max_strike, nTrials, rate, T);
jpm_gbm_put_returns = put_returns(jpm_gbm_sim, jpm_strike_step, jpm_min_strike, jpm_max_strike, nTrials)'; 

pfe_min_strike = round(pfe_gbm_sim(end) * (0.80));
pfe_max_strike = round(pfe_gbm_sim(end) * (1.20));
pfe_strike_step = (pfe_max_strike - pfe_min_strike) / 7;
[pfe_gbm_put_price, pfe_strikes] = price_put(pfe_gbm_sim, pfe_strike_step, pfe_min_strike, pfe_max_strike, nTrials, rate, T);
pfe_gbm_put_returns = put_returns(pfe_gbm_sim, pfe_strike_step, pfe_min_strike, pfe_max_strike, nTrials)'; 

tsla_min_strike = round(tsla_gbm_sim(end) * (0.80));
tsla_max_strike = round(tsla_gbm_sim(end) * (1.20));
tsla_strike_step = (tsla_max_strike - tsla_min_strike) / 7;
[tsla_gbm_put_price, tsla_strikes] = price_put(tsla_gbm_sim, tsla_strike_step, tsla_min_strike, tsla_max_strike, nTrials, rate, T);
tsla_gbm_put_returns = put_returns(tsla_gbm_sim, tsla_strike_step, tsla_min_strike, tsla_max_strike, nTrials)'; 

cvx_min_strike = round(cvx_gbm_sim(end) * (0.80));
cvx_max_strike = round(cvx_gbm_sim(end) * (1.20));
cvx_strike_step = (cvx_max_strike - cvx_min_strike) / 7;
[cvx_gbm_put_price, cvx_strikes] = price_put(cvx_gbm_sim, cvx_strike_step, cvx_min_strike, cvx_max_strike, nTrials, rate, T);
cvx_gbm_put_returns = put_returns(cvx_gbm_sim, cvx_strike_step, cvx_min_strike, cvx_max_strike, nTrials)'; 

dal_min_strike = round(dal_gbm_sim(end) * (0.80));
dal_max_strike = round(dal_gbm_sim(end) * (1.20));
dal_strike_step = (dal_max_strike - dal_min_strike) / 7;
[dal_gbm_put_price, dal_strikes] = price_put(dal_gbm_sim, dal_strike_step, dal_min_strike, dal_max_strike, nTrials, rate, T);
dal_gbm_put_returns = put_returns(dal_gbm_sim, dal_strike_step, dal_min_strike, dal_max_strike, nTrials)'; 

% put returns
gbm_put_returns = [aapl_gbm_put_returns jpm_gbm_put_returns pfe_gbm_put_returns tsla_gbm_put_returns ...
    cvx_gbm_put_returns dal_gbm_put_returns];

% call strikes
gbm_put_strikes = [aapl_strikes' jpm_strikes' pfe_strikes' tsla_strikes' cvx_strikes' dal_strikes'];

%% Amp options
aapl_gbm_amp_price = price_lookback(aapl_gbm_sim, rate, T, @amplitude_payoff);
aapl_gbm_amp_returns = mean(amplitude_payoff(aapl_gbm_sim));

jpm_gbm_amp_price = price_lookback(jpm_gbm_sim, rate, T, @amplitude_payoff);
jpm_gbm_amp_returns = mean(amplitude_payoff(jpm_gbm_sim));

pfe_gbm_amp_price = price_lookback(pfe_gbm_sim, rate, T, @amplitude_payoff);
pfe_gbm_amp_returns = mean(amplitude_payoff(pfe_gbm_sim));

tsla_gbm_amp_price = price_lookback(tsla_gbm_sim, rate, T, @amplitude_payoff);
tsla_gbm_amp_returns = mean(amplitude_payoff(tsla_gbm_sim));

cvx_gbm_amp_price = price_lookback(cvx_gbm_sim, rate, T, @amplitude_payoff);
cvx_gbm_amp_returns = mean(amplitude_payoff(cvx_gbm_sim));

dal_gbm_amp_price = price_lookback(dal_gbm_sim, rate, T, @amplitude_payoff);
dal_gbm_amp_returns = mean(amplitude_payoff(dal_gbm_sim));

% amp returns
gbm_amp_returns = [aapl_gbm_amp_returns jpm_gbm_amp_returns pfe_gbm_amp_returns tsla_gbm_amp_returns ...
    cvx_gbm_amp_returns dal_gbm_amp_returns];

%% final max options
aapl_gbm_max_price = price_lookback(aapl_gbm_sim, rate, T, @min_final_payoff);
aapl_gbm_max_returns = mean(min_final_payoff(aapl_gbm_sim));

jpm_gbm_max_price = price_lookback(jpm_gbm_sim, rate, T, @min_final_payoff);
jpm_gbm_max_returns = mean(min_final_payoff(jpm_gbm_sim));

pfe_gbm_max_price = price_lookback(pfe_gbm_sim, rate, T, @min_final_payoff);
pfe_gbm_max_returns = mean(min_final_payoff(pfe_gbm_sim));

tsla_gbm_max_price = price_lookback(tsla_gbm_sim, rate, T, @min_final_payoff);
tsla_gbm_max_returns = mean(min_final_payoff(tsla_gbm_sim));

cvx_gbm_max_price = price_lookback(cvx_gbm_sim, rate, T, @min_final_payoff);
cvx_gbm_max_returns = mean(min_final_payoff(cvx_gbm_sim));

dal_gbm_max_price = price_lookback(dal_gbm_sim, rate, T, @min_final_payoff);
dal_gbm_max_returns = mean(min_final_payoff(dal_gbm_sim));

% max returns
gbm_max_returns = [aapl_gbm_max_returns jpm_gbm_max_returns pfe_gbm_max_returns tsla_gbm_max_returns ...
    cvx_gbm_max_returns dal_gbm_max_returns];

%% min final options
aapl_gbm_min_price = price_lookback(aapl_gbm_sim, rate, T, @min_final_payoff);
aapl_gbm_min_returns = mean(min_final_payoff(aapl_gbm_sim));

jpm_gbm_min_price = price_lookback(jpm_gbm_sim, rate, T, @min_final_payoff);
jpm_gbm_min_returns = mean(min_final_payoff(jpm_gbm_sim));

pfe_gbm_min_price = price_lookback(pfe_gbm_sim, rate, T, @min_final_payoff);
pfe_gbm_min_returns = mean(min_final_payoff(pfe_gbm_sim));

tsla_gbm_min_price = price_lookback(tsla_gbm_sim, rate, T, @min_final_payoff);
tsla_gbm_min_returns = mean(min_final_payoff(tsla_gbm_sim));

cvx_gbm_min_price = price_lookback(cvx_gbm_sim, rate, T, @min_final_payoff);
cvx_gbm_min_returns = mean(min_final_payoff(cvx_gbm_sim));

dal_gbm_min_price = price_lookback(dal_gbm_sim, rate, T, @min_final_payoff);
dal_gbm_min_returns = mean(min_final_payoff(dal_gbm_sim));

% min returns
gbm_min_returns = [aapl_gbm_min_returns jpm_gbm_min_returns pfe_gbm_min_returns tsla_gbm_min_returns ...
    cvx_gbm_min_returns dal_gbm_min_returns];
