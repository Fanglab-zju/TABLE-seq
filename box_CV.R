library(ggplot2)

rpkm <- read.table('rpkm_rep.txt',header = T)
rpkm <- rpkm[rowSums(rpkm)>0,]

TABLEseq <- rpkm[,c(1,2)]
dUTP <- rpkm[,c(3,4)]

SD <- apply(TABLEseq,1, sd)
CV_TABLEseq <- as.data.frame(SD / colMeans(TABLEseq) * 100)
CV_TABLEseq$seq_name <- 'TABLE-seq'
names(CV_TABLEseq)[1] <- 'CV'

SD <- apply(dUTP,1, sd)
CV_dUTP <- as.data.frame(SD / colMeans(dUTP) * 100)
CV_dUTP$seq_name <- 'dUTP'
names(CV_dUTP)[1] <- 'CV'

CV <- rbind(CV_TABLEseq,CV_dUTP)



CV$seq_name <- factor(CV$seq_name,levels = c('TABLE-seq','dUTP'))
library(ggpubr)
my_comparisons <- list(c('TABLE-seq','dUTP'))
p1<-ggplot(data = CV,aes(x = seq_name,y = CV,fill=seq_name))+
  stat_boxplot(geom = "errorbar",width=0.3,size=3)+
  stat_compare_means(comparisons = my_comparisons, label = "p.format",
                     face='bold',size=14,hide.ns = F,
                     bracket.size = 3,method = 't.test',p.adjust.methods='BH',vjust = 0,
                     label.y = c(90))+
  geom_boxplot(outlier.colour = NA)+
  theme_bw()+
  geom_boxplot(size=2,outlier.colour = NA)+ theme_bw()+ 
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),panel.border = element_blank(),
        axis.line = element_line(colour = "black",size = 3,lineend = "square"),
        axis.title = element_blank(),
        axis.text = element_text(family = "Arial",size = 40,face = 'bold',color = "black"),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.length = unit(.6,"lines"),
        axis.ticks= element_line(size = 3)) + guides(fill=F)+
  labs(x='',y='')+
  scale_fill_manual(values = c('#4472C4','#ED7D31'))+ylim(0,120)
ggsave('CV.svg',p1,dpi=600,height = 8,width = 10,path = './')

