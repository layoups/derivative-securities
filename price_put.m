function [put_prices, put_strikes] = price_put(paths, step, min_strike, max_strike, nTrials, rate, T)
put_strikes = (min_strike:step:max_strike);
put_payoffs = nan(1,length(put_strikes));

for i = 1:length(put_strikes)    
    for j = 1: nTrials    
        put_payoffs(j,i) = max(put_strikes(i) - paths(end,j), 0);    
        put_prices = mean(exp(-rate*T)* ...    
            put_payoffs);
    end
end