#!/bin/bash
# author= sergio.espeso-gil
# Allows to run a permutation analysis using Chrom3D models to infer the likelihood of finding euclidean distances of regions of interest versus randomness. 
# Requires: 1) Chrom3D model (cmm format) , 2) Regions of interest (ROI) , 3) Number of iterations,  4) Chromosomes sizes
# Example : sh automat_permute.sh yourmodel.cmm ROI.txt 100000 mm10.chrom.sizes

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

Filename="$(basename $2)"
out=$(echo "$(basename $2)._automat_permute")
mkdir $out

tail -n +2 EucledeanPairWiseTable.txt > $out/EucledeanPairWiseTable.$Nperm.txt


let Nperm-=1

done

cat $out/*.txt > $out/$Filename.RandomizedMapping.$Nperm.txt


