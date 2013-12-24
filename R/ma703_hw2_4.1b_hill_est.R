# Problem 4.1b of Kolaczyk text
# Calculate the Hill estimator for the exponent in power-law degree distrs
# MA 703 Fall 2013
#_______________________________________________________________________________
# by Chris Watson, 2013-11-01
library(VGAM)

hill.est <- function(num.samples, alpha) {
  k <- 10   # "location" parameter for Pareto distr.
  
  x <- rpareto(num.samples, k, alpha)
  d <- sort(x)
  est <- (sum(log(d[2:num.samples] / d[1])) / num.samples)^(-1)

  list(samples=x, deg=d, estimate=est)
}
