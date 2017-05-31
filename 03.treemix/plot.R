Args<-commandArgs(T)
verbose=T
stem = Args[1]
source("/ifshk5/PC_HUMAN_EU/USER/liaoqijun/soft/treemix/treemix-1.12/src/plotting_funcs.R")
# tree
pdf(paste(stem,"tree.pdf",sep="."))
plot_tree(stem,"poporder")
dev.off()

# residual visualization
pdf(paste(stem,"residual.pdf",sep="."))
plot_resid(stem, "poporder")
dev.off()


#common1 = paste("mv Rplots.pdf", paste(stem,"tree.pdf",sep="."))
#try(system(common1))

