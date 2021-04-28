clc
clear all

%% import data

stock_returns = readtable("Returns Data.xlsx");
stock_prices = readtable("Stock Data.xlsx");

aapl_returns = stock_returns.AAPL;
jpm_returns = stock_returns.JPM;
pfe_returns = stock_returns.PFE;
tsla_returns = stock_returns.TSLA;
cvx_returns = stock_returns.CVX;
dal_returns = stock_returns.DAL;

aapl_prices = stock_prices.AAPL;
jpm_prices = stock_prices.JPM;
pfe_prices = stock_prices.PFE;
tsla_prices = stock_prices.TSLA;
cvx_prices = stock_prices.CVX;
dal_prices = stock_prices.DAL;

%% simulation parameters

returns_mat = [aapl_returns jpm_returns pfe_returns tsla_returns cvx_returns dal_returns];
prices_mat = [aapl_prices jpm_prices pfe_prices tsla_prices cvx_prices dal_prices];

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

%%
aapl_gbm_sim = squeeze(gbm_stocks(:, 1, :));
jpm_gbm_sim = squeeze(gbm_stocks(:, 2, :));
pfe_gbm_sim = squeeze(gbm_stocks(:, 3, :));
tsla_gbm_sim = squeeze(gbm_stocks(:, 4, :));
cvx_gbm_sim = squeeze(gbm_stocks(:, 5, :));
dal_gbm_sim = squeeze(gbm_stocks(:, 6, :));

%% multi jump
JumpMean = 0.8 * ones(6, 1);
JumpVol = 0.3 * ones(6, 1);       
JumpFreq = 5;

mert = merton(mean_returns, sigma, ...
    JumpFreq, JumpMean, JumpVol, ...
    'StartState', start, ...
    'correlation', corr_returns);

%% jump sim

merton_stocks = simulate(mert, nobs, ...
 'DeltaTime', DeltaTime, ...
 'nTrials', nTrials);

%%

aapl_merton_sim = squeeze(merton_stocks(:, 1, :));
jpm_merton_sim = squeeze(merton_stocks(:, 2, :));
pfe_merton_sim = squeeze(merton_stocks(:, 3, :));
tsla_merton_sim = squeeze(merton_stocks(:, 4, :));
cvx_merton_sim = squeeze(merton_stocks(:, 5, :));
dal_merton_sim = squeeze(merton_stocks(:, 6, :));


