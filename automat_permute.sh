#!/bin/bash
# author= sergio.espeso-gil

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"
cmm=$1
Nperm=$3
Genome=$4

until [  $Nperm -lt 1 ]; do

echo "Computing iteration number $Nperm"
echo "Extracting bead.ids"
grep beadID $cmm > beads
awk -F' ' '{print $11"\t"$3"\t"$4"\t"$5}' beads | sed -e "s/[beadIDxyz=/>]\+//g" | sed 's/\"//g'  > bead.ids
rm beads

echo "Getting ROI beads"
awk -F["_:-"] '{print $1"\t"$3"\t"$4}' bead.ids | awk -F" " '{print $1"\t"$2"\t"$3}' > tmp
paste tmp bead.ids > bead.bedfile
bedtools shuffle -i $2 -g $Genome > ROI.bed
bedtools intersect -a bead.bedfile -b ROI.bed -wa | awk -F"\t" '{print $4}' | sort | uniq > ROI

Rscript automat_euclidian.R bead.ids ROI

mkdir output

mv EucledeanPairWiseTable.txt output/EucledeanPairWiseTable.$Nperm.txt
mv EucledeanPairWiseTable.txt output/EucledeanPairWiseTable.$Nperm.txt

let Nperm-=1

done
