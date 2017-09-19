Args<-commandArgs(T)
verbose=T
stem = Args[1]
source("plotting_funcs.R")
# tree
pdf(paste(stem,"tree.pdf",sep="."))
plot_tree(stem,"poporder",cex = 0.5)
dev.off()

# residual visualization
pdf(paste(stem,"residual.pdf",sep="."))
plot_resid(stem, "poporder",cex = 0.5)
dev.off()


#common1 = paste("mv Rplots.pdf", paste(stem,"tree.pdf",sep="."))
#try(system(common1))

