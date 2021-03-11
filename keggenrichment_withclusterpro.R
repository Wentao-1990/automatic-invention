rm(list=ls())
options(warn=1)

library(optparse)
library(clusterProfiler)
library(cowplot)

if(TRUE){
  option_list <- list(
    make_option(c("-i","--input"), type="character",default = "input.txt",
                help = "Input table file to read [default]"),
    make_option(c("-o","--output"),type="character",default = "output",
                help = "output directory or prefix [default]")
  )
  
  opts <- parse_args(OptionParser(option_list = option_list ))
  
  print(paste("The input file is ", opts$input,  sep = ""))
  print(paste("The output file prefix is ", opts$output, sep = ""))
}


goenrichall_clu <- function(rawfile){
  raw_fc <- read.delim(rawfile,sep="\t",check.names = F, header = F)
  raw_id <- raw_fc[which(duplicated(raw_fc$V38)==FALSE),]
  id_all <- raw_id[,c(1,41)]
  
  kegg_all <- enrichKEGG(id_all$V41, organism = "hsa", pvalueCutoff = 0.05, pAdjustMethod = "BH")
  kegg_p1 <- dotplot(kegg_all, font.size=10)
  kegg_p2 <- barplot(kegg_all, font.size=10)
  kegg_all <- data.frame(kegg_all)
  
  return(list(kegg_all, kegg_p1,kegg_p2))
  #return(list(go_bp, go_mf,go_cc,))
  #id_all <- bitr(as.vector(dpro_rpkm$V1), fromType = "SYMBOL", toType = c("ENTREZID","ENSEMBL"), OrgDb = "org.Hs.eg.db")
  
}

go_all <-  goenrichall_clu(opts$input)
pdf(file=paste(opts$output,".kegg.pdf",sep=""),width = 6,height = 7)
cowplot::plot_grid(go_all[[2]],go_all[[3]],nrow = 2)
dev.off()


write.csv(go_all[[1]],file=paste(opts$output,".kegg.txt",sep=""),append = T, quote = F, eol = "\n")

#write.table(go_all[[1]],file=paste(opts$output,".bp.txt",sep=""),append = F, quote = F, eol = "", row.names = F, col.names = F)
#write.table(go_all[[2]],file=paste(opts$output,".mf.txt",sep=""),append = F, quote = F, eol = "", row.names = F, col.names = F)
#write.table(go_all[[3]],file=paste(opts$output,".cc.txt",sep=""),append = F, quote = F, eol = "", row.names = F, col.names = F)
