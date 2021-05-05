function [put_returns, put_payoffs] = put_returns(paths, step, min_strike, max_strike, nTrials)
put_strikes = (min_strike:step:max_strike);
put_payoffs = nan(1,length(put_strikes));

for i = 1:length(put_strikes)    
    for j = 1: nTrials    
        put_payoffs(j,i) = max(put_strikes(i) - paths(end, j),0);    
    end
end

put_returns = mean(put_payoffs);
