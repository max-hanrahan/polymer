numatoms=8000
chainlength=20

printf "There are $numatoms atoms and the chain length is $chainlength.\n"
printf "How many polymers would you like stiffened?\n"

read chains
startfrom=$((numatoms - chainlength * chains))+1 # the index of the first monomer (TODO: off by one?)

sed -i '23626,$d' t0.5p0.0n8000npt.lmp #clears the end of the file so that we may run this script without manually resetting
printf "Angles\n\n" >> t0.5p0.0n8000npt.lmp;

# Careful! This is a tricky loop. We use i to calculate the ID, and only increment
# i when we're not considering monomers at the start or end of the polymers.
# However, index is the ID, and should increment in every loop.
index=1
for ((i=1; index< $chains * ($chainlength - 2) +1; i++));
do if ((i%$chainlength != 0)) && ((i%$chainlength != 19));
then echo "$index 1 $((startfrom-1 + $i)) $((startfrom + $i)) $((startfrom+1 + $i))" >> t0.5p0.0n8000npt.lmp;
index=$((index+1))
fi;
done;
