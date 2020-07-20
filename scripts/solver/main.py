import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import sys

from tqdm import tqdm
from read_files import *
from solvers import *
from monitor import *


monitor("outputs", "psrecord", log=False, plot=True)


file = sys.argv[1]
title = file.split("/")[-1]
costs = []
solutioned = False
#small = pd.read_csv(file)
small = read_file(file)
for i in tqdm(range(0, 20)):
    while not solutioned:
        print(i)
        sol = run_pipe(1, 6, small, 20, -20, how_try=100000)
        solutioned = is_solution(sol, 1, 6)
        if solutioned:
            sol.to_csv(f"{title}_{i}.csv", index=False)
            cost = compute_total_cost(sol)
            costs.append(cost)
        print(f"{i} -> {solutioned} : {compute_total_cost(sol)}")
        del sol
    solutioned = False

sns.set()

fig, axs = plt.subplots(nrows=2)

sns.scatterplot(x=np.array(range(0, len(costs))), y=np.array(sorted(costs, reverse=True)), ax=axs[0])
sns.scatterplot(x=np.array(range(0, len(costs))), y=np.array(costs), ax=axs[1])
fig.savefig(f"outputs/{title}.png")
