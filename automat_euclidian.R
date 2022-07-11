
source("./beads.to.euc.R")
require("RColorBrewer")
require("pheatmap")
require("reshape2")
require("ggbiplot")
require("ggplot2")

options(echo=T)
args <- commandArgs(trailingOnly = TRUE)
beads <- args[1]
ROI <- args[2]

euclidian_extraction <- beads.to.euc(beads,ROI)
write.table(euclidian_extraction, "ToCentroid.txt", sep="\t", quote=FALSE, row.names=FALSE)
rownames(euclidian_extraction) <- euclidian_extraction$bead_ID
euclidian_distances <-as.matrix(dist(euclidian_extraction[-1], method = "euclidian", diag = TRUE, upper = TRUE))

toPCA <- prcomp(euclidian_distances,
             center = TRUE,
            scale. = TRUE)
g <- ggbiplot(toPCA, ellipse=FALSE, circle = FALSE, var.axes=F)

pdf("PCAeuclidian_distances.pdf",width=8,height=8)
g
dev.off()



PairWiseTable<- melt(euclidian_distances)

close<-subset(PairWiseTable, value < 10)
close$group<-"1_Close"
medium1<-subset(PairWiseTable, value >= 10 )
medium2<-subset(medium1, value < 30 )
medium2$group<-"2_Mid"
far<-subset(PairWiseTable, value >= 30)
far$group<-"3_Far"
ToPlot<-rbind(close,
              medium2,
              far)
pdf("BoxPlotDistances.pdf",width=8,height=8)
ggplot(ToPlot, aes(x=group, y=value, fill=group)) + geom_boxplot()
dev.off()

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
