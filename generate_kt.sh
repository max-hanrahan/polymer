PVAR=0.0
NVAR=8000
FVAR=5
TSTEP=0.3
EPS=1.0

# read user input
KVAR=$1
TVAR=$2

# optional vars: node number (def 46) and restart (default False)
NODEVAR=${3:-46}
RESTART=${4:-false}

# this is to get the value of t_high right (I suppose I could've made a function)
if echo "$TVAR > 0.9" | bc -l | grep -q 1; then
    T_HIGH=1.2
elif echo "$TVAR > 0.6" | bc -l | grep -q 1; then
    T_HIGH="$(echo "$TVAR + $TSTEP" | bc | awk '{printf "%.1f", $0}')" # for TVAR = 0.6-0.8
elif echo "$TVAR >= 0.45" | bc -l | grep -q 1; then
    T_HIGH="$(echo "2*$TVAR - $TSTEP" | bc | awk '{printf "%.1f", $0}')" # for TVAR = 0.6-0.8
fi

if $RESTART; then
    T_HIGH=$TVAR
    
fi

NUM_STIFF="$(echo "$FVAR * $NVAR /100" | bc)"

printf "Inputted: k= $KVAR, T = $TVAR\n"
printf "Node = $NODEVAR, Restart = $RESTART\n\n"
printf "Pressure: $PVAR\n"
printf "Num. Atoms: $NVAR\n"
printf "Stiffened Chains: $FVAR%% ($NUM_STIFF atoms) \n"
printf "Epsilon: $EPS\n\n"

# if needed, make the specific directories
mkdir -p k${KVAR}; mkdir -p k${KVAR}/t${TVAR}
# copy t${TVAR+TSTEP} restart to this new directory:
cp k${KVAR}/t${T_HIGH}/k${KVAR}t${T_HIGH}p${PVAR}f${FVAR}n${NVAR}npt-1.res k${KVAR}/t${TVAR}/

cp -r kkk/ttt/. k${KVAR}/t${TVAR}/ # copy abstract directory contents into specific dir
cd k${KVAR}/t${TVAR}/

sed -i "s/kkk/$KVAR/g" *; rename {kkk} ${KVAR} * # change all {kkk} -> specific k
sed -i "s/TTT/$TVAR/g" *; rename {TTT} ${TVAR} * # change all {ttt} -> specific t
sed -i "s/ppp/$PVAR/g" *; rename {ppp} ${PVAR} * # etc...
sed -i "s/nnn/$NVAR/g" *; rename {nnn} ${NVAR} * # etc...
sed -i "s/fff/$FVAR/g" *; rename {fff} ${FVAR} * # etc...
sed -i "s/t_high/$T_HIGH/g" *;


# one more silly workaround for cpu.sub
sed -i "s/{{k}}/$KVAR/g" cpu.sub; # change all {kkk} -> specific k
sed -i "s/{{T}}/$TVAR/g" cpu.sub; # change all {ttt} -> specific t
sed -i "s/{{p}}/$PVAR/g" cpu.sub; # etc...
sed -i "s/{{n}}/$NVAR/g" cpu.sub; # etc...
sed -i "s/{{f}}/$FVAR/g" cpu.sub; # etc...

sed -i "s/NN/$NODEVAR/g" cpu.sub;

sbatch cpu.sub && cd ../../
