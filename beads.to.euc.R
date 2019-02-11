
beads.to.euc <- function(beads_IDS, ROI) { 
a <- read.table(beads_IDS, sep = "\t", col.names=c("ID","x","y","z"))
b <- read.table(ROI, sep = "\t", col.names=c("ID"))
matrix.euclidian = merge(a, b, by=c("ID"))
final_table<-matrix.euclidian [c('bead_ID','x','y','z')]
return(final_table)
}
