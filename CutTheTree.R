#' Cut The Tree
#' Functions to compare number of clusters and members across two matrices with the same set of domains (beads)
#' @author sergio.espeso-gil
#' @param EuclideanMatrix1 Euclidean distances matrix 1 
#' @param EuclideanMatrix2 Euclidean distances matrix 2
#' @Quantile  quantile value to be used 
#' @example CutTheTree(EuclideanMatrix1, EuclideanMatrix2, Quantile=0.95)
#' @export 

require("RColorBrewer")
require("pheatmap")
require("reshape2")
require("ggbiplot")
require("ggplot2")
require("cowplot")
require("ggdendro")
require("dplyr")
require(ComplexHeatmap)
require(gridExtra)
require(dendextend)


CutTheTree<-function(EuclideanMatrix1, EuclidianMatrix2 , Quantile=0.95){

# Extract EuM1:
col_groups <- substr(colnames(EuclideanMatrix1), 1, 1)
table(col_groups)
mat_col <- data.frame(group = col_groups)
rownames(mat_col) <- colnames(EuclideanMatrix1)
mat_colors <- list(group = brewer.pal(3, "Set1"))
names(mat_colors$group) <- unique(col_groups)

EuM1= pheatmap::pheatmap(
  mat               = EuclideanMatrix1,
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

# HeigthThresold1<-quantile(EuM1$tree_row$height, probs = Quantile)
HeigthThresold1<-125

DendroPlot1<-ggdendrogram(EuM1$tree_row, rotate = TRUE, theme_dendro = FALSE) + geom_hline(aes(yintercept=HeigthThresold1),
                                                                              color="blue", linetype="dashed", size=1) + theme(axis.text=element_text(size=6))

ToHist<-data.frame(EuM1$tree_row$height)

HistogramHeigthPlot1<- ggplot(ToHist, aes(x= EuM1.tree_row.height)) +  geom_histogram(aes(y=..density..), colour="black", fill="white")+
  geom_density(alpha=.2, fill="#FF6666") + geom_vline(aes(xintercept=HeigthThresold1), color="blue", linetype="dashed", size=1)


Clusters1<-data.frame(sort(cutree(EuM1$tree_row, h=HeigthThresold1))) %>% setNames("Clusters_Matrix1")

# Extract EuM2:
col_groups <- substr(colnames(EuclideanMatrix2), 1, 1)
table(col_groups)
mat_col <- data.frame(group = col_groups)
rownames(mat_col) <- colnames(EuclideanMatrix2)
mat_colors <- list(group = brewer.pal(3, "Set1"))
names(mat_colors$group) <- unique(col_groups)

EuM2= pheatmap::pheatmap(
  mat               = EuclideanMatrix2,
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

# HeigthThresold2<-quantile(EuM2$tree_row$height, probs = Quantile)
HeigthThresold2<-125

DendroPlot2<-ggdendrogram(EuM2$tree_row, rotate = TRUE, theme_dendro = FALSE) + geom_hline(aes(yintercept=HeigthThresold2),
                                                                                           color="blue", linetype="dashed", size=1) + theme(axis.text=element_text(size=6))

ToHist<-data.frame(EuM2$tree_row$height)

HistogramHeigthPlot2<- ggplot(ToHist, aes(x= EuM2.tree_row.height)) +  geom_histogram(aes(y=..density..), colour="black", fill="white")+
  geom_density(alpha=.2, fill="#FF6666") + geom_vline(aes(xintercept=HeigthThresold2), color="blue", linetype="dashed", size=1)


Clusters2<-data.frame(sort(cutree(EuM2$tree_row, h=HeigthThresold2))) %>% setNames("Clusters_Matrix2")

# plot dendogram plots:
pdf("DendogramsPlot2.pdf",width=8,height=8)
DendroPlot<-plot_grid(HistogramHeigthPlot1, HistogramHeigthPlot2, 
          DendroPlot1, DendroPlot2)
DendroPlot

dev.off()
          

SummaryDF<-cbind(Clusters1, Clusters2)

pdf("DomainAssociatedClusters.pdf",width=15,height=8)

pheatmap(t(SummaryDF), fontsize = 7)

dev.off()

SummaryClusters<-data.frame(t(data.frame(
Number_clusters_M1=length(unique(as.numeric(Clusters1$Clusters_Matrix1))),
Number_clusters_M2=length(unique(as.numeric(Clusters2$Clusters_Matrix2)))))) %>% setNames("Number of clusters")
SummaryClusters$group<-rownames(SummaryClusters)


D1<-as.dendrogram(EuM1$tree_row)
D2<-as.dendrogram(EuM2$tree_row)
dl <- dendlist(D1, D2)


pdf("DiffDendroGram.pdf",width=15,height=8)

dend_diff(D1, D2)

dev.off()


pdf("TangleGramDefault.pdf",width=15,height=8)

dl <- dendlist(D1, D2)
tanglegram(dl)

dev.off()



pdf("TangleGramUntaggled.pdf",width=15,height=8)

x <- dl %>% untangle(method = "step2side") 
x %>% plot(main = paste("entanglement =", round(entanglement(x), 2)))

dev.off()


}
