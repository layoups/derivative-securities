function [amp_payoff] = amplitude_payoff(paths)
amp_payoff = max(paths) - min(paths);