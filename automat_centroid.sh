awk '{ sum = ($2 ** 2) + ($3 ** 2) + ($4 ** 2); avg = sum ** 0.5 ; print $1"\t"$2"\t"$3"\t"$4, avg }' beads_coordinates.ids > test.id
