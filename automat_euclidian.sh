
#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"
cmm=$1

echo "Extracting bead.ids"
grep beadID $cmm > beads
awk -F' ' '{print $11"\t"$3"\t"$4"\t"$5}' beads | sed -e "s/[beadIDxyz=/>]\+//g" | sed 's/\"//g'  > bead.ids
rm beads

echo "Getting ROI beads"
awk -F["_:-"] '{print $1"\t"$3"\t"$4}' bead.ids | awk -F" " '{print $1"\t"$2"\t"$3}' > tmp
paste tmp bead.ids > bead.bedfile
bedtools intersect -a bead.bedfile -b $2 -wa | awk -F"\t" '{print $4}' | sort | uniq > ROI

Rscript automat_euclidian.R bead.ids ROI

echo "Calculating distance to the centroid.."
awk '{ sum = ($2 ** 2) + ($3 ** 2) + ($4 ** 2); avg = sum ** 0.5 ; print $1"\t"$2"\t"$3"\t"$4, avg }' ToCentroid.txt > EuclideanCentroid.txt

