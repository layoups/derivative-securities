import numpy as np


class ProcessCEV:

    def __init__(self, mu, sigma, gamma):
        self._mu = mu
        self._sigma = sigma
        self._gamma = gamma

    def Simulate(self, T=1, dt=0.001, S0=1.):
        n = round(T / dt)
        
        mu = self._mu
        sigma = self._sigma
        gamma = self._gamma

        gaussian_increments = np.random.normal(size=n - 1)
        res = np.zeros(n)
        res[0] = S0
        S = S0
        sqrt_dt = dt ** 0.5
        for i in range(int(n - 1)):
            S = S + S * mu * dt + sigma * \
                (S ** gamma) * gaussian_increments[i] * sqrt_dt
            res[i + 1] = S

        return res


