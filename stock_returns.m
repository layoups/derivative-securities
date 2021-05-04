function returns = stock_returns(paths)
returns = mean((paths(end) - paths(1)) / paths(1));