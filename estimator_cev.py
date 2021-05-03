import numpy as np
import pandas as pd


class EstimatorCEV:

    def __init__(self, dt):
        self._dt = dt
        self._alpha0 = 3
    
    def Estimate(self, trajectory):
        alpha, Vt = self._estimate_alpha(trajectory)
        sigma, gamma = self._evaluate_sigma_gamma(trajectory, alpha, Vt)
        if sigma == None:
            return None, None, None
        else:
            mu = self._estimate_mu(trajectory)
            return (mu, sigma, gamma)

    def _get_alpha(self, u, V):
        return -13 / 11 - 12 / 11 * u / V

    def _estimate_alpha(self, trajectory):
        u = self._estimate_mu(trajectory)
        error = 10
        eps = 1e-8
        alpha = self._alpha0

        while np.sum(error) > eps:
            V = self._evaluate_Vt(trajectory, alpha)
            new_alpha = self._get_alpha(u, V)
            alpha = new_alpha
            error = (alpha - new_alpha) ** 2
        
        return new_alpha, V

    def _log_increments(self, trajectory):
        return np.diff(trajectory) / trajectory[:-1]
    
    def _estimate_mu(self, trajectory):
        return np.mean(self._log_increments(trajectory)) / self._dt 
        # return np.mean(trajectory)

    def _log_increments_alpha(self, trajectory, alpha):
        mod_increments = self._log_increments(trajectory ** (1 + alpha))
        return mod_increments / (1 + alpha)

    def _evaluate_Vt(self, trajectory, alpha):
        lhs = self._log_increments_alpha(trajectory, alpha)
        rhs = self._log_increments(trajectory)
        center = 2 * (lhs - rhs) / (alpha * self._dt)
        return center

    def _evaluate_sigma_gamma(self, trajectory, alpha, Vt):
        if np.any(trajectory <= 0):
            return None, None

        Vt[np.where(Vt == 0)[0]] += 1e-8
        logVt = np.log(Vt)

        St = trajectory[:-1] 
        if np.any(St <= 0):
            return None, None
        logSt = np.log(St)

        twos = 2 * np.ones(St.shape[0])
        A = np.column_stack((twos, logSt))

        res = np.linalg.lstsq(A, logVt, rcond=-1)[0]
        return (2 * np.exp(res[0]), 0.5 * (res[1] + 2))


if __name__ == "__main__":

    from cev import ProcessCEV

    df = pd.read_csv("Stock Data.csv")
    stock_df = df[df.columns[1:6]]
    stock_dict = stock_df.to_dict("series")

    def get_stock_gamma(stock):
        return EstimatorCEV(dt=1/252).Estimate(stock_dict[stock])[2]


    for s in stock_dict:
        print("Gamma for {} is {}".format(s, get_stock_gamma(s)))

    gammas = {s: [get_stock_gamma(s)] for s in stock_dict}
    gammas_df = pd.DataFrame.from_dict(gammas)
    print(gammas_df)
    gammas_df.to_csv("stock_gammas.csv")



    def test(true_mu, true_sigma, true_gamma):
        dt = 0.001
        T = 10
        
        sample_mu = []
        sample_sigma = []
        sample_gamma = []

        for i in range(100):
            mu_est, sigma_est, gamma_est = EstimatorCEV(dt=dt).Estimate(ProcessCEV(
                true_mu, true_sigma, true_gamma).Simulate(T, dt=dt))
            
            if mu_est != None:
                sample_mu = [mu_est] + sample_mu
                sample_sigma = [sigma_est] + sample_sigma
                sample_gamma = [gamma_est ] + sample_gamma
    
        print("mu : " + str(true_mu) + " \t| est : " + str(np.mean(sample_mu)) + " \t| std : " + str(np.std(sample_mu)))
        print("sigma : " + str(true_sigma) + " \t| est : " + str(np.mean(sample_sigma)) + " \t| std : " + str(np.std(sample_sigma)))
        print("gamma : " + str(true_gamma) + " \t| est : " + str(np.mean(sample_gamma)) + " \t| std : " + str(np.std(sample_gamma)))
        print(10*"-")


    # test(0.,0.5,0.8)
    # test(0.2,0.5,0.8)
    # test(0.2,0.5,1.2)
    # test(0.,0.3,0.2)
    # test(0.,3,2)