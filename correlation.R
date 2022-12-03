rpkm <- read.table('rpkm.txt',sep = '\t',header = T)
rpkm <- rpkm[rowSums(rpkm)>0,]

rpkm <- log2(rpkm+1)
png(sprintf("~/plpt/cor.png"), width = 8, height = 8, units = "in", res = 300)
panel_upper <- function(x, y, digits = 2, col, ...) { 
  usr <- par("usr"); on.exit(par(usr)) 
  par(usr = c(0, 1, 0, 1))  
  # 文本颜色  
  text_color <- if(cor(x, y) > 0) {"black"} else {"white"} # 大于0为黑色，小于0为白色
  # 文本内容
  #txt <- round(cor(x,y), 2) # 保留2位小数
  txt <- floor(cor(x,y)*100)/100 # 保留2位小数
  # 背景颜色
  col_index <- if (cor(x,y) > 0) {(1 - cor(x,y))} else {(1 + cor(x,y))}
  bg_col <- if (cor(x,y) > 0) {
    rgb(red = 1, green = col_index, blue = col_index)
  } else { rgb(red = col_index, green = col_index, blue = 1)}
  # 绘图
  rect(xleft = 0, ybottom = 0, xright = 1, ytop = 1, col = bg_col) # rect画背景
  text(x = 0.5, y = 0.5, labels = txt, cex = 2, col = text_color,family='Arial',font=2)
}
# 定义下三角panel
panel_lower <- function(x, y, bg = NA, pch = par("pch"),
                        cex = 1.5, col_smooth = "blue",...) {
  points(x, y, pch = pch, bg = bg, cex = cex)
  abline(stats::lm(y ~ x), col = col_smooth,...)
}
# 绘图
par(lwd=2,cex.axis=1.5,font.axis=2)
pairs(rpkm, main ="",
      pch = 20, 
      upper.panel = panel_upper,
      lower.panel = panel_lower,
      font.labels=2)

dev.off()
