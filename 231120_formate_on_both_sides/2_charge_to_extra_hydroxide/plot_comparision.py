import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.ticker import StrMethodFormatter, NullFormatter, AutoMinorLocator
from matplotlib import rcParams
import numpy as np

font = {"size": 10}
plt.rc("font", **font)
plt.rc("legend", fontsize=18)
# rcParams['axes.titlepad'] = 20

df1 = pd.read_csv("fe3_comparison.txt", header=None, delimiter=" ")
df1 = df1.T
df1["layer"] = df1.index

# Create subplots
fig, axs = plt.subplots(5, 1, sharex=True, figsize=(4, 18))

fig.subplots_adjust(hspace=0.15, wspace=0.01)

# Plot each subplot
for i in range(5):
    axs[i].plot(
        df1[i][1:] / 36,
        df1.layer[1:],
        linewidth=4,
        color="blue",
    )
    axs[i].set_ylim(axs[i].get_ylim()[::-1])
    axs[i].set_xlim([0.0, 1.05])
    axs[i].set_yticks([0, 5, 10, 15])
    axs[i].set_xticks([0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0])
    axs[i].grid(True, linestyle="--")
    axs[i].set_ylabel(r"Fe$_\mathrm{oct}$ layer", ha="center", fontsize=24, labelpad=10)


axs[0].set_title("-OH asymmetric", pad=5, fontsize=15)
axs[1].set_title("-OH symmetric", pad=5, fontsize=15)
axs[2].set_title("extra H (pos1)", pad=5, fontsize=15)
axs[3].set_title("extra H (pos2)", pad=5, fontsize=15)
axs[4].set_title("extra H (pos3)", pad=5, fontsize=15)


axs[3].set_ylabel(r"Fe$_\mathrm{oct}$ layer", ha="center", fontsize=24, labelpad=10)
axs[4].set_xlabel(
    r"$n_{\mathrm{{Fe}_{oct}^{3+}}}/{n_{\mathrm{{Fe}_{oct}}}}}}$",
    labelpad=25,
    fontsize=24,
)
# Display the plot

fig.savefig("models_comp.pdf", format="pdf", bbox_inches="tight")
fig.savefig("models_comp.png", dpi=300.0, format="png", bbox_inches="tight")

plt.tight_layout()
plt.show()
