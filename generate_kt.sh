PVAR=0.0
NVAR=8000
FVAR=5

printf "Pressure: $PVAR\n"
printf "Num. Atoms: $NVAR\n"
# printf "Pdamp: $FVAR\n" todo: check with Starr to make sure this is right

printf "Enter k-value: (int or float)\n"
read KVAR

printf "Enter t-value: (float)\n"
read TVAR

# if needed, make the specific directories
mkdir k${KVAR}; mkdir k${KVAR}/t${TVAR}

cp -r kkk/ttt/. k${KVAR}/t${TVAR}/ # copy abstract directory contents into specific dir
cd k${KVAR}/t${TVAR}/

sed -i "s/kkk/$KVAR/g" *; rename {kkk} {${KVAR}} * # change all kkk -> specific k
sed -i "s/TTT/$TVAR/g" *; rename {TTT} {${TVAR}} * # change all ttt -> specific t
sed -i "s/ppp/$PVAR/g" *; rename {ppp} {${PVAR}} * # etc...
sed -i "s/nnn/$NVAR/g" *; rename {nnn} {${NVAR}} * # etc...
sed -i "s/fff/$FVAR/g" *; rename {fff} {${FVAR}} * # note2self: use a loop dingus

sbatch cpu.sub && cd ../../