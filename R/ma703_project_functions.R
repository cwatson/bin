# Functions written for MA703 graph theory project, using cortical thickness
# data from the TGA study
#_______________________________________________________________________________
# by Chris Watson, 2013-12-23


# Take a vector and transform it to have a different range
range.transform <- function(x, min.val=0, max.val=1) {
  if (max.val==1) {
    (x - min(x)) / diff(range(x))
  } else {
    ((x - min(x)) * (max.val-1) / diff(range(x))) + min.val
  }
}

# Get the r- and p-values of a dataset; threshold it to create an adjacency
# matrix; exclude certain columns (brain regions) if desirable
corr.matrix <- function(cur.dataset, threshold=thresh, exclusions=exclude) {
  r <- rcorr(as.matrix(cur.dataset[, -exclusions]))$r
  p <- rcorr(as.matrix(cur.dataset[, -exclusions]))$P
  r.thresh <- ifelse(abs(r) > threshold, 1, 0)
  out <- list(R=r, P=p, r.thresh=r.thresh)
}

# Simulate n random graphs with a specific degree distribution
# Also calculate path length, transitivity, and mean degree
sim.rand.graph <- function(deg.dist, n) {
  tmp <- vector("list", n)
  for (i in 1:n) {
    tmp[[i]] <- degree.sequence.game(deg.dist)
  }
  Lp <- sapply(tmp, average.path.length)
  Cp <- sapply(tmp, transitivity)
  d <- sapply(tmp, function(x) mean(degree(x)))
  list(Lp.rand=Lp, Cp.rand=Cp, d=d)
}

# Deprecated; tried to figure out how to do correlations based on Kendall's t
# Ended up being too complicated with my data
cor.one.region <- function(cur.dataset, cur.region) {
  corrs <- with(cur.dataset,
                by(cur.dataset$thickness,
                  cur.dataset$region,
                  function(x)
                    cor.test(x,
                      subset(cur.dataset,
                      region==cur.region)$thickness,
                      type='kendall')$estimate,
                  simplify=F))

  pvals <- with(cur.dataset,
                by(cur.dataset$thickness,
                  cur.dataset$region,
                  function(x)
                    cor.test(x,
                      subset(cur.dataset,
                      region==cur.region)$thickness,
                      type='kendall')$p.value))
  out <- list(tau=corrs, p=pvals)
}

# Plot adjacency graphs, with the nodes having a specific spatial layout that
# matches that of the brain
plot.adj <- function(adj.matrix, title='', subtitle='', vert.lab.col='black',
                     vert.size=10, vert.col='lightblue', vert.lab.cex=0.75,
                     vert.lab=get.vertex.attribute(adj.matrix, 'name'),
                     edge.col='red', edge.width=1,
                     layout=as.matrix(coords[-exclude, ])) {
  plot(adj.matrix, layout=layout, 
    main=title, sub=subtitle,
    vertex.color=vert.col, vertex.size=vert.size, vertex.label=vert.lab,
    vertex.label.color=vert.lab.col, vertex.label.cex=vert.lab.cex,
    edge.width=edge.width, edge.color=edge.col)
}

# Plot for 2 groups a given measure (e.g. avg. degree), with the horizontal
# axis representing a range of correlation thresholds
plot.threshes <- function(yvar.1, yvar.2, ylabel) {
  plot(threshes, yvar.1, type='l', col='blue', ann=F)
  lines(threshes, yvar.2, col='red')
  ymin <- min(c(yvar.1, yvar.2), na.rm=T)
  ymove <- 0.1*diff(range(c(yvar.1, yvar.2), na.rm=T))
  legend(0.3, ymin+ymove, c('Control', 'd-TGA'), cex=0.75, col=c('blue', 'red'),
         lty=c(1,1))
  title(xlab='Correlation thresholds', ylab=ylabel)
}

# Function for initializing the png of the human brain outline
plot.over.brain <- function(filename) {
    png(file=filename)
    plot.new()
    rasterImage(r, -0.12, -0.21, 1.12, 1.22)
    par(new=T)
}
