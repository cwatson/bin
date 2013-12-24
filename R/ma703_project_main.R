# Main file for the MA703 project on cortical thickness network analysis for the
# TGA data.
#_______________________________________________________________________________
# by Chris Watson, 2013-12-23

library(igraph)
library(ggplot2)
library(Hmisc)
library(corrgram)
library(reshape)
library(png)

source('ma703_project_functions.R')
source('ma703_project_load.R')

# Get correlation matrices
#-------------------------------------------------------------------------------
corrs.control <- corr.matrix(control.thick[, -1:-3], threshold=thresh, exclusions=exclude)
corrs.tga     <- corr.matrix(tga.thick[, -1:-3], threshold=thresh, exclusions=exclude)


#===============================================================================
# Graph theoretical measures
#===============================================================================
adj.control <- simplify(graph.adjacency(corrs.control$r.thresh, mode='undirected'))
adj.tga     <- simplify(graph.adjacency(corrs.tga$r.thresh, mode='undirected'))
adj.control.weighted <- simplify(graph.adjacency(
  corrs.control$r.thresh * corrs.control$R, mode='undirected', weighted=T))
adj.tga.weighted <- simplify(graph.adjacency(
  corrs.tga$r.thresh * corrs.tga$R, mode='undirected', weighted=T))

weights.control <- range.transform(x=E(adj.control.weighted)$weight, 1, 5)
weights.tga     <- range.transform(E(adj.tga.weighted)$weight, 1, 5)

# Degree distr and centrality
#---------------------------------------
deg.dist.control <- degree(adj.control)
deg.dist.tga     <- degree(adj.tga)
centrality.btwn.control <- centralization.betweenness(adj.control)
centrality.btwn.tga     <- centralization.betweenness(adj.tga)
centrality.ev.control <- centralization.evcent(adj.control)
centrality.ev.tga     <-     centralization.evcent(adj.tga)

# Wilcoxon tests 
deg.dist.wilcox <- wilcox.test(deg.dist.control, deg.dist.tga,
                          alternative=c('greater'), correct=F, conf.int=T)
centrality.btwn.wilcox <- wilcox.test(centrality.btwn.control$res,
                          centrality.btwn.tga$res, correct=F, conf.int=T)
centrality.ev.wilcox <- wilcox.test(centrality.ev.control$vector,
                          centrality.ev.tga$vector, correct=F, conf.int=T)


# Combine degrees into one data frame to plot both histograms in one plot
#-------------------------------------------------------------------------------
degs.control <- data.frame(degs = deg.dist.control, group='control')
degs.tga <- data.frame(degs = deg.dist.tga, group='d-TGA')
degs.all <- rbind(degs.control, degs.tga)


# Transitivity (the friend of your friend is also your friend)
#---------------------------------------
transitivity.control <- transitivity(adj.control, type='local')
transitivity.tga     <- transitivity(adj.tga, type='local')

transitivity.control <- unlist(rapply(list(transitivity.control),
                               f=function(x) ifelse(is.nan(x), 0, x),
                               how='replace'))
transitivity.tga     <- unlist(rapply(list(transitivity.tga),
                               f=function(x) ifelse(is.nan(x), 0, x),
                               how='replace'))


# Community detection
#-------------------------------------------------------------------------------
community.control <- edge.betweenness.community(adj.control)
community.tga     <- edge.betweenness.community(adj.tga)

V(adj.control)$color <- community.control$membership + 1
V(adj.tga)$color     <- community.tga$membership + 1


#-------------------------------------------------------------------------------
# Small world stuff
#-------------------------------------------------------------------------------
rand.control <- sim.rand.graph(deg.dist.control, 100)
rand.tga <- sim.rand.graph(deg.dist.tga, 100)
Lp.rand.control <- mean(rand.control$Lp.rand)
Lp.rand.tga <- mean(rand.tga$Lp.rand)
Cp.rand.control <- mean(rand.control$Cp.rand)
Cp.rand.tga <- mean(rand.tga$Cp.rand)

Lp.control <- average.path.length(adj.control)
Lp.tga <- average.path.length(adj.tga)
Cp.control <- transitivity(adj.control)
Cp.tga <- transitivity(adj.tga)

sigma.control <- (Cp.control / Cp.rand.control) /
  (Lp.control / Lp.rand.control)
sigma.tga <- (Cp.tga / Cp.rand.tga) /
  (Lp.tga / Lp.rand.tga)


#-------------------------------------------------------------------------------
# Robustness across different thresholds
#-------------------------------------------------------------------------------

# First create graphs for each threshold
# Output is a list of lists of length(threshes) 
#-------------------------------------------------------------------------------
threshes <- seq(0.1, 0.9, 0.01)
corrs.control.all <- lapply(threshes, function(x)
  corr.matrix(control.thick[, -1:-3], threshold=x, exclusions=exclude))
corrs.tga.all <- lapply(threshes, function(x)
  corr.matrix(tga.thick[, -1:-3], threshold=x, exclusions=exclude))

adj.control.all <- lapply(corrs.control.all,
  function(x) simplify(graph.adjacency(x$r.thresh, mode='undirected')))
adj.tga.all <- lapply(corrs.tga.all,
  function(x) simplify(graph.adjacency(x$r.thresh, mode='undirected')))


# Get the mean degree for each threshold
#-------------------------------------------------------------------------------
deg.dist.control.all <- lapply(adj.control.all, function(x) degree(x))
deg.dist.tga.all <- lapply(adj.tga.all, function(x) degree(x))
meandeg.control <- sapply(deg.dist.control.all, function(x) mean(x))
meandeg.tga <- sapply(deg.dist.tga.all, function(x) mean(x))


# Get average path lengths for each threshold
#-------------------------------------------------------------------------------
avg.path.lengths.control <- sapply(adj.control.all,
  function(x) average.path.length(x))
avg.path.lengths.tga <- sapply(adj.tga.all, function(x) average.path.length(x))


# Get clustering coefficients for each threshold
#-------------------------------------------------------------------------------
cluster.coeffs.control <- sapply(adj.control.all, function(x) transitivity(x))
cluster.coeffs.tga <- sapply(adj.tga.all, function(x) transitivity(x))


# Small world measures for each threshold
# Produces a list of length(threshes), each containing Lp and Cp of length n
#-------------------------------------------------------------------------------
all.rand.control <- lapply(deg.dist.control.all,
  function(x) sim.rand.graph(x, 100))
all.rand.tga <- lapply(deg.dist.tga.all, function(x) sim.rand.graph(x, 100))

Lp.rand.control.all <- sapply(all.rand.control, function(x) mean(x$Lp.rand))
Lp.rand.tga.all <- sapply(all.rand.tga, function(x) mean(x$Lp.rand))
Cp.rand.control.all <- sapply(all.rand.control, function(x) mean(x$Cp.rand))
Cp.rand.tga.all <- sapply(all.rand.tga, function(x) mean(x$Cp.rand))

sigma.control.all <- (cluster.coeffs.control / Cp.rand.control.all) /
  (avg.path.lengths.control / Lp.rand.control.all)
sigma.tga.all <- (cluster.coeffs.tga / Cp.rand.tga.all) /
  (avg.path.lengths.tga / Lp.rand.tga.all)


# Betweenness centrality for each threshold
#-------------------------------------------------------------------------------
betweenness.control <- sapply(adj.control.all, function(x)
  centralization.betweenness(x)$centralization)
betweenness.tga <- sapply(adj.tga.all, function(x)
  centralization.betweenness(x)$centralization)
