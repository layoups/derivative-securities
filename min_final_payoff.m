function mf_payoff = min_final_payoff(paths)
mf_payoff = max(paths(end) - min(paths), 0);