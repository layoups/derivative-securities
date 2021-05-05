function [returns, pffs] = all_stock_returns(paths, returns_func)
dim_stocks = size(paths);
num_stocks = dim_stocks(2);
nTrials = dim_stocks(3);

returns = nan(1, num_stocks);
pffs = nan(num_stocks, nTrials);

for i=1:num_stocks
    stock_sim = squeeze(paths(:, i, :));
    [returns(:, i), pffs(i, :)] = returns_func(stock_sim);
end