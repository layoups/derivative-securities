function [returns, pffs] = stock_returns(paths)
temp = (paths(end, :) - paths(1, :)) ./ paths(1, :);
returns = mean(temp);
pffs = paths(end, :) - paths(1, :);