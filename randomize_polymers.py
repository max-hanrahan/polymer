# # Creates a file called swapped_coords.xyz that swaps the coordinates to our desired outcome.
# # Requires polymers.txt (the initial atomic positions) in same directory.
import numpy as np
import pandas as pd
import random
columns = ['index', 'chain', 'type', 'xcoord', 'ycoord', 'zcoord']
df = pd.read_csv('polymers.txt', names = columns)

CHAIN_LENGTH = 20 # number of chains per polymer
STIFFENED_CHAINS = 20 # number of chains to stiffen
TOTAL_CHAINS = 400 # total number of chains
TYPE_1 = 1 # atom type 1
TYPE_2 = 2 # atom_type 2

# todo: maybe specify percentages so we don't have to keep changing these "global" variables
CHAIN_LENGTH = int(CHAIN_LENGTH / 2) # cut the chains in half
STIFFENED_CHAINS = int(STIFFENED_CHAINS * 2) # double the stiffened chains
TOTAL_CHAINS = int(TOTAL_CHAINS * 2) # double the total chains

# create new column of correct chain indices
chain_col = np.zeros((TOTAL_CHAINS, CHAIN_LENGTH))
for i in range(0, TOTAL_CHAINS):
    chain_col[i] = [i+1]*10
chain_col = chain_col.flatten()

df['chain'] = chain_col # insert new column into the dataframe

# here we want to choose 40 chains to stiffen at random from a sequence of 800 chains.
seq = range(1,TOTAL_CHAINS + 1)
stiffs = random.sample(seq, STIFFENED_CHAINS) # indices of the stiffened chains
df.loc[df['chain'].isin(stiffs), 'type'] = TYPE_2

# since order of index doesn't matter, might as well sort them by index:
df = df.sort_values(by = 'index')
df.to_csv('randomized_polys.xyz', sep = ' ', index = False, header = False)
