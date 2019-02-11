
#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"
cmm=$1

echo "Extracting bead.ids" 
grep beadID $cmm > beads
awk -F' ' '{print $11"\t"$3"\t"$4"\t"$5}' beads | sed -e "s/[beadIDxyz=/>]\+//g" | sed 's/\"//g'  > bead.ids
rm beads

R --vanilla bead.ids $2 < automat_euclidian.R
