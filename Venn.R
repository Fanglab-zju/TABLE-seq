library(grid)
library(VennDiagram)
library(ggplot2)
rpkm <- read.table('rpkm.txt',sep = '\t',header = T)
rpkm[rpkm==0]<-NA
rpkm$gene <- rownames(rpkm)

A=rownames(na.omit(rpkm[,c('TABLE-seq','dUTP_based')]))
B=rownames(na.omit(rpkm[,c('TABLE-seq','dUTP_based')]))

venn.plot<-venn.diagram(
  x=list(A=A,B=B),
  filename = NULL,
  height = 3000,
  width = 4000,
  # cat.pos = c(0,0,120,95,0),
  category.names = c("TABLE-seq","dUTP based"),
  fill = c("#4472C4", "#ED7D31"),
  fontface = 'bold',cat.fontface = rep('bold',2),cat.cex = rep(3,2),cex = 1.5,cat.fontfamily = rep('Arial',2),
  margin=0.2
);

ggsave ("venn.svg",plot=venn.plot,width = 12,height = 12,dpi=600,path = "./")
