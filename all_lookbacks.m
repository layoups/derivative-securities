function [returns, prices, pffs] = all_lookbacks(paths, rate, T, price_func, ...
    payoff_func, nTrials)
dim_stocks = size(paths);
num_stocks = dim_stocks(2);

prices = nan(1, num_stocks);
returns = nan(1, num_stocks);
pffs = nan(nTrials, num_stocks);

for i=1:num_stocks
    stock_sim = squeeze(paths(:, i, :));
    stock_opt_price = price_func(stock_sim, rate, T, payoff_func);
    payoff = payoff_func(stock_sim);
    stock_opt_returns = mean(payoff);
    returns(:, i) = stock_opt_returns;
    prices(:, i) = stock_opt_price;
    pffs(:, i) = payoff;
end
