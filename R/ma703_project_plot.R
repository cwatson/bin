# File that does all the plotting for the MA703 final project.
#_______________________________________________________________________________
# by Chris Watson, 2013-12-23

source('ma703_project_main.R')

# Plot the correlation matrices using "corrgram" or "ggplot", or "heatmap"
#-------------------------------------------------------------------------------
#heatmap(corrs.control$R, Rowv=NA, Colv=NA, col=heat.colors(256))
#corrgram(corrs.control$R, main="Control group correlations")#order=T)  # "order=T" uses PCA

#control.thick.corrs.m <- melt(control.thick.corrs.thresh)
#tga.thick.corrs.m <- melt(tga.thick.corrs.thresh)
#print(ggplot(control.thick.corrs.m, aes(X1, X2, fill = value)) +
#  labs(title="Controls") + geom_tile(aes(fill = value)) +
#  scale_fill_gradient2(low="blue", high="red"))
#dev.new()
#print(ggplot(tga.thick.corrs.m, aes(X1, X2, fill = value)) +
#  labs(title="d-TGA") + geom_tile(aes(fill = value)) +
#  scale_fill_gradient2(low="blue", high="red"))

# Plot a histogram of degree dist. for both groups
#---------------------------------------
png(file = "../images/degree_distributions_hist.png")
print(ggplot(degs.all, aes(degs, fill = group)) +
  geom_histogram(binwidth = 1, alpha = 0.6, aes(y = ..density..),
  position = 'identity'))
dev.off()

#===============================================================================
# Plot the graph itself; this is the adjacency matrix
#===============================================================================
subtitle <- sprintf("threshold = %0.2f", thresh)

# Plots w/ constant edge widths and vertex sizes
#-------------------------------------------------------------------------------
plot.over.brain("../images/adjacency_graph_controls.png")
plot.adj(adj.control, title='Controls', subtitle)
dev.off()
plot.over.brain("../images/adjacency_graph_dTGA.png")
plot.adj(adj.tga, title='d-TGA', subtitle)
dev.off()

# Plots w/ variable edge widths and constant vertex sizes
#-------------------------------------------------------------------------------
plot.over.brain("../images/adjacency_graph_controls_weighted.png")
plot.adj(adj.control, title='Controls', subtitle, edge.width=weights.control)
dev.off()
plot.over.brain("../images/adjacency_graph_dTGA_weighted.png")
plot.adj(adj.tga, title='d-TGA', subtitle, edge.width=weights.tga)
dev.off()

# Plots w/ constant edge widths and variable vertex sizes
#-------------------------------------------------------------------------------
plot.over.brain("../images/adjacency_graph_controls_vertex_degree.png")
plot.adj(adj.control, title='Controls', subtitle,
  vert.size=2*degree(adj.control),
  vert.lab.cex=(degree(adj.control)+.05)/max(degree(adj.control)))
dev.off()
plot.over.brain("../images/adjacency_graph_dTGA_vertex_degree.png")
plot.adj(adj.tga, title='d-TGA', subtitle, vert.size=2*degree(adj.tga),
  vert.lab.cex=(degree(adj.tga)+.05)/max(degree(adj.tga)))
dev.off()

# Plots w/ constant edge widths and variable vertex sizes (eigenvector)
plot.over.brain("../images/adjacency_graph_controls_vertex_ev.png")
plot.adj(adj.control, title='Controls', subtitle,
  vert.size=25*centrality.ev.control$vector,
  vert.lab.cex=centrality.ev.control$vector+.01)
dev.off()
plot.over.brain("../images/adjacency_graph_dTGA_vertex_ev.png")
plot.adj(adj.tga, title='d-TGA', subtitle, vert.size=25*centrality.ev.tga$vector,
  vert.lab.cex=centrality.ev.tga$vector+.01)
dev.off()

# Plots w/ constant edge widths and variable vertex sizes (betweenness)
#-------------------------------------------------------------------------------
plot.over.brain("../images/adjacency_graph_controls_vertex_btwn.png")
plot.adj(adj.control, title='Controls', subtitle,
  vert.size=3*log1p(centrality.btwn.control$res)+.05,
  vert.lab.cex=0.2*log1p(centrality.btwn.control$res)+.05)
dev.off()
plot.over.brain("../images/adjacency_graph_dTGA_vertex_btwn.png")
plot.adj(adj.tga, title='d-TGA', subtitle,
  vert.size=3*log1p(centrality.btwn.tga$res)+.05,
  vert.lab.cex=0.2*log1p(centrality.btwn.tga$res)+.05)
dev.off()

# Plots w/ constant edge widths and variable vertex sizes (clustering)
#-------------------------------------------------------------------------------
plot.over.brain("../images/adjacency_graph_controls_vertex_clustering.png")
plot.adj(adj.control, title='Controls', subtitle,
  vert.size=20*transitivity.control,
  vert.lab.cex=transitivity.control+.01)
dev.off()
plot.over.brain("../images/adjacency_graph_dTGA_vertex_clustering.png")
plot.adj(adj.tga, title='d-TGA', subtitle, vert.size=20*transitivity.tga,
  vert.lab.cex=transitivity.tga+.01)
dev.off()


# Plots with groupings from community detection
#-------------------------------------------------------------------------------
plot.over.brain("../images/adjacency_graph_controls_community.png")
plot.adj(adj.control, title='Controls', subtitle,
  vert.col=colors()[7*community.control$membership], vert.lab=NA,
  vert.size=range.transform(deg.dist.control, 5, 15), edge.col='gray')
dev.off()
plot.over.brain("../images/adjacency_graph_dTGA_community.png")
plot.adj(adj.tga, title='d-TGA', subtitle,
  vert.col=colors()[7*community.tga$membership], vert.lab=NA,
  vert.size=range.transform(deg.dist.tga, 5, 15), edge.col='gray')
dev.off()

# Plot of communities without a spatial layout
png(file='../images/adjacency_graph_controls_community_random.png')
plot(community.control, adj.control, vertex.color=V(adj.control)$color,
  main="Control", vertex.label.cex=0.75, vertex.size=10,
  vertex.label.color='darkblue')
dev.off()
png(file='../images/adjacency_graph_dTGA_community_random.png')
plot(community.tga, adj.tga, vertex.color=V(adj.tga)$color,
  main="d-TGA", vertex.label.cex=0.75, vertex.size=10,
  vertex.label.color='darkblue')
dev.off()


#-------------------------------------------------------------------------------
# Plots of network measures for all thresholds
#-------------------------------------------------------------------------------
png(file='../images/mean_degrees.png')
plot.threshes(meandeg.control, meandeg.tga, 'Mean degree')
dev.off()

png(file='../images/avg_path_lengths.png')
plot.threshes(avg.path.lengths.control, avg.path.lengths.tga, 'Characteristic
  path length')
dev.off()

png(file='../images/clustering_coeff.png')
plot.threshes(cluster.coeffs.control, cluster.coeffs.tga, 'Transitivity')
dev.off()

png(file='../images/small_worldness.png')
plot.threshes(sigma.control.all, sigma.tga.all, 'Small-worldness')
dev.off()

png(file='../images/betweenness.png')
plot.threshes(betweenness.control, betweenness.tga, 'Betweenness')
dev.off()
