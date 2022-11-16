COMMIT_STR=$1

for knum in {1,2,5,10,20,50,100};
do for tnum in 0.45 0.50 0.55 0.6 0.7 0.8 0.9 1.0 1.1 1.2;
# do cp -r poly_copy/polymers/k$knum/t$tnum polymer/k$knum/t$tnum && printf "coping folder...\n"
do git add k$knum/t$tnum && git commit -m "$COMMIT_STR: k$knum, t$tnum" && git push
#do printf "$COMMIT_STR: k$knum/t$tnum\n";
done;
done; # clever git
