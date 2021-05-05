function [call_returns, call_payoffs] = call_returns(paths, step, min_strike, max_strike, nTrials)
call_strikes = (min_strike:step:max_strike);
call_payoffs = nan(1,length(call_strikes));

for i = 1:length(call_strikes)    
    for j = 1: nTrials    
        call_payoffs(j,i) = max(paths(end,j) - call_strikes(i),0);    
    end
end

call_returns = mean(call_payoffs);
