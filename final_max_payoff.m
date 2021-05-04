function fm_payoff = final_max_payoff(paths)
fm_payoff = max(paths) - paths(end);