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

HeigthThresold1<-quantile(EuM1$tree_row$height, probs = Quantile)


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

HeigthThresold2<-quantile(EuM2$tree_row$height, probs = Quantile)


DendroPlot2<-ggdendrogram(EuM2$tree_row, rotate = TRUE, theme_dendro = FALSE) + geom_hline(aes(yintercept=HeigthThresold2),
                                                                                           color="blue", linetype="dashed", size=1) + theme(axis.text=element_text(size=6))

ToHist<-data.frame(EuM2$tree_row$height)

HistogramHeigthPlot2<- ggplot(ToHist, aes(x= EuM2.tree_row.height)) +  geom_histogram(aes(y=..density..), colour="black", fill="white")+
  geom_density(alpha=.2, fill="#FF6666") + geom_vline(aes(xintercept=HeigthThresold2), color="blue", linetype="dashed", size=1)


Clusters2<-data.frame(sort(cutree(EuM2$tree_row, h=HeigthThresold2))) %>% setNames("Clusters_Matrix2")

SummaryDF<-cbind(Clusters1, Clusters2)

pheatmap(t(SummaryDF), fontsize = 7)

p3 = grid.grabExpr(draw(pheatmap(t(SummaryDF), fontsize = 7)))

p1<-plot_grid(HistogramHeigthPlot1, HistogramHeigthPlot2, 
              DendroPlot1, DendroPlot2,nrow=2)


p3 = grid.grabExpr(draw(pheatmap(t(SummaryDF), fontsize = 7)))

plots <- align_plots(p3, p1, align = 'v', axis = 'l')
upper_row <- plot_grid(plots[[2]])

CutTheTreePlot<-plot_grid(upper_row, plots[[1]],ncol = 1)

return(CutTheTreePlot)

}

#' UntangeTheThree
#' Functions to compare number trees
#' @author sergio.espeso-gil
#' @param EuclideanMatrix1 Euclidean distances matrix 1 
#' @param EuclideanMatrix2 Euclidean distances matrix 2
#' @param Untaggling apply untanggling 
#' @param Method methodology to untanggle the trees
#' @Quantile  quantile value to be used 
#' @example CutTheTree(EuclideanMatrix1, EuclideanMatrix2, Quantile=0.95)
#' @export 

UntangeTheThree<-function(EuclideanMatrix1, EuclidianMatrix2, Untaggling=TRUE, Method="step2side"){
  
  
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
  
  
D1<-as.dendrogram(EuM1$tree_row)
D2<-as.dendrogram(EuM2$tree_row)
dl <- dendlist(D1, D2)

if (Untaggling == FALSE){
  
UntangeTheThree<-tanglegram(dl)
  
} else {

  Ut <- dl %>% untangle(method = Method) 
  UntangeTheThree<-Ut %>% plot(main = paste("entanglement =", round(entanglement(Ut), 2))) 
  
}

return(UntangeTheThree)

}

