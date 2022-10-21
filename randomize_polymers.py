#!/usr/bin/env python
# coding: utf-8

# # Outputs three .xyz files: one that randomizes the posititons of the atoms, one that lists the bond configs, and one that lists the angle configs.
# # Requires polymers.txt (only the initial atomic positions) in same directory.

import numpy as np
import pandas as pd
columns = ['index', 'chain', 'type', 'xcoord', 'ycoord', 'zcoord']
atoms = pd.read_csv('polymers.txt', names = columns)

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
    chain_col[i] = [i+1]*CHAIN_LENGTH
chain_col = chain_col.flatten()

atoms['chain'] = chain_col # insert new column into the dataframe

# here we want to choose 40 chains to stiffen at random from a sequence of 800 chains.
import random
seq = range(1,TOTAL_CHAINS + 1)
stiffs = random.sample(seq, STIFFENED_CHAINS) # indices of the stiffened chains

atoms.loc[atoms['chain'].isin(stiffs), 'type'] = TYPE_2

# first, sort them by type such that all the type 2 are at the end
atoms = atoms.sort_values(by = ['type', 'index'])
# then, re-order the index and chain so that our stiffened ones are at the end once again:
atoms['chain'] = chain_col
atoms['index'] = np.arange(1, TOTAL_CHAINS*CHAIN_LENGTH+1)

# re-print the bonds:
first_col = np.arange(1, (CHAIN_LENGTH-1)*TOTAL_CHAINS + 1, dtype = int)
second_col = np.ones_like(first_col)

# third col is trickier to generate:
third_col = []
for i in range(CHAIN_LENGTH * TOTAL_CHAINS):
    if i % CHAIN_LENGTH != 0: # if it is not at the end of the chain...
        third_col.append(i) # add number to array
third_col = np.array(third_col)
fourth_col = third_col + 1 # why I love numpy

bonds = pd.DataFrame(np.transpose([first_col, second_col, third_col, fourth_col]))


# similar setup for new angles
angles_1 = np.arange(1, (CHAIN_LENGTH-2)*STIFFENED_CHAINS + 1, dtype = int)
angles_2 = np.ones_like(angles_1)

# third col starts from 1 and counts up to number of stiffened monomers
angles_3 = []
for i in range(CHAIN_LENGTH * STIFFENED_CHAINS):
    # skip the last two on the chain in this column
    if ((i +1) % 10!= 0) and ((i+2)%10 != 0):
        angles_3.append(i+ (TOTAL_CHAINS - STIFFENED_CHAINS) * CHAIN_LENGTH + 1)
angles_3 = np.array(angles_3)
angles_4 = angles_3 + 1
angles_5 = angles_4 + 1

angles = pd.DataFrame(np.transpose([angles_1, angles_2, angles_3, angles_4, angles_5]))

# save everything to text for copying and pasting back into LAMMPS
# todo: perhaps there is a way for python to insert these into their proper locations?
atoms.to_csv('randomized_polys.xyz', sep = ' ', index = False, header = False)
angles.to_csv('corrected_angles.xyz', sep = ' ', index = False, header = False)
bonds.to_csv('corrected_bonds.xyz', sep = ' ', index = False, header = False)
