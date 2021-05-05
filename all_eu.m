function [returns, prices, strikes, pffs] = all_eu(paths, num_options, ...
    price_func, returns_func, rate, T, nTrials)

dim_stocks = size(paths);
num_stocks = dim_stocks(2);

returns = nan(num_options + 1, num_stocks);
prices = nan(num_options + 1, num_stocks);
strikes = nan(num_options + 1, num_stocks);
pffs = nan(num_options + 1, num_stocks, nTrials);

for i=1:num_stocks
    stock_sim = squeeze(paths(:, i, :));
    min_strike = round(stock_sim(end) * (0.80));
    max_strike = round(stock_sim(end) * (1.20));
    
    strike_step = (max_strike - min_strike) / num_options;
    [stock_opt_price, stock_strikes] = price_func(stock_sim, ...
    strike_step, min_strike, max_strike, nTrials, rate, T);
    [stock_opt_returns, stock_opt_payoffs] = returns_func(stock_sim, strike_step, ...
    min_strike, max_strike, nTrials); 

    returns(:, i) = stock_opt_returns';
    prices(:, i) = stock_opt_price';
    strikes(:, i) = stock_strikes';
    pffs(:, i, :) = stock_opt_payoffs';
end