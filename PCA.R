library(ggplot2)

doPCAplot <- function(x=x){
  pca_df <- prcomp(x,center = T,scale. = T)
  percentage<-round(pca_df$sdev / sum(pca_df$sdev) * 100,2)
  percentage<-paste(colnames(pca_df),"(", paste(as.character(percentage), "%", ")", sep=""))
  pca_df <-data.frame(pca_df$rotation, Sample = factor(unique(colnames(x)),levels = unique(colnames(x))))
  med <- mean(pca_df$PC1)
  pca_df$PC1 <- pca_df$PC1-med
  p <-ggplot(pca_df,aes(x=PC1,y=PC2,color=Sample))+ geom_point(size=10) +
    theme_bw() +
    theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank(),panel.border = element_rect(colour = "black", fill=NA, size=5),
          #axis.line = element_line(colour = "black",size = 3,lineend = "square"),
          axis.title = element_text(family = "Arial",size = 24,face = "bold"),
          axis.text = element_text(family = "Arial",size = 26,face = "bold",color = "black"),
          legend.title = element_text(face = "bold",size = 24),
          legend.text = element_text(face = "bold",size = 26),
          legend.key.height=unit(2.5,'lines'),
          axis.ticks.length = unit(.8,"lines"),
          axis.ticks= element_line(size = 3)) + 
    xlab(paste0('PC1',percentage[1])) +
    ylab(paste0('PC2',percentage[2])) #+ coord_fixed(ylim = c(-1,1),xlim = c(-1,1))
  return(p)
}

Tn5 <- read.table('Tn5.txt',sep = '\t',header = T)
Tn5 <- Tn5[rowSums(Tn5)>0,]
p <- doPCAplot(Tn5)
p


ggsave('PCA_Tn5.svg',dpi=600,path='./',plot = p)
