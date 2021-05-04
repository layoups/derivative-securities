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
nTrials = 20;

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
JumpFreq = 252/10/360;

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

