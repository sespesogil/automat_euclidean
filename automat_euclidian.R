
source("./beads.to.euc.R")
require("RColorBrewer")
require("pheatmap")
require("reshape2")

options(echo=T)
args <- commandArgs(trailingOnly = TRUE)
beads <- args[1]
ROI <- args[2]

euclidian_extraction <- beads.to.euc(beads,ROI)
rownames(euclidian_extraction) <- euclidian_extraction$bead_ID
euclidian_distances <-as.matrix(dist(euclidian_extraction[-1], method = "euclidian", diag = TRUE, upper = TRUE))
PairWiseTable<- melt(euclidian_distances)
write.table(PairWiseTable, "EucledeanPairWiseTable.txt", sep="\t", quote=FALSE, row.names=FALSE)
write.table(euclidian_distances, "EucledeanPairWiseMatrix.txt", sep="\t", quote=FALSE, row.names=TRUE)
col_groups <- substr(colnames(euclidian_distances), 1, 1)
table(col_groups)
mat_col <- data.frame(group = col_groups)
rownames(mat_col) <- colnames(euclidian_distances)
mat_colors <- list(group = brewer.pal(3, "Set1"))
names(mat_colors$group) <- unique(col_groups)
pdf("euclidian_distances.pdf",width=8,height=8)
pheatmap(
  mat               = euclidian_distances,
  color             = rainbow(1000),
  border_color      = NA,
  show_colnames     = TRUE,
  show_rownames     = TRUE,
  annotation_col    = mat_col,
  annotation_colors = mat_colors,
  drop_levels       = TRUE,
  fontsize          = 2,
  main              = "Euclidian_distances"
)
dev.off()
