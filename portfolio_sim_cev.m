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

aapl_CEV_returns = mean(stock_returns(aapl_CEV_sim));
jpm_CEV_returns = mean(stock_returns(jpm_CEV_sim));
pfe_CEV_returns = mean(stock_returns(pfe_CEV_sim));
tsla_CEV_returns = mean(stock_returns(tsla_CEV_sim));
cvx_CEV_returns = mean(stock_returns(cvx_CEV_sim));
dal_CEV_returns = mean(stock_returns(dal_CEV_sim));

CEV_returns = [aapl_CEV_returns jpm_CEV_returns pfe_CEV_returns tsla_CEV_returns cvx_CEV_returns dal_CEV_returns];

%% call options
aapl_min_strike = round(aapl_CEV_sim(end) * (0.80));
aapl_max_strike = round(aapl_CEV_sim(end) * (1.20));
aapl_strike_step = (aapl_max_strike - aapl_min_strike) / 7;
[aapl_CEV_call_price, aapl_strikes] = price_call(aapl_CEV_sim, aapl_strike_step, aapl_min_strike, aapl_max_strike, nTrials, rate, T);
aapl_CEV_call_returns = call_returns(aapl_CEV_sim, aapl_strike_step, aapl_min_strike, aapl_max_strike, nTrials)'; 

jpm_min_strike = round(jpm_CEV_sim(end) * (0.80));
jpm_max_strike = round(jpm_CEV_sim(end) * (1.20));
jpm_strike_step = (jpm_max_strike - jpm_min_strike) / 7;
[jpm_CEV_call_price, jpm_strikes] = price_call(jpm_CEV_sim, jpm_strike_step, jpm_min_strike, jpm_max_strike, nTrials, rate, T);
jpm_CEV_call_returns = call_returns(jpm_CEV_sim, jpm_strike_step, jpm_min_strike, jpm_max_strike, nTrials)'; 

pfe_min_strike = round(pfe_CEV_sim(end) * (0.80));
pfe_max_strike = round(pfe_CEV_sim(end) * (1.20));
pfe_strike_step = (pfe_max_strike - pfe_min_strike) / 7;
[pfe_CEV_call_price, pfe_strikes] = price_call(pfe_CEV_sim, pfe_strike_step, pfe_min_strike, pfe_max_strike, nTrials, rate, T);
pfe_CEV_call_returns = call_returns(pfe_CEV_sim, pfe_strike_step, pfe_min_strike, pfe_max_strike, nTrials)'; 

tsla_min_strike = round(tsla_CEV_sim(end) * (0.80));
tsla_max_strike = round(tsla_CEV_sim(end) * (1.20));
tsla_strike_step = (tsla_max_strike - tsla_min_strike) / 7;
[tsla_CEV_call_price, tsla_strikes] = price_call(tsla_CEV_sim, tsla_strike_step, tsla_min_strike, tsla_max_strike, nTrials, rate, T);
tsla_CEV_call_returns = call_returns(tsla_CEV_sim, tsla_strike_step, tsla_min_strike, tsla_max_strike, nTrials)'; 

cvx_min_strike = round(cvx_CEV_sim(end) * (0.80));
cvx_max_strike = round(cvx_CEV_sim(end) * (1.20));
cvx_strike_step = (cvx_max_strike - cvx_min_strike) / 7;
[cvx_CEV_call_price, cvx_strikes] = price_call(cvx_CEV_sim, cvx_strike_step, cvx_min_strike, cvx_max_strike, nTrials, rate, T);
cvx_CEV_call_returns = call_returns(cvx_CEV_sim, cvx_strike_step, cvx_min_strike, cvx_max_strike, nTrials)'; 

dal_min_strike = round(dal_CEV_sim(end) * (0.80));
dal_max_strike = round(dal_CEV_sim(end) * (1.20));
dal_strike_step = (dal_max_strike - dal_min_strike) / 7;
[dal_CEV_call_price, dal_strikes] = price_call(dal_CEV_sim, dal_strike_step, dal_min_strike, dal_max_strike, nTrials, rate, T);
dal_CEV_call_returns = call_returns(dal_CEV_sim, dal_strike_step, dal_min_strike, dal_max_strike, nTrials)'; 

CEV_call_returns = [aapl_CEV_call_returns jpm_CEV_call_returns pfe_CEV_call_returns tsla_CEV_call_returns ...
    cvx_CEV_call_returns dal_CEV_call_returns];

CEV_call_strikes = [aapl_strikes' jpm_strikes' pfe_strikes' tsla_strikes' cvx_strikes' dal_strikes'];

%% put options
aapl_min_strike = round(aapl_CEV_sim(end) * (0.80));
aapl_max_strike = round(aapl_CEV_sim(end) * (1.20));
aapl_strike_step = (aapl_max_strike - aapl_min_strike) / 7;
[aapl_CEV_put_price, aapl_strikes] = price_put(aapl_CEV_sim, aapl_strike_step, aapl_min_strike, aapl_max_strike, nTrials, rate, T);
aapl_CEV_put_returns = put_returns(aapl_CEV_sim, aapl_strike_step, aapl_min_strike, aapl_max_strike, nTrials)'; 

jpm_min_strike = round(jpm_CEV_sim(end) * (0.80));
jpm_max_strike = round(jpm_CEV_sim(end) * (1.20));
jpm_strike_step = (jpm_max_strike - jpm_min_strike) / 7;
[jpm_CEV_put_price, jpm_strikes] = price_put(jpm_CEV_sim, jpm_strike_step, jpm_min_strike, jpm_max_strike, nTrials, rate, T);
jpm_CEV_put_returns = put_returns(jpm_CEV_sim, jpm_strike_step, jpm_min_strike, jpm_max_strike, nTrials)'; 

pfe_min_strike = round(pfe_CEV_sim(end) * (0.80));
pfe_max_strike = round(pfe_CEV_sim(end) * (1.20));
pfe_strike_step = (pfe_max_strike - pfe_min_strike) / 7;
[pfe_CEV_put_price, pfe_strikes] = price_put(pfe_CEV_sim, pfe_strike_step, pfe_min_strike, pfe_max_strike, nTrials, rate, T);
pfe_CEV_put_returns = put_returns(pfe_CEV_sim, pfe_strike_step, pfe_min_strike, pfe_max_strike, nTrials)'; 

tsla_min_strike = round(tsla_CEV_sim(end) * (0.80));
tsla_max_strike = round(tsla_CEV_sim(end) * (1.20));
tsla_strike_step = (tsla_max_strike - tsla_min_strike) / 7;
[tsla_CEV_put_price, tsla_strikes] = price_put(tsla_CEV_sim, tsla_strike_step, tsla_min_strike, tsla_max_strike, nTrials, rate, T);
tsla_CEV_put_returns = put_returns(tsla_CEV_sim, tsla_strike_step, tsla_min_strike, tsla_max_strike, nTrials)'; 

cvx_min_strike = round(cvx_CEV_sim(end) * (0.80));
cvx_max_strike = round(cvx_CEV_sim(end) * (1.20));
cvx_strike_step = (cvx_max_strike - cvx_min_strike) / 7;
[cvx_CEV_put_price, cvx_strikes] = price_put(cvx_CEV_sim, cvx_strike_step, cvx_min_strike, cvx_max_strike, nTrials, rate, T);
cvx_CEV_put_returns = put_returns(cvx_CEV_sim, cvx_strike_step, cvx_min_strike, cvx_max_strike, nTrials)'; 

dal_min_strike = round(dal_CEV_sim(end) * (0.80));
dal_max_strike = round(dal_CEV_sim(end) * (1.20));
dal_strike_step = (dal_max_strike - dal_min_strike) / 7;
[dal_CEV_put_price, dal_strikes] = price_put(dal_CEV_sim, dal_strike_step, dal_min_strike, dal_max_strike, nTrials, rate, T);
dal_CEV_put_returns = put_returns(dal_CEV_sim, dal_strike_step, dal_min_strike, dal_max_strike, nTrials)'; 

CEV_put_returns = [aapl_CEV_put_returns jpm_CEV_put_returns pfe_CEV_put_returns tsla_CEV_put_returns ...
    cvx_CEV_put_returns dal_CEV_put_returns];

CEV_put_strikes = [aapl_strikes' jpm_strikes' pfe_strikes' tsla_strikes' cvx_strikes' dal_strikes'];

%% Amp options
aapl_CEV_amp_price = price_lookback(aapl_CEV_sim, rate, T, @amplitude_payoff);
aapl_CEV_amp_returns = mean(amplitude_payoff(aapl_CEV_sim));

jpm_CEV_amp_price = price_lookback(jpm_CEV_sim, rate, T, @amplitude_payoff);
jpm_CEV_amp_returns = mean(amplitude_payoff(jpm_CEV_sim));

pfe_CEV_amp_price = price_lookback(pfe_CEV_sim, rate, T, @amplitude_payoff);
pfe_CEV_amp_returns = mean(amplitude_payoff(pfe_CEV_sim));

tsla_CEV_amp_price = price_lookback(tsla_CEV_sim, rate, T, @amplitude_payoff);
tsla_CEV_amp_returns = mean(amplitude_payoff(tsla_CEV_sim));

cvx_CEV_amp_price = price_lookback(cvx_CEV_sim, rate, T, @amplitude_payoff);
cvx_CEV_amp_returns = mean(amplitude_payoff(cvx_CEV_sim));

dal_CEV_amp_price = price_lookback(dal_CEV_sim, rate, T, @amplitude_payoff);
dal_CEV_amp_returns = mean(amplitude_payoff(dal_CEV_sim));

CEV_amp_returns = [aapl_CEV_amp_returns jpm_CEV_amp_returns pfe_CEV_amp_returns tsla_CEV_amp_returns ...
    cvx_CEV_amp_returns dal_CEV_amp_returns];

%% final max options
aapl_CEV_max_price = price_lookback(aapl_CEV_sim, rate, T, @min_final_payoff);
aapl_CEV_max_returns = mean(min_final_payoff(aapl_CEV_sim));

jpm_CEV_max_price = price_lookback(jpm_CEV_sim, rate, T, @min_final_payoff);
jpm_CEV_max_returns = mean(min_final_payoff(jpm_CEV_sim));

pfe_CEV_max_price = price_lookback(pfe_CEV_sim, rate, T, @min_final_payoff);
pfe_CEV_max_returns = mean(min_final_payoff(pfe_CEV_sim));

tsla_CEV_max_price = price_lookback(tsla_CEV_sim, rate, T, @min_final_payoff);
tsla_CEV_max_returns = mean(min_final_payoff(tsla_CEV_sim));

cvx_CEV_max_price = price_lookback(cvx_CEV_sim, rate, T, @min_final_payoff);
cvx_CEV_max_returns = mean(min_final_payoff(cvx_CEV_sim));

dal_CEV_max_price = price_lookback(dal_CEV_sim, rate, T, @min_final_payoff);
dal_CEV_max_returns = mean(min_final_payoff(dal_CEV_sim));

CEV_max_returns = [aapl_CEV_max_returns jpm_CEV_max_returns pfe_CEV_max_returns tsla_CEV_max_returns ...
    cvx_CEV_max_returns dal_CEV_max_returns];

%% min final options
aapl_CEV_min_price = price_lookback(aapl_CEV_sim, rate, T, @min_final_payoff);
aapl_CEV_min_returns = mean(min_final_payoff(aapl_CEV_sim));

jpm_CEV_min_price = price_lookback(jpm_CEV_sim, rate, T, @min_final_payoff);
jpm_CEV_min_returns = mean(min_final_payoff(jpm_CEV_sim));

pfe_CEV_min_price = price_lookback(pfe_CEV_sim, rate, T, @min_final_payoff);
pfe_CEV_min_returns = mean(min_final_payoff(pfe_CEV_sim));

tsla_CEV_min_price = price_lookback(tsla_CEV_sim, rate, T, @min_final_payoff);
tsla_CEV_min_returns = mean(min_final_payoff(tsla_CEV_sim));

cvx_CEV_min_price = price_lookback(cvx_CEV_sim, rate, T, @min_final_payoff);
cvx_CEV_min_returns = mean(min_final_payoff(cvx_CEV_sim));

dal_CEV_min_price = price_lookback(dal_CEV_sim, rate, T, @min_final_payoff);
dal_CEV_min_returns = mean(min_final_payoff(dal_CEV_sim));

CEV_min_returns = [aapl_CEV_min_returns jpm_CEV_min_returns pfe_CEV_min_returns tsla_CEV_min_returns ...
    cvx_CEV_min_returns dal_CEV_min_returns];
