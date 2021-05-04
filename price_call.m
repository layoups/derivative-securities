function [call_prices, call_strikes] = price_call(paths, step, min_strike, max_strike, nTrials, rate, T)
call_strikes = (min_strike:step:max_strike);
call_payoffs = nan(1,length(call_strikes));

for i = 1:length(call_strikes)    
    for j = 1: nTrials    
        call_payoffs(j,i) = max(paths(end,j) - call_strikes(i),0);    
        call_prices = mean(exp(-rate*T)*...    
            call_payoffs);
    end
end