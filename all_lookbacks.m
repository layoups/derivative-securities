function [returns, prices] = all_lookbacks(paths, rate, T, price_func, ...
    payoff_func)
dim_stocks = size(paths);
num_stocks = dim_stocks(2);

prices = nan(1, num_stocks);
returns = nan(1, num_stocks);

for i=1:num_stocks
    stock_sim = paths(:, i, :);
    stock_opt_price = price_func(stock_sim, rate, T, payoff_func);
    stock_opt_returns = mean(payoff_func(stock_sim));
    returns(:, i) = stock_opt_returns;
    prices(:, i) = stock_opt_price;
end
