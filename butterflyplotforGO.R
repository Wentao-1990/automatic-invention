
library(ggplot2)
library(cowplot)
library(optparse)


option_list <- list(
  make_option(c("-u","--up"),type="character",default = "upgo.txt",
              help = "Input table file to read [default %default]"),
  make_option(c("-d","--down"),type="character",default = "downgo.txt",
              help = "Input table file to read [default %default]"),
  make_option(c("-o","--output"),type="character",default= "output.txt",
              help = "output table file to write [default %default]")
)

opts <- parse_args(OptionParser(option_list = option_list ))

print(paste("The input file is ", c(opts$u, opts$d),  sep = ""))
print(paste("The output file is ", opts$output, sep = ""))



up <- read.table(opts$up, sep="\t" ,row.names = 1, quote="")
down <- read.table(opts$down ,sep="\t" ,row.names = 1,quote="")

up <- up[order(up$pvalue, decreasing = TRUE), ]
if(length(up[,1])>10){
	up <- tail(up,10)
}else{
	up <- up
}
up$Description <- factor(up$Description, levels = up$Description)
id_up <- levels(up$Description)

down <- down[order(down$pvalue, decreasing = TRUE), ]

if(length(down[,1])>10){
	down <- tail(down,10)
}else{
	down <- down
}

down$Description <- factor(down$Description, levels = down$Description)
id_down <- levels(down$Description)

n <- length(up$Description) - length(down$Description)
if (n > 0) {
  down$Description <- as.character(down$Description)
  for (i in paste('nn', as.character(seq(1, n, 1)), sep = '')) down <- rbind(list(NA,i, NA,NA,NA,NA,NA,NA,NA),down)
  down$Description <- factor(down$Description, levels = down$Description)
  id_down <- c(rep('', n), id_down)
} else if (n < 0) {
  up$Description <- as.character(up$Description)
  for (i in paste('nn', as.character(seq(1, abs(n), 1)), sep = '')) up <- rbind(list(NA,i, NA,NA,NA,NA,NA,NA,NA), up)
  up$Description <- factor(up$Description, levels = up$Description)
  id_up <- c(rep('', abs(n)), id_up)
}


up_psort <- sort(abs(-log10(up$pvalue))%/%4+1,decreasing = T)
up_bl = c()
for(i in 0:(up_psort[1]-1)){
  up_bl <- c(up_bl,4*(i))
}


#up-regulated GO
p_up <- ggplot(up, aes(Description, -log(pvalue, 10))) + geom_col(fill = '#AA5AB8', color = 'black', width = 0.6) +
  theme(panel.grid = element_blank(), panel.background = element_rect(fill = 'transparent')) +
  theme(axis.line.x = element_line(colour = 'black'), axis.line.y = element_line(colour = 'transparent'), axis.ticks.y = element_line(colour = 'transparent')) +
  theme(plot.title = element_text(hjust = 0.5, face = 'plain')) +
  coord_flip() +
  geom_hline(yintercept = 0) +
  labs(x = '', y = '', title = 'Up') +
  scale_y_continuous(expand = c(0, 0), breaks = up_bl, labels = as.character(up_bl)) + scale_x_discrete(labels = id_up , position = 'top')

down_psort <- sort(abs(-log10(down$pvalue))%/%4+1,decreasing = T)
down_bl = c()
for(i in seq((down_psort[1]-1),0,by=-1)){
  down_bl <- c(down_bl,4*(-i))
}


#down-regulated GO
p_down <- ggplot(down, aes(Description, log(pvalue, 10))) +
  geom_col(fill = '#4B8364', color = 'black', width = 0.6) +
  theme(panel.grid = element_blank(), panel.background = element_rect(fill = 'transparent')) +
  theme(axis.line.x = element_line(colour = 'black'), axis.line.y = element_line(colour = 'transparent'), axis.ticks.y = element_line(colour = 'transparent')) +
  theme(plot.title = element_text(hjust = 0.5, face = 'plain')) +
  geom_hline(yintercept = 0) +
  coord_flip() +
  labs(x = '', y = '', title = 'Down') +
  scale_y_continuous(expand = c(0, 0), breaks = down_bl, labels = as.character(down_bl)) +       #杩欏効鏇存敼闂磋窛璁剧疆
  scale_x_discrete(labels = id_down, position = 'bottom')
####butteryfly plot####
library(cowplot)

pdf(opts$output, width = 13, height = 7)
plot_grid(p_down, p_up, nrow = 2, ncol = 2, rel_heights = c(9, 1), labels = 'GO_Enrichment Score (-log10(p-value)) ', label_x = 0.5, label_y = 0, label_fontface = 'plain')
dev.off()
