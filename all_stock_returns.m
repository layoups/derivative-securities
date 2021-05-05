function returns = all_stock_returns(paths, returns_func)
dim_stocks = size(paths);
num_stocks = dim_stocks(2);

returns = nan(1, num_stocks);

for i=1:num_stocks
    stock_sim = paths(:, i, :);
    stock_returns = mean(returns_func(stock_sim));
    returns(:, i) = stock_returns;
end