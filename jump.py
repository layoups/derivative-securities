import numpy as np 
import pandas as pd 



df = pd.read_csv("Returns Data.csv")
df = df[df.columns[:6]]

def get_jumps(df, stock):
    returns_df = df[stock]
    desc = returns_df.describe(percentiles=[0.1, 0.25, 0.5, 0.75, 0.9])
    jumps = returns_df[returns_df > desc["90%"]]
    return jumps.describe()

jumps = {s: get_jumps(df, s) for s in df.columns}
jumps_df = pd.DataFrame(jumps)
jumps_df.to_csv("jumps.csv")