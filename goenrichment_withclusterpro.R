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
  raw_id <- raw_fc[which(duplicated(raw_fc$V41)==FALSE),]
  id_all <- raw_id[,c(1,41)]
  
  go_bp <- enrichGO(id_all$V41, OrgDb = "org.Hs.eg.db" , ont = 'BP', keyType = "ENTREZID" ,pAdjustMethod = "BH" ,pvalueCutoff = 0.05, readable = T)
  bp_p1 <- dotplot(go_bp, font.size=10)
  bp_p2 <- barplot(go_bp, font.size=10)
  go_bp <- data.frame(go_bp)
  
  go_mf <- enrichGO(id_all$V41, OrgDb = "org.Hs.eg.db" , ont = 'MF', keyType = "ENTREZID" ,pAdjustMethod = "BH" ,pvalueCutoff = 0.05, readable = T)
  mf_p1 <- dotplot(go_mf, font.size=10)
  mf_p2 <- barplot(go_mf, font.size=10)
  go_mf <- data.frame(go_mf)
  
  go_cc <- enrichGO(id_all$V41, OrgDb = "org.Hs.eg.db" , ont = 'CC', keyType = "ENTREZID" ,pAdjustMethod = "BH" ,pvalueCutoff = 0.05, readable = T)
  cc_p1 <- dotplot(go_cc, font.size=10)
  cc_p2 <- barplot(go_cc, font.size=10)
  go_cc <- data.frame(go_cc)
  return(list(go_bp, go_mf,go_cc,bp_p1,bp_p2,mf_p1,mf_p2,cc_p1,cc_p2))
  #return(list(go_bp, go_mf,go_cc,))
  #id_all <- bitr(as.vector(dpro_rpkm$V1), fromType = "SYMBOL", toType = c("ENTREZID","ENSEMBL"), OrgDb = "org.Hs.eg.db")
  
}

go_all <-  goenrichall_clu(opts$input)
pdf(file=paste(opts$output,".bp.pdf",sep=""),width = 6,height = 7)
cowplot::plot_grid(go_all[[4]],go_all[[5]],nrow = 2)
dev.off()

pdf(file=paste(opts$output,".mf.pdf",sep=""),width = 6,height = 7)
cowplot::plot_grid(go_all[[6]],go_all[[7]],nrow = 2)
dev.off()

pdf(file=paste(opts$output,".cc.pdf",sep=""),width = 6,height = 7)
cowplot::plot_grid(go_all[[8]],go_all[[9]],nrow = 2)
dev.off()

write.csv(go_all[[1]],file=paste(opts$output,".bp.txt",sep=""),append = T, quote = F, eol = "\n")
write.csv(go_all[[2]],file=paste(opts$output,".mf.txt",sep=""),append = T, quote = F, eol = "\n")
write.csv(go_all[[3]],file=paste(opts$output,".cc.txt",sep=""),append = T, quote = F, eol = "\n")


#write.table(go_all[[1]],file=paste(opts$output,".bp.txt",sep=""),append = F, quote = F, eol = "", row.names = F, col.names = F)
#write.table(go_all[[2]],file=paste(opts$output,".mf.txt",sep=""),append = F, quote = F, eol = "", row.names = F, col.names = F)
#write.table(go_all[[3]],file=paste(opts$output,".cc.txt",sep=""),append = F, quote = F, eol = "", row.names = F, col.names = F)
