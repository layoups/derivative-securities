import matplotlib.pyplot as plt
from cev import ProcessCEV


T = 20
dt = 0.01
for i in range(10):
    # plt.plot(ProcessCEV(0.05, 0.15, 0.5).Simulate(
    #     T, dt), label="CEV (gamma = 0.5)")
    # plt.plot(ProcessCEV(0.05, 0.15, 1.5).Simulate(
    #     T, dt), label="CEV (gamma = 1.5)")
    plt.plot(ProcessCEV(0.05, 0.15, 0.5).Simulate(
        T, dt))
    plt.plot(ProcessCEV(0.05, 0.15, 1.5).Simulate(
        T, dt))

plt.xlabel('Time index')
plt.ylabel('Value')
plt.title("Realization of stochastic processes")
plt.legend(["CEV (gamma = 1.5)"])
plt.show()