# Main file for MA703 project, cortical thickness network analysis of TGA data.
#_______________________________________________________________________________
# by Chris Watson, 2013-12-23

source('ma703_project_load.R')

kNumThreshes <- length(threshes)
N <- which(abs(threshes - cost) < 0.001)

thickness <- get.thickness(file1=lhfile, file2=rhfile, group1, group2)

if (resids == 1) {
  m <- get.resid(thickness$all, kNumCovars, group1, group2)
  all.p <- unlist(lapply(m$models, function(x) summary(x)$coef[2, 4]))

  if (plotting == 1) {
    # Check residuals for normality
    check.resid(m$all)
  }

  corrs.group1 <- lapply(threshes, function(x)
    corr.matrix(m$group1[, -length(m$group1)], cost=x, exclusions=exclude))
  corrs.group2 <- lapply(threshes, function(x)
    corr.matrix(m$group2[, -length(m$group2)], cost=x, exclusions=exclude))

  # Used later for null covariance matrices
  cov1 <- cov(m$group1[, -c(exclude, length(m$group1))])
  cov2 <- cov(m$group2[, -c(exclude, length(m$group2))])

  SD1 <- sapply(m$group1[, -c(exclude, length(m$group1))], sd)
  SD2 <- sapply(m$group2[, -c(exclude, length(m$group1))], sd)

} else {
  corrs.group1 <- lapply(threshes, function(x)
    corr.matrix(thickness$group1[, -1:-kNumCovars], cost=x, exclusions=exclude))
  corrs.group2 <- lapply(threshes, function(x)
    corr.matrix(thickness$group2[, -1:-kNumCovars], cost=x, exclusions=exclude))
}

#===============================================================================
# Graph theoretical measures, across different 'cost' thresholds
#===============================================================================
adj.group1 <- lapply(corrs.group1,
  function(x) simplify(graph.adjacency(x$r.thresh, mode='undirected')))
adj.group2 <- lapply(corrs.group2,
  function(x) simplify(graph.adjacency(x$r.thresh, mode='undirected')))

adj.group1.weighted <- lapply(corrs.group1, function(x)
  simplify(graph.adjacency(x$r.thresh * corrs.group1[[N]]$R,
                           mode='undirected', weighted=T)))
adj.group2.weighted <- lapply(corrs.group2, function(x)
  simplify(graph.adjacency(x$r.thresh * corrs.group2[[N]]$R,
                           mode='undirected', weighted=T)))

kNumVertices <- vcount(adj.group1[[1]])

# Transform edge weights btwn 1 and 5, for visualization purposes
weights.group1 <- range.transform(E(adj.group1.weighted[[N]])$weight, 1, 5)
weights.group2 <- range.transform(E(adj.group2.weighted[[N]])$weight, 1, 5)

# Degree distr and centrality
#---------------------------------------
deg.dist.group1 <- lapply(adj.group1, degree)
deg.dist.group2 <- lapply(adj.group2, degree)

centrality.btwn.group1 <- lapply(adj.group1, function(x)
  centralization.betweenness(x)$res)
centrality.btwn.group2 <- lapply(adj.group2, function(x)
  centralization.betweenness(x)$res)
centrality.ev.group1 <- lapply(adj.group1, function(x)
  centralization.evcent(x)$vector)
centrality.ev.group2 <- lapply(adj.group2, function(x)
  centralization.evcent(x)$vector)


# Transitivity (the friend of your friend is also your friend)
#---------------------------------------
transitivity.group1 <- lapply(adj.group1, transitivity, type='local')
transitivity.group1 <- rapply(transitivity.group1, function(x)
                              ifelse(is.nan(x), 0, x), how='replace')
transitivity.group2 <- lapply(adj.group2, transitivity, type='local')
transitivity.group2 <- rapply(transitivity.group2, function(x)
                              ifelse(is.nan(x), 0, x), how='replace')

cl.coeff.group1 <- lapply(adj.group1, transitivity)
cl.coeff.group2 <- lapply(adj.group2, transitivity)


# Community detection stuff
community.group1 <- lapply(adj.group1, community.measures)
community.group2 <- lapply(adj.group2, community.measures)

vcols1 <- mapply(function(x, y) color.vertices(x, y),
                adj.group1, community.group1)
vcols2 <- mapply(function(x, y) color.vertices(x, y),
                adj.group2, community.group2)
ecols1 <- mapply(function(x, y) color.edges(x, y),
                adj.group1, community.group1)
ecols2 <- mapply(function(x, y) color.edges(x, y),
                adj.group2, community.group2)

for (th in 1:kNumThreshes) {
  V(adj.group1[[th]])$color <- vcols1[, th]
  V(adj.group2[[th]])$color <- vcols2[, th]
  E(adj.group1[[th]])$color <- ecols1[[th]]
  E(adj.group2[[th]])$color <- ecols2[[th]]
}
        
#TODO1
#TODO1
## Stuff to set edge colors
#comm <- community.group1[[10]]
#adj.graph <- adj.group1[[10]]
#Nc <- max(comm$community$membership)
#tmp <- list()
#for (i in 1:Nc) {
#  if (sum(comm$community$membership == i) == 1) {
#    tmp[[i]] <- 0
#  } else {
#    tmp[[i]] <- as.vector(E(adj.graph)[which(comm$community$membership == i) %--% 1:kNumVertices])
#    E(adj.graph)[tmp[[i]]]$color <- comm$vcolors[i]
#  }
#}
#dups <- unlist(tmp)[duplicated(unlist(tmp))]
#dups <- dups[dups > 0]
#E(adj.graph)[dups]$color <- 'gray'
#TODO1
#TODO1



#-------------------------------------------------------------------------------
# Small world measures for each threshold
# Produces a list of length(threshes), each containing Lp and Cp of length n
#-------------------------------------------------------------------------------
kNumIters <- as.list(rep(10, kNumThreshes))
if (OS == 'windows') {
#  rand.group1 <- llply(deg.dist.group1, .fun=sim.rand.graph.par, kNumIters,
#                       .progress='text')
#  rand.group2 <- llply(deg.dist.group2, .fun=sim.rand.graph.par, kNumIters,
#                       .progress='text')
  rand.group1 <- mapply(function(x, y, z)
                  sim.rand.graph.par(x, y, z), deg.dist.group1, kNumIters,
                  cl.coeff.group1, SIMPLIFY=F)
  rand.group2 <- mapply(function(x, y, z)
                  sim.rand.graph.par(x, y, z), deg.dist.group2, kNumIters,
                  cl.coeff.group2, SIMPLIFY=F)
#  rand.group1 <- lapply(deg.dist.group1, sim.rand.graph.par, kNumIters)
#  rand.group2 <- lapply(deg.dist.group2, sim.rand.graph.par, kNumIters)

} else {
  rand.group1 <- mcmapply(function(x, y, z)
                  sim.rand.graph.par(x, y, z), deg.dist.group1, kNumIters,
                  cl.coeff.group1, mc.cores=num.cores, mc.cleanup=T, SIMPLIFY=F,
                  USE.NAMES=F)
  rand.group2 <- mcmapply(function(x, y, z)
                  sim.rand.graph.par(x, y, z), deg.dist.group2, kNumIters,
                  cl.coeff.group2, mc.cores=num.cores, mc.cleanup=T, SIMPLIFY=F,
                  USE.NAMES=F)
}
  
small.world.group1 <- small.world(adj.group1, rand.group1, threshes)
small.world.group2 <- small.world(adj.group2, rand.group2, threshes)



# Calculate the rich club coefficient
#-------------------------------------------------------------------------------
#TODO1 think of how to actually choose the degree threshold
deg.thresh <- kNumVertices - ceiling(0.1 * kNumVertices)

rich.group1.k <- lapply(1:max(deg.dist.group1[[N]]), function(x)
                        rich.club.coeff(adj.group1[[N]], x))
rich.group2.k <- lapply(1:max(deg.dist.group2[[N]]), function(x)
                        rich.club.coeff(adj.group2[[N]], x))

rich.group1 <- lapply(adj.group1, function(x)
                           rich.club.coeff(x, sort(degree(x))[deg.thresh]))
rich.group2 <- lapply(adj.group2, function(x)
                           rich.club.coeff(x, sort(degree(x))[deg.thresh]))

rich.group1.coeffs <- sapply(rich.group1, function(x) x$coeff)
rich.group2.coeffs <- sapply(rich.group2, function(x) x$coeff)

rich.group1.norm <- rich.group1.coeffs / sapply(rand.group1, function(x)
                                                mean(x$rich))
rich.group2.norm <- rich.group2.coeffs / sapply(rand.group2, function(x)
                                                mean(x$rich))


#-------------------------------------------------------------------------------
# Calculate participation coefficient (PC)
#-------------------------------------------------------------------------------
# PC > 0.3 is important (hubs), see Sporns et al., 2007, PLoS One
PC.group1 <- mapply(function(x, y, z)
                    part.coeff(x$r.thresh, y, z[[1]]$membership),
                    corrs.group1, adj.group1, community.group1)
PC.group2 <- mapply(function(x, y, z)
                    part.coeff(x$r.thresh, y, z[[1]]$membership),
                    corrs.group2, adj.group2, community.group2)


# Calculate within-module degree z-score
z.group1 <- mapply(function(x, y, z)
                    within.module.deg.z.score(x$r.thresh, y, z[[1]]$membership),
                    corrs.group1, adj.group1, community.group1)
z.group2 <- mapply(function(x, y, z)
                    within.module.deg.z.score(x$r.thresh, y, z[[1]]$membership),
                    corrs.group2, adj.group2, community.group2)

#-------------------------------------------------------------------------------
# Efficiency; global (local) should be higher (lower) in random networks
#-------------------------------------------------------------------------------
g.eff.group1 <- sapply(adj.group1, global.eff)
g.eff.group2 <- sapply(adj.group2, global.eff)

l.eff.group1 <- lapply(adj.group1, local.eff)
l.eff.group2 <- lapply(adj.group2, local.eff)


# Create a data frame in which each row is a node, and each column is a
# different network measure (degree, centrality, etc.)
group1.network.measures <- data.frame(degree=deg.dist.group1[[N]],
                                       cent.btwn=centrality.btwn.group1[[N]],
                                       cent.ev=centrality.ev.group1[[N]],
                                       transitivity=transitivity.group1[[N]],
                                       local.eff=l.eff.group1[[N]],
                                       PC=PC.group1[, N])
rownames(group1.network.measures) <- V(adj.group1[[N]])$name
group2.network.measures <- data.frame(degree=deg.dist.group2[[N]],
                                       cent.btwn=centrality.btwn.group2[[N]],
                                       cent.ev=centrality.ev.group2[[N]],
                                       transitivity=transitivity.group2[[N]],
                                       local.eff=l.eff.group2[[N]],
                                       PC=PC.group2[, N])
rownames(group2.network.measures) <- V(adj.group2[[N]])$name


#TODO1
#TODO1
# Preliminary bootstrap stuff
# Honestly really isn't different than taking the mean of the random network
# samples in rand.group[12]
# But it's super fast ( < 1s) so maybe it's worth it just because
sample.mean <- function(x, d) {
  return(sum(x[d]) / length(x[d]))
}
sample.se <- function(x, d) {
  N <- length(x[d])
  return((sum(x[d]^2) - sum(x[d])^2 / N) / (N - 1))
}
kNumBoot <- 10000
#tmp <- boot(rand.group1[[N]]$Lp.rand, statistic=sample.mean, R=kNumBoot)
#quantile(tmp$t)
#quantile(rand.group1[[N]]$Lp.rand)
#TODO1
#TODO1

rich.group1.se <- lapply(rand.group1,
                         function(x) boot(x$rich, statistic=sample.se,
                                          R=kNumBoot))
rich.group2.se <- lapply(rand.group2,
                         function(x) boot(x$rich, statistic=sample.se,
                                          R=kNumBoot))
rand.group1.Lp.se <- lapply(rand.group1,
                            function(x) boot(x$Lp, statistic=sample.se,
                                             R=kNumBoot))
rand.group2.Lp.se <- lapply(rand.group2,
                            function(x) boot(x$Lp, statistic=sample.se,
                                             R=kNumBoot))
rand.group1.Cp.se <- lapply(rand.group1,
                            function(x) boot(x$Cp, statistic=sample.se,
                                             R=kNumBoot))
rand.group2.Cp.se <- lapply(rand.group2,
                            function(x) boot(x$Cp, statistic=sample.se,
                                             R=kNumBoot))
mod.group1.se <- lapply(rand.group1,
                            function(x) boot(x$mod, statistic=sample.se,
                                             R=kNumBoot))
mod.group2.se <- lapply(rand.group2,
                            function(x) boot(x$mod, statistic=sample.se,
                                             R=kNumBoot))

# Stop parallel processing code
if (OS == 'windows') {
  stopCluster(cl)
}
