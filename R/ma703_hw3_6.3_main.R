# Code to loop through and create preferential attachment models, varying the
# maximum time n
#_______________________________________________________________________________
# by Chris Watson, 2013-12-05
require(igraph)
source('ma703_hw3_6.3a_pref-attach-model.R')
source('../../hw2/code/ma703_hw2_4.1b_hill_est.R')

d <- 1      # The number of edges to add each step
k <- 10     # Chosen arbitrarily for the Pareto distribution
fit <- vector()
hill <- vector()
mods <- list()
betas <- vector()

for (n in seq(100, 1000, 50)) {
  # Initialize graph as having a single vertex with a loop
  g <- graph.formula(1) + edges(c(1, 1))
  for (t in 1:n) {
    g.new <- pref.attach.vert(g, t)
    g <- g.new[[1]]
  }

  # Fit a power-law distribution to the degree distribution
  fit[n/50 - 1] <- power.law.fit(degree(g))$alpha

  # Compare with the Hill estimator
  deg.sort <- sort(degree(g))
  hill[n/50 -1] <- ((1/k) * sum(log(deg.sort[(n-k+1):n] / deg.sort[n-k])))^(-1)

  # Compare w/ naive regression
  #-------------------------------------

  # Generate pseudorandom numbers u, then the x's will follow a Pareto distr.
  u <- runif(n+1)
  x <- 1 / (u^(1/3))    # I chose x_0 = 1, for the min possible value
  tmp <- data.frame('prob.dist'=log1p(cumsum(x)),
                    'degree.dist'=-log1p(degree(g)))
  mods[[n/50 - 1]] <- lm(prob.dist ~ degree.dist, data=tmp, offset=-degree.dist)
  betas[n/50 - 1] <- mods[[n/50 - 1]]$coefficients[2]
}

# Plot the degree distribution, along with the density of the Pareto sample
png('../images/density_6.3a.png')
plot(density(degree(g)), col='red')
lines(density(x), col='blue')
dev.off()
