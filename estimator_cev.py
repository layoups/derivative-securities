import numpy as np
import pandas as pd


class EstimatorCEV:

    def __init__(self, dt):
        self._dt = dt
        self._alpha0 = -5
    
    def Estimate(self, trajectory):
        sigma, gamma = self._evaluate_sigma_gamma(trajectory, self._alpha0)
        if sigma == None:
            return None, None, None
        else:
            mu = self._estimate_mu(trajectory)
            return (mu, sigma, gamma)

    def _log_increments(self, trajectory):
        return np.diff(trajectory) / trajectory[:-1]
    
    def _estimate_mu(self, trajectory):
        return np.mean(self._log_increments(trajectory)) / self._dt 

    def _log_increments_alpha(self, trajectory, alpha):
        mod_increments = self._log_increments(trajectory ** (1 + alpha))
        return mod_increments / (1 + alpha)

    def _evaluate_Vt(self, trajectory, alpha):
        lhs = self._log_increments_alpha(trajectory, alpha)
        rhs = self._log_increments(trajectory)
        center = 2 * (lhs - rhs) / (alpha * self._dt)
        return center

    def _evaluate_sigma_gamma(self, trajectory, alpha):
        if np.any(trajectory <= 0):
            return None, None
        
        Vts = self._evaluate_Vt(trajectory, alpha)
        if np.any(Vts <= 0):
            return None, None
        logVts = np.log(Vts)

        Sts = trajectory[:-1]  # removes the last term as in eq. (5)
        if np.any(Sts <= 0):
            return None, None
        logSts = np.log(Sts)

        ones = np.ones(Sts.shape[0])
        A = np.column_stack((ones, logSts))

        res = np.linalg.lstsq(A, logVts, rcond=-1)[0]
        return (2 * np.exp(res[0] / 2), 0.5 * (res[1] + 2))


if __name__ == "__main__":

    from cev import ProcessCEV

    returns = pd.read_csv("Returns Data.xlsx", engine='c')
    returns



    def test(true_mu, true_sigma, true_gamma):
        dt = 0.001
        T = 10
        
        sample_mu = []
        sample_sigma = []
        sample_gamma = []

        for i in range(500):
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
    # test(0.,0.5,2)