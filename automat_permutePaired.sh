#!/bin/bash
# author= sergio.espeso-gil

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"
cmm1=$1
cmm2=$2
Nperm=$4
Genome=$5

until [  $Nperm -lt 1 ]; do

echo "Computing iteration number $Nperm"
echo "Extracting bead.ids"
grep beadID $cmm1 > beads1
grep beadID $cmm2 > beads2
awk -F' ' '{print $11"\t"$3"\t"$4"\t"$5}' beads1 | sed -e "s/[beadIDxyz=/>]\+//g" | sed 's/\"//g'  > bead1.ids
rm beads1
awk -F' ' '{print $11"\t"$3"\t"$4"\t"$5}' beads2 | sed -e "s/[beadIDxyz=/>]\+//g" | sed 's/\"//g'  > bead2.ids
rm beads2


echo "Getting ROI beads"
awk -F["_:-"] '{print $1"\t"$3"\t"$4}' bead1.ids | awk -F" " '{print $1"\t"$2"\t"$3}' > tmp1
paste tmp1 bead1.ids > bead1.bedfile
awk -F["_:-"] '{print $1"\t"$3"\t"$4}' bead2.ids | awk -F" " '{print $1"\t"$2"\t"$3}' > tmp2
paste tmp2 bead2.ids > bead2.bedfile
bedtools shuffle -i $2 -g $Genome > ROI.bed
bedtools intersect -a bead1.bedfile -b ROI.bed -wa | awk -F"\t" '{print $4}' | sort | uniq > ROI1
bedtools intersect -a bead2.bedfile -b ROI.bed -wa | awk -F"\t" '{print $4}' | sort | uniq > ROI2

mkdir PairedOutput1
Rscript automat_euclidian.R bead1.ids ROI1
tail -n +2 EucledeanPairWiseTable.txt > PairedOutput1/EucledeanPairWiseTable.$Nperm.txt

mkdir PairedOutput2
Rscript automat_euclidian.R bead2.ids ROI2
tail -n +2 EucledeanPairWiseTable.txt > PairedOutput2/EucledeanPairWiseTable.$Nperm.txt


let Nperm-=1

done

cat PairedOutput1/*.txt > PairedOutput1/RandomizedMapping.txt
cat PairedOutput2/*.txt > PairedOutput1/RandomizedMapping.txt
