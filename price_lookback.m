function lookback_price = price_lookback(paths, rate, T, func)
lookback_price = mean(exp(-rate * T) * ...
    func(paths));