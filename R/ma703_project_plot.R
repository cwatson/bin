# File that does all the plotting for the MA703 final project.
#_______________________________________________________________________________
# by Chris Watson, 2013-12-23

#source('ma703_project_main.R')

if (nifti.plot == 0) {
  data(raster_brain_outline)
  #img <- readPNG('C:/Users/cwatson/Desktop/classes/Fall2013/ma703/project/images/brain_top_view_outline.png')
  #r <- as.raster(img[, , 1:3])
  underlay.fun <- plot.over.brain
  coord.scale <- diag(c(1/8, 1/10))    # scale the node layout
} else {
  if (atlas == 'dk') {
    coords.cur <- cbind(coords.cur[, 1], coords.cur[, 2] + 1.5, coords.cur[, 3])
    rownames(coords.cur) <- row.names(coords)
  }
  data(mni152)
  underlay.fun <- plot.over.brain.axial
  coord.scale <- diag(c(1/10, 1/12))    # scale the node layout
}

if (plotting == 1) {
  # Plot the densities of the vertex degrees 
  png(file=paste(image.dir, 'degree_distributions_density.png', sep=''))
  a <- density(degree(adj.group1[[N]]), from=0, to=max(degree(adj.group1[[N]])))
  b <- density(degree(adj.group2[[N]]), from=0, to=max(degree(adj.group2[[N]])))
  plot(a, main='Degree distributions', xlab='Degree (#)',
      ylim=c(0, max(a$y, b$y)), col='blue')
  par(new=T)
  lines(b, col='red')
  legend('topright', c(group1, group2), col=c('blue', 'red'), lty=1)
  grid()
  dev.off()
  

  # Plot the densities of the correlations themselves
  a <- density(corrs.group1[[N]]$R[lower.tri(corrs.group1[[N]]$R)])
  b <- density(corrs.group2[[N]]$R[lower.tri(corrs.group2[[N]]$R)])
  png(file=paste(image.dir, 'correlation_coeffs_density.png', sep=''))
  plot(a, main='Pearson correlation coefficients', xlab='r',
      ylim=c(0, max(a$y, b$y)), col='blue')
  par(new=T)
  lines(b, col='red')
  legend('topright', c(group1, group2), col=c('blue', 'red'), lty=1)
  abline(v=mean(corrs.group1[[N]]$R[lower.tri(corrs.group1[[N]]$R)]),
         col='blue', lty=3)
  abline(v=mean(corrs.group2[[N]]$R[lower.tri(corrs.group1[[N]]$R)]),
         col='red', lty=3)
  grid()
  dev.off()
}
#===============================================================================
# Plot the graph itself; this is the adjacency matrix
#===============================================================================
subtitle1 <- sprintf('threshold = %0.4f\ncost = %0.1f%s',
                     corrs.group1[[N]]$threshold, 100*cost, '%')
subtitle2 <- sprintf('threshold = %0.4f\ncost = %0.1f%s',
                     corrs.group2[[N]]$threshold, 100*cost, '%')

# Plots w/ constant edge widths and vertex sizes
#-------------------------------------------------------------------------------
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group1, '.png', sep=''))
plot.adj(adj.group1[[N]], title=group1, subtitle1)
par(new=T, mar=c(5, 0, 3, 0)+0.1)
title(group1, col.main='white', sub=subtitle1, col.sub='white')
dev.off()
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group2, '.png', sep=''))
plot.adj(adj.group2[[N]], title=group2, subtitle2)
par(new=T, mar=c(5, 0, 3, 0)+0.1)
title(group2, col.main='white', sub=subtitle2, col.sub='white')
dev.off()

#TODO1
#TODO1
# Plot left lateral nodes only
#TODO1
#TODO1
#adj.group1[[N]].left <- induced.subgraph(adj.group1[[N]], V(adj.group1[[N]])[1:32])
#adj.group2[[N]].left <- induced.subgraph(adj.group2[[N]], V(adj.group2[[N]])[1:32])
#adj.group1[[N]].right <- induced.subgraph(adj.group1[[N]], V(adj.group1[[N]])[33:64])
#adj.group2[[N]].right <- induced.subgraph(adj.group2[[N]], V(adj.group2[[N]])[33:64])
#
## Note that y-coords are negative, so anterior is to left of graph
#left.lateral <- matrix(c(-coords[-exclude, 2][1:32],
#                         coords[-exclude, 3][1:32]), ncol=2, byrow=F)
#right.lateral <- matrix(c(coords[2:33, 2], coords[2:33, 3]), ncol=2, byrow=F)
#
#dev.new()
#plot.adj(adj.group1[[N]].left, layout=left.lateral,
#         xlim=range(coords$y), ylim=1.5*range(coords$z), rescale=F,
#         vert.size=50)
#dev.new()
#plot.adj(adj.group1[[N]].right, layout=right.lateral,
#         xlim=range(coords$y), ylim=1.5*range(coords$z), rescale=F)
#
#TODO1
#TODO1
# Plot left vertices only, axial view
#left.axial <- matrix(c(coords[-exclude, 1][1:32],
#                       coords[-exclude, 2][1:32]), ncol=2, byrow=F)
#right.axial <- matrix(c(coords[-exclude, 1][33:64],
#                       coords[-exclude, 2][33:64]), ncol=2, byrow=F)
#
#underlay.fun(plotting)
#plot.adj(adj.group1[[N]].left, title=group1, subtitle1, layout=left.axial,
#         xlim=range(coords$x), ylim=range(coords$y), rescale=F)
#underlay.fun(plotting)
#plot.adj(adj.group1[[N]].right, title=group1, subtitle1, layout=right.axial,
#         xlim=range(coords$x), ylim=range(coords$y), rescale=F)
#underlay.fun(plotting)
#plot.adj(adj.group2[[N]].left, title=group2, subtitle2, layout=left.axial,
#         xlim=range(coords$x), ylim=range(coords$y), rescale=F)
#underlay.fun(plotting)
#plot.adj(adj.group2[[N]].right, title=group2, subtitle2, layout=right.axial,
#         xlim=range(coords$x), ylim=range(coords$y), rescale=F)


# Plots w/ variable edge widths and constant vertex sizes
#-------------------------------------------------------------------------------
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group1, '_edge_weights.png', sep=''))
plot.adj(adj.group1[[N]], title=group1, subtitle1, edge.width=weights.group1)
dev.off()
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group2, '_edge_weights.png', sep=''))
plot.adj(adj.group2[[N]], title=group2, subtitle2, edge.width=weights.group2)
dev.off()

# Plots w/ constant edge widths and variable vertex sizes
#-------------------------------------------------------------------------------
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group1, '_deg_size.png', sep=''))
plot.adj(adj.group1[[N]], title=paste(group1, '(degree size)', sep=' '), subtitle1,
  vert.size=2*deg.dist.group1[[N]],
  vert.lab.cex=(deg.dist.group1[[N]]+.05)/max(deg.dist.group1[[N]]))
dev.off()
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group2, '_deg_size.png', sep=''))
plot.adj(adj.group2[[N]], title=paste(group2, '(degree size)', sep=' '), subtitle2,
  vert.size=2*deg.dist.group2[[N]],
  vert.lab.cex=(deg.dist.group2[[N]]+.05)/max(deg.dist.group2[[N]]))
dev.off()

# Plots w/ constant edge widths and variable vertex sizes (eigenvector)
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group1, '_EV_cent.png', sep=''))
plot.adj(adj.group1[[N]], title=paste(group1, '(EV centrality)', sep=' '), subtitle1,
  vert.size=25*centrality.ev.group1[[N]],
  vert.lab.cex=centrality.ev.group1[[N]]+.01)
dev.off()
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group2, '_EV_cent.png', sep=''))
plot.adj(adj.group2[[N]], title=paste(group2, '(EV centrality)', sep=' '), subtitle2,
  vert.size=25*centrality.ev.group2[[N]],
  vert.lab.cex=centrality.ev.group2[[N]]+.01)
dev.off()

# Plots w/ constant edge widths and variable vertex sizes (betweenness)
#-------------------------------------------------------------------------------
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group1, '_Btwn_cent.png', sep=''))
plot.adj(adj.group1[[N]], title=paste(group1, '(Betweenness centrality)', sep=' '),
  subtitle1,
  vert.size=3*log1p(centrality.btwn.group1[[N]])+.05,
  vert.lab.cex=0.2*log1p(centrality.btwn.group1[[N]])+.05)
dev.off()
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group2, '_Btwn_cent.png', sep=''))
plot.adj(adj.group2[[N]], title=paste(group2, '(Betweenness centrality)', sep=' '),
  subtitle2,
  vert.size=3*log1p(centrality.btwn.group2[[N]])+.05,
  vert.lab.cex=0.2*log1p(centrality.btwn.group2[[N]])+.05)
dev.off()

# Plots w/ constant edge widths and variable vertex sizes (clustering)
#-------------------------------------------------------------------------------
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group1, '_clust.png', sep=''))
plot.adj(adj.group1[[N]], title=paste(group1, '(clustering)', sep=' '), subtitle1,
  vert.size=20*transitivity.group1[[N]],
  vert.lab.cex=transitivity.group1[[N]]+.01)
dev.off()
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group2, '_clust.png', sep=''))
plot.adj(adj.group2[[N]], title=paste(group2, '(clustering)', sep=' '), subtitle2,
  vert.size=20*transitivity.group2[[N]],
  vert.lab.cex=transitivity.group2[[N]]+.01)
dev.off()


# Plots with groupings from community detection
#-------------------------------------------------------------------------------
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group1, '_comm.png', sep=''))
plot.adj(adj.group1[[N]], title=group1, subtitle1,
  vert.col=V(adj.group1[[N]])$color,
  vert.lab=NA,
  vert.size=range.transform(deg.dist.group1[[N]], 2.5, 15),
  edge.col=unlist(E(adj.group1[[N]])$color))
dev.off()
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group2, '_comm.png', sep=''))
plot.adj(adj.group2[[N]], title=group2, subtitle2,
  vert.col=V(adj.group2[[N]])$color,
  vert.lab=NA,
  vert.size=range.transform(deg.dist.group2[[N]], 2.5, 15),
  edge.col=unlist(E(adj.group2[[N]])$color))
dev.off()

# Plot of communities without a spatial layout
if (plotting == 1) {
png(file=paste(image.dir, prefix, group1, '_comm_rand.png', sep=''))
plot(community.group1[[N]][[1]], adj.group1[[N]],
  vertex.color=V(adj.group1[[N]])$color,
  main=group1, vertex.label.cex=0.75, vertex.size=10,
  vertex.label.color='darkblue')
dev.off()
png(file=paste(image.dir, prefix, group2, '_comm_rand.png', sep=''))
plot(community.group2[[N]][[1]], adj.group2[[N]],
  vertex.color=V(adj.group2[[N]])$color,
  main=group2, vertex.label.cex=0.75, vertex.size=10,
  vertex.label.color='darkblue')
dev.off()
}

# Plot the subgraphs of rich club nodes
#---------------------------------------
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group1, '_rich.png', sep=''))
plot.adj(rich.group1[[N]]$graph, title=paste(group1, '(rich club)'), subtitle1,
    layout=as.matrix(coords.cur[V(rich.group1[[N]]$graph)$name, 1:2]) %*% coord.scale,
    rescale=F)
dev.off()
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group2, '_rich.png', sep=''))
plot.adj(rich.group2[[N]]$graph, title=paste(group2, '(rich club)'), subtitle2,
    layout=as.matrix(coords.cur[V(rich.group2[[N]]$graph)$name, 1:2]) %*% coord.scale,
    rescale=F)
dev.off()

# Plots based on each node's participation index
#---------------------------------------
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group1, '_PC.png', sep=''))
plot.adj(adj.group1[[N]], title=paste(group1, '(PC)', sep=' '), subtitle1,
         vert.size=range.transform(PC.group1[, N], 2.5, 15))
dev.off()
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group2, '_PC.png', sep=''))
plot.adj(adj.group2[[N]], title=paste(group2, '(PC)', sep=' '), subtitle2,
         vert.size=range.transform(PC.group2[, N], 2.5, 15))
dev.off()

# Plots based on each node's local efficiency
#---------------------------------------
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group1, '_loc_eff.png', sep=''))
plot.adj(adj.group1[[N]], title=paste(group1, '(local eff.)', sep=' '), subtitle1,
         vert.size=range.transform(l.eff.group1[[N]], 0, 15))
dev.off()
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group2, '_loc_eff.png', sep=''))
plot.adj(adj.group2[[N]], title=paste(group2, '(local eff.)', sep=' '), subtitle2,
         vert.size=range.transform(l.eff.group2[[N]], 0, 15))
dev.off()

# Plots based on each node's within-module degree z-score
#---------------------------------------
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group1, '_zscore.png', sep=''))
plot.adj(adj.group1[[N]], title=paste(group1, '(z-score)', sep=' '), subtitle1,
         vert.size=range.transform(z.group1[, N], 1, 15))
dev.off()
underlay.fun(plotting,
  fname=paste(image.dir, prefix, group2, '_zscore.png', sep=''))
plot.adj(adj.group2[[N]], title=paste(group2, '(z-score)', sep=' '), subtitle2,
         vert.size=range.transform(z.group2[, N], 1, 15))
dev.off()

if (plotting == 1) {
#-------------------------------------------------------------------------------
# Plots of network measures for all thresholds
#-------------------------------------------------------------------------------
png(file=paste(image.dir, 'avg_path_lengths.png', sep=''))
y1se <- sapply(rand.group1.Lp.se, function(x) mean(x$t))
y2se <- sapply(rand.group2.Lp.se, function(x) mean(x$t))
plot.se(small.world.group1$Lp, small.world.group2$Lp,
        ylabel='Characteristic path length', group1=group1, group2=group2,
        y1se=y1se, y2se=y2se)
dev.off()

png(file=paste(image.dir, 'clustering_coeff.png', sep=''))
y1se <- sapply(rand.group1.Cp.se, function(x) mean(x$t))
y2se <- sapply(rand.group2.Cp.se, function(x) mean(x$t))
plot.se(small.world.group1$Cp, small.world.group2$Cp,
        ylabel='Transitivity', group1=group1, group2=group2,
        y1se=y1se, y2se=y2se)
dev.off()

# Plot small world values, but mean degree has to be greater than log(64)
inds.valid <- which(sapply(adj.group1, function(x) mean(degree(x))) >
                     log(kNumVertices))
png(file=paste(image.dir, 'small_worldness.png', sep=''))
plot.threshes(small.world.group1$sigma[inds.valid],
              small.world.group2$sigma[inds.valid],
              ylabel='Small-worldness', group1=group1, group2=group2)
dev.off()

png(file=paste(image.dir, 'betweenness.png', sep=''))
plot.threshes(sapply(centrality.btwn.group1, mean),
              sapply(centrality.btwn.group2, mean),
              ylabel='Betweenness Centrality', group1=group1, group2=group2)
dev.off()


# Plot rich club coefficients
y1se <- 10*sapply(rich.group1.se, function(x) mean(x$t))
y2se <- 10*sapply(rich.group2.se, function(x) mean(x$t))
png(file=paste(image.dir, 'rich_club.png', sep=''))
plot.se(rich.group1.norm, rich.group2.norm, ylabel='Rich club coeff.',
        group1=group1, group2=group2, y1se=y1se, y2se=y2se)
dev.off()
}
